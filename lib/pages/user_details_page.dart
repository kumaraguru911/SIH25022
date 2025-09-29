import 'package:flutter/material.dart';

class UserDetailsPage extends StatelessWidget {
  // Re-using colors from Dashboard for consistency
  static const Color irPrimaryBlue = Color(0xFF0B2B4E);
  static const Color cardColor = Colors.white;
  static const Color textColor = Color(0xFF1E293B);
  static const Color secondaryTextColor = Color(0xFF64748B);
  static const Color dashboardBg = Color(0xFFF0F2F5);

  const UserDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dashboardBg,
      appBar: AppBar(
        title: const Text('User Profile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: irPrimaryBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 60,
                  backgroundColor: irPrimaryBlue,
                  child: Icon(Icons.person, size: 70, color: Colors.white),
                ),
                const SizedBox(height: 20),
                const Text(
                  'RAGU', // Placeholder name
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Senior Traffic Controller',
                  style: TextStyle(fontSize: 16, color: secondaryTextColor),
                ),
                const SizedBox(height: 30),
                _buildInfoCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(0.05), offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          _buildDetailRow(Icons.badge, "Employee ID", "E12045"),
          _buildDetailRow(Icons.business, "Division", "Madras (MAS)"),
          _buildDetailRow(Icons.phone, "Contact", "+91 9876543210"),
          _buildDetailRow(Icons.email, "Email", "ragu@indianrail.gov.in"),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Icon(icon, color: irPrimaryBlue, size: 20),
          const SizedBox(width: 16),
          Text(label, style: const TextStyle(color: secondaryTextColor, fontSize: 16)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: textColor, fontSize: 16)),
        ],
      ),
    );
  }
}