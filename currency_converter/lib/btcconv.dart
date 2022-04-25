import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ndialog/ndialog.dart';

class BTCScreen extends StatelessWidget {
  const BTCScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 201, 171, 211),
      appBar: AppBar(
        title: const Text('BitCoin Converter'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
                height: 200,
                child: Center(
                  child: Image.asset('assets/images/bitcoinLogo.png', scale: 2),
                )),
            const BTCForm(),
          ],
        ),
      ),
    );
  }
}

class BTCForm extends StatefulWidget {
  const BTCForm({Key? key}) : super(key: key);

  @override
  State<BTCForm> createState() => _BTCFormState();
}

class _BTCFormState extends State<BTCForm> {
  TextEditingController valueEditingController = TextEditingController();
  String selectCurrency = "eth", finalValue = "Please enter any value";
  double input = 0.0, result = 0.0;

  List<String> currencyList = [
    "eth",
    "ltc",
    "bch",
    "bnb",
    "eos",
    "xrp",
    "xlm",
    "link",
    "dot",
    "yfi",
    "usd",
    "aed",
    "ars",
    "aud",
    "bdt",
    "bhd",
    "bmd",
    "brl",
    "cad",
    "chf",
    "clp",
    "cny",
    "czk",
    "dkk",
    "eur",
    "gbp",
    "hkd",
    "huf",
    "idr",
    "ils",
    "inr",
    "jpy",
    "krw",
    "kwd",
    "lkr",
    "mmk",
    "mxn",
    "myr",
    "ngn",
    "nok",
    "nzd",
    "php",
    "pkr",
    "pln",
    "rub",
    "sar",
    "sek",
    "sgd",
    "thb",
    "try",
    "twd",
    "uah",
    "vef",
    "vnd",
    "zar",
    "xdr",
    "xag",
    "xau",
    "bits",
    "sats",
    "btc"
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
            child: Column(children: [
          const Text(
            "BitCoin Currency Converter",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          TextField(
            controller: valueEditingController,
            keyboardType: const TextInputType.numberWithOptions(),
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: "Enter value in Bitcoin",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                )),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text("Convert to: ",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              DropdownButton(
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
                itemHeight: 60,
                borderRadius: BorderRadius.circular(20.0),
                value: selectCurrency,
                onChanged: (newValue) {
                  setState(() {
                    selectCurrency = newValue.toString();
                  });
                },
                items: currencyList.map((selectCurrency) {
                  return DropdownMenuItem(
                    child: Text(
                      selectCurrency,
                    ),
                    value: selectCurrency,
                  );
                }).toList(),
              ),
            ],
          ),
          ElevatedButton(
              onPressed: _convertBTC,
              child: const Text("Convert",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
          const SizedBox(height: 10),
          Container(
            width: 500,
            height: 125,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              children: [
                Text(finalValue,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 22)),
              ],
            ),
          )
        ])));
  }

  Future<void> _convertBTC() async {
    ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text("Progress"), title: const Text("Searching..."));
    progressDialog.show();

    var url = Uri.parse('https://api.coingecko.com/api/v3/exchange_rates');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonData = response.body;
      var parsedData = json.decode(jsonData);
      var value = parsedData['rates'][selectCurrency]['value'];
      var unit = parsedData['rates'][selectCurrency]['unit'];

      input = double.parse(valueEditingController.text);
      result = input * value;

      setState(() {
        finalValue =
            "Value of $input BTC is $unit " + result.toStringAsFixed(2);
      });
      progressDialog.dismiss();
    }
  }
}
