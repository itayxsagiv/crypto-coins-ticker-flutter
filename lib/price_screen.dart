import 'dart:io';

import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  int value;

  Widget iOSPicker() {
    List<Widget> currenciesItems = [];
    for (String currency in currenciesList) {
      Widget currencyItem = Text(currency);
      currenciesItems.add(currencyItem);
    }

    return CupertinoPicker(
      itemExtent: 32,
      onSelectedItemChanged: (int selectedIndex) {
        print(selectedIndex);
      },
      children: currenciesItems,
    );
  }

  DropdownButton androidPicker() {
    List<DropdownMenuItem<String>> currenciesItems = [];
    for (String currency in currenciesList) {
      DropdownMenuItem<String> currencyItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      currenciesItems.add(currencyItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: currenciesItems,
      onChanged: (value) {
        setState(
          () {
            selectedCurrency = value;
          },
        );
      },
    );
  }

  Future<void> getCoinValue() async {
    CoinData coinData = CoinData();
    value = await coinData.getCoinData();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getCoinValue();
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
          Padding(
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
                  value != null ? '1 BTC = $value USD' : '1 BTC = ? USD',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidPicker(),
          ),
        ],
      ),
    );
  }
}
