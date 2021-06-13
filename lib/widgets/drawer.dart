import 'package:flutter/material.dart';
import '../screens/main_screen.dart';
import '../screens/music_player.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 100,
          color: Theme.of(context).primaryColor,
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacementNamed(MusicPlayer.routeName);
          },
          child: ListTile(
            leading: Icon(
              Icons.music_note,
              color: Theme.of(context).primaryColor,
            ),
            title: Text('Music'),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacementNamed(MainScreen.roruteName);
          },
          child: ListTile(
            leading: Icon(
              Icons.radio,
              color: Theme.of(context).primaryColor,
            ),
            title: Text('Radio'),
          ),
        )
      ],
    );
  }
}
