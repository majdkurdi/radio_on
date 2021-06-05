import 'dart:convert';

import 'package:http/http.dart' as http;

import '../modals/channel.dart';

class ChannelsGetter {
  Future<List<Channel>> getChannels(String countryName) async {
    final String url =
        'https://fr1.api.radio-browser.info/json/stations/bycountry/$countryName';

    http.Response response = await http.get(Uri.parse(url));
    List<Channel> channels = [];
    var extractedData = jsonDecode(response.body);
    extractedData.forEach((e) {
      channels
          .add(Channel(name: e['name'], url: e['url'], imageUrl: e['favicon']));
    });

    return channels;
  }
}
