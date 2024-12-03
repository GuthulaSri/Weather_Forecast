import 'package:flutter/material.dart';
import 'package:weather_app/weather_app_page.dart';

void main(){
  runApp(const WeatherApp());
}

class WeatherApp extends StatefulWidget{
  const WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
@override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
      appBarTheme:  const AppBarTheme( color: Colors.blue),
      ),
      home:  const WeatherAppPage(),

    );
  }
}