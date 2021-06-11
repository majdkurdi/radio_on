import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/main_screen.dart';
import './screens/welcome_screen.dart';
import './providers/countries_provider.dart';
import './providers/channels_provider.dart';

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
          MainScreen.roruteName: (ctx) => MainScreen(),
          WelcomeScreen.routeName: (ctx) => WelcomeScreen()
        },
        home: AudioServiceWidget(child: WelcomeScreen()),
      ),
    );
  }
}
