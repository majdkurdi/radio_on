import 'package:flutter/material.dart';
import '../modals/channel.dart';

class ListTileWidget extends StatelessWidget {
  final Channel channel;

  ListTileWidget({@required this.channel});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage('assets/def.jpg'),
      ),
      title: Text(channel.name),
    );
  }
}
