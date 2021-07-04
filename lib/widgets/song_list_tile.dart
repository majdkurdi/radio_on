import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/songs_provider.dart';
import '../screens/player_screen.dart';
import '../services/background_audio_service.dart';
import '../modals/song.dart';

class SongListTile extends StatelessWidget {
  final Song song;
  SongListTile({@required this.song});
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
                params: {'path': song.path});
            Provider.of<SongsProvider>(context, listen: false).setSong(song);
            Navigator.of(context).pushNamed(PlayerScreen.routeName);
          },
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/def.png'),
            ),
            title: Text(song.title),
          ),
        ),
        Divider(
          color: Theme.of(context).primaryColor,
        )
      ],
    );
  }
}
