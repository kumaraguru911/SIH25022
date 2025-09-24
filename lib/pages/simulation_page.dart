import 'package:flutter/material.dart';
import '../theme/ir_theme.dart'; // ✅ reuse your dashboard theme

class SimulationPage extends StatefulWidget {
  @override
  _SimulationPageState createState() => _SimulationPageState();
}

class _SimulationPageState extends State<SimulationPage> {
  Widget _kpiCard(String title, String value, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
        border: Border.all(color: Colors.grey.withOpacity(0.08), width: 1.2),
      ),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 40,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: Colors.black54)),
              SizedBox(height: 4),
              Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }
  int simulationsRun = 0;
  int maxDelay = 0;
  double avgDelay = 0;
  String? selectedTrain;
  final List<String> trains = [
    '12675 - Kovai Express',
    '12676 - Cheran Express',
    '12951 - Mumbai Rajdhani',
    '12952 - Chennai Rajdhani',
  ];
  final TextEditingController delayController = TextEditingController();
  String simulationResult = '';
  List<Map<String, dynamic>> history = [];

  void runSimulation() {
    if (selectedTrain == null || delayController.text.isEmpty) return;

    int delay = int.tryParse(delayController.text) ?? 0;
    String result =
        'Simulation Result for $selectedTrain\nDelay: $delay mins\nImpact: Other trains may be rescheduled.\nSuggested actions: Monitor dashboard for cascading effects.';

    setState(() {
      simulationResult = result;
      history.insert(0, {
        "train": selectedTrain,
        "delay": delay,
        "impact": "Possible cascading delays",
        "time": DateTime.now().toString().substring(11, 19),
      });
      simulationsRun++;
      maxDelay = delay > maxDelay ? delay : maxDelay;
      int totalDelay = history.fold(0, (sum, h) => sum + (h["delay"] as int));
      avgDelay = history.isEmpty ? 0 : totalDelay / history.length;
    });
  }

  Widget buildDelayBars() {
    if (history.isEmpty) {
      return Center(child: Text("No simulation data yet.", style: TextStyle(color: Colors.grey)));
    }

    return Column(
      children: history.map((h) {
        double delayValue = (h["delay"] as int).toDouble();
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${h["train"]} - ${h["delay"]} mins",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              Stack(
                children: [
                  Container(
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  Container(
                    height: 16,
                    width: delayValue * 5, // scale delay visually
                    decoration: BoxDecoration(
                      color: IRColors.navy, // from ir_theme.dart
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
  // ...existing code...
    return Scaffold(
      backgroundColor: Color(0xFFF6F8FA),
      body: SafeArea(
        child: Column(
          children: [
            // AppBar (light, modern)
            Container(
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
                border: Border.all(color: Colors.grey.withOpacity(0.08), width: 1.2),
              ),
              child: Row(
                children: [
                  Image.asset('assets/indian_railways_logo.jpeg', height: 40, width: 40, errorBuilder: (_, __, ___) => Icon(Icons.train, color: Colors.blue, size: 36)),
                  SizedBox(width: 16),
                  Text('SIMULATION LAB', style: TextStyle(color: Colors.blue[900], fontWeight: FontWeight.bold, fontSize: 22, letterSpacing: 2)),
                  Spacer(),
                  Icon(Icons.timeline, color: Colors.amber[800]),
                  SizedBox(width: 8),
                  Text('IR Section Controller', style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w600)),
                  SizedBox(width: 18),
                ],
              ),
            ),
            // KPI/status bar (light)
            Container(
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
                border: Border.all(color: Colors.grey.withOpacity(0.08), width: 1.2),
              ),
              child: Row(
                children: [
                  _kpiCard('Simulations Run', simulationsRun.toString(), Colors.green),
                  SizedBox(width: 18),
                  _kpiCard('Avg Delay', avgDelay.toStringAsFixed(1) + ' min', Colors.orange),
                  SizedBox(width: 18),
                  _kpiCard('Max Delay', maxDelay.toString() + ' min', Colors.red),
                  Spacer(),
                  Icon(Icons.info_outline, color: Colors.grey[600]),
                  SizedBox(width: 6),
                  Text('All values are hypothetical', style: TextStyle(color: Colors.grey[700])),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // ================= Train Selection =================
                    Container(
                      margin: EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
                        border: Border.all(color: Colors.grey.withOpacity(0.08), width: 1.2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.train, color: Colors.blue[800]),
                                SizedBox(width: 8),
                                Text("Select Train", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue[900])),
                              ],
                            ),
                            SizedBox(height: 10),
                            DropdownButton<String>(
                              value: selectedTrain,
                              hint: Text('Choose a train'),
                              isExpanded: true,
                              dropdownColor: Colors.white,
                              items: trains.map((train) {
                                return DropdownMenuItem(
                                  value: train,
                                  child: Text(train),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedTrain = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ================= Delay Input =================
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
                        border: Border.all(color: Colors.grey.withOpacity(0.08), width: 1.2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.timer, color: Colors.blue[800]),
                                SizedBox(width: 8),
                                Text("Enter Hypothetical Delay / Hold (minutes)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue[900])),
                              ],
                            ),
                            SizedBox(height: 10),
                            TextField(
                              controller: delayController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                hintText: "e.g., 15",
                                prefixIcon: Icon(Icons.timer, color: Colors.blue[800]),
                              ),
                            ),
                            SizedBox(height: 16),
                            Center(
                              child: ElevatedButton.icon(
                                onPressed: runSimulation,
                                icon: Icon(Icons.play_arrow),
                                label: Text("Run Simulation"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue[800],
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                    // ================= Latest Result =================
                    if (simulationResult.isNotEmpty) ...[
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                          border: Border.all(color: Colors.blue[100]!, width: 1.2),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Row(
                            children: [
                              Icon(Icons.analytics, color: Colors.blue[800]),
                              SizedBox(width: 10),
                              Expanded(child: Text(simulationResult, style: TextStyle(fontSize: 16, color: Colors.blue[900]))),
                            ],
                          ),
                        ),
                      ),
                    ],

                    // ================= Delay Impact Bars =================
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
                        border: Border.all(color: Colors.grey.withOpacity(0.08), width: 1.2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.bar_chart, color: Colors.blue[800]),
                                SizedBox(width: 8),
                                Text("Delay Impact Visualization", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue[900])),
                              ],
                            ),
                            SizedBox(height: 10),
                            buildDelayBars(),
                          ],
                        ),
                      ),
                    ),

                    // ================= History =================
                    if (history.isNotEmpty)
                      Container(
                        margin: EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                          border: Border.all(color: Colors.blue[100]!, width: 1.2),
                        ),
                        child: ExpansionTile(
                          leading: Icon(Icons.history, color: Colors.blue[900]),
                          title: Text("Simulation History", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue[900])),
                          children: history.map((h) {
                            return ListTile(
                              leading: Icon(Icons.train, color: Colors.blue[800]),
                              title: Text("${h["train"]} - Delay ${h["delay"]} mins"),
                              subtitle: Text("Impact: ${h["impact"]}\nTime: ${h["time"]}"),
                            );
                          }).toList(),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // Footer/status bar (light)
            Container(
              height: 32,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
              ),
              child: Row(
                children: [
                  SizedBox(width: 18),
                  Icon(Icons.person, color: Colors.grey[600], size: 18),
                  SizedBox(width: 6),
                  Text('Operator: Simulation Desk', style: TextStyle(color: Colors.grey[700])),
                  Spacer(),
                  Icon(Icons.memory, color: Colors.grey[600], size: 18),
                  SizedBox(width: 6),
                  Text('IR Sim v1.0', style: TextStyle(color: Colors.grey[700])),
                  SizedBox(width: 18),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  // ...existing code...
  }
}
