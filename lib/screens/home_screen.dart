import 'package:flutter/material.dart';
import 'package:trackmyshots/theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/images/logo.png',
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.vaccines, color: AppTheme.primaryBlue),
          ),
        ),
        title: const Text('TrackMyShots'),
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
            // Greeting
            Text(
              'Hello,\nEmily',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),

            // Search Bar (Placeholder)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.paddingMedium,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.grey[500]),
                  const SizedBox(width: 8),
                  Text(
                    'Search Doctor',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Quick Access Vaccine Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildVaccineQuickButton('R', 'Rotavirus', AppTheme.primaryDark),
                _buildVaccineQuickButton('H', 'Hepatitis B', AppTheme.primaryBlue),
                _buildVaccineQuickButton('P', 'PCV', AppTheme.primaryLight),
                _buildVaccineQuickButton('D', 'DTP', AppTheme.accentCyan),
              ],
            ),
            const SizedBox(height: 32),

            // Upcoming Appointment Section
            Text(
              'Upcoming Appointment',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildAppointmentCard(),
            const SizedBox(height: 32),

            // Recent Visits Section
            Text(
              'My Recent Visit',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildRecentVisitCard(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildVaccineQuickButton(String letter, String name, Color color) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
          ),
          child: Center(
            child: Text(
              letter,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildAppointmentCard() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.paddingMedium),
      decoration: AppDecoration.gradientCard,
      child: Row(
        children: [
          // Doctor Avatar
          const CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(
              'https://via.placeholder.com/60',
            ),
          ),
          const SizedBox(width: 16),
          // Appointment Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Dr. Ray Alex',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'General Practitioner',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.calendar_today, color: Colors.white, size: 16),
                      SizedBox(width: 8),
                      Text(
                        'Wed, 21 May 2025',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(width: 16),
                      Icon(Icons.access_time, color: Colors.white, size: 16),
                      SizedBox(width: 8),
                      Text(
                        '10:30 am - 11:30 am',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentVisitCard() {
    return Container(
      height: 200,
      decoration: AppTheme.cardDecoration,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 8),
            Text(
              'Recent visit history will appear here',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.primaryDark,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/tracking');
              break;
            case 1:
              // Profile icon - stay on home or navigate to profile
              break;
            case 2:
              // Home - already here
              break;
            case 3:
              Navigator.pushNamed(context, '/educational');
              break;
            case 4:
              Navigator.pushNamed(context, '/reminders');
              break;
          }
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white60,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.track_changes),
            label: 'Tracking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services_outlined),
            label: 'Resources',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            label: 'Notes',
          ),
        ],
      ),
    );
  }
}

// Helper class for decorations
class AppDecoration {
  static BoxDecoration gradientCard = BoxDecoration(
    gradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [AppTheme.primaryBlue, AppTheme.accentCyan],
    ),
    borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
    boxShadow: [
      BoxShadow(
        color: AppTheme.shadowColor,
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );
}
