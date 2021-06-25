import 'package:flutter/cupertino.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';

class SongsProvider with ChangeNotifier {
  List<SongInfo> _mySongs;
  SongInfo _currentSong;

  SongInfo get currentSong {
    return _currentSong;
  }

  List<SongInfo> get mySongs {
    return [..._mySongs];
  }

  List<SongInfo> searchRes(String sText) {
    if (sText == null || sText == '') return [];
    return _mySongs
        .where((element) =>
            element.title.toLowerCase().contains(sText.toLowerCase()))
        .toList();
  }

  Future<void> getSongs() async {
    FlutterAudioQuery audioQuery = FlutterAudioQuery();

    _mySongs = await audioQuery.getSongs();
    notifyListeners();
  }

  void setSong(SongInfo song) {
    _currentSong = song;
    notifyListeners();
  }

  SongInfo get nextSong {
    var currentIndex =
        _mySongs.indexWhere((element) => element.title == _currentSong.title);
    return _mySongs[(currentIndex + 1)];
  }

  SongInfo get previousSong {
    var currentIndex =
        _mySongs.indexWhere((element) => element.title == _currentSong.title);
    return _mySongs[(currentIndex - 1)];
  }
}
