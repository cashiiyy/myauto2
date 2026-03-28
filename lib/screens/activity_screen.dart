import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'activity_details_screen.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Reacts to theme
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Recent Activity',
          style: GoogleFonts.inter(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, size: 30),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          _buildActivityCard(
            context,
            title: 'Ride to MG Road',
            date: 'Yesterday, 4:30 PM',
            amount: '₹120',
            distance: '8.2 km',
            icon: '🛺',
          ),
          _buildActivityCard(
            context,
            title: 'Ride to Statue Jn.',
            date: 'March 5, 3:30 PM',
            amount: '₹20',
            distance: '1.2 km',
            icon: '🛺',
          ),
          _buildActivityCard(
            context,
            title: 'Cancelled Ride',
            date: 'March 4, 18:00',
            amount: '₹0',
            distance: '0 km',
            icon: '❌',
            isCancelled: true,
          ),
          _buildActivityCard(
            context,
            title: 'Ride to Airport',
            date: 'Yesterday, 4:30 PM',
            amount: '₹120',
            distance: '8.2 km',
            icon: '🛺',
          ),
          _buildActivityCard(
            context,
            title: 'Ride to SCT,Papanamcode',
            date: 'June 6, 7:30 PM',
            amount: '₹200',
            distance: '18.2 km',
            icon: '🛺',
          ),
          const SizedBox(height: 100), // padding for bottom bar
        ],
      ),
    );
  }

  Widget _buildActivityCard(
    BuildContext context, {
    required String title,
    required String date,
    required String amount,
    required String distance,
    required String icon,
    bool isCancelled = false,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? Colors.black54 : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ActivityDetailsScreen(
                  title: title,
                  date: date,
                  amount: amount,
                  distance: distance,
                  isCancelled: isCancelled,
                )
              )
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isCancelled ? Colors.red.withOpacity(0.1) : Colors.amber.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Text(icon, style: const TextStyle(fontSize: 20)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.fustat(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$date · $amount · $distance',
                        style: GoogleFonts.abel(
                          fontSize: 14,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
