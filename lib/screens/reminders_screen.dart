import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackmyshots/theme/app_theme.dart';
import 'package:trackmyshots/services/app_state.dart';
import 'package:trackmyshots/models/models.dart';

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
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // TODO: Navigate to notification settings
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
        child: Consumer<AppState>(
          builder: (context, appState, child) {
            final upcomingDoses = appState.upcomingDoses;
            final upcomingAppointment = appState.upcomingAppointment;
            
            final reminders = _buildRemindersList(
              upcomingDoses,
              upcomingAppointment,
            );

            return ListView(
              padding: const EdgeInsets.all(AppTheme.paddingLarge),
              children: [
                // Header Stats
                _buildStatsCard(context, upcomingDoses.length),
                const SizedBox(height: 24),

                // Reminders List
                if (reminders.isEmpty)
                  _buildEmptyState()
                else
                  ...reminders.map((reminder) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: reminder,
                    );
                  }).toList(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatsCard(BuildContext context, int upcomingCount) {
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
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.notifications_active,
              color: AppTheme.primaryBlue,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$upcomingCount Upcoming',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  upcomingCount == 1 
                      ? 'vaccination scheduled' 
                      : 'vaccinations scheduled',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.grey[400]),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.paddingXLarge),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
      ),
      child: Column(
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'All Caught Up!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You have no upcoming vaccinations or reminders',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildRemindersList(
    List<Map<String, dynamic>> upcomingDoses,
    Appointment? upcomingAppointment,
  ) {
    final List<Widget> reminders = [];

    // Add appointment reminder if exists
    if (upcomingAppointment != null) {
      reminders.add(_buildAppointmentReminderCard(upcomingAppointment));
    }

    // Add dose reminders
    for (var doseInfo in upcomingDoses) {
      final vaccine = doseInfo['vaccine'] as Vaccine;
      final dose = doseInfo['dose'] as VaccineDose;
      final daysUntil = doseInfo['daysUntil'] as int;

      if (daysUntil < 0) {
        // Overdue
        reminders.add(_buildReminderCard(
          '${vaccine.name} dose ${dose.doseNumber} is overdue',
          Icons.warning,
          AppTheme.error,
          'Scheduled for ${_formatDate(dose.scheduledDate!)}',
          isUrgent: true,
        ));
      } else if (daysUntil <= 7) {
        // Due soon
        reminders.add(_buildReminderCard(
          '${vaccine.name} dose ${dose.doseNumber} due in $daysUntil days',
          Icons.access_time,
          AppTheme.warning,
          'Scheduled for ${_formatDate(dose.scheduledDate!)}',
        ));
      } else {
        // Future dose
        reminders.add(_buildReminderCard(
          '${vaccine.name} dose ${dose.doseNumber} scheduled',
          Icons.calendar_today,
          AppTheme.info,
          'Due ${_formatDate(dose.scheduledDate!)}',
        ));
      }
    }

    // Add educational reminders
    if (reminders.length < 5) {
      reminders.add(_buildReminderCard(
        'Learn about potential side effects',
        Icons.info_outline,
        AppTheme.info,
        'Tap to read more about vaccine reactions',
      ));
    }

    return reminders;
  }

  Widget _buildAppointmentReminderCard(Appointment appointment) {
    final daysUntil = appointment.dateTime.difference(DateTime.now()).inDays;
    
    return _buildReminderCard(
      'Appointment with ${appointment.doctorName}',
      Icons.event,
      AppTheme.primaryBlue,
      '${appointment.formattedDate} at ${appointment.formattedTime}',
      subtitle: daysUntil <= 1 
          ? daysUntil == 0 
              ? 'Today' 
              : 'Tomorrow'
          : 'In $daysUntil days',
    );
  }

  Widget _buildReminderCard(
    String message,
    IconData icon,
    Color color,
    String details, {
    String? subtitle,
    bool isUrgent = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.paddingLarge),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
        border: isUrgent
            ? Border.all(color: color, width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                if (subtitle != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      subtitle,
                      style: TextStyle(
                        color: color,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                Text(
                  details,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          if (isUrgent)
            Icon(Icons.priority_high, color: color, size: 20),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    
    return '${days[date.weekday - 1]}, ${date.day} ${months[date.month - 1]}';
  }
}
