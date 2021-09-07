import 'dart:convert';

import 'package:http/http.dart' as http;

const keyAPI = '588CB19A-67D1-4CD6-BDF2-0307BC1AA1D7';

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

class CoinData {
  Future<Map> getCoinData(String currency) async {
    Map virtualCurrencies = {};
    for (String virtualCurrency in cryptoList) {
      http.Response response = await http.get(
          'https://rest.coinapi.io/v1/exchangerate/$virtualCurrency/$currency?apikey=$keyAPI');
      if (response.statusCode == 200) {
        Map decodedJson = jsonDecode(response.body);
        double rawValue = decodedJson['rate'];
        int value = rawValue.toInt();
        virtualCurrencies[virtualCurrency] = value;
      } else {
        virtualCurrencies = {'BTC': 1, 'ETH': 2, 'LTC': 3};
      }
    }
    return virtualCurrencies;
  }
}
