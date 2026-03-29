import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);

    // Draw little jagged bumps/tear marks on top and bottom edges
    double punchRadius = 10.0;
    
    // Left side middle punch
    path.addOval(Rect.fromCircle(center: Offset(0, size.height / 2), radius: punchRadius * 1.5));
    // Right side middle punch
    path.addOval(Rect.fromCircle(center: Offset(size.width, size.height / 2), radius: punchRadius * 1.5));

    path.fillType = PathFillType.evenOdd;
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

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
      backgroundColor: const Color(0xFFDDDDDD), // Grey background highlights the ticket
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Trip Details',
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
            color: Colors.black,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: ClipPath(
          clipper: TicketClipper(),
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: isCancelled ? Colors.red.withValues(alpha: 0.1) : Colors.amber.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: isCancelled 
                      ? const Text('❌', style: TextStyle(fontSize: 40))
                      : Image.asset('assets/images/rickshaw (1).png', width: 44, height: 44),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: GoogleFonts.fustat(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
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
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: Text('------------------------------------', 
                    style: TextStyle(color: Colors.grey, letterSpacing: 2.0)),
                ),
                _buildRow('Status', isCancelled ? 'Cancelled' : 'Completed', 
                  isCancelled ? Colors.red : Colors.green),
                const SizedBox(height: 16),
                _buildRow('Amount', amount, Colors.black),
                const SizedBox(height: 16),
                _buildRow('Distance', distance, Colors.black),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: Text('------------------------------------', 
                    style: TextStyle(color: Colors.grey, letterSpacing: 2.0)),
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Driver Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
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
                        Text('Ramesh Kumar', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.black)),
                        Text('KL 01 AB 1234', style: TextStyle(color: Colors.grey[600])),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 32),
                // Barcode simulation
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(20, (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    width: index % 3 == 0 ? 4 : 2,
                    height: 40,
                    color: Colors.black,
                  )),
                )
              ],
            ),
          ),
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
