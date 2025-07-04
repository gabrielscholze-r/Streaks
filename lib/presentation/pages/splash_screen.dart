

import 'package:flutter/material.dart';
import 'package:streaks/presentation/pages/main_page.dart'; 

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome(); 
  }

  _navigateToHome() async {
    
    await Future.delayed(const Duration(seconds: 3), () {});

    
    if (mounted) { 
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.primary, 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            Icon(
              Icons.check_circle_outline, 
              size: 120,
              color: colorScheme.onPrimary, 
            ),
            const SizedBox(height: 24),
            Text(
              'Streaks', 
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: colorScheme.onPrimary, 
              ),
            ),
            const SizedBox(height: 48),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.onPrimary), 
            ),
          ],
        ),
      ),
    );
  }
}