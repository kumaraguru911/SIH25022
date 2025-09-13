import 'package:flutter/material.dart';

class TrainingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Simulation Lab'), backgroundColor: Colors.blue[900]),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: List.generate(5, (index) {
            return Card(
              child: ListTile(
                title: Text('Scenario ${index + 1}: Signal Failure / Fog Delay'),
                subtitle: Text('AI Recommendation: Hold / Reroute / Optimize'),
                trailing: ElevatedButton(
                  child: Text('Simulate'),
                  onPressed: () {},
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
