import 'package:flutter/material.dart';
import 'package:trackmyshots/theme/app_theme.dart';

class OnboardingWelcomeScreen extends StatelessWidget {
  const OnboardingWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.paddingLarge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Logo or App Icon placeholder
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.medical_services_outlined,
                  size: 60,
                  color: AppTheme.primaryBlue,
                ),
              ),
              const SizedBox(height: AppTheme.paddingXLarge),
              
              // Welcome Text
              Text(
                'Welcome to\nTrackMyShots',
                textAlign: TextAlign.center,
                style: AppTheme.lightTheme.textTheme.headlineLarge?.copyWith(
                  color: AppTheme.primaryBlue,
                ),
              ),
              const SizedBox(height: AppTheme.paddingMedium),
              
              // Description
              Text(
                'Track your child\'s immunizations with ease. Never miss a vaccine dose again.',
                textAlign: TextAlign.center,
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textSecondary,
                  height: 1.5,
                ),
              ),
              const Spacer(),
              
              // Features List (Optional but nice)
              _buildFeatureRow(
                Icons.check_circle_outline,
                'Smart Schedule Generation',
              ),
              const SizedBox(height: AppTheme.paddingMedium),
              _buildFeatureRow(
                Icons.notifications_outlined,
                'Timely Reminders',
              ),
              const SizedBox(height: AppTheme.paddingMedium),
              _buildFeatureRow(
                Icons.shield_outlined,
                'Secure & Private',
              ),
              
              const Spacer(flex: 2),
              
              // Get Started Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to Child Information Screen (to be created)
                    // For now, we'll placeholder it or use a named route we are about to create
                    Navigator.pushNamed(context, '/child-info');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                    ),
                    elevation: 4,
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.paddingMedium),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: AppTheme.success, size: 20),
        const SizedBox(width: AppTheme.paddingSmall),
        Text(
          text,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
