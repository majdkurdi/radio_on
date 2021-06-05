import 'package:flutter/cupertino.dart';

import '../services/countries_getter.dart';

class CountriesProvider with ChangeNotifier {
  List<String> _countries = [];

  List<String> get countries {
    return [..._countries];
  }

  Future<void> updateCountries() async {
    _countries = await CountriesGetter().getCountries();
    notifyListeners();
    if (_countries.isEmpty) {
      _countries.add('syria');
      notifyListeners();
    }
  }
}
