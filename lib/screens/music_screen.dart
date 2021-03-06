import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audio_service/audio_service.dart';
import '../screens/player_screen.dart';
import '../widgets/drawer.dart';
import '../widgets/song_list_tile.dart';
import '../providers/songs_provider.dart';
import '../services/background_audio_service.dart';
import '../modals/song.dart';

class MusicScreen extends StatefulWidget {
  static const String routeName = '/music-player';

  @override
  _MusicScreenState createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  bool loading = false;
  String searchText;
  bool searchMode = false;
  @override
  void initState() {
    Future.delayed(Duration(seconds: 0)).then((value) async {
      await initAudioService();
    });
    super.initState();
  }

  initAudioService() async {
    await AudioService.connect();
  }

  @override
  void dispose() {
    AudioService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Song> mySongs = Provider.of<SongsProvider>(context).mySongs;
    List<Song> searchRes =
        Provider.of<SongsProvider>(context).searchRes(searchText);
    Song currentSong = Provider.of<SongsProvider>(context).currentSong;
    return Scaffold(
        drawer: MainDrawer(),
        appBar: AppBar(
            title: searchMode
                ? TextField(
                    decoration: InputDecoration(hintText: 'Search'),
                    onChanged: (value) {
                      setState(() {
                        searchText = value;
                      });
                    },
                  )
                : Text('Your Music'),
            actions: [
              IconButton(
                  icon: Icon(searchMode ? Icons.arrow_forward : Icons.search),
                  onPressed: () {
                    setState(() {
                      searchMode = !searchMode;
                    });
                  }),
            ]),
        body: loading
            ? Center(
                child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation(Theme.of(context).primaryColor),
              ))
            : Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemBuilder: (ctx, i) => SongListTile(
                              song: searchMode ? searchRes[i] : mySongs[i],
                            ),
                        itemCount:
                            searchMode ? searchRes.length : mySongs.length),
                  ),
                  if (currentSong != null)
                    Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(PlayerScreen.routeName);
                            },
                            child: Hero(
                              tag: 'player_photo',
                              child: Image(
                                image: AssetImage('assets/def.png'),
                                height: 50,
                                width: 50,
                              ),
                            ),
                          ),
                          Expanded(child: Text(currentSong.title)),
                          IconButton(
                            icon: Icon(Icons.skip_previous),
                            onPressed: () async {
                              var previousSong = Provider.of<SongsProvider>(
                                      context,
                                      listen: false)
                                  .previousSong;
                              Provider.of<SongsProvider>(context, listen: false)
                                  .setSong(previousSong);
                              await AudioService.stop();
                              await AudioService.connect();
                              AudioService.start(
                                  backgroundTaskEntrypoint: entrypoint,
                                  params: {'path': previousSong.path});
                            },
                          ),
                          StreamBuilder(
                              stream: AudioService.playbackStateStream,
                              builder: (context, snapshot) {
                                var isPlaying = snapshot.data?.playing ?? false;
                                return IconButton(
                                  icon: Icon(isPlaying
                                      ? Icons.stop
                                      : Icons.play_arrow),
                                  onPressed: () async {
                                    isPlaying
                                        ? AudioService.stop()
                                        : AudioService.start(
                                            backgroundTaskEntrypoint:
                                                entrypoint,
                                            params: {'path': currentSong.path});

                                    setState(() {
                                      isPlaying = !isPlaying;
                                    });
                                  },
                                );
                              }),
                          IconButton(
                            icon: Icon(Icons.skip_next),
                            onPressed: () async {
                              var nextSong = Provider.of<SongsProvider>(context,
                                      listen: false)
                                  .nextSong;
                              Provider.of<SongsProvider>(context, listen: false)
                                  .setSong(nextSong);
                              await AudioService.stop();
                              await AudioService.connect();
                              AudioService.start(
                                  backgroundTaskEntrypoint: entrypoint,
                                  params: {'path': nextSong.path});
                            },
                          )
                        ],
                      ),
                    )
                ],
              ));
  }
}
