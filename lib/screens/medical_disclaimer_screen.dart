import 'package:flutter/material.dart';
import 'package:trackmyshots/theme/app_theme.dart';

class MedicalDisclaimerScreen extends StatelessWidget {
  const MedicalDisclaimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical Liability Disclaimer'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              size: 64,
              color: Colors.orange,
            ),
            const SizedBox(height: 24),
            Text(
              'Important Medical Disclaimer',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryDark,
                  ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              context,
              'Not Medical Advice',
              'The content provided by TrackMyShots, including vaccination schedules, reminders, and educational resources, is for informational purposes only. It is NOT intended to be a substitute for professional medical advice, diagnosis, or treatment.',
            ),
            _buildSection(
              context,
              'Consult Your Doctor',
              'Always seek the advice of your physician or other qualified health provider with any questions you may have regarding a medical condition or your child\'s immunization schedule. Never disregard professional medical advice or delay in seeking it because of something you have read on this application.',
            ),
            _buildSection(
              context,
              'Accuracy of Information',
              'While we strive to keep the vaccination schedules up to date with national guidelines (e.g., Ghana Health Service), medical standards can change. TrackMyShots does not guarantee that the schedule generated is perfectly accurate for your specific location or health situation.',
            ),
            _buildSection(
              context,
              'Limitation of Liability',
              'The developers of TrackMyShots shall not be held liable for any damages, health complications, or legal issues arising from the use of this application. You are responsible for verifying all vaccination dates with your healthcare provider.',
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'I Understand',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.black54,
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }
}
