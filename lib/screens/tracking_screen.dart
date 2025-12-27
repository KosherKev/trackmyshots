import 'package:flutter/material.dart';
import 'package:trackmyshots/theme/app_theme.dart';

class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Tracking'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              Navigator.pushNamed(context, '/reminders');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Immunization Schedule Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppTheme.paddingLarge),
              decoration: BoxDecoration(
                gradient: AppTheme.lightBlueGradient,
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
              ),
              child: const Center(
                child: Text(
                  'Immunization\nSchedule',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Date Selector
            _buildDateSelector(context),
            const SizedBox(height: 24),

            // Featured Vaccine Card (Rotavirus)
            _buildFeaturedVaccineCard(context),
            const SizedBox(height: 24),

            // Tracking Section
            Text(
              'Tracking',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),

            // Progress Cards Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.0,
              children: [
                _buildProgressCard('Hepatitis B', 100, AppTheme.progress100),
                _buildProgressCard('DTP', 50, AppTheme.progress50),
                _buildProgressCard('Hib', 80, AppTheme.progress80),
                _buildProgressCard('PCV', 50, AppTheme.progress50),
              ],
            ),
          ],
        ),
      ),
    );
  }