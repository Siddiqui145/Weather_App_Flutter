import 'package:flutter/material.dart';
import 'package:weather_app/Weather_Screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Weather App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),

      home: ( WeatherScreen()), // The first screen of your app
    );
  }
}

@override
Widget build(BuildContext context) {
  return  WeatherScreen();
}
