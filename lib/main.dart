import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/RadioScreen.dart';
import './screens/welcome_screen.dart';
import './screens/music_screen.dart';
import './screens/player_screen.dart';
import './providers/countries_provider.dart';
import './providers/channels_provider.dart';
import './providers/songs_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: CountriesProvider()),
        ChangeNotifierProvider.value(value: ChannelsProvider()),
        ChangeNotifierProvider.value(value: SongsProvider()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.teal,
          fontFamily: 'TitilliumWeb',
          textTheme: TextTheme(
            headline6: TextStyle(fontFamily: 'TitilliumWeb'),
          ),
        ),
        routes: {
          RadioScreen.roruteName: (ctx) => RadioScreen(),
          WelcomeScreen.routeName: (ctx) => WelcomeScreen(),
          MusicScreen.routeName: (ctx) => MusicScreen(),
          PlayerScreen.routeName: (ctx) => PlayerScreen()
        },
        home: AudioServiceWidget(child: WelcomeScreen()),
      ),
    );
  }
}
