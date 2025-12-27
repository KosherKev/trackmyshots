import 'package:flutter/material.dart';
import 'package:trackmyshots/theme/app_theme.dart';

class EducationalResourcesScreen extends StatelessWidget {
  const EducationalResourcesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Educational Resources'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              Navigator.pushNamed(context, '/reminders');
            },
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
            _buildResourceCard(
              context,
              'Vaccine Purpose',
              Icons.article_outlined,
              () {
                // Navigate to detailed content
              },
            ),
            const SizedBox(height: 16),
            _buildResourceCard(
              context,
              'Potential Side Effects',
              Icons.warning_amber_outlined,
              () {
                // Navigate to detailed content
              },
            ),
            const SizedBox(height: 16),
            _buildResourceCard(
              context,
              'Importance of Adherence',
              Icons.verified_outlined,
              () {
                // Navigate to detailed content
              },
            ),
            const SizedBox(height: 16),
            _buildResourceCard(
              context,
              'Immunization',
              Icons.vaccines_outlined,
              () {
                // Navigate to detailed content
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceCard(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
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
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: AppTheme.primaryBlue,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
          ],
        ),
      ),
    );
  }
}
