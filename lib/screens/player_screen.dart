import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:provider/provider.dart';
import '../providers/songs_provider.dart';
import '../services/background_audio_service.dart';

class PlayerScreen extends StatefulWidget {
  static const String routeName = '/player-screen';

  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  bool playing = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      playing = AudioService.playbackState.playing;
    });
  }

  @override
  Widget build(BuildContext context) {
    SongInfo currrentSong = Provider.of<SongsProvider>(context).currentSong;
    return Scaffold(
      appBar: AppBar(
        title: Text('Player'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(currrentSong.title),
          ),
          SizedBox(
            height: 20,
          ),
          Image(
            image: AssetImage('assets/def.png'),
            height: 100,
            width: 100,
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FloatingActionButton(
                onPressed: () async {
                  var previousSong =
                      Provider.of<SongsProvider>(context, listen: false)
                          .previousSong;
                  Provider.of<SongsProvider>(context, listen: false)
                      .setSong(previousSong);
                  await AudioService.stop();
                  await AudioService.connect();
                  AudioService.start(
                      backgroundTaskEntrypoint: entrypoint,
                      params: {'path': previousSong.filePath});
                },
                child: Icon(Icons.skip_previous),
              ),
              FloatingActionButton(
                onPressed: () {
                  playing ? AudioService.pause() : AudioService.play();
                  setState(() {
                    playing = !playing;
                  });
                },
                child: Icon(playing ? Icons.stop : Icons.play_arrow),
              ),
              FloatingActionButton(
                onPressed: () async {
                  var nextSong =
                      Provider.of<SongsProvider>(context, listen: false)
                          .nextSong;
                  Provider.of<SongsProvider>(context, listen: false)
                      .setSong(nextSong);
                  await AudioService.stop();
                  await AudioService.connect();
                  AudioService.start(
                      backgroundTaskEntrypoint: entrypoint,
                      params: {'path': nextSong.filePath});
                },
                child: Icon(Icons.skip_next),
              ),
            ],
          )
        ],
      ),
    );
  }
}
