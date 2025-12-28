import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackmyshots/theme/app_theme.dart';
import 'package:trackmyshots/services/app_state.dart';
import 'package:trackmyshots/models/models.dart';
import 'package:trackmyshots/widgets/vaccine_detail_modal.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  DateTime selectedDate = DateTime.now();
  int _currentIndex = 0; // Tracking tab
  bool _navigationChecked = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_navigationChecked) {
      _checkPendingNavigation();
      _navigationChecked = true;
    }
  }

  void _checkPendingNavigation() {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is String) {
      final parts = args.split('|');
      if (parts.length == 2) {
        final vaccineId = parts[0];
        // final doseId = parts[1]; // We can use this later to highlight specific dose
        
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showVaccineDetails(vaccineId);
        });
      }
    }
  }

  void _showVaccineDetails(String vaccineId) {
    final appState = Provider.of<AppState>(context, listen: false);
    final vaccine = appState.getVaccineById(vaccineId);
    if (vaccine != null) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => VaccineDetailModal(vaccine: vaccine),
      );
    }
  }

  void _previousMonth() {
    setState(() {
      selectedDate = DateTime(selectedDate.year, selectedDate.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      selectedDate = DateTime(selectedDate.year, selectedDate.month + 1);
    });
  }

  String _formatDate(DateTime date) {
    final months = ['January', 'February', 'March', 'April', 'May', 'June',
                    'July', 'August', 'September', 'October', 'November', 'December'];
    return '${months[date.month - 1]} ${date.year}';
  }

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
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          final vaccines = appState.vaccines;
          final upcomingDoses = appState.upcomingDoses;

          return SingleChildScrollView(
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
                  child: Column(
                    children: [
                      const Text(
                        'Immunization\nSchedule',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${vaccines.length} vaccines tracked',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Month Selector
                _buildMonthSelector(context),
                const SizedBox(height: 24),

                // Upcoming Doses Section
                if (upcomingDoses.isNotEmpty) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Upcoming Doses',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      TextButton(
                        onPressed: () {
                          // TODO: Show all upcoming doses
                        },
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildUpcomingDosesList(upcomingDoses.take(3).toList()),
                  const SizedBox(height: 24),
                ],

                // Tracking Progress Section
                Text(
                  'Vaccination Progress',
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
                  children: vaccines.map((vaccine) {
                    return _buildProgressCard(
                      context,
                      vaccine.name,
                      vaccine.completionPercentage.toInt(),
                      _getProgressColor(vaccine.completionPercentage),
                      vaccine,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // Vaccine List with Details
                Text(
                  'All Vaccines',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                ...vaccines.map((vaccine) => _buildVaccineListItem(context, vaccine)),
                
                const SizedBox(height: 100), // Space for bottom nav
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildMonthSelector(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.paddingLarge,
        vertical: AppTheme.paddingMedium,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowColor,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: _previousMonth,
          ),
          Text(
            _formatDate(selectedDate),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: _nextMonth,
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingDosesList(List<Map<String, dynamic>> upcomingDoses) {
    return Column(
      children: upcomingDoses.map((doseInfo) {
        final vaccine = doseInfo['vaccine'] as Vaccine;
        final dose = doseInfo['dose'] as VaccineDose;
        final daysUntil = doseInfo['daysUntil'] as int;

        return GestureDetector(
          onTap: () {
            showVaccineDetailModal(context, vaccine);
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(AppTheme.paddingMedium),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
              border: Border.all(
                color: daysUntil < 0 
                    ? AppTheme.error.withOpacity(0.3)
                    : daysUntil <= 7
                        ? AppTheme.warning.withOpacity(0.3)
                        : AppTheme.info.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: daysUntil < 0
                        ? AppTheme.error.withOpacity(0.1)
                        : daysUntil <= 7
                            ? AppTheme.warning.withOpacity(0.1)
                            : AppTheme.info.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    daysUntil < 0 
                        ? Icons.warning 
                        : Icons.vaccines,
                    color: daysUntil < 0
                        ? AppTheme.error
                        : daysUntil <= 7
                            ? AppTheme.warning
                            : AppTheme.info,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${vaccine.name} - Dose ${dose.doseNumber}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dose.scheduledDate != null
                            ? 'Scheduled: ${_formatScheduledDate(dose.scheduledDate!)}'
                            : 'Not scheduled',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                if (daysUntil < 0)
                  Chip(
                    label: const Text(
                      'Overdue',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    backgroundColor: AppTheme.error,
                  )
                else if (daysUntil <= 7)
                  Chip(
                    label: Text(
                      '$daysUntil days',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    backgroundColor: AppTheme.warning,
                  )
                else
                  Chip(
                    label: Text(
                      '${(daysUntil / 7).ceil()} weeks',
                      style: const TextStyle(fontSize: 12),
                    ),
                    backgroundColor: AppTheme.info.withOpacity(0.2),
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  String _formatScheduledDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Color _getProgressColor(double percentage) {
    if (percentage == 100) return AppTheme.progress100;
    if (percentage >= 75) return AppTheme.progress80;
    if (percentage >= 50) return AppTheme.progress50;
    return AppTheme.warning;
  }

  Widget _buildProgressCard(
    BuildContext context,
    String vaccineName,
    int percentage,
    Color color,
    Vaccine vaccine,
  ) {
    return GestureDetector(
      onTap: () {
        showVaccineDetailModal(context, vaccine);
      },
      child: Container(
        padding: const EdgeInsets.all(AppTheme.paddingMedium),
        decoration: BoxDecoration(
          color: AppTheme.primaryBlue,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadowColor,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              vaccineName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 70,
                  height: 70,
                  child: CircularProgressIndicator(
                    value: percentage / 100,
                    strokeWidth: 6,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$percentage%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${vaccine.completedDoses}/${vaccine.totalDoses}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVaccineListItem(BuildContext context, Vaccine vaccine) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowColor,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            showVaccineDetailModal(context, vaccine);
          },
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.paddingMedium),
            child: Row(
              children: [
                // Vaccine Icon/Letter
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: _getProgressColor(vaccine.completionPercentage)
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      vaccine.shortName,
                      style: TextStyle(
                        color: _getProgressColor(vaccine.completionPercentage),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Vaccine Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vaccine.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${vaccine.completedDoses} of ${vaccine.totalDoses} doses completed',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Progress bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: vaccine.completionPercentage / 100,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _getProgressColor(vaccine.completionPercentage),
                          ),
                          minHeight: 6,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Status Icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: vaccine.isCompleted
                        ? AppTheme.success.withOpacity(0.1)
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    vaccine.isCompleted ? Icons.check_circle : Icons.arrow_forward_ios,
                    color: vaccine.isCompleted ? AppTheme.success : Colors.grey[400],
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showVaccineDetailModal(BuildContext context, Vaccine vaccine) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => VaccineDetailModal(vaccine: vaccine),
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
          _buildNavIcon(Icons.track_changes, 0, null), // Current screen
          _buildNavIcon(Icons.person, 1, '/profile'),
          _buildNavIcon(Icons.home, 2, '/home'),
          _buildNavIcon(Icons.medical_services, 3, '/educational'),
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
