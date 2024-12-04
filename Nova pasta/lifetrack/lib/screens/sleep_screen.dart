import 'package:flutter/material.dart';

class SleepScreen extends StatelessWidget {
  const SleepScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitoramento de Sono'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Monitoramento do sono diário',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.bedtime),
              title: Text('Horas de sono registradas'),
              subtitle: Text('8 horas'),
            ),
            ListTile(
              leading: Icon(Icons.alarm),
              title: Text('Horário de dormir'),
              subtitle: Text('22:30'),
            ),
            ListTile(
              leading: Icon(Icons.alarm_off),
              title: Text('Horário de acordar'),
              subtitle: Text('06:30'),
            ),
          ],
        ),
      ),
    );
  }
}
