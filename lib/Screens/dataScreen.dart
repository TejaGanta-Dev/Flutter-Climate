import 'dart:convert';

import 'package:climate_app/Screens/city.dart';
import 'package:climate_app/Screens/constants.dart';
import 'package:climate_app/Screens/loadingScreen.dart';
import 'package:climate_app/Screens/weather.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DataScreen extends StatefulWidget {
  final weatherData;
  const DataScreen({super.key, this.weatherData});

  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  int condition = 10;
  int temp = 10;
  String city = 'London';
  @override
  void initState() {
    super.initState();
    updateUi(widget.weatherData);
  }

  WeatherModel weatherModel = WeatherModel();
  updateUi(dynamic weatherData) {
    double temprature = weatherData['main']['temp'];
    temp = temprature.toInt();
    condition = weatherData['weather'][0]['id'];
    city = weatherData['name'];
  }

  Future<void> getCurrentWeatherData(String city) async {
    print('object');
    var url = Uri.https('api.openweathermap.org', '/data/2.5/weather', {
      'q': city,
      'appid': '82b251f3d90b5a34877fded7614712e8',
      'units': 'metric'
    });
    http.Response response = await http.get(url);
    print(response.body);
    setState(() {
      updateUi(jsonDecode(response.body));
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Center(child: Text('Clima'))),
        body: Container(
          constraints: const BoxConstraints.expand(),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        print('Get');
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const MyHomePage(title: 'Flutter Home Page');
                        }));
                      },
                      child: const Icon(
                        Icons.near_me,
                        size: 50.0,
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        var cityName = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const CityScreen();
                            },
                          ),
                        );
                        print(cityName);
                        if (cityName != null) {
                          getCurrentWeatherData(cityName);
                        }
                      },
                      child: const Icon(
                        Icons.location_city,
                        size: 50.0,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '$temp°',
                        style: kTempTextStyle,
                      ),
                      Text(
                        weatherModel.getWeatherIcon(condition),
                        style: kConditionTextStyle,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Text(
                    "${weatherModel.getMessage(temp)} in $city",
                    textAlign: TextAlign.right,
                    style: kMessageTextStyle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
