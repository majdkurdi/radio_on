import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../providers/channels_provider.dart';

class Channel {
  final String id;
  final String name;
  final String url;
  final String imageUrl;
  bool isFavorite;

  Channel(
      {@required this.name,
      @required this.url,
      @required this.imageUrl,
      @required this.id,
      this.isFavorite = false});

  void toggleFavorite(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isFavorite = !isFavorite;
    prefs.setBool('$id', isFavorite);
    Provider.of<ChannelsProvider>(context, listen: false).notify();
  }
}
