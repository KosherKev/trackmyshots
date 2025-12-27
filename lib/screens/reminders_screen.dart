import 'package:flutter/material.dart';
import 'package:trackmyshots/theme/app_theme.dart';

class RemindersScreen extends StatelessWidget {
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Reminders & Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppTheme.primaryDark, AppTheme.primaryBlue.withOpacity(0.8)],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(AppTheme.paddingLarge),
          children: [
            _buildReminderCard(
              'PCV dose scheduled 23rd June',
              Icons.calendar_today,
            ),
            const SizedBox(height: 16),
            _buildReminderCard(
              'Hib dose was given on 15th July',
              Icons.check_circle,
            ),
            const SizedBox(height: 16),
            _buildReminderCard(
              'Learn about potential side effects',
              Icons.info_outline,
            ),
            const SizedBox(height: 16),
            _buildReminderCard(
              'Rotavirus will be given in 5 weeks time',
              Icons.access_time,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReminderCard(String message, IconData icon) {
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
          Icon(icon, color: AppTheme.primaryBlue, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
