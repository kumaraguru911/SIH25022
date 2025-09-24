import 'package:flutter/material.dart';
import '../theme/ir_theme.dart';

class KpiPage extends StatefulWidget {
  @override
  _KpiPageState createState() => _KpiPageState();
}

class _KpiPageState extends State<KpiPage> {
  // Dashboard-style gradient colors
  static const Color _appBarStart = Color(0xFF003366);
  static const Color _appBarEnd = Color(0xFF1A2636);
  static const Color _cardBg = Colors.white;
  static const Color _sectionBg = Color(0xFFF3F6FA);

  // Placeholder dynamic KPI data
  Map<String, dynamic> kpiData = {
    'onTimePercent': 92,
    'averageDelay': 3.5,
    'throughput': 58,
    'trackUtilization': 78,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _sectionBg,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [_appBarStart, _appBarEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 8)],
          ),
          child: Row(
            children: [
              SizedBox(width: 18),
              Image.asset(
                'assets/indian_railways_logo.jpeg',
                height: 40,
                width: 40,
                errorBuilder: (_, __, ___) =>
                    Icon(Icons.train, color: Colors.white, size: 36),
              ),
              SizedBox(width: 14),
              Text(
                'KPIs Dashboard',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    letterSpacing: 2),
              ),
              Spacer(),
              Icon(Icons.show_chart, color: Colors.amberAccent),
              SizedBox(width: 8),
              Text(
                'IR Section Controller',
                style: TextStyle(
                    color: Colors.white70, fontWeight: FontWeight.w600),
              ),
              SizedBox(width: 18),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ================= KPI Cards Section =================
            Container(
              padding: EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: _cardBg,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.insights, color: Colors.blueAccent),
                      SizedBox(width: 8),
                      Text(
                        'Performance KPIs',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _appBarEnd),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                          child: kpiCard(
                              title: "On-Time %",
                              value: "${kpiData['onTimePercent']}%",
                              color: Colors.green,
                              icon: Icons.schedule)),
                      SizedBox(width: 16),
                      Expanded(
                          child: kpiCard(
                              title: "Average Delay",
                              value: "${kpiData['averageDelay']} min",
                              color: Colors.red,
                              icon: Icons.timer)),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                          child: kpiCard(
                              title: "Throughput",
                              value: "${kpiData['throughput']} Trains",
                              color: Colors.blue,
                              icon: Icons.train)),
                      SizedBox(width: 16),
                      Expanded(
                          child: kpiCard(
                              title: "Track Utilization",
                              value: "${kpiData['trackUtilization']}%",
                              color: Colors.orange,
                              icon: Icons.track_changes)),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // ================= KPI Graph / Progress Section =================
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _cardBg,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.timeline, color: Colors.amberAccent),
                      SizedBox(width: 8),
                      Text(
                        "Realtime Performance Indicators",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _appBarEnd),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  buildProgressBar(
                      label: "Network Efficiency", value: 0.85, color: Colors.green),
                  buildProgressBar(
                      label: "Platform Utilization", value: 0.72, color: Colors.orange),
                  buildProgressBar(
                      label: "Train Punctuality", value: 0.92, color: Colors.blue),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: buildCircularKpi(
                            label: "Daily Trains",
                            value: 58,
                            maxValue: 100,
                            color: _appBarEnd),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: buildCircularKpi(
                            label: "Late Trains",
                            value: 8,
                            maxValue: 100,
                            color: Colors.red),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 20), // Extra space at bottom for safe scroll
          ],
        ),
      ),
    );
  }

  // ================= KPI Card =================
  Widget kpiCard({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 28),
                SizedBox(width: 10),
                Text(title,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 12),
            Text(value,
                style: TextStyle(
                    fontSize: 26, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }

  // ================= Linear Progress Bars =================
  Widget buildProgressBar(
      {required String label, required double value, required Color color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$label: ${(value * 100).toStringAsFixed(1)}%",
              style: TextStyle(fontSize: 16)),
          SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 16,
              color: color,
              backgroundColor: Colors.grey[300],
            ),
          ),
        ],
      ),
    );
  }

  // ================= Circular KPI Indicator =================
  Widget buildCircularKpi({
    required String label,
    required double value,
    required double maxValue,
    required Color color,
  }) {
    double percentage = (value / maxValue).clamp(0, 1);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 70,
                height: 70,
                child: CircularProgressIndicator(
                  value: percentage,
                  color: color,
                  backgroundColor: Colors.grey[300],
                  strokeWidth: 8,
                ),
              ),
              Text("${(percentage * 100).toStringAsFixed(0)}%",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(width: 16),
          Text(label, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
