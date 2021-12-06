import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'INR';
  Map<String, String> cryptoPrices = {};

  DropdownButton<String> getAndroidDropDownButton() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (int i = 0; i < currenciesList.length; i++) {
      String curr = currenciesList[i];
      var newItem = DropdownMenuItem(
        child: Text(curr),
        value: curr,
      );
      dropDownItems.add(newItem);
    }
    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropDownItems,
      onChanged: (value) {
        if (value != null)
          setState(() async {
            selectedCurrency = value;
            fetchData();
          });
      },
    );
  }

  CupertinoPicker getIOSPicker() {
    List<Text> list = [];
    for (String s in currenciesList) {
      list.add(Text(s));
    }
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          fetchData();
        });
      },
      children: list,
    );
  }

  Widget getPicker() {
    if (Platform.isAndroid) {
      return getAndroidDropDownButton();
    } else if (Platform.isIOS) {
      return getIOSPicker();
    }
    return getIOSPicker();
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    var temp = {};
    CoinData coinData = CoinData();
    cryptoPrices.clear();
    cryptoPrices = await coinData.getValueofCurrIn(selectedCurrency);
    setState(() {
      cryptoPrices = cryptoPrices;
      //print(cryptoPrices);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            children: [
              cryptoCard(
                  currency: cryptoList[0],
                  value: cryptoPrices[cryptoList[0]] ?? '?',
                  selectedCurrency: selectedCurrency),
              cryptoCard(
                  currency: cryptoList[1],
                  value: cryptoPrices[cryptoList[1]] ?? '?',
                  selectedCurrency: selectedCurrency),
              cryptoCard(
                  currency: cryptoList[2],
                  value: cryptoPrices[cryptoList[2]] ?? '?',
                  selectedCurrency: selectedCurrency),
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: getPicker(),
          ),
        ],
      ),
    );
  }
}

class cryptoCard extends StatelessWidget {
  final String value;
  final String selectedCurrency;
  final String currency;

  cryptoCard(
      {required this.currency,
      required this.value,
      required this.selectedCurrency});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $currency = ' + '${value} ${selectedCurrency}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
