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
  @override
  Widget build(BuildContext context) {
    SongInfo currrentSong = Provider.of<SongsProvider>(context).currentSong;
    return Scaffold(
      appBar: AppBar(
        title: Text('Player'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(currrentSong.title),
          ),
          Hero(
            tag: 'player_photo',
            child: Image(
              image: AssetImage('assets/def.png'),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FloatingActionButton(
                backgroundColor: Theme.of(context).primaryColor,
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
              StreamBuilder(
                builder: (context, snapshot) {
                  var playing = snapshot.data?.playing ?? false;
                  return FloatingActionButton(
                    backgroundColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      playing
                          ? AudioService.stop()
                          : AudioService.start(
                              backgroundTaskEntrypoint: entrypoint,
                              params: {'path': currrentSong.filePath});
                    },
                    child: Icon(playing ? Icons.stop : Icons.play_arrow),
                  );
                },
                stream: AudioService.playbackStateStream,
              ),
              FloatingActionButton(
                backgroundColor: Theme.of(context).primaryColor,
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
