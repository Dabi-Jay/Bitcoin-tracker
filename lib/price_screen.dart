import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  const PriceScreen({super.key});

  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'AUD';

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        value: currency,
        child: Text(currency),
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value!;
          getData();
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          getData();
        });
      },
      children: pickerItems,
    );
  }

  String bitcoinValue = '?';

  Map<String, String> coinValues = {};
  bool isWaiting = false;

  void getData() async {
    isWaiting = true;
    try {
      var data = await CoinData().getCoinData(selectedCurrency);
      isWaiting = false;
      setState(() {
        coinValues = data;
      });
    } catch (e) {
      print('$e + na here');
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🤑 Coin Ticker'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              CryptoCard(
                bitcoinValue: isWaiting ? '?' : coinValues['BTC'],
                selectedCurrency: selectedCurrency,
                selectedCrypto: 'BTC',
              ),
              CryptoCard(
                bitcoinValue: isWaiting ? '?' : coinValues['ETH'],
                selectedCurrency: selectedCurrency,
                selectedCrypto: 'ETH',
              ),
              CryptoCard(
                bitcoinValue: isWaiting ? '?' : coinValues['LTC'],
                selectedCurrency: selectedCurrency,
                selectedCrypto: 'LTC',
              ),
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard({
    super.key,
    required this.bitcoinValue,
    required this.selectedCurrency,
    required this.selectedCrypto,
  });

  final String? bitcoinValue;
  final String selectedCurrency;
  final String selectedCrypto;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 15.0,
            horizontal: 18.0,
          ),
          child: Text(
            '1 $selectedCrypto = $bitcoinValue $selectedCurrency',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

////For bonus points, create a method that loops through the cryptoList and generates a CryptoCard for each. Call makeCards() in the build() method instead of the Column with 3 CryptoCards.
//  Column makeCards() {
//    List<CryptoCard> cryptoCards = [];
//    for (String crypto in cryptoList) {
//      cryptoCards.add(
//        CryptoCard(
//          cryptoCurrency: crypto,
//          selectedCurrency: selectedCurrency,
//          value: isWaiting ? '?' : coinValues[crypto],
//        ),
//      );
//    }
//    return Column(
//      crossAxisAlignment: CrossAxisAlignment.stretch,
//      children: cryptoCards,
//    );
//  }
