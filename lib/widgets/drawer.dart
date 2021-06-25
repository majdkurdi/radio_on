import 'package:flutter/material.dart';
import '../screens/RadioScreen.dart';
import '../screens/music_screen.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: [
        Container(
          width: double.infinity,
          height: 150,
          color: Theme.of(context).primaryColor,
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacementNamed(MusicScreen.routeName);
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
            Navigator.of(context).pushReplacementNamed(RadioScreen.roruteName);
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
    ));
  }
}
