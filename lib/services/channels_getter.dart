import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../modals/channel.dart';

class ChannelsGetter {
  Future<List<Channel>> getChannels(String countryName) async {
    final String url =
        'https://fr1.api.radio-browser.info/json/stations/bycountry/$countryName';

    http.Response response = await http.get(Uri.parse(url));
    List<Channel> channels = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var extractedData = jsonDecode(response.body);
    extractedData.forEach((e) {
      channels.add(Channel(
          name: e['name'],
          url: e['url'],
          imageUrl: e['favicon'],
          id: e['changeuuid'],
          isFavorite: prefs.getBool('${e['changeuuid']}') ?? false));
    });

    return channels;
  }
}
