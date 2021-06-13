import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:audio_service/audio_service.dart';
import 'package:radio_on/services/background_audio_service.dart';
import '../screens/player_screen.dart';
import '../widgets/drawer.dart';
import '../providers/songs_provider.dart';

class MusicPlayer extends StatefulWidget {
  static const String routeName = '/music-player';

  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  @override
  void initState() {
    initAudioService();
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
    return Scaffold(
        drawer: MainDrawer(),
        appBar: AppBar(
          title: Text('Music Player'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 4,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(height: 10),
              FutureBuilder(
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    List<SongInfo> mySongs =
                        Provider.of<SongsProvider>(context).mySongs;
                    return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (ctx, i) => SongListTile(
                              songInfo: mySongs[i],
                            ),
                        itemCount: mySongs.length);
                  } else {
                    return CircularProgressIndicator();
                  }
                },
                future: Provider.of<SongsProvider>(context, listen: false)
                    .getSongs(),
              ),
            ],
          ),
        ));
  }
}

class SongListTile extends StatelessWidget {
  final SongInfo songInfo;
  SongListTile({@required this.songInfo});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (AudioService.running) AudioService.stop();
        await AudioService.connect();
        AudioService.start(
            backgroundTaskEntrypoint: entrypoint,
            params: {'path': songInfo.filePath});
        Provider.of<SongsProvider>(context, listen: false).setSong(songInfo);
        Navigator.of(context).pushNamed(PlayerScreen.routeName);
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage('assets/def.png'),
        ),
        title: Text(songInfo.title),
      ),
    );
  }
}
