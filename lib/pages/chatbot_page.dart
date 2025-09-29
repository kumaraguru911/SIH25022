import 'dart:async';
import 'package:flutter/material.dart';

class ChatbotPage extends StatefulWidget {
  @override
  _ChatbotPageState createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {"sender": "bot", "text": "Hello! 👋 I’m your AI Rail Assistant. What would you like to check today?", "type": "text"},
  ];

  bool _isTyping = false;

  void _handleSend([String? quickMessage]) {
    String userMessage = quickMessage ?? _controller.text.trim();
    if (userMessage.isNotEmpty) {
      setState(() {
        _messages.insert(0, {"sender": "user", "text": userMessage, "type": "text"});
        _controller.clear();
      });
      _getBotResponse(userMessage);
    }
  }

  void _getBotResponse(String userMessage) {
    String response = "I'm sorry, I don't understand that request. Please ask about trains, routes, or delays.";
    Map<String, dynamic> responseMsg = {"sender": "bot", "text": response, "type": "text"};

    if (userMessage.toLowerCase().contains("train")) {
      responseMsg = {
        "sender": "bot",
        "type": "card",
        "title": "Train 12295 - MAS → AJJ",
        "status": "✅ On Time",
        "departure": "Chennai Central - 10:15 AM",
        "arrival": "Arakkonam - 11:30 AM"
      };
    } else if (userMessage.toLowerCase().contains("delay")) {
      responseMsg = {
        "sender": "bot",
        "type": "alert",
        "text": "⚠️ Delay Alert: Major delay on KPD → JTJ section. Several express trains running late by 1-2 hours."
      };
    } else if (userMessage.toLowerCase().contains("route")) {
      responseMsg = {
        "sender": "bot",
        "type": "list",
        "title": "Chennai → Bangalore Route",
        "points": ["Chennai Central", "Katpadi", "Jolarpettai", "Salem", "Bangalore"]
      };
    } else if (userMessage.toLowerCase().contains("pnr")) {
      responseMsg = {
        "sender": "bot",
        "type": "card",
        "title": "PNR Status - 4528392012",
        "status": "🟢 Confirmed (2A)",
        "departure": "MAS - 22:45",
        "arrival": "SBC - 05:20"
      };
    }

    setState(() => _isTyping = true);

    Timer(const Duration(milliseconds: 1200), () {
      setState(() {
        _isTyping = false;
        _messages.insert(0, responseMsg);
      });
    });
  }

  Widget _buildMessage(Map<String, dynamic> message) {
    if (message['sender'] == 'user') {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF004aad), Color(0xFF0072ff)]),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(message['text'], style: const TextStyle(color: Colors.white)),
        ),
      );
    }

    // Bot Messages
    switch (message['type']) {
      case "card":
        return _buildInfoCard(message);
      case "alert":
        return _buildAlert(message['text']);
      case "list":
        return _buildList(message['title'], message['points']);
      default:
        return Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(message['text'], style: const TextStyle(color: Colors.black87)),
          ),
        );
    }
  }

  Widget _buildInfoCard(Map<String, dynamic> data) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(data['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 6),
              Text("Status: ${data['status']}", style: const TextStyle(color: Colors.green)),
              Text("Departure: ${data['departure']}"),
              Text("Arrival: ${data['arrival']}"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAlert(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(text, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildList(String title, List<String> points) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              ...points.map((e) => Row(
                    children: [
                      const Icon(Icons.train, size: 18, color: Colors.blue),
                      const SizedBox(width: 6),
                      Text(e),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = ["Train Status", "Delay Info", "Routes", "PNR Check"];
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: actions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return ActionChip(
            label: Text(actions[index]),
            onPressed: () => _handleSend(actions[index]),
            backgroundColor: Colors.blue.shade50,
            labelStyle: const TextStyle(color: Colors.blue),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF004aad),
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
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isTyping && index == 0) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("⏳ Bot is typing...", style: TextStyle(color: Colors.grey.shade700)),
                    ),
                  );
                }
                final message = _messages[index - (_isTyping ? 1 : 0)];
                return _buildMessage(message);
              },
            ),
          ),
          const Divider(height: 1, color: Colors.black12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Column(
              children: [
                _buildQuickActions(),
                const SizedBox(height: 8),
                Row(
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
                          fillColor: Colors.grey.shade100,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                        ),
                        onSubmitted: (_) => _handleSend(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FloatingActionButton(
                      onPressed: () => _handleSend(),
                      backgroundColor: const Color(0xFF004aad),
                      child: const Icon(Icons.send, color: Colors.white),
                      mini: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}