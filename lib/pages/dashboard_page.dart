import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

// Data Models
enum TrainDirection { UP, DOWN }

class SectionTrain {
  final String id;
  final String name;
  double pos;
  TrainDirection direction;
  String status;
  String eta;
  int speed;
  String loco;
  int delay;
  String currentSection;

  SectionTrain({
    required this.id,
    required this.name,
    required this.pos,
    required this.direction,
    required this.status,
    required this.eta,
    required this.speed,
    required this.loco,
    required this.delay,
    required this.currentSection,
  });
}

void main() {
  runApp(const RailwayDashboardApp());
}

class RailwayDashboardApp extends StatelessWidget {
  const RailwayDashboardApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Section Control',
      theme: ThemeData(
        fontFamily: 'Roboto',
        primaryColor: _DashboardPageState.irPrimaryBlue,
        scaffoldBackgroundColor: _DashboardPageState.dashboardBg,
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      home: const DashboardPage(),
    );
  }
}

// --- Dashboard Page ---
class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Professional & Indian Railways-inspired Color Palette
  static const Color irPrimaryBlue = Color(0xFF0B2B4E);
  static const Color irMaroon = Color(0xFFAA2C2B);
  static const Color irGold = Color(0xFFFFCC33);
  static const Color kpiGreen = Color(0xFF22C55E);
  static const Color kpiRed = Color(0xFFDC2626);
  static const Color kpiOrange = Color(0xFFF79E74);
  static const Color dashboardBg = Color(0xFFF0F2F5);
  static const Color cardColor = Colors.white;
  static const Color textColor = Color(0xFF1E293B);
  static const Color secondaryTextColor = Color(0xFF64748B);

  // Data
  bool online = true;
  int activeTrains = 8;
  // Map to hold train images. Make sure these paths are correct in your assets folder.
final Map<String, String> _trainImages = {
  'Chennai Mail': 'assets/chennai_central.jpg',
  'Bangalore Mail': 'assets/bengaluru.jpg',
  'Bangalore Express': 'assets/bengaluru.jpg',
  'Sanghamitra Express': 'assets/sanghamitra.jpg',
  'Brindavan Express': 'assets/bengaluru.jpg',
  'Intercity Express': 'assets/mumbai.jpg',
  'Mysuru Express': 'assets/Mysuru.jpg',
  'Yercaud Express': 'assets/yercaud.jpg',
  // Add other train names and their image paths here
};
  List<Map<String, dynamic>> alerts = [
    {"level": "Critical", "title": "Track signal failure", "route": "MAS-KPD", "affected": ["12295", "12640"], "time": "17:30"},
    {"level": "High", "title": "GOOTY–REN signal delay", "route": "GOOTY-REN", "affected": ["12657"], "time": "12:40"},
    {"level": "Info", "title": "Maintenance scheduled", "route": "MAS", "affected": [], "time": "18:00"},
  ];
  List<SectionTrain> sectionTrains = [
    SectionTrain(id: '12295', name: 'Sanghamitra Express', pos: 0.13, direction: TrainDirection.UP, status: 'On Time', eta: '13:18', speed: 110, loco: "WAP7-30159", delay: 0, currentSection: "MAS-AJJ"),
    SectionTrain(id: '12640', name: 'Brindavan Express', pos: 0.24, direction: TrainDirection.UP, status: 'Delayed', eta: '17:28', speed: 100, loco: "WAP4-22673", delay: 13, currentSection: "AJJ-KPD"),
    SectionTrain(id: '12657', name: 'Bangalore Mail', pos: 0.70, direction: TrainDirection.DOWN, status: 'Delayed', eta: '14:50', speed: 85, loco: "WAP7-30343", delay: 25, currentSection: "JTJ-SA"),
    SectionTrain(id: '12681', name: 'Chennai Mail', pos: 0.56, direction: TrainDirection.UP, status: 'Delayed', eta: '15:30', speed: 90, loco: "WAP7-30221", delay: 32, currentSection: "KPD-JTJ"),
    SectionTrain(id: '16526', name: 'Bangalore Express', pos: 0.05, direction: TrainDirection.DOWN, status: 'On Time', eta: '11:00', speed: 120, loco: "WAP7-30111", delay: 0, currentSection: "SBC-HSUR"),
    SectionTrain(id: '12678', name: 'Intercity Express', pos: 0.35, direction: TrainDirection.DOWN, status: 'On Time', eta: '16:05', speed: 105, loco: "WAP4-22289", delay: 0, currentSection: "DPJ-SA"),
    SectionTrain(id: '12659', name: 'Mysuru Express', pos: 0.20, direction: TrainDirection.UP, status: 'On Time', eta: '17:00', speed: 115, loco: "WAP4-22673", delay: 0, currentSection: "SA-ED"),
    SectionTrain(id: '16527', name: 'Yercaud Express', pos: 0.55, direction: TrainDirection.UP, status: 'Delayed', eta: '18:30', speed: 80, loco: "WAP7-30155", delay: 15, currentSection: "ED-SA"),
  ];
  final List<String> stationList = const ['MAS', 'AJJ', 'KPD', 'JTJ', 'SA', 'DPJ', 'HSUR', 'SBC', 'ED'];

  String trainFilter = "All";
  String selectedAlertRoute = "";
  Timer? _animTimer;
  final Random _rand = Random();

  List<SectionTrain> get filteredTrains {
    if (trainFilter == "All") return sectionTrains;
    if (trainFilter == "Delayed") return sectionTrains.where((t) => t.delay > 0).toList();
    if (trainFilter == "On-time") return sectionTrains.where((t) => t.delay == 0).toList();
    return sectionTrains;
  }

  @override
  void initState() {
    super.initState();
    _animTimer = Timer.periodic(const Duration(milliseconds: 700), (_) {
      setState(() {
        for (var t in sectionTrains) {
          double speed = (t.status == 'Delayed') ? 0.003 : 0.01;
          if (t.direction == TrainDirection.UP) {
            t.pos += speed * (_rand.nextDouble() + 0.2);
            if (t.pos > 1.0) t.pos = 0.0;
          } else {
            t.pos -= speed * (_rand.nextDouble() + 0.2);
            if (t.pos < 0.0) t.pos = 1.0;
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _animTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dashboardBg,
      body: SafeArea(
        child: Row(
          children: [
            // Sidebar
            _sidebar(),
            // Main content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Page Header
                    Text("Control Dashboard", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28, color: textColor)),
                    const SizedBox(height: 12),
                    Text("Real-time operational overview for Madras Division", style: TextStyle(fontSize: 14, color: secondaryTextColor)),
                    const SizedBox(height: 30),
                    // KPIs
                    _kpiWrap(),
                    const SizedBox(height: 30),
                    // Panels grid (map, trains, alerts)
                    _dashboardPanels(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: irPrimaryBlue,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => ChatbotPage()));
        },
        child: const Icon(Icons.chat_bubble_outline, color: Colors.white),
      ),
    );
  }

  // --- Widget Builders ---
  Widget _sidebar() {
    return Container(
      width: 250.0,
      decoration: BoxDecoration(
        color: irPrimaryBlue,
        boxShadow: [BoxShadow(blurRadius: 13, color: Colors.black.withOpacity(0.07), offset: const Offset(0, 4))],
      ),
      padding: const EdgeInsets.symmetric(vertical: 21, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.train, color: irGold, size: 28),
              const SizedBox(width: 8),
              Text("Section Control", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
            ],
          ),
          const SizedBox(height: 25),
          _sidebarBtn(Icons.dashboard_rounded, "Control Dashboard", selected: true),
          _sidebarBtn(Icons.directions_subway, "Live Movements", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LiveMovementsPage()))),
          _sidebarBtn(Icons.lightbulb_outline, "AI-Recommendation", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AiRecommendationsPage()))),
          _sidebarBtn(Icons.bar_chart, "Reports & Analytics", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ReportsAnalyticsPage()))),
          const SizedBox(height: 20),
          _sidebarStatus(),
          const Spacer(),
          const Divider(color: Colors.white24, height: 20),
          Row(
            children: [
              CircleAvatar(backgroundColor: irGold, child: Text('SC', style: TextStyle(color: irPrimaryBlue, fontWeight: FontWeight.bold))),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Section Controller", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
                  Text("Madras Division", style: TextStyle(fontSize: 12, color: Colors.white70)),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _sidebarBtn(IconData icon, String label, {bool selected = false, VoidCallback? onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 10),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: selected ? Colors.white.withOpacity(0.13) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: selected ? irGold : Colors.white70, size: 20),
            const SizedBox(width: 10),
            Text(label, style: TextStyle(fontWeight: selected ? FontWeight.bold : FontWeight.normal, fontSize: 15, color: selected ? Colors.white : Colors.white70)),
          ],
        ),
      ),
    );
  }

  Widget _sidebarStatus() {
    String istTime = TimeOfDay.now().format(context);
    return Container(
      decoration: BoxDecoration(
        color: irPrimaryBlue.withOpacity(0.5),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: irGold.withOpacity(0.2)),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("SYSTEM STATUS", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 10, color: Colors.white54)),
          const SizedBox(height: 6),
          _statusRow(Icons.power, "Online", online ? kpiGreen : kpiRed),
          _statusRow(Icons.access_time, "IST Time: $istTime", Colors.white),
          _statusRow(Icons.train, "Active Trains: $activeTrains", irGold),
          _statusRow(Icons.warning_amber_rounded, "Alerts: ${alerts.length}", kpiRed),
        ],
      ),
    );
  }

  Widget _statusRow(IconData icon, String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(text, style: TextStyle(fontSize: 12, color: color)),
        ],
      ),
    );
  }

  Widget _kpiWrap() {
    return Wrap(
      spacing: 20,
      runSpacing: 20,
      alignment: WrapAlignment.start,
      children: [
        _kpiCard(title: "Active Trains", value: "$activeTrains", icon: Icons.train_rounded, accent: irPrimaryBlue),
        _kpiCard(title: "On-Time %", value: "${_calculateOnTime()}%", icon: Icons.av_timer_rounded, accent: _onTimeColor()),
        _kpiCard(title: "Critical Alerts", value: "${_criticalAlertsCount()}", icon: Icons.error_rounded, accent: kpiRed),
        _kpiCard(title: "RAILOPT-AI", value: "3", icon: Icons.lightbulb, accent: irGold, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AiRecommendationsPage()))),
      ],
    );
  }

  Widget _kpiCard({required String title, required String value, required IconData icon, required Color accent, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 200,
        height: 100,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(0.05), offset: const Offset(0, 4))],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(icon, color: accent, size: 24),
                const SizedBox(width: 8),
                Expanded(child: Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: secondaryTextColor, fontSize: 14))),
              ],
            ),
            const SizedBox(height: 6),
            Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: textColor, fontSize: 24)),
          ],
        ),
      ),
    );
  }

  Widget _dashboardPanels() {
  return LayoutBuilder(builder: (ctx, cons) {
    double panelWidth = (cons.maxWidth - 20) / 2;
    if (cons.maxWidth < 700) {
      panelWidth = cons.maxWidth;
    }
    return Wrap(
      spacing: 20,
      runSpacing: 20,
      children: [
        _panelContainer(
          width: cons.maxWidth,
          height: 400,
          child: SectionMap(
            stations: stationList,
            trains: sectionTrains,
            highlightRoute: selectedAlertRoute,
            onStationTap: _showStationDetails,
            onTrainTap: _showTrainDetails,
          ),
        ),
        _panelContainer(width: panelWidth, height: 400, child: _liveTrainPanel()),
        _panelContainer(width: panelWidth, height: 400, child: _alertsPanel()),
      ],
    );
  });
}

  Widget _panelContainer({required double width, required double height, required Widget child}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(0.05), offset: const Offset(0, 4))],
      ),
      child: child,
    );
  }

  Widget _liveTrainPanel() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Live Train Movements", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: textColor)),
              Row(
                children: [
                  _filterTab("All"),
                  _filterTab("Delayed"),
                  _filterTab("On-time"),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(color: Colors.black12, height: 1),
          const SizedBox(height: 10),
          _buildDetailedTrainTable(),
        ],
      ),
    );
  }

  Widget _buildDetailedTrainTable() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Table Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(color: dashboardBg, borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  SizedBox(width: 40, child: Text("ID", style: TextStyle(fontWeight: FontWeight.bold, color: secondaryTextColor))),
                  SizedBox(width: 120, child: Text("Name", style: TextStyle(fontWeight: FontWeight.bold, color: secondaryTextColor))),
                  SizedBox(width: 60, child: Text("Status", style: TextStyle(fontWeight: FontWeight.bold, color: secondaryTextColor))),
                  SizedBox(width: 50, child: Text("Speed", style: TextStyle(fontWeight: FontWeight.bold, color: secondaryTextColor))),
                  Expanded(child: Text("Delay", style: TextStyle(fontWeight: FontWeight.bold, color: secondaryTextColor))),
                ],
              ),
            ),
            // Table Rows
            const SizedBox(height: 8),
            ...filteredTrains.map((t) => _buildTrainRow(t)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTrainRow(SectionTrain t) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(blurRadius: 2, color: Colors.black12)],
      ),
      child: Row(
        children: [
          SizedBox(width: 40, child: Text(t.id, style: TextStyle(fontWeight: FontWeight.w600, color: textColor, fontSize: 13))),
          SizedBox(width: 120, child: Text(t.name, style: TextStyle(fontWeight: FontWeight.w500, color: textColor, fontSize: 13))),
          SizedBox(
            width: 60,
            child: _statusChip(t.delay),
          ),
          SizedBox(width: 50, child: Text("${t.speed} kmph", style: TextStyle(color: secondaryTextColor, fontSize: 13))),
          Expanded(child: Text(t.delay == 0 ? "On Time" : "+${t.delay} min", style: TextStyle(fontWeight: FontWeight.bold, color: _trainStatusColor(t.delay), fontSize: 13))),
        ],
      ),
    );
  }

  Widget _alertsPanel() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Alerts & Disruptions", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: textColor)),
          const SizedBox(height: 10),
          const Divider(color: Colors.black12, height: 1),
          Expanded(
            child: ListView.builder(
              itemCount: alerts.length,
              itemBuilder: (_, i) => Dismissible(
                key: Key(alerts[i]["route"]),
                onDismissed: (direction) {
                  setState(() {
                    alerts.removeAt(i);
                    // Reset highlight if dismissed route was highlighted
                    if (selectedAlertRoute == alerts[i]["route"]) {
                      selectedAlertRoute = "";
                    }
                  });
                },
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  color: Colors.green.shade600,
                  child: const Icon(Icons.check, color: Colors.white),
                ),
                child: _alertCard(alerts[i]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterTab(String label) {
    final bool isSelected = trainFilter == label;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: ChoiceChip(
        selected: isSelected,
        label: Text(label),
        onSelected: (selected) => setState(() => trainFilter = label),
        selectedColor: irPrimaryBlue.withOpacity(.13),
        backgroundColor: dashboardBg,
        labelStyle: TextStyle(
          color: isSelected ? irPrimaryBlue : secondaryTextColor,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        ),
        visualDensity: VisualDensity.compact,
      ),
    );
  }

  Widget _statusChip(int delay) {
    final statusColor = _trainStatusColor(delay);
    final statusText = delay == 0 ? "On Time" : (delay > 20 ? "Critical" : "Delayed");
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: statusColor.withOpacity(0.15), borderRadius: BorderRadius.circular(16)),
      child: Text(statusText, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }

  Color _trainStatusColor(int delay) {
    return delay == 0 ? kpiGreen : (delay > 20 ? kpiRed : kpiOrange);
  }

  Widget _alertCard(Map<String, dynamic> a) {
    Color levelColor;
    if (a["level"] == "Critical") levelColor = kpiRed;
    else if (a["level"] == "High") levelColor = kpiOrange;
    else levelColor = kpiGreen;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: () => setState(() => selectedAlertRoute = a["route"]),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: levelColor, size: 20),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: levelColor.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
                    child: Text(a["level"], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: levelColor)),
                  ),
                  const SizedBox(width: 8),
                  Text(a["route"], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: textColor)),
                  const Spacer(),
                  Text(a["time"], style: TextStyle(color: secondaryTextColor, fontSize: 11)),
                ],
              ),
              const SizedBox(height: 8),
              Text(a["title"], style: TextStyle(fontWeight: FontWeight.w600, color: textColor)),
              if ((a["affected"] as List).isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      Icon(Icons.directions_train, size: 14, color: secondaryTextColor),
                      const SizedBox(width: 4),
                      Text("Impacts trains: ", style: TextStyle(fontSize: 12, color: secondaryTextColor)),
                      Expanded(
                        child: Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: (a["affected"] as List).map((trainId) => _infoChip(trainId, irMaroon)).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // The void _showStationDetails function
void _showStationDetails(String stationCode) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      int trainsAtStation = sectionTrains.where((t) => 
          t.currentSection.contains(stationCode) ||
          (stationList.indexOf(t.currentSection.split('-').first) == stationList.indexOf(stationCode))
      ).length;
      int activeAlerts = alerts.where((a) => a["route"].contains(stationCode)).length;

      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("$stationCode Station Status", style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Current Status: All Clear", style: TextStyle(color: kpiGreen, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _detailRow(Icons.train, "Trains in Vicinity:", "$trainsAtStation"),
            _detailRow(Icons.warning, "Active Alerts:", "$activeAlerts"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Close", style: TextStyle(color: irPrimaryBlue, fontWeight: FontWeight.bold)),
          ),
        ],
      );
    },
  );
}

// The void _showTrainDetails function with the added image
void _showTrainDetails(SectionTrain t) {
  String imagePath = _trainImages[t.name] ?? 'assets/train_loco.jpg'; // Use a default image if not found

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.directions_train, color: irPrimaryBlue),
            const SizedBox(width: 10),
            Text("${t.id} - ${t.name}", style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display the dynamic train image
              Center(
                child: Image.asset(
                  imagePath,
                  height: 100,
                  width: 150,
                  fit: BoxFit.cover,
                ),
              ),
              const Divider(height: 20, thickness: 1),
              _detailRow(Icons.access_time_filled, "ETA", t.eta),
              _detailRow(Icons.speed, "Speed", "${t.speed} kmph"),
              _detailRow(Icons.timer_off, "Delay", "${t.delay} min"),
              _detailRow(Icons.power_settings_new, "Loco", t.loco),
              _detailRow(Icons.swap_horiz, "Direction", t.direction == TrainDirection.UP ? 'UP' : 'DOWN'),
              _detailRow(Icons.route, "Current Section", t.currentSection),
              const Divider(),
              Text("Operational Status:", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(t.status, style: TextStyle(color: _trainStatusColor(t.delay), fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Close", style: TextStyle(color: irPrimaryBlue, fontWeight: FontWeight.bold)),
          ),
        ],
      );
    },
  );
}


  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: irPrimaryBlue),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(color: secondaryTextColor)),
          const Spacer(),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
        ],
      ),
    );
  }

  int _calculateOnTime() {
    if (sectionTrains.isEmpty) return 100;
    int ontime = sectionTrains.where((t) => t.delay == 0).length;
    return ((ontime / sectionTrains.length) * 100).round();
  }
  int _criticalAlertsCount() => alerts.where((a) => a["level"] == "Critical").length;

  Color _onTimeColor() {
    int onTime = _calculateOnTime();
    if (onTime < 80) return kpiRed;
    if (onTime < 95) return kpiOrange;
    return kpiGreen;
  }
}

// --- Placeholder Pages ---
class LiveMovementsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Movements', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: _DashboardPageState.irPrimaryBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Text(
          'Detailed Live Movement Data',
          style: TextStyle(fontSize: 24, color: _DashboardPageState.secondaryTextColor),
        ),
      ),
    );
  }
}

class AiRecommendationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Recommendations', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: _DashboardPageState.irPrimaryBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Text(
          'Predictive Analytics & Insights',
          style: TextStyle(fontSize: 24, color: _DashboardPageState.secondaryTextColor),
        ),
      ),
    );
  }
}

class ReportsAnalyticsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports & Analytics', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: _DashboardPageState.irPrimaryBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Text(
          'Operational Reports & Trends',
          style: TextStyle(fontSize: 24, color: _DashboardPageState.secondaryTextColor),
        ),
      ),
    );
  }
}

class ChatbotPage extends StatefulWidget {
  @override
  _ChatbotPageState createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [
    {"sender": "bot", "text": "Hello! I am your AI assistant. How can I help you today?"},
    {"sender": "bot", "text": "You can ask me about train statuses, route info, or current disruptions."},
  ];

  void _handleSend() {
    if (_controller.text.isNotEmpty) {
      String userMessage = _controller.text;
      setState(() {
        _messages.add({"sender": "user", "text": userMessage});
        _controller.clear();
      });
      _getBotResponse(userMessage);
    }
  }

  void _getBotResponse(String userMessage) {
    String response = "I'm sorry, I don't understand that request. Please ask about trains, routes, or delays.";
    if (userMessage.toLowerCase().contains("train")) {
      response = "The latest status for Train 12295 is 'On Time' on the MAS-AJJ section.";
    } else if (userMessage.toLowerCase().contains("delay")) {
      response = "The current major delay is on the KPD-JTJ section affecting several express trains.";
    } else if (userMessage.toLowerCase().contains("route")) {
      response = "The main route from Chennai to Bangalore passes through Katpadi, Jolarpettai, and Salem.";
    }

    Timer(const Duration(milliseconds: 1000), () {
      setState(() {
        _messages.add({"sender": "bot", "text": response});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _DashboardPageState.irPrimaryBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("AI Assistant", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];
                return Align(
                  alignment: message['sender'] == 'user' ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: message['sender'] == 'user' ? _DashboardPageState.irPrimaryBlue : _DashboardPageState.cardColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      message['text']!,
                      style: TextStyle(
                        color: message['sender'] == 'user' ? Colors.white : _DashboardPageState.textColor,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1, color: Colors.black12),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Ask me anything...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: _DashboardPageState.dashboardBg,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    ),
                    onSubmitted: (_) => _handleSend(),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: _handleSend,
                  backgroundColor: _DashboardPageState.irPrimaryBlue,
                  child: const Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- Map and Painter ---
class SectionMap extends StatelessWidget {
  final List<String> stations;
  final List<SectionTrain> trains;
  final String highlightRoute;
  final Function(String stationCode) onStationTap;
  final Function(SectionTrain train) onTrainTap;

  const SectionMap({
    Key? key,
    required this.stations,
    required this.trains,
    required this.highlightRoute,
    required this.onStationTap,
    required this.onTrainTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        decoration: BoxDecoration(
          color: const Color(0xFF161F2E),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: AdvancedTrackPainter(
                  stations: stations,
                  trains: trains,
                  highlightRoute: highlightRoute,
                ),
              ),
            ),
            ..._buildStationMarkers(constraints),
            ..._buildTrainMarkers(constraints),
          ],
        ),
      );
    });
  }

  List<Widget> _buildStationMarkers(BoxConstraints constraints) {
    final double startX = 40;
    final double endX = constraints.maxWidth - 40;
    final double centerY = constraints.maxHeight / 2;
    final double usableWidth = endX - startX;
    final double segmentWidth = usableWidth / (stations.length - 1);
    final int saIndex = stations.indexOf('SA');
    final int edIndex = stations.indexOf('ED');
    final double branchOffsetY = 70;

    return stations.asMap().entries.map((entry) {
      int i = entry.key;
      String stationCode = entry.value;
      double x = startX + i * segmentWidth;
      double y = centerY + 18;

      if (i == edIndex) {
        x = startX + saIndex * segmentWidth + segmentWidth;
        y = centerY + 18 + branchOffsetY;
      }
      return Positioned(
        left: x - 20,
        top: y,
        child: GestureDetector(
          onTap: () => onStationTap(stationCode),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(stationCode, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      );
    }).toList();
  }

  List<Widget> _buildTrainMarkers(BoxConstraints constraints) {
    final double startX = 40;
    final double endX = constraints.maxWidth - 40;
    final double centerY = constraints.maxHeight / 2;
    final double usableWidth = endX - startX;
    final double stationInterval = usableWidth / (stations.length - 1);
    final double mainTrack1Y = centerY - 15;
    final double mainTrack2Y = centerY + 15;
    final int saIndex = stations.indexOf('SA');
    final int edIndex = stations.indexOf('ED');
    final double branchOffsetY = 70;

    return trains.map((t) {
      double displayX = 0;
      double displayY = 0;

      final currentSectionParts = t.currentSection.split('-');
      final startStation = currentSectionParts[0];
      final endStation = currentSectionParts[1];
      final startStationIndex = stations.indexOf(startStation);
      final endStationIndex = stations.indexOf(endStation);

      if (startStation == 'SA' && endStation == 'ED') {
        // Branch line SA to ED
        displayX = startX + saIndex * stationInterval + t.pos * stationInterval;
        displayY = centerY + branchOffsetY;
      } else if (startStation == 'ED' && endStation == 'SA') {
        // Branch line ED to SA
        displayX = startX + saIndex * stationInterval + (1.0 - t.pos) * stationInterval;
        displayY = centerY + branchOffsetY;
      } else {
        // Main line
        displayX = startX + startStationIndex * stationInterval + (endStationIndex - startStationIndex) * stationInterval * t.pos;
        displayY = t.direction == TrainDirection.UP ? mainTrack1Y : mainTrack2Y;
      }

      return Positioned(
        left: displayX - 25,
        top: displayY - 25,
        child: GestureDetector(
          onTap: () => onTrainTap(t),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: t.direction == TrainDirection.UP ? Colors.green.shade600 : Colors.blue.shade600,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [BoxShadow(color: Colors.white24, blurRadius: 8)],
              ),
              child: Row(
                children: [
                  Icon(Icons.train, color: Colors.white, size: 17),
                  const SizedBox(width: 5),
                  Text(t.id, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
            ),
          ),
        ),
      );
    }).toList();
  }
}

class AdvancedTrackPainter extends CustomPainter {
  final List<String> stations;
  final List<SectionTrain> trains;
  final String highlightRoute;

  AdvancedTrackPainter({required this.stations, required this.trains, required this.highlightRoute});

  @override
  void paint(Canvas canvas, Size size) {
    final double startX = 40;
    final double endX = size.width - 40;
    final double centerY = size.height / 2;
    final double usableWidth = endX - startX;
    final double segmentWidth = usableWidth / (stations.length - 1);
    final Paint trackPaint = Paint()..color = Colors.white..strokeWidth = 2;
    final Paint occupiedPaint = Paint()..color = _DashboardPageState.kpiRed..strokeWidth = 3..strokeCap = StrokeCap.round;
    final Paint highlightPaint = Paint()..color = Colors.orange.shade700..strokeWidth = 5..strokeCap = StrokeCap.round;
    final Paint alertLinePaint = Paint()..color = Colors.red..strokeWidth = 5..strokeCap = StrokeCap.round;

    // Draw main line tracks
    for (int i = 0; i < stations.length - 1; i++) {
      double x1 = startX + i * segmentWidth;
      double x2 = startX + (i + 1) * segmentWidth;
      
      Paint currentTrackPaint = trackPaint;
      String currentSection = "${stations[i]}-${stations[i+1]}";
      
      for (var train in trains) {
        if (train.currentSection == currentSection || train.currentSection == "${stations[i+1]}-${stations[i]}") {
          currentTrackPaint = occupiedPaint;
          break;
        }
      }
      
      canvas.drawLine(Offset(x1, centerY - 15), Offset(x2, centerY - 15), currentTrackPaint);
      canvas.drawLine(Offset(x1, centerY + 15), Offset(x2, centerY + 15), currentTrackPaint);
    }
    
    // Draw branch line from SA to ED
    final int saIndex = stations.indexOf('SA');
    final int edIndex = stations.indexOf('ED');
    final double saX = startX + saIndex * segmentWidth;
    final double edX = startX + edIndex * segmentWidth;
    final double branchOffsetY = 70;
    
    // Connection from main line to branch (slanted)
canvas.drawLine(Offset(saX, centerY + 15), Offset(saX + 20, centerY + 15 + branchOffsetY), trackPaint);

// Branch track itself (horizontal)
canvas.drawLine(Offset(saX + 20, centerY + 15 + branchOffsetY), Offset(edX, centerY + 15 + branchOffsetY), trackPaint);

    // Draw alert on the branch
    if (highlightRoute.isNotEmpty) {
      final List<String> routeStations = highlightRoute.split('-');
      if (routeStations.length == 2) {
        final String start = routeStations[0];
        final String end = routeStations[1];
        
        final int startIndex = stations.indexOf(start);
        final int endIndex = stations.indexOf(end);
        
        if (startIndex != -1 && endIndex != -1) {
          double startXPos = startX + startIndex * segmentWidth;
          double endXPos = startX + endIndex * segmentWidth;
          double yPos = centerY + 15;
          
          if (start == 'SA' && end == 'ED' || start == 'ED' && end == 'SA') {
            startXPos = saX + 5;
            endXPos = edX;
            yPos = centerY + 15 + branchOffsetY;
          }

          canvas.drawLine(Offset(startXPos, yPos), Offset(endXPos, yPos), alertLinePaint);
        }
      }
    }
    
    // Draw station markers and labels
    for (int i = 0; i < stations.length; i++) {
      double x = startX + i * segmentWidth;
      double y = centerY;
      if (stations[i] == 'ED') {
        x = startX + saIndex * segmentWidth + segmentWidth;
        y += branchOffsetY;
      }
      
      final Paint stationPaint = Paint()..color = Colors.white..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(x, y), 6, stationPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

// Helper widget for a small info chip
class _infoChip extends StatelessWidget {
  final String text;
  final Color color;
  const _infoChip(this.text, this.color, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(16)),
      child: Text(text, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w500)),
    );
  }
}