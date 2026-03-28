import 'package:flutter/material.dart';
import 'get_started_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _fadeoutController;

  late Animation<double> _textFadeIn;
  late Animation<double> _textFadeOut;
  late Animation<Offset> _autoSlideIn;
  late Animation<Offset> _blackScreenSlideIn;

  @override
  void initState() {
    super.initState();
    _mainController = AnimationController(vsync: this, duration: const Duration(milliseconds: 3000));
    _fadeoutController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));

    // 0.0 -> 0.3: Text Fades In
    _textFadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _mainController, curve: const Interval(0.0, 0.3, curve: Curves.easeIn))
    );

    // 0.4 -> 0.5: Text Fades Out
    _textFadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _mainController, curve: const Interval(0.4, 0.5, curve: Curves.easeOut))
    );

    // 0.5 -> 0.7: Auto Slides in from left (-1.0) to center (0.0)
    _autoSlideIn = Tween<Offset>(begin: const Offset(-1.5, 0.0), end: Offset.zero).animate(
      CurvedAnimation(parent: _mainController, curve: const Interval(0.5, 0.75, curve: Curves.easeOutCubic))
    );

    // 0.8 -> 1.0: Black screen sweeps in from bottom or right to cover
    _blackScreenSlideIn = Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero).animate(
      CurvedAnimation(parent: _mainController, curve: const Interval(0.8, 1.0, curve: Curves.easeInOutExpo))
    );

    _mainController.forward().then((_) {
      _fadeoutController.forward().then((_) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => const GetStartedScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
              transitionDuration: const Duration(milliseconds: 800),
            )
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _fadeoutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Base background
      body: Stack(
        children: [
          // Text Animation
          Align(
            alignment: Alignment.center,
            child: AnimatedBuilder(
              animation: _mainController,
              builder: (context, child) {
                return Opacity(
                  opacity: _textFadeIn.value * _textFadeOut.value,
                  child: Text(
                    'My Auto',
                    style: GoogleFonts.mysteryQuest(
                      fontSize: 64,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    )
                  ),
                );
              },
            ),
          ),

          // Auto Slide Animation
          Align(
            alignment: Alignment.center,
            child: AnimatedBuilder(
              animation: _mainController,
              builder: (context, child) {
                return SlideTransition(
                  position: _autoSlideIn,
                  child: Image.asset('assets/images/auto.png', width: 200, height: 200, fit: BoxFit.contain,
                    errorBuilder: (ctx, _, __) => const Text('🛺', style: TextStyle(fontSize: 100))
                  ),
                );
              },
            ),
          ),

          // Black Screen Slide In Overlay
          AnimatedBuilder(
            animation: _mainController,
            builder: (context, child) {
              return SlideTransition(
                position: _blackScreenSlideIn,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
