import 'package:flutter/material.dart';
import 'package:trackmyshots/screens/educational_detail_screen.dart';
import 'package:trackmyshots/widgets/standard_card.dart';

class EducationalResourcesScreen extends StatefulWidget {
  const EducationalResourcesScreen({super.key});

  @override
  State<EducationalResourcesScreen> createState() => _EducationalResourcesScreenState();
}

class _EducationalResourcesScreenState extends State<EducationalResourcesScreen> {
  int _currentIndex = 3; // Educational tab

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
          'Educational Resources',
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
      body: StandardScreenContainer(
        children: [
          StandardCard(
            text: 'Vaccine Purpose',
            leading: const Icon(
              Icons.article_outlined,
              color: Color(0xFF0066B3),
              size: 28,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EducationalDetailScreen.vaccinePurpose(context),
                ),
              );
            },
          ),
          StandardCard(
            text: 'Potential Side Effects',
            leading: const Icon(
              Icons.warning_amber_outlined,
              color: Color(0xFF0066B3),
              size: 28,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EducationalDetailScreen.sideEffects(context),
                ),
              );
            },
          ),
          StandardCard(
            text: 'Importance of Adherence',
            leading: const Icon(
              Icons.verified_outlined,
              color: Color(0xFF0066B3),
              size: 28,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EducationalDetailScreen.adherenceImportance(context),
                ),
              );
            },
          ),
          StandardCard(
            text: 'Immunization Overview',
            leading: const Icon(
              Icons.vaccines_outlined,
              color: Color(0xFF0066B3),
              size: 28,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EducationalDetailScreen.immunizationOverview(context),
                ),
              );
            },
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
}
