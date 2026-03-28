import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ActivityDetailsScreen extends StatelessWidget {
  final String title;
  final String date;
  final String amount;
  final String distance;
  final bool isCancelled;

  const ActivityDetailsScreen({
    super.key,
    required this.title,
    required this.date,
    required this.amount,
    required this.distance,
    this.isCancelled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Trip Details',
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark 
                    ? Colors.black54 
                    : Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.grey.withOpacity(0.2),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: isCancelled ? Colors.red.withOpacity(0.1) : Colors.amber.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(isCancelled ? '❌' : '🛺', style: const TextStyle(fontSize: 40)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: GoogleFonts.fustat(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    date,
                    style: GoogleFonts.abel(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const Divider(height: 48),
                  _buildRow('Status', isCancelled ? 'Cancelled' : 'Completed', 
                    isCancelled ? Colors.red : Colors.green),
                  const SizedBox(height: 16),
                  _buildRow('Amount', amount, null),
                  const SizedBox(height: 16),
                  _buildRow('Distance', distance, null),
                  const Divider(height: 48),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Driver Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Ramesh Kumar', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                          Text('KL 01 AB 1234', style: TextStyle(color: Colors.grey[600])),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, Color? valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, color: Colors.grey)),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: valueColor)),
      ],
    );
  }
}
