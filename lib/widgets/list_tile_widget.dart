import 'package:flutter/material.dart';
import '../modals/channel.dart';

class ListTileWidget extends StatelessWidget {
  final Channel channel;
  final Function onPressed;

  ListTileWidget({@required this.channel, @required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            await onPressed(channel.url);
          },
          child: ListTile(
            leading: Container(
              width: 50.0,
              height: 50.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25.0),
                child: FadeInImage(
                    fit: BoxFit.cover,
                    width: 50,
                    height: 50,
                    placeholder: AssetImage('assets/def.png'),
                    image: AssetImage('assets/def.png')
                    // NetworkImage(channel.imageUrl.contains('imgur.com')
                    //     ? channel.imageUrl.replaceFirst('i.imgur.com', 'imgur.com')
                    //     : channel.imageUrl),
                    // imageErrorBuilder: (context, bla, _) => Image(
                    //   fit: BoxFit.cover,
                    //   image: AssetImage('assets/def.png'),
                    //),
                    ),
              ),
            ),
            title: Text(channel.name),
          ),
        ),
        Divider(
          color: Theme.of(context).primaryColor,
        )
      ],
    );
  }
}
