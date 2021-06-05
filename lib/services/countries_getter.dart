import 'dart:convert';

import 'package:http/http.dart' as http;

class CountriesGetter {
  Future<List<String>> getCountries() async {
    const String url = 'https://fr1.api.radio-browser.info/json/countries';

    final response = await http.get(Uri.parse(url));
    List extractedData = jsonDecode(response.body);

    List<String> countries = [];
    extractedData.forEach((element) {
      countries.add(element['name']);
    });

    return countries;
  }
}
