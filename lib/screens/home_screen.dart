import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackmyshots/theme/app_theme.dart';
import 'package:trackmyshots/services/app_state.dart';
import 'package:trackmyshots/services/notification_service.dart';
import 'package:trackmyshots/models/models.dart';
import 'package:trackmyshots/screens/appointment_detail_screen.dart';
import 'package:trackmyshots/screens/add_edit_appointment_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // int _currentIndex = 2; // Home is at index 2

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkPendingNotification();
    });
  }

  void _checkPendingNotification() {
    final payload = NotificationService().pendingPayload;
    if (payload != null) {
      final parts = payload.split('|');
      if (parts.isNotEmpty) {
        final type = parts[0];
        final id = parts.length > 1 ? parts[1] : null;

        if (type == 'appointment' && id != null) {
          Navigator.pushNamed(context, '/appointment-detail', arguments: id);
        } else {
          // Default or vaccine type
          Navigator.pushNamed(context, '/tracking', arguments: id);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Image.asset(
        //     'images/logo.png',
        //     errorBuilder: (context, error, stackTrace) =>
        //         const Icon(Icons.vaccines, color: AppTheme.primaryBlue),
        //   ),
        // ),
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
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello,',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                              ),
                        ),
                        PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'add_child') {
                              Navigator.pushNamed(context, '/child-info');
                            } else {
                              appState.selectChild(value);
                            }
                          },
                          offset: const Offset(0, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Text(
                                childProfile?.name ?? 'Select Child',
                                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primaryBlue,
                                    ),
                              ),
                              const Icon(Icons.keyboard_arrow_down, color: AppTheme.primaryBlue, size: 32),
                            ],
                          ),
                          itemBuilder: (context) {
                            final List<PopupMenuEntry<String>> items = [];
                            
                            // Add existing children
                            for (final child in appState.children) {
                              items.add(
                                PopupMenuItem(
                                  value: child.id,
                                  child: Row(
                                    children: [
                                      if (child.id == childProfile?.id)
                                        const Icon(Icons.check, color: AppTheme.primaryBlue, size: 20)
                                      else
                                        const SizedBox(width: 20),
                                      const SizedBox(width: 8),
                                      Text(
                                        child.name,
                                        style: TextStyle(
                                          fontWeight: child.id == childProfile?.id 
                                              ? FontWeight.bold 
                                              : FontWeight.normal,
                                          color: child.id == childProfile?.id 
                                              ? AppTheme.primaryBlue 
                                              : Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                            
                            // Divider
                            if (items.isNotEmpty) {
                              items.add(const PopupMenuDivider());
                            }
                            
                            // Add Child option
                            items.add(
                              const PopupMenuItem(
                                value: 'add_child',
                                child: Row(
                                  children: [
                                    Icon(Icons.add_circle_outline, color: AppTheme.primaryBlue, size: 20),
                                    SizedBox(width: 12),
                                    Text(
                                      'Add Child',
                                      style: TextStyle(
                                        color: AppTheme.primaryBlue,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                            
                            return items;
                          },
                        ),
                      ],
                    ),
                  ],
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
                
                // Show real appointment or add button
                if (upcomingAppointment != null)
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AppointmentDetailScreen(
                            appointment: upcomingAppointment,
                          ),
                        ),
                      );
                    },
                    child: _buildAppointmentCard(upcomingAppointment),
                  )
                else
                  _buildNoAppointmentCard(context),
                  
                const SizedBox(height: 32),

                // Recent Visits Section
                Text(
                  'My Recent Visit',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                _buildRecentVisitCard(context, appState.appointments),
                
                const SizedBox(height: 100), // Space for bottom nav
              ],
            ),
          );
        },
      ),
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
    
    return GestureDetector(
      onTap: () {
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
      decoration: BoxDecoration(
        gradient: AppTheme.blueGradient,
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
          // Doctor Avatar
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white.withOpacity(0.3),
            child: Text(
              appointment.doctorName.substring(0, 1),
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
          const Icon(Icons.chevron_right, color: Colors.white, size: 28),
        ],
      ),
    );
  }

  Widget _buildNoAppointmentCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.paddingLarge),
      decoration: AppTheme.cardDecoration,
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
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddEditAppointmentScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Schedule Appointment'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentVisitCard(BuildContext context, List<Appointment> appointments) {
    // Get completed appointments
    final completedAppointments = appointments
        .where((apt) => apt.status == AppointmentStatus.completed)
        .toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));

    if (completedAppointments.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppTheme.paddingLarge),
        decoration: AppTheme.cardDecoration,
        child: Center(
          child: Column(
            children: [
              Icon(Icons.history, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'No recent visits',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final recentVisit = completedAppointments.first;
    
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AppointmentDetailScreen(
              appointment: recentVisit,
            ),
          ),
        );
      },
      child: Container(
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
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    recentVisit.doctorSpecialty,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    recentVisit.formattedDate,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
          ],
        ),
      ),
    );
  }


}
