import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_screen.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  bool isPassenger = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Watermark for Glassmorphism
          Positioned(
            bottom: 50,
            left: -50,
            right: -50,
            child: Opacity(
              opacity: 0.05,
              child: Center(
                child: Text(
                  'My Auto',
                  style: GoogleFonts.cinzel(
                    fontSize: 80, // Slightly smaller fit for Cinzel
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  Image.asset('assets/images/auto.jpg', width: 100, height: 100, fit: BoxFit.contain, errorBuilder: (ctx, _, __) => const Text('🛺', style: TextStyle(fontSize: 70))),
                  const SizedBox(height: 16),
                  Text(
                    'Get Started',
                    style: GoogleFonts.inter(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Login or Sign up to find your ride',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('I am a...', style: GoogleFonts.inter(fontSize: 14)),
                  ),
                  const SizedBox(height: 12),
                  
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => setState(() => isPassenger = true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isPassenger ? const Color(0xFF007AFF) : Colors.grey[200],
                            foregroundColor: isPassenger ? Colors.white : Colors.black,
                            elevation: isPassenger ? 2 : 0,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Passenger'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => setState(() => isPassenger = false),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: !isPassenger ? const Color(0xFFFF9500) : Colors.grey[200],
                            foregroundColor: !isPassenger ? Colors.white : Colors.black,
                            elevation: !isPassenger ? 2 : 0,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Driver'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),

                  _buildGlassButton('Continue with Google'),
                  const SizedBox(height: 16),
                  _buildGlassButton('Continue with Email'),
                  const SizedBox(height: 16),
                  _buildGlassButton('Continue with Phone Number'),
                  
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassButton(String text) {
    return InkWell(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      },
      borderRadius: BorderRadius.circular(30),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withOpacity(0.8), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  spreadRadius: 1,
                  offset: const Offset(0, 4)
                ),
              ],
            ),
            child: Center(
              child: Text(
                text,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
