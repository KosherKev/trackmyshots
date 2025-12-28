import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackmyshots/services/app_state.dart';
import 'package:trackmyshots/theme/app_theme.dart';

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

  Future<void> _navigateToHome() async {
    // Wait for AppState to initialize
    final appState = Provider.of<AppState>(context, listen: false);
    
    // Simple delay for splash effect
    await Future.delayed(const Duration(seconds: 2));
    
    // Wait until loading is done
    while (appState.isLoading) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    
    if (mounted) {
      if (appState.currentChild == null) {
        Navigator.pushReplacementNamed(context, '/onboarding');
      } else {
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            Image.asset(
              'assets/images/logo.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 24),
            Text(
              'TrackMyShots',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: AppTheme.primaryDark,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Child Immunization Tracker',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(
              color: AppTheme.primaryBlue,
            ),
          ],
        ),
      ),
    );
  }
}
