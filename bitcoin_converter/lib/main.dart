import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ndialog/ndialog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BitCoin Converter',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: Scaffold(
        backgroundColor: Colors.lightBlue[100],
        appBar: AppBar(
          title: const Text('BitCoin Converter'),
        ),
        body: const Center(child: BtcConvPage()),
      ),
    );
  }
}

class BtcConvPage extends StatefulWidget {
  const BtcConvPage({Key? key}) : super(key: key);

  @override
  State<BtcConvPage> createState() => _BtcConvPageState();
}

class _BtcConvPageState extends State<BtcConvPage> {
  String selectLoc = "Changlun",
      description = "No weather information",
      weather = "";
  var temperature = 0.0, feelslike = 0.0, humidity = 0;
  // if not sure the value just put like this >>> var temperature, feelslike, humidity;
  List<String> locList = [
    "Changlun",
    "Jitra",
    "Alor Setar",
    "Baling",
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(
                hintText: 'Enter value in Bitcoin',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0))),
            keyboardType: const TextInputType.numberWithOptions(),
          ),
          const SizedBox(height: 10),
          DropdownButton(
            itemHeight: 60,
            value: selectLoc,
            onChanged: (newValue) {
              setState(() {
                selectLoc = newValue.toString();
              });
            },
            items: locList.map((selectLoc) {
              return DropdownMenuItem(
                child: Text(
                  selectLoc,
                ),
                value: selectLoc,
              );
            }).toList(),
          ),
          ElevatedButton(onPressed: _loadWeather, child: const Text("Convert")),
          const SizedBox(height: 10),
          Text(description,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 32)),
        ],
      ),
    ));
  }

  Future<void> _loadWeather() async {
    ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text("Progress"), title: const Text("Searching..."));
    progressDialog.show();
    var apiid = "946e5008fb41777080260ebf25ebcb6d";
    var url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$selectLoc&appid=$apiid&units=metric");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonData = response.body;
      var parsedData = json.decode(jsonData);
      temperature = parsedData['main']['temp'];
      humidity = parsedData['main']['humidity'];
      weather = parsedData['weather'][0]['main'];
      feelslike = parsedData['main']['feels_like'];
      setState(() {
        description =
            "The current weather in $selectLoc is $weather. The current temperature is $temperature Celcius and humidity is $humidity percent. ";
      });
      progressDialog.dismiss();
    }
  }
}
