import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackmyshots/theme/app_theme.dart';
import 'package:trackmyshots/services/app_state.dart';
import 'package:trackmyshots/models/models.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 2; // Home is at index 2

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
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          final childProfile = appState.currentChild;
          final upcomingAppointment = appState.upcomingAppointment;
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting with child's name
                Text(
                  'Hello,\n${childProfile?.name ?? 'There'}',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                
                // Show child's age if available
                if (childProfile != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    '${childProfile.formattedAge} old',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                  ),
                ],
                
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

                // Quick Access Vaccine Buttons with real data
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildVaccineQuickButton(
                      context,
                      appState,
                      'R',
                      'Rotavirus',
                      AppTheme.primaryDark,
                      'rotavirus',
                    ),
                    _buildVaccineQuickButton(
                      context,
                      appState,
                      'H',
                      'Hepatitis B',
                      AppTheme.primaryBlue,
                      'hep_b',
                    ),
                    _buildVaccineQuickButton(
                      context,
                      appState,
                      'P',
                      'PCV',
                      AppTheme.primaryLight,
                      'pcv',
                    ),
                    _buildVaccineQuickButton(
                      context,
                      appState,
                      'D',
                      'DTP',
                      AppTheme.accentCyan,
                      'dtp',
                    ),
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
                
                // Show real appointment or placeholder
                if (upcomingAppointment != null)
                  _buildAppointmentCard(upcomingAppointment)
                else
                  _buildNoAppointmentCard(),
                  
                const SizedBox(height: 32),

                // Recent Visits Section
                Text(
                  'My Recent Visit',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                _buildRecentVisitCard(appState.appointments),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildVaccineQuickButton(
    BuildContext context,
    AppState appState,
    String letter,
    String name,
    Color color,
    String vaccineId,
  ) {
    final vaccine = appState.getVaccineById(vaccineId);
    final percentage = vaccine?.completionPercentage.toInt() ?? 0;
    
    return GestureDetector(
      onTap: () {
        // Navigate to tracking screen or show vaccine details
        Navigator.pushNamed(context, '/tracking');
      },
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
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
              // Progress indicator
              if (vaccine != null && vaccine.completedDoses > 0)
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: vaccine.isCompleted 
                          ? AppTheme.success 
                          : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: vaccine.isCompleted
                        ? const Icon(
                            Icons.check,
                            size: 12,
                            color: Colors.white,
                          )
                        : Text(
                            '${vaccine.completedDoses}',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(Appointment appointment) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.paddingMedium),
      decoration: AppDecoration.gradientCard,
      child: Row(
        children: [
          // Doctor Avatar
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white.withOpacity(0.3),
            child: Text(
              appointment.doctorName.substring(4, 5), // First letter of last name
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Appointment Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appointment.doctorName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  appointment.doctorSpecialty,
                  style: const TextStyle(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, 
                              color: Colors.white, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            appointment.formattedDate,
                            style: const TextStyle(color: Colors.white, fontSize: 13),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.access_time, 
                              color: Colors.white, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            appointment.formattedTime,
                            style: const TextStyle(color: Colors.white, fontSize: 13),
                          ),
                        ],
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

  Widget _buildNoAppointmentCard() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.paddingLarge),
      decoration: AppTheme.cardDecoration,
      child: Center(
        child: Column(
          children: [
            Icon(Icons.calendar_today_outlined, 
                size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No upcoming appointments',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () {
                // TODO: Navigate to appointment booking
              },
              icon: const Icon(Icons.add),
              label: const Text('Schedule Appointment'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentVisitCard(List<Appointment> appointments) {
    final pastAppointments = appointments
        .where((apt) => apt.isPast && apt.status == AppointmentStatus.completed)
        .toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));

    if (pastAppointments.isEmpty) {
      return Container(
        height: 150,
        decoration: AppTheme.cardDecoration,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.history, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 8),
              Text(
                'No recent visits yet',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    final recentVisit = pastAppointments.first;
    return Container(
      padding: const EdgeInsets.all(AppTheme.paddingMedium),
      decoration: AppTheme.cardDecoration,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.check_circle,
              color: AppTheme.success,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recentVisit.doctorName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  recentVisit.formattedDate,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                if (recentVisit.notes != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    recentVisit.notes!,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 13,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
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
              Navigator.pushNamed(context, '/profile');
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
