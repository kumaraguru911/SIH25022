import 'package:flutter/material.dart';

class SimulationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Simulation Lab'), backgroundColor: Colors.blue[900]),
      body: Center(
        child: Text('Simulation Page', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
