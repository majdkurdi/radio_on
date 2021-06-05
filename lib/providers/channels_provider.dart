import 'package:flutter/cupertino.dart';

import '../modals/channel.dart';
import '../services/channels_getter.dart';

class ChannelsProvider with ChangeNotifier {
  List<Channel> _channels = [];

  List<Channel> get channels {
    return [..._channels];
  }

  Future<void> updateChannels(String countryName) async {
    _channels = await ChannelsGetter().getChannels(countryName);
    print(_channels[0].name);
    notifyListeners();
  }
}
