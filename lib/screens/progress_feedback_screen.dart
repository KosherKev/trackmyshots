import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackmyshots/services/app_state.dart';
import 'package:trackmyshots/models/models.dart';
import 'package:trackmyshots/widgets/standard_card.dart';

class ProgressFeedbackScreen extends StatefulWidget {
  const ProgressFeedbackScreen({super.key});

  @override
  State<ProgressFeedbackScreen> createState() => _ProgressFeedbackScreenState();
}

class _ProgressFeedbackScreenState extends State<ProgressFeedbackScreen> {
  // int _currentIndex = 3; // Managed by MainScreen

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
          'Progress & Feedback',
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
              Navigator.pushNamed(context, '/reminders');
            },
          ),
        ],
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          final vaccines = appState.vaccines;
          
          return StandardScreenContainer(
            children: [
              // Vaccine Status Cards
              ...vaccines.map((vaccine) {
                return StandardCard(
                  text: vaccine.name,
                  trailing: vaccine.isCompleted
                      ? const Icon(
                          Icons.check_circle,
                          color: Color(0xFF4CAF50),
                          size: 28,
                        )
                      : Icon(
                          Icons.hourglass_empty,
                          color: Colors.grey[600],
                          size: 28,
                        ),
                );
              }).toList(),
              
              const SizedBox(height: 100), // Space for bottom nav
            ],
          );
        },
      ),
      // bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  /*
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
          _buildNavIcon(Icons.medical_services, 3, null), // Current screen  
          _buildNavIcon(Icons.assignment, 4, '/reminders'),
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
  */
}
