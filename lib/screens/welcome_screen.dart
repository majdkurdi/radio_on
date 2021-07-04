import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'RadioScreen.dart';
import '../providers/countries_provider.dart';
import '../providers/songs_provider.dart';

class WelcomeScreen extends StatefulWidget {
  static const String routeName = 'welcome-screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 0)).then((value) async {
      print(1);
      await Provider.of<CountriesProvider>(context, listen: false)
          .updateCountries();
      print(2);
      await Provider.of<SongsProvider>(context, listen: false).getSongs();
    }).then((value) {
      print(3);
      Navigator.pushReplacementNamed(context, RadioScreen.roruteName);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(),
          Hero(
            tag: 'logo',
            child: Container(
              // height: 150,
              // width: 200,
              child: Image(
                // fit: BoxFit.fitHeight,
                image: AssetImage('assets/logo.png'),
              ),
            ),
          ),
          Text(
            'TasQment',
            style: TextStyle(color: Colors.grey.withOpacity(0.7), fontSize: 20),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
