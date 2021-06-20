import 'package:flutter/cupertino.dart';

import '../modals/channel.dart';
import '../services/channels_getter.dart';

class ChannelsProvider with ChangeNotifier {
  List<Channel> _channels = [];

  List<Channel> get channels {
    return [..._channels];
  }

  List<Channel> get favorites {
    return _channels.where((element) => element.isFavorite).toList();
  }

  Future<void> updateChannels(String countryName) async {
    _channels = await ChannelsGetter().getChannels(countryName);
    print(_channels[0].name);
    notifyListeners();
  }

  List<Channel> search(String sText) {
    if (sText == null || sText == '') return [];
    List<Channel> searchRes = _channels
        .where((element) =>
            element.name.toLowerCase().contains(sText.toLowerCase()))
        .toList();
    return searchRes;
  }

  void notify() {
    notifyListeners();
  }
}
