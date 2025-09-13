// lib/pages/dashboard_page.dart
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:ui';
import 'disruption_page.dart';
import 'kpi_page.dart';
import 'simulation_page.dart';
import 'training_page.dart';
import 'package:flutter/foundation.dart';

// This file provides a professional dashboard focused on a section (Madras division).
// Center panel: a circuit-board style interactive SectionMap (Chennai Central -> Katpadi).
// Left panel: train list with actions.
// Right panel: AI Decision Assistant with suggestion history.

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Mock KPI values
  int activeTrains = 142;
  int delayedTrains = 8;
  double onTimePercent = 94.0;

  // Suggestion history (mock)
  List<Map<String, String>> suggestionHistory = [
    {
      "id": "S1",
      "title": "Allow Rajdhani 12951 before Freight 93452",
      "detail": "Rulebook priority + saves 12 mins",
      "time": "10:02"
    },
    {
      "id": "S2",
      "title": "Hold Freight 2002 for 5 mins",
      "detail": "Prevents cascading delay",
      "time": "09:58"
    },
  ];

  // Section trains - this will be used by SectionMap and animated (pos: 0..1)
  List<SectionTrain> sectionTrains = [
  SectionTrain(
    id: '12657',
    name: 'Brindavan Express (12657)',
    pos: 0.12,
    direction: TrainDirection.UP,
    status: 'Running On Time',
    eta: '10:25'),
  SectionTrain(
    id: '12007',
    name: 'Shatabdi Express (12007)',
    pos: 0.42,
    direction: TrainDirection.UP,
    status: 'Delayed 5 min',
    eta: '11:10'),
  SectionTrain(
    id: '12601',
    name: 'MGR Chennai Mail (12601)',
    pos: 0.64,
    direction: TrainDirection.DOWN,
    status: 'Running On Time',
    eta: '12:05'),
  SectionTrain(
    id: '93452',
    name: 'Freight Special',
    pos: 0.85,
    direction: TrainDirection.DOWN,
    status: 'Running On Time',
    eta: '12:20'),
  // Branch train: pos 0..1 along the branch (0=start of branch, 1=end at TRT)
  SectionTrain(
    id: 'BRANCH1',
    name: 'Branch Local',
    pos: 0.0, // animate this from 0 to 1 for movement
    direction: TrainDirection.UP,
    status: 'Running On Branch',
    eta: '11:45'),
  ];

  Timer? _animTimer;
  Random _rand = Random();

  @override
  void initState() {
    super.initState();

    // Start a periodic timer to animate trains slightly (mock movement).
    _animTimer = Timer.periodic(Duration(milliseconds: 500), (_) {
      setState(() {
        for (var t in sectionTrains) {
          // small jitter for demo; if delayed, move slower
          double speed = (t.status.toLowerCase().contains('delayed')) ? 0.003 : 0.01;
          if (t.direction == TrainDirection.UP) {
            t.pos += speed * (_rand.nextDouble() + 0.2);
            if (t.pos > 1.0) t.pos = 0.0; // Loop back for continuous demo
          } else {
            t.pos -= speed * (_rand.nextDouble() + 0.2);
            if (t.pos < 0.0) t.pos = 1.0; // Loop back for continuous demo
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

  // Helper to add a suggestion entry
  void _addSuggestion(String title, String detail) {
    setState(() {
      suggestionHistory.insert(0, {
        "id": "S${suggestionHistory.length + 1}",
        "title": title,
        "detail": detail,
        "time": TimeOfDay.now().format(context)
      });
      if (suggestionHistory.length > 20) suggestionHistory.removeLast();
    });
  }

  // Placeholder for applying suggestion
  void _applySuggestion(Map<String, String> s) {
    // For demo, just add to history and show snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Applied: ${s["title"]}')),
    );
  }

  // Placeholder for override (controller action)
  void _overrideSuggestion(Map<String, String> s) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Overrode: ${s["title"]}')),
    );
  }

  // Show train action popup
  void _showTrainActions(BuildContext ctx, SectionTrain t) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        title: Text(t.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _infoRow('Train No.', t.id),
            _infoRow('Status', t.status),
            _infoRow('ETA', t.eta),
            _infoRow('Direction', t.direction == TrainDirection.UP ? 'UP' : 'DOWN'),
            SizedBox(height: 8),
            Text('Actions:', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                // Hold action (mock)
                setState(() {
                  t.status = 'Held';
                });
                _addSuggestion('Hold ${t.name}', 'Controller initiated hold');
                ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text('${t.name} held.')));
              },
              child: Text('Hold')),
          TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                // Reroute action (mock)
                _addSuggestion('Reroute ${t.name}', 'Rerouted via loop line (demo)');
                ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text('${t.name} rerouted.')));
              },
              child: Text('Reroute')),
          TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: Text('Close')),
        ],
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Expanded(child: Text(title, style: TextStyle(color: Colors.black54))),
          Text(value, style: TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  // Build UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF003366), Color(0xFF1A2636)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 8)],
          ),
          child: Row(
            children: [
              SizedBox(width: 18),
              Image.asset('assets/indian_railways_logo.jpeg', height: 40, width: 40, errorBuilder: (_, __, ___) => Icon(Icons.train, color: Colors.white, size: 36)),
              SizedBox(width: 14),
              Text('INDIAN RAILWAYS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22, letterSpacing: 2)),
              SizedBox(width: 18),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red[900],
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                ),
                child: Text('MADRAS DIVISION', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              ),
              Spacer(),
              Icon(Icons.access_time, color: Colors.white70),
              SizedBox(width: 6),
              Text(TimeOfDay.now().format(context), style: TextStyle(color: Colors.white)),
              SizedBox(width: 18),
              Icon(Icons.notifications, color: Colors.amberAccent),
              SizedBox(width: 8),
              CircleAvatar(radius: 10, backgroundColor: Colors.red, child: Text('2', style: TextStyle(fontSize: 12, color: Colors.white))),
              SizedBox(width: 18),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // KPI digital status bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1A2636), Color(0xFF003366)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)],
              ),
              child: Row(
                children: [
                  _kpiCard('Active Trains', activeTrains.toString(), Colors.green),
                  SizedBox(width: 18),
                  _kpiCard('Delayed', delayedTrains.toString(), Colors.red),
                  SizedBox(width: 18),
                  _kpiCard('On-Time %', '${onTimePercent.toStringAsFixed(1)}%', Colors.blue),
                  SizedBox(width: 18),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.yellow[800],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.lightbulb, color: Colors.white, size: 18),
                        SizedBox(width: 6),
                        Text('AI SUGGESTIONS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  Spacer(),
                  ElevatedButton.icon(
                    onPressed: () {
                      _addSuggestion('Priority to 12007', 'AI recommends priority to Shatabdi (demo)');
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('AI suggestion created')));
                    },
                    icon: Icon(Icons.autorenew),
                    label: Text('Generate AI Suggestion'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent, foregroundColor: Colors.black, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  // Sidebar
                  Container(
                    width: 220,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF0E2740), Color(0xFF1A2636)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 24),
                        Image.asset('assets/indian_railways_logo.jpeg', height: 48, width: 48, errorBuilder: (_, __, ___) => Icon(Icons.train, color: Colors.white, size: 36)),
                        SizedBox(height: 10),
                        Text('RAIL CONTROL', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1)),
                        Divider(color: Colors.white12),
                        _sidebarTile(Icons.dashboard, 'Dashboard', selected: true, onTap: () {}),
                        _sidebarTile(Icons.timeline, 'Simulation', onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => SimulationPage()));
                        }),
                        _sidebarTile(Icons.show_chart, 'KPIs', onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => KpiPage()));
                        }),
                        _sidebarTile(Icons.school, 'Training', onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => TrainingPage()));
                        }),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Madras Division', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600)),
                        ),
                        SizedBox(height: 12),
                      ],
                    ),
                  ),
                  // Main content
                  Expanded(
                    child: Container(
                      color: Color(0xFFF3F6FA),
                      child: Column(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  // Left: Train list
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Color(0xFF1A2636),
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.train, color: Colors.amberAccent),
                                              SizedBox(width: 8),
                                              Text('Section Trains', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Expanded(
                                            child: ListView.builder(
                                              itemCount: sectionTrains.length,
                                              itemBuilder: (_, i) {
                                                var t = sectionTrains[i];
                                                return _trainListTile(t, dark: true);
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  // Center: SectionMap (unchanged)
                                  Expanded(
                                    flex: 6,
                                    child: Container(
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Chennai Central → Katpadi (Section View)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                                          SizedBox(height: 8),
                                          Expanded(
                                            child: SectionMap(
                                              stations: [
                                                'MAS', 'PER', 'VLK', 'AVD', 'TRL', 'KBT', 'AJJ', 'SHU', 'MCN', 'KPD'
                                              ],
                                              trains: sectionTrains,
                                              onTrainTap: (train) => _showTrainActions(context, train),
                                              onChange: (trainId, newPos) {
                                                setState(() {
                                                  var tr = sectionTrains.firstWhere((e) => e.id == trainId, orElse: () => sectionTrains[0]);
                                                  tr.pos = newPos.clamp(0.0, 1.0);
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  // Right: AI decision assistant
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Color(0xFF1A2636),
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.lightbulb, color: Colors.yellowAccent),
                                              SizedBox(width: 8),
                                              Text('AI Decision Assistant', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Text('Suggestions & History', style: TextStyle(color: Colors.white54)),
                                          Divider(color: Colors.white24),
                                          Expanded(
                                            child: ListView.builder(
                                              itemCount: suggestionHistory.length,
                                              itemBuilder: (_, idx) {
                                                var s = suggestionHistory[idx];
                                                return Card(
                                                  color: Color(0xFF25344D),
                                                  margin: EdgeInsets.symmetric(vertical: 6),
                                                  child: ListTile(
                                                    title: Text(s['title']!, style: TextStyle(color: Colors.white)),
                                                    subtitle: Text(s['detail']!, style: TextStyle(color: Colors.white70)),
                                                    trailing: Wrap(
                                                      spacing: 4,
                                                      children: [
                                                        IconButton(
                                                            icon: Icon(Icons.check, color: Colors.greenAccent),
                                                            onPressed: () {
                                                              _applySuggestion(s);
                                                            }),
                                                        IconButton(
                                                            icon: Icon(Icons.close, color: Colors.redAccent),
                                                            onPressed: () {
                                                              _overrideSuggestion(s);
                                                            }),
                                                        IconButton(
                                                            icon: Icon(Icons.remove_red_eye, color: Colors.blueAccent),
                                                            onPressed: () {
                                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Previewed ${s['title']}')));
                                                            }),
                                                      ],
                                                    ),
                                                    onTap: () {
                                                      showDialog(
                                                          context: context,
                                                          builder: (_) => AlertDialog(
                                                            title: Text(s['title']!),
                                                            content: Text(s['detail']! + '\nTime: ${s['time']}'),
                                                            actions: [
                                                              TextButton(onPressed: () => Navigator.pop(context), child: Text('Close'))
                                                            ],
                                                          ));
                                                    },
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          SizedBox(height: 6),
                                          ElevatedButton.icon(
                                            onPressed: () {
                                              _addSuggestion('Quick Hold Recommendation', 'Hold low-priority freight (demo)');
                                            },
                                            icon: Icon(Icons.add),
                                            label: Text('Add Suggestion (demo)'),
                                            style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent, foregroundColor: Colors.black, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Footer/status bar
                          Container(
                            height: 32,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF003366), Color(0xFF1A2636)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: 18),
                                Icon(Icons.person, color: Colors.white54, size: 18),
                                SizedBox(width: 6),
                                Text('Operator: Control Room 1', style: TextStyle(color: Colors.white70)),
                                Spacer(),
                                Icon(Icons.memory, color: Colors.white54, size: 18),
                                SizedBox(width: 6),
                                
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sidebarTile(IconData icon, String title, {bool selected = false, Function()? onTap}) {
    return ListTile(
      leading: Icon(icon, color: selected ? Colors.white : Colors.white70),
      title: Text(title, style: TextStyle(color: selected ? Colors.white : Colors.white70)),
      onTap: onTap ?? () {},
    );
  }

  Widget _kpiCard(String title, String value, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6), boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 6)
      ]),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 50,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: Colors.black54)),
              SizedBox(height: 4),
              Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }

  Widget _trainListTile(SectionTrain t, {bool dark = false}) {
    final Color bg = dark ? Color(0xFF25344D) : Colors.white;
    final Color fg = dark ? Colors.white : Colors.black87;
    final Color sub = dark ? Colors.white70 : Colors.black54;
    final Color iconColor = t.status.toLowerCase().contains('delayed') ? Colors.redAccent : Colors.greenAccent;
    return Card(
      color: bg,
      margin: EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(Icons.train, color: iconColor),
        title: Text(t.name, style: TextStyle(color: fg, fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Icon(Icons.schedule, size: 14, color: sub),
                  SizedBox(width: 2),
                  Text('ETA: ${t.eta}', style: TextStyle(color: sub)),
                  SizedBox(width: 10),
                  Icon(Icons.swap_vert, size: 14, color: sub),
                  SizedBox(width: 2),
                  Text('Dir: ${t.direction == TrainDirection.UP ? 'UP' : 'DOWN'}', style: TextStyle(color: sub)),
                  SizedBox(width: 10),
                  Icon(Icons.circle, size: 10, color: t.status == 'Held' ? Colors.orange : (t.status.toLowerCase().contains('delayed') ? Colors.red : Colors.green)),
                  SizedBox(width: 2),
                  Text(t.status, style: TextStyle(color: sub)),
                ],
              ),
            ),
            SizedBox(height: 6),
            LinearProgressIndicator(value: t.pos, minHeight: 6, color: Colors.blueAccent, backgroundColor: Colors.white10),
          ],
        ),
        trailing: Wrap(
          spacing: 4,
          children: [
            IconButton(
              onPressed: () {
                _showTrainActions(context, t);
              },
              icon: Icon(Icons.pause, color: Colors.amber),
            ),
            IconButton(
              onPressed: () {
                _addSuggestion('Reroute ${t.name}', 'Proposed reroute via loop line (demo)');
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Reroute proposed for ${t.name}')));
              },
              icon: Icon(Icons.alt_route, color: Colors.blueAccent),
            ),
          ],
        ),
        onTap: () => _showTrainActions(context, t),
      ),
    );
  }
}

// -------------------------- Section Map Widget (Final) --------------------------

typedef TrainTapCallback = void Function(SectionTrain train);
typedef TrainPositionCallback = void Function(String trainId, double newPos);

class SectionMap extends StatefulWidget {
  final List<String> stations;
  final List<SectionTrain> trains;
  final TrainTapCallback? onTrainTap;
  final TrainPositionCallback? onChange;

  SectionMap({required this.stations, required this.trains, this.onTrainTap, this.onChange});

  @override
  _SectionMapState createState() => _SectionMapState();
}

class _SectionMapState extends State<SectionMap> {
  String? _draggingTrainId;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      final height = constraints.maxHeight;

      return GestureDetector(
        onPanUpdate: (details) {
          if (_draggingTrainId != null) {
            setState(() {
              final dx = details.delta.dx;
              final train = widget.trains.firstWhere((t) => t.id == _draggingTrainId);
              double newPos = train.pos + dx / width;
              train.pos = newPos.clamp(0.0, 1.0);
              if (widget.onChange != null) widget.onChange!(train.id, train.pos);
            });
          }
        },
        onPanEnd: (_) {
          _draggingTrainId = null;
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(color: Colors.black),
            ),
            
            Positioned.fill(
              child: CustomPaint(
                painter: AdvancedTrackPainter(
                  stations: widget.stations,
                  trains: widget.trains,
                ),
              ),
            ),

            ...widget.trains.where((t) => t.id != 'BRANCH1').map((t) {
              final double startX = 60;
              final double stationInterval = (width - 120) / (widget.stations.length - 1);
              final double displayX = startX + t.pos * (stationInterval * (widget.stations.length - 1));
              final double centerY = height / 2;
              final double mainTrack1Y = centerY - 15; // UP
              final double mainTrack2Y = centerY + 15; // DOWN
              final double mainTrack3Y = centerY + 45; // Freight/loop (optional)
              double displayY;
              switch (t.direction) {
                case TrainDirection.UP:
                  displayY = mainTrack1Y;
                  break;
                case TrainDirection.DOWN:
                  displayY = t.id.contains('Freight') ? mainTrack3Y : mainTrack2Y;
                  break;
              }
              return Positioned(
                left: displayX - 25,
                top: displayY - 25,
                child: GestureDetector(
                  onTap: () => widget.onTrainTap!(t),
                  onPanStart: (details) {
                    _draggingTrainId = t.id;
                  },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: t.direction == TrainDirection.UP ? Colors.green[700] : Colors.blue[700],
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.white, width: 1.5),
                        boxShadow: [BoxShadow(color: Colors.white24, blurRadius: 4)],
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.train, color: Colors.white, size: 16),
                          SizedBox(width: 4),
                          Text(t.id, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
            // Draw branch train
            ...widget.trains.where((t) => t.id == 'BRANCH1').map((t) {
              // Branch geometry must match painter
              final double startX = 60 + 6 * ((width - 120) / 9); // AJJ index = 6
              final double centerY = height / 2;
              final double branchStartY = centerY + 15;
              final double branchTiltedX = startX + 40;
              final double branchTiltedY = branchStartY + 40;
              final double branchHorizontalX2 = branchTiltedX + 100;
              final double branchHorizontalY = branchTiltedY;
              // Interpolate position along branch (0..0.4 = tilted, 0.4..1 = horizontal)
              double bx, by;
              if (t.pos < 0.4) {
                double f = t.pos / 0.4;
                bx = startX + (branchTiltedX - startX) * f;
                by = branchStartY + (branchTiltedY - branchStartY) * f;
              } else {
                double f = (t.pos - 0.4) / 0.6;
                bx = branchTiltedX + (branchHorizontalX2 - branchTiltedX) * f;
                by = branchTiltedY;
              }
              return Positioned(
                left: bx - 25,
                top: by - 25,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red[700],
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.white, width: 1.5),
                    boxShadow: [BoxShadow(color: Colors.redAccent, blurRadius: 6)],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.train, color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text('25022', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      );
    });
  }
}

// -------------------------- Advanced Track Painter --------------------------
// This is the core logic for the new, complex track view.

class AdvancedTrackPainter extends CustomPainter {
  final List<String> stations;
  final List<SectionTrain> trains;

  AdvancedTrackPainter({required this.stations, required this.trains});

  @override
  void paint(Canvas canvas, Size size) {
    final double startX = 48;
    final double endX = size.width - 48;
    final double centerY = size.height / 2;
    final double usableWidth = endX - startX;
    final double segmentWidth = usableWidth / (stations.length - 1);

    // Track colors and painters
    final Paint mainTrack = Paint()
      ..color = Colors.white
      ..strokeWidth = 3;
    final Paint loopTrack = Paint()
      ..color = Colors.white54
      ..strokeWidth = 2;
    final Paint occupiedTrack = Paint()
      ..color = Colors.red
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final TextPainter tp = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    
    // Check for occupied blocks
    Map<int, bool> occupiedBlocks = {};
    for (var train in trains) {
      if (train.pos > 0 && train.pos < 1) {
        int blockIndex = ((train.pos * (stations.length - 1))).floor();
        occupiedBlocks[blockIndex] = true;
      }
    }

    // --- Draw Mainline and Loop Tracks ---
    for (int i = 0; i < stations.length - 1; i++) {
      double x1 = startX + i * segmentWidth;
      double x2 = startX + (i + 1) * segmentWidth;
      
      bool isOccupied = occupiedBlocks.containsKey(i);
      Paint currentPaint = isOccupied ? occupiedTrack : mainTrack;

      // Draw main lines
      canvas.drawLine(Offset(x1, centerY - 15), Offset(x2, centerY - 15), currentPaint);
      canvas.drawLine(Offset(x1, centerY + 15), Offset(x2, centerY + 15), currentPaint);

      // Draw loop/siding tracks at stations
      if (stations[i] == 'Arakkonam' || stations[i] == 'Tiruvallur') {
        canvas.drawLine(Offset(x1 + 20, centerY + 45), Offset(x2 - 20, centerY + 45), loopTrack);
      }

      // Draw branch at AJJ
      if (stations[i] == 'AJJ') {
        // Branch geometry
        final double branchStartX = x1;
        final double branchStartY = centerY + 15;
        final double branchTiltedX = branchStartX + 40;
        final double branchTiltedY = branchStartY + 40;
        final double branchHorizontalX2 = branchTiltedX + 100;
        final double branchHorizontalY = branchTiltedY;
        // If branch train is present and on branch, draw red line
        final branchTrain = trains.where((t) => t.id == 'BRANCH1').toList();
        bool showRed = branchTrain.isNotEmpty && branchTrain.first.pos > 0.0 && branchTrain.first.pos < 1.0;
        Paint branchPaint = showRed ? occupiedTrack : mainTrack;
        // Tilted branch
        canvas.drawLine(
          Offset(branchStartX, branchStartY),
          Offset(branchTiltedX, branchTiltedY),
          branchPaint
        );
        // Horizontal branch
        canvas.drawLine(
          Offset(branchTiltedX, branchTiltedY),
          Offset(branchHorizontalX2, branchHorizontalY),
          branchPaint
        );
        // Draw TRT station at end
        canvas.drawLine(
          Offset(branchHorizontalX2, branchHorizontalY - 25),
          Offset(branchHorizontalX2, branchHorizontalY + 25),
          mainTrack
        );
        tp.text = TextSpan(
          text: 'TRT',
          style: const TextStyle(color: Colors.yellow, fontSize: 12, fontWeight: FontWeight.bold),
        );
        tp.layout();
        tp.paint(canvas, Offset(branchHorizontalX2 - tp.width / 2, branchHorizontalY + 30));
        // Draw signals at TRT
        final signalPaint = Paint()..color = showRed ? Colors.red : Colors.green;
        canvas.drawCircle(Offset(branchHorizontalX2 - 10, branchHorizontalY - 15), 4, signalPaint);
        canvas.drawCircle(Offset(branchHorizontalX2 + 10, branchHorizontalY - 15), 4, signalPaint);
      }
    }

    // --- Draw Station Icons and Labels ---
    for (int i = 0; i < stations.length; i++) {
      double x = startX + i * segmentWidth;
      
      // Vertical station tick
      canvas.drawLine(Offset(x, centerY - 25), Offset(x, centerY + 25), mainTrack);
      
      // Station name label
      tp.text = TextSpan(
        text: stations[i],
        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
      );
      tp.layout();
      tp.paint(canvas, Offset(x - tp.width / 2, centerY + 30));

      // Signal icons
      final signalPaint = Paint()
        ..color = (occupiedBlocks.containsKey(i) && i > 0) ? Colors.red : Colors.green;
      
      // Left signal
      canvas.drawCircle(Offset(x - 10, centerY - 15), 4, signalPaint);
      // Right signal
      canvas.drawCircle(Offset(x + 10, centerY - 15), 4, signalPaint);
    }
  }

  @override
  bool shouldRepaint(covariant AdvancedTrackPainter oldDelegate) {
    // Only repaint if the train data has changed
    return !listEquals(oldDelegate.trains, trains);
  }
  
  bool listEquals(List<SectionTrain> a, List<SectionTrain> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i].pos != b[i].pos) return false;
    }
    return true;
  }
}

// -------------------------- Model --------------------------
enum TrainDirection { UP, DOWN }

class SectionTrain {
  final String id;
  final String name;
  double pos; // 0..1 along the section
  TrainDirection direction;
  String status;
  String eta;

  SectionTrain({
    required this.id,
    required this.name,
    required this.pos,
    required this.direction,
    required this.status,
    required this.eta,
  });
}