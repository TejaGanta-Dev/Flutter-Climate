import 'dart:async';
import 'dart:convert';

import 'package:climate_app/Screens/dataScreen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    getLocation();
    print('init');
  }

  late double latitude;
  late double longitude;
  Future<Position> getLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position);
    latitude = position.latitude;
    longitude = position.longitude;
    getCurrentWeatherData();
    return position;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              onPressed: () {
                getCurrentWeatherData();
              },
              style: TextButton.styleFrom(backgroundColor: Colors.yellow),
              child: const Text(
                'Get location',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  late double temp;
  late int condition;
  late String city;
  Future<void> getCurrentWeatherData() async {
    print('object');
    var url = Uri.https('api.openweathermap.org', '/data/2.5/weather', {
      'lat': '$latitude',
      'lon': '$longitude',
      'appid': '82b251f3d90b5a34877fded7614712e8',
      'units': 'metric'
    });
    http.Response response = await http.get(url);
    print(response.body);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return DataScreen(weatherData: jsonDecode(response.body));
        },
      ),
    );
  }
}
