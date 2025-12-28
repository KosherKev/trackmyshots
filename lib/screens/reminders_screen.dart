import 'package:flutter/material.dart';
import 'package:trackmyshots/widgets/standard_card.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  int _currentIndex = 4; // Reminders tab

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Reminders & Notifications',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {
              // Already on reminders screen
            },
          ),
        ],
      ),
      body: StandardScreenContainer(
        children: [
          // Title
          const SizedBox(height: 20),
          const Text(
            'Reminders &\nNotifications',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 32),
          
          // Reminder Cards
          StandardCard(
            text: 'PCV dose scheduled 23rd June',
            centerText: true,
          ),
          StandardCard(
            text: 'Hib dose was given on 15th July',
            centerText: true,
          ),
          StandardCard(
            text: 'Learn about potential side effects',
            centerText: true,
          ),
          StandardCard(
            text: 'Rotavirus will be given in 5 weeks time',
            centerText: true,
          ),
          
          const SizedBox(height: 100), // Space for bottom nav
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavIcon(Icons.track_changes, 0, '/tracking'),
          _buildNavIcon(Icons.person, 1, '/profile'),
          _buildNavIcon(Icons.home, 2, '/home'),
          _buildNavIcon(Icons.medical_services, 3, '/educational'),
          _buildNavIcon(Icons.assignment, 4, null), // Current screen
        ],
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, int index, String? route) {
    final isSelected = _currentIndex == index;
    return InkWell(
      onTap: () {
        if (route != null) {
          Navigator.pushNamed(context, route);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Icon(
          icon,
          color: isSelected ? const Color(0xFF0066B3) : const Color(0xFF757575),
          size: 28,
        ),
      ),
    );
  }
}
