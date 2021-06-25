import 'package:flutter/material.dart';
import '../modals/channel.dart';

class ChannelListTile extends StatefulWidget {
  final Channel channel;
  final Function onPressed;

  ChannelListTile({@required this.channel, @required this.onPressed});

  @override
  _ChannelListTileState createState() => _ChannelListTileState();
}

class _ChannelListTileState extends State<ChannelListTile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            await widget.onPressed(widget.channel.url);
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
                  image: NetworkImage(
                      widget.channel.imageUrl.contains('imgur.com')
                          ? widget.channel.imageUrl
                              .replaceFirst('i.imgur.com', 'imgur.com')
                          : widget.channel.imageUrl),
                  imageErrorBuilder: (context, bla, _) => Image(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/def.png'),
                  ),
                ),
              ),
            ),
            title: Text(
              widget.channel.name,
            ),
            trailing: IconButton(
                icon: Icon(widget.channel.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border),
                onPressed: () {
                  setState(() {
                    widget.channel.toggleFavorite(context);
                  });
                }),
          ),
        ),
        Divider(
          color: Theme.of(context).primaryColor,
        )
      ],
    );
  }
}
