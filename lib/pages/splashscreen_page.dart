import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:travel_in_chiangmai/pages/home_page.dart';
import 'package:travel_in_chiangmai/pages/onboarding_page.dart';
import 'package:travel_in_chiangmai/widgets/main_nav.dart';
import 'package:travel_in_chiangmai/services/onboarding_service.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    final seenOnboarding = await OnBoardingService.hasSeenOnboarding();

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              seenOnboarding ? const HomePage() : const OnBoardingPage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color.fromARGB(248, 171, 120, 2).withOpacity(0.9), // top
              const Color.fromARGB(248, 171, 120, 2).withOpacity(0.6), // bottom
            ],
          ),
        ),
        child: Center(
          child: Lottie.asset(
            'assets/lotties/splash2.json',
            width: 250,
            height: 250,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
