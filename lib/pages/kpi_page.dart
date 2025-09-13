import 'package:flutter/material.dart';

class KpiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('KPIs Dashboard'), backgroundColor: Colors.blue[900]),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: kpiCard('On-Time %', '92%', Colors.green)),
                SizedBox(width: 16),
                Expanded(child: kpiCard('Average Delay', '3.5 min', Colors.red)),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: kpiCard('Throughput', '58 Trains', Colors.blue)),
                SizedBox(width: 16),
                Expanded(child: kpiCard('Track Utilization', '78%', Colors.orange)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget kpiCard(String title, String value, Color color) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(title, style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text(value,
                style: TextStyle(fontSize: 28, color: color, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
