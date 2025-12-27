import 'package:flutter/material.dart';
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
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/home');
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
            // TODO: Add app logo/icon here
            Icon(
              Icons.vaccines,
              size: 100,
              color: AppTheme.primaryBlue,
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