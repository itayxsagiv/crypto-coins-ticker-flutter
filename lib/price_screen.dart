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
  Map selectedCurrencyPrices = {};

  Widget iOSPicker() {
    List<Widget> currenciesItems = [];
    for (String currency in currenciesList) {
      Widget currencyItem = Text(currency);
      currenciesItems.add(currencyItem);
    }

    return CupertinoPicker(
      itemExtent: 32,
      onSelectedItemChanged: (int selectedIndex) {
        selectedCurrency = currenciesList[selectedIndex];
        getCoinValue(selectedCurrency);
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
            getCoinValue(selectedCurrency);
          },
        );
      },
    );
  }

  Future<void> getCoinValue(String currency) async {
    CoinData coinData = CoinData();
    selectedCurrencyPrices = await coinData.getCoinData(currency);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getCoinValue(selectedCurrency);
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
          MultipleCurrenciesWidgets(
            selectedCurrencyPrices: selectedCurrencyPrices,
            selectedCurrency: selectedCurrency,
            virtualCurrencies: cryptoList,
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(
              bottom: 30.0,
            ),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidPicker(),
          ),
        ],
      ),
    );
  }
}

class MultipleCurrenciesWidgets extends StatelessWidget {
  const MultipleCurrenciesWidgets({
    @required this.selectedCurrencyPrices,
    @required this.selectedCurrency,
    @required this.virtualCurrencies,
  });

  final Map selectedCurrencyPrices;
  final String selectedCurrency;
  final List<String> virtualCurrencies;

  List<Widget> getCurrencyWidgets() {
    List<Widget> currencyWidgets = [];
    for (String virtualCurrency in virtualCurrencies) {
      Widget currencyWidget = CurrencyWidget(
        selectedCurrencyPrice: selectedCurrencyPrices[virtualCurrency],
        selectedCurrency: selectedCurrency,
        virtualCurrency: virtualCurrency,
      );
      currencyWidgets.add(currencyWidget);
    }
    return currencyWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: getCurrencyWidgets(),
    );
  }
}

class CurrencyWidget extends StatelessWidget {
  const CurrencyWidget({
    @required this.selectedCurrencyPrice,
    @required this.selectedCurrency,
    @required this.virtualCurrency,
  });

  final int selectedCurrencyPrice;
  final String selectedCurrency;
  final String virtualCurrency;

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
            selectedCurrencyPrice != null
                ? '1 $virtualCurrency = $selectedCurrencyPrice $selectedCurrency'
                : '1 $virtualCurrency = ? $selectedCurrency',
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
