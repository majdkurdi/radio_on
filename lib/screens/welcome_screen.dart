import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './main_screen.dart';
import '../providers/countries_provider.dart';

class WelcomeScreen extends StatelessWidget {
  static const String routeName = 'welcome-screen';
  @override
  Widget build(BuildContext context) {
    Provider.of<CountriesProvider>(context, listen: false)
        .updateCountries()
        .then((_) {
      Future.delayed(Duration(seconds: 2)).then((value) {
        Navigator.pushReplacementNamed(context, MainScreen.roruteName);
      });
    });
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
