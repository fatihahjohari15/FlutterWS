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
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyWeatherPage(),
    );
  }
}

class MyWeatherPage extends StatefulWidget {
  const MyWeatherPage({Key? key}) : super(key: key);

  @override
  State<MyWeatherPage> createState() => _MyWeatherState();
}

class _MyWeatherState extends State<MyWeatherPage> {
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
    return Scaffold(
        appBar: AppBar(title: const Text("Weather APP")),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Simple Weather App",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
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
            ElevatedButton(
                onPressed: _loadWeather, child: const Text("Load Weather")),
            const SizedBox(height: 10),
            Text(description,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 32)),
          ],
        )));
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
