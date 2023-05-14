import 'dart:convert';

import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const apiKey = '3C6179E6-D36C-4F3E-9242-7B5D3E10FF61';
String coinApiUrl = 'https://rest.coinapi.io/v1/exchangerate';

class CoinData {
  Future getCoinData(String selectedCurrency) async {
    Map<String, String> crytoPrices = {};
    for (String crypto in cryptoList) {
      Uri requestURL =
          Uri.parse('$coinApiUrl/$crypto/$selectedCurrency?apikey=$apiKey');

      http.Response response = await http.get(requestURL);

      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        var rate = decodedData['rate'];
        crytoPrices[crypto] = rate.toStringAsFixed(0);
      } else {
        print(response.statusCode);
        throw 'Problem with the get request';
      }
    }
    return crytoPrices;
  }
}
