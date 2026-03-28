import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/auto_model.dart';
import 'package:flutter/cupertino.dart';

class AutoDetailsSheet extends StatelessWidget {
  final AutoModel auto;
  final double distance;

  const AutoDetailsSheet({super.key, required this.auto, required this.distance});

  void _callDriver() async {
    final Uri url = Uri(scheme: 'tel', path: auto.phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  void _shareLocation() {
    // ScaffoldMessenger.of(context).showSnackBar...
    // In actual implementation, uses share plugin
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    auto.driverName,
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        auto.rating.toStringAsFixed(1),
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: auto.isAvailable ? Colors.green[100] : Colors.red[100],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  auto.isAvailable ? 'Available' : 'Busy',
                  style: GoogleFonts.inter(
                    color: auto.isAvailable ? Colors.green[800] : Colors.red[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(CupertinoIcons.car_detailed, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                auto.vehicleNumber,
                style: GoogleFonts.inter(fontSize: 16),
              ),
              const Spacer(),
              const Icon(CupertinoIcons.location_solid, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                '${distance.toStringAsFixed(1)} km away',
                style: GoogleFonts.inter(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _callDriver,
                  icon: const Icon(CupertinoIcons.phone_fill),
                  label: const Text('Call Driver'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _shareLocation,
                  icon: const Icon(CupertinoIcons.share),
                  label: const Text('Share Pick-up'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
