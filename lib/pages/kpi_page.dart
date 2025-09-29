import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class KpiPage extends StatelessWidget {
  // Re-using colors from Dashboard for consistency
  static const Color irPrimaryBlue = Color(0xFF0B2B4E);
  static const Color textColor = Color(0xFF1E293B);
  static const Color secondaryTextColor = Color(0xFF64748B);
  static const Color dashboardBg = Color(0xFFF0F2F5);

  // Placeholder dynamic KPI data
  Map<String, dynamic> kpiData = {
    'onTimePercent': 92,
    'averageDelay': 3.5,
    'throughput': 58,
    'trackUtilization': 78,
    'networkEfficiency': 85,
    'platformUtilization': 72,
    'trainPunctuality': 92,
    'criticalAlerts': 3,
  };

  // Mock data for the bar chart
  final List<double> weeklyThroughput = [55, 62, 58, 65, 70, 68, 58];

  KpiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Key Performance Indicators", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28, color: textColor)),
          const SizedBox(height: 12),
          Text("Divisional performance metrics for the current operational day.", style: TextStyle(fontSize: 14, color: secondaryTextColor)),
          const SizedBox(height: 30),

          // Main KPI Cards
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              kpiCard(title: "On-Time Percentage", value: "${kpiData['onTimePercent']}%", trend: "up", change: "+1.2%"),
              kpiCard(title: "Average Delay", value: "${kpiData['averageDelay']} min", trend: "down", change: "-0.5 min"),
              kpiCard(title: "Daily Throughput", value: "${kpiData['throughput']} Trains", trend: "up", change: "+3"),
              kpiCard(title: "Critical Alerts", value: "${kpiData['criticalAlerts']}", trend: "neutral", change: "0"),
            ],
          ),
          const SizedBox(height: 40),

          // Secondary Metrics Section
          _buildSection(
            title: "Operational Efficiency",
            icon: Icons.insights,
            child: Column(
              children: [_buildEfficiencyChart()],
            ),
          ),
          const SizedBox(height: 20),

          // Key Metrics List
          _buildSection(
            title: "Punctuality Breakdown",
            icon: Icons.pie_chart_outline,
            child: Column(
              children: [
                _buildMetricRow("On-Time Trains", "50"),
                _buildMetricRow("Minor Delays (< 15 min)", "6"),
                _buildMetricRow("Major Delays (> 15 min)", "2"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required IconData icon, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(0.05), offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: irPrimaryBlue, size: 20),
              const SizedBox(width: 10),
              Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
            ],
          ),
          const Divider(height: 24),
          child,
        ],
      ),
    );
  }

  Widget kpiCard({required String title, required String value, required String trend, required String change}) {
    final trendIcon = trend == "up" ? Icons.arrow_upward : (trend == "down" ? Icons.arrow_downward : Icons.remove);
    final trendColor = trend == "up" ? Colors.green : (trend == "down" ? Colors.red : Colors.grey);

    return Container(
      width: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(0.05), offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 15, color: secondaryTextColor, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: irPrimaryBlue)),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(trendIcon, color: trendColor, size: 16),
              const SizedBox(width: 4),
              Text(change, style: TextStyle(color: trendColor, fontWeight: FontWeight.bold)),
              const SizedBox(width: 4),
              Text("vs yesterday", style: TextStyle(color: secondaryTextColor, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEfficiencyChart() {
    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 100,
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) => Colors.black87,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                String label;
                switch (group.x.toInt()) {
                  case 0:
                    label = 'Track Utilization';
                    break;
                  case 1:
                    label = 'Network Efficiency';
                    break;
                  case 2:
                    label = 'Platform Utilization';
                    break;
                  default:
                    throw Error();
                }
                return BarTooltipItem(
                  '$label\n',
                  const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  children: <TextSpan>[
                    TextSpan(
                      text: rod.toY.toStringAsFixed(0) + '%',
                      style: const TextStyle(color: irPrimaryBlue, fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ],
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  const style = TextStyle(color: secondaryTextColor, fontWeight: FontWeight.bold, fontSize: 14);
                  String text;
                  switch (value.toInt()) {
                    case 0:
                      text = 'Track';
                      break;
                    case 1:
                      text = 'Network';
                      break;
                    case 2:
                      text = 'Platform';
                      break;
                    default:
                      text = '';
                      break;
                  }
                  return SideTitleWidget(axisSide: meta.axisSide, space: 16, child: Text(text, style: style));
                },
                reservedSize: 38,
              ),
            ),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          barGroups: [
            _makeBarGroup(0, kpiData['trackUtilization'].toDouble()),
            _makeBarGroup(1, kpiData['networkEfficiency'].toDouble()),
            _makeBarGroup(2, kpiData['platformUtilization'].toDouble()),
          ],
          gridData: FlGridData(show: false),
        ),
      ),
    );
  }

  BarChartGroupData _makeBarGroup(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: irPrimaryBlue,
          width: 22,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(6),
            topRight: Radius.circular(6),
          ),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 100,
            color: Colors.grey.shade200,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16, color: secondaryTextColor)),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
        ],
      ),
    );
  }
}
