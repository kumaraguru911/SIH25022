import 'package:flutter/material.dart';

class SimulationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('What-if Simulation'), backgroundColor: Colors.blue[900]),
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.grey[100],
              child: Center(
                  child: Text('Gantt Chart: Drag/Drop Trains',
                      style: TextStyle(fontSize: 24))),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.grey[200],
              child: Center(
                  child: Text('AI Impact Panel: Delay Saved/Lost',
                      style: TextStyle(fontSize: 20))),
            ),
          ),
        ],
      ),
    );
  }
}
