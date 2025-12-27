import 'package:flutter/material.dart';
import 'package:trackmyshots/theme/app_theme.dart';

class ProgressFeedbackScreen extends StatelessWidget {
  const ProgressFeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Progress & Feedback'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              Navigator.pushNamed(context, '/reminders');
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppTheme.paddingLarge),
        children: [
          _buildVaccineProgressCard(
            'Hepatitis B',
            true,
            Icons.check_circle,
            AppTheme.success,
          ),
          const SizedBox(height: 16),
          _buildVaccineProgressCard(
            'Rotavirus',
            false,
            Icons.pending,
            AppTheme.warning,
          ),
          const SizedBox(height: 16),
          _buildVaccineProgressCard(
            'DTP',
            false,
            Icons.pending,
            AppTheme.info,
          ),
          const SizedBox(height: 16),
          _buildVaccineProgressCard(
            'Hib',
            false,
            Icons.pending,
            AppTheme.info,
          ),
        ],
      ),
    );
  }

  Widget _buildVaccineProgressCard(
    String vaccineName,
    bool isCompleted,
    IconData icon,
    Color iconColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.paddingLarge),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              vaccineName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}
