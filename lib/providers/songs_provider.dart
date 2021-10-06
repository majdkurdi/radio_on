import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import '../modals/song.dart';

class SongsProvider with ChangeNotifier {
  List<Song> _mySongs = [];
  Song _currentSong;

  Song get currentSong {
    return _currentSong;
  }

  List<Song> get mySongs {
    return [..._mySongs];
  }

  List<Song> searchRes(String sText) {
    if (sText == null || sText == '') return [];
    return _mySongs
        .where((element) =>
            element.title.toLowerCase().contains(sText.toLowerCase()))
        .toList();
  }

  Future<void> getSongs() async {
    if (await Permission.storage.request().isGranted) {
      Directory dir = Directory('/storage/emulated/0/');

      List<FileSystemEntity> _files;
      List<Song> _songs = [];
      _files = dir.listSync(recursive: true, followLinks: false);
      for (FileSystemEntity entity in _files) {
        String path = entity.path;
        if (path.endsWith('.mp3') || path.endsWith('.wav')) {
          var songTitle = entity.path.split('/').last.replaceAll('.mp3', '');
          _songs.add(Song(title: songTitle, path: entity.path));
        }
      }
      print(_songs.length);
      _mySongs = _songs;
    }
  }

  void setSong(Song song) {
    _currentSong = song;
    notifyListeners();
  }

  Song get nextSong {
    var currentIndex =
        _mySongs.indexWhere((element) => element.title == _currentSong.title);
    return _mySongs[(currentIndex + 1)];
  }

  Song get previousSong {
    var currentIndex =
        _mySongs.indexWhere((element) => element.title == _currentSong.title);
    return _mySongs[(currentIndex - 1)];
  }
}
