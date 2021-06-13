import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audio_service/audio_service.dart';
import '../modals/channel.dart';
import '../providers/countries_provider.dart';
import '../providers/channels_provider.dart';
import '../widgets/list_tile_widget.dart';
import '../widgets/drawer.dart';
import '../services/background_audio_service.dart';

class MainScreen extends StatefulWidget {
  static const String roruteName = '/main-screen';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String chosenCountry = 'Syrian Arab Republic';
  bool loading = false;
  Channel chosenChannel;

  initAudioService() async {
    await AudioService.connect();
  }

  void updateChosenChannel(String channelUrl) async {
    var myCh = Provider.of<ChannelsProvider>(context, listen: false)
        .channels
        .firstWhere((e) => e.url == channelUrl);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    chosenChannel = myCh;
    prefs.setString('channelName', myCh.name);
  }

  @override
  void initState() {
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
      if (prefs.getString('channelName') != null) {
        chosenChannel = Provider.of<ChannelsProvider>(context, listen: false)
            .channels
            .firstWhere(
                (element) => element.name == prefs.getString('channelName'));
      }
      setState(() {
        loading = false;
      });
    });
    initAudioService();
    super.initState();
  }

  @override
  void dispose() {
    AudioService.disconnect();
    super.dispose();
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
              await Provider.of<ChannelsProvider>(context, listen: false)
                  .updateChannels(value);
              setState(() {
                chosenCountry = value;
              });
            },
          ),
        ],
      ),
      drawer: MainDrawer(),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 4,
              color: Theme.of(context).primaryColor,
            ),
            Positioned(
              child: StreamBuilder<PlaybackState>(
                stream: AudioService.playbackStateStream,
                builder: (context, snapshot) {
                  var isPlaying = snapshot.data?.playing ?? false;
                  return FloatingActionButton(
                    onPressed: () async {
                      if (isPlaying) {
                        AudioService.stop();
                      } else {
                        AudioService.connect();
                        AudioService.start(
                            backgroundTaskEntrypoint: entrypoint,
                            params: {'url': chosenChannel.url});
                      }
                    },
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Icon(isPlaying ? Icons.stop : Icons.play_arrow),
                  );
                },
              ),
              right: 20,
              bottom: 20,
            ),
          ]),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: loading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemBuilder: (ctx, i) => ListTileWidget(
                        channel: channels[i],
                        onPressed: (String url) async {
                          updateChosenChannel(url);
                          if (AudioService.playbackState.playing)
                            await AudioService.stop();
                          await initAudioService();
                          AudioService.start(
                              backgroundTaskEntrypoint: entrypoint,
                              params: {'url': url});
                        }),
                    itemCount: channels.length,
                  ),
          ),
        ],
      ),
    );
  }
}
