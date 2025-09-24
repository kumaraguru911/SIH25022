import 'package:flutter/material.dart';

class DisruptionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Disruption Handling'), backgroundColor: Colors.red[900]),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            disruptionCard(
                'Signal failure at Station Y',
                'Impact: Express 12951 delayed 8 min',
                Colors.red[100]!,
                Colors.red[700]!),
            disruptionCard(
                'Track Block Section A-B',
                'AI Suggestion: Reroute Freight via Loop Line',
                Colors.orange[100]!,
                Colors.orange[700]!),
          ],
        ),
      ),
    );
  }

  Widget disruptionCard(
      String title, String subtitle, Color bg, Color buttonColor) {
    return Card(
      color: bg,
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: ElevatedButton(
          child: Text('Apply AI Plan'),
          style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
          onPressed: () {},
        ),
      ),
    );
  }
}
