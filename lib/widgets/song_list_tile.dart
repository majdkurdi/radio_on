import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:provider/provider.dart';
import '../providers/songs_provider.dart';
import '../screens/player_screen.dart';
import '../services/background_audio_service.dart';

class SongListTile extends StatelessWidget {
  final SongInfo songInfo;
  SongListTile({@required this.songInfo});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            if (AudioService.running) AudioService.stop();
            await AudioService.connect();
            AudioService.start(
                backgroundTaskEntrypoint: entrypoint,
                params: {'path': songInfo.filePath});
            Provider.of<SongsProvider>(context, listen: false)
                .setSong(songInfo);
            Navigator.of(context).pushNamed(PlayerScreen.routeName);
          },
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/def.png'),
            ),
            title: Text(songInfo.title),
          ),
        ),
        Divider(
          color: Theme.of(context).primaryColor,
        )
      ],
    );
  }
}
