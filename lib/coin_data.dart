import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/foundation.dart';
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

const APIkey = 'ccabc6c39cc7024ab6b855f7bc3335c3cc9d70bf';
const url = 'https://api.nomics.com/v1/currencies/ticker';

class CoinData {
  Future getValueofCurrIn(String exchangeCurrency) async {
    http.Response response = await http.get(Uri.parse(
        'https://api.nomics.com/v1/currencies/ticker?key=$APIkey&ids=BTC,ETH,LTC&interval=1d,30d&convert=$exchangeCurrency&per-page=100&page=1'));
    Map<String, String> cryptoPrices = {};
    var data = (jsonDecode(response.body));
    if (response.statusCode == 200) {
      //print(response.statusCode);
      for (int j = 0; j < cryptoList.length; j++) {
        double d = double.parse(data[j]['price']);
        cryptoPrices[cryptoList[j]] = d.toStringAsFixed(0);
      }
    } else {
      print(response.statusCode);
    }
    return cryptoPrices;
  }
}
