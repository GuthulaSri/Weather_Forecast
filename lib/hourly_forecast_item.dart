import 'package:flutter/material.dart';
class HourlyForecastSystem extends StatelessWidget{
  final String time;
  final IconData icon;
  final double temp;

  const HourlyForecastSystem({
    super.key,
    required this.time,
    required this.icon,
    required this.temp,

  });

  @override
  Widget build(BuildContext context) {
    return  Card(
      color: Colors.lightBlueAccent,
      elevation: 6,
      child:Container(
        width: 100,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40)
        ),
        child:Column(
          children: [
            Text(time, style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8,),
            Icon(icon,
              size: 32,
            ),
            const SizedBox(height: 8,),
            Text('${temp.toStringAsFixed(1)} °C',style: const TextStyle(
              fontSize: 16,
            ),
            ),
          ],
        ),
      ),
    );
  }
}
