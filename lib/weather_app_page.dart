import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/hourly_forecast_item.dart';
import 'package:weather_app/secrets.dart';
import 'package:weather_icons/weather_icons.dart';
import 'additional_info_item.dart';
import 'package:http/http.dart' as http;


class WeatherAppPage extends StatefulWidget{
  const WeatherAppPage({super.key});

  @override
  State<WeatherAppPage> createState() => _WeatherAppPageState();
}

class _WeatherAppPageState extends State<WeatherAppPage> {
   late Future<Map<String, dynamic>> weather;
  @override
  void initState(){
    super.initState();
    weather=getCurrentWeather();
  }

  Future<Map<String, dynamic>> getCurrentWeather() async{
  try {
    String cityName = 'Hyderabad';

    final result = await http.get(Uri.parse(
        'http://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherAppApiKey'),
    );

     final data=jsonDecode(result.body);

    if(data['cod']!='200') {
      throw 'An unexpected error occured';
    }
    return data;

  }
  catch(e){
    throw e.toString();
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather', style:TextStyle(
          fontSize: 30,
          color: Colors.black,
           fontWeight: FontWeight.bold,
        ) ,
        ),
        centerTitle: true,
        actions: [IconButton(onPressed: (){
          setState(() {
            weather=getCurrentWeather();
          });
        }, icon:const  Icon(Icons.refresh))
        ],
      ),
      body: FutureBuilder(
        future:weather,
        builder:(context,snapshot) {
         if(snapshot.connectionState==ConnectionState.waiting){
           return const Center(child: CircularProgressIndicator.adaptive());
         }

         if(snapshot.hasError){
           return Center(child: Text(snapshot.error.toString()));
         }

         final data = snapshot.data!;

         final currentWeather = data['list'][0];

         final currentTemp = currentWeather['main']['temp'];
         final currentSky = currentWeather['weather'][0]['main'];
         final currentPressure=currentWeather['main']['pressure'];
         final humidity=currentWeather['main']['humidity'];
         final windSpeed=currentWeather['wind']['speed'];

          return Padding(
          padding:  const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //   main card
            SizedBox(
            width: double.infinity,
            child: Card(
              color: Colors.lightBlueAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)
              ),
              elevation: 10,
              child:ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2,sigmaY: 2),
                  child:  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          '${(currentTemp -273.15).toStringAsFixed(1)} °C',
                          style:
                          const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                        ),
                         Icon(
                           currentSky=='Clouds' ? Icons.cloud : currentSky=='Clear' ? Icons.sunny : currentSky=='Rain' ? WeatherIcons.rain : Icons.error,
                          size: 65,
                        ),
                        const SizedBox(height: 15,),
                         Text('$currentSky', style: const TextStyle(
                          fontSize: 30,
                        ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            ),
            const SizedBox(height: 20,),
            const Text('Hourly Forecast', style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            ),
            const SizedBox(height: 10,),
           //

            SizedBox(
              height: 125,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                  itemCount: data.length,
                  itemBuilder: (context, index){
                    final hourlyForecast = data['list'][index+1];
                    final hourlySky = data['list'][index+1]['weather'][0]['main'];
                    final time=DateTime.parse(hourlyForecast['dt_txt']);
                    return HourlyForecastSystem(
                        time:DateFormat.j().format(time),
                        icon: hourlySky=='Clouds' ? Icons.cloud : hourlySky =='Clear' ? Icons.sunny : hourlySky=='Rain' ? WeatherIcons.rain : Icons.error ,
                        temp: (hourlyForecast['main']['temp']-273.15),
                    );
                  }
              ),
            ),
            const SizedBox(height: 20,),
            const Text('Additional Information',
            style: TextStyle(
              fontSize:28,
              fontWeight: FontWeight.bold,
            ),
            ),
            const SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                 additionalinfo(icon:Icons.water_drop,
                  label:'Humidity',
                  value: humidity.toString(),
                 ),
                 additionalinfo(icon: Icons.air,
                label: 'Wind Speed',
                value: windSpeed.toString(),
                ),
                additionalinfo(icon: Icons.beach_access,
                label: 'Pressure',
                value: currentPressure.toString(),
                ),
              ],
            ),
          ],
          ),
        );
        },
      ),
    );
  }
}



