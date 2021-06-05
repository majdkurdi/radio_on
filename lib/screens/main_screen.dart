import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:just_audio/just_audio.dart';
import '../modals/channel.dart';
import '../providers/countries_provider.dart';
import '../providers/channels_provider.dart';
import '../widgets/list_tile_widget.dart';

class MainScreen extends StatefulWidget {
  static const String roruteName = '/main-screen';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String chosenCountry = 'Syrian Arab Republic';
  bool loading = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 0)).then((value) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        loading = true;
      });
      if (prefs.getString('country') != null) {
        chosenCountry = prefs.getString('country');
      }
      await Provider.of<ChannelsProvider>(context, listen: false)
          .updateChannels(chosenCountry);

      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> countries = Provider.of<CountriesProvider>(context).countries;
    List<Channel> channels = Provider.of<ChannelsProvider>(context).channels;
    return Scaffold(
      appBar: AppBar(
        title: Text('Radio ON'),
        actions: [
          Text(
            chosenCountry,
            textAlign: TextAlign.center,
          ),
          PopupMenuButton(
            itemBuilder: (context) => countries
                .map((e) => PopupMenuItem(
                      child: Text(e, style: TextStyle(color: Colors.black54)),
                      value: e,
                    ))
                .toList(),
            onSelected: (value) async {
              await Provider.of<ChannelsProvider>(context)
                  .updateChannels(value);
              setState(() {
                chosenCountry = value;
              });
            },
          ),
        ],
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemBuilder: (ctx, i) {
                return ListTileWidget(channel: channels[i]);
              },
              itemCount: channels.length,
            ),
    );
  }
}
