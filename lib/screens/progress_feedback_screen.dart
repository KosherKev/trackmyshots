import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackmyshots/theme/app_theme.dart';
import 'package:trackmyshots/services/app_state.dart';
import 'package:trackmyshots/models/models.dart';

class ProgressFeedbackScreen extends StatelessWidget {
  const ProgressFeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Progress & Analytics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO: Share vaccination card
            },
          ),
        ],
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          final childProfile = appState.currentChild;
          final vaccines = appState.vaccines;
          
          return ListView(
            padding: const EdgeInsets.all(AppTheme.paddingLarge),
            children: [
              // Overall Progress Card
              _buildOverallProgressCard(context, appState),
              const SizedBox(height: 24),

              // Age-Appropriate Vaccines
              if (childProfile != null) ...[
                _buildAgeAppropriateSection(context, childProfile, vaccines),
                const SizedBox(height: 24),
              ],

              // Vaccine Status Breakdown
              _buildVaccineStatusSection(context, vaccines),
              const SizedBox(height: 24),

              // Timeline
              _buildTimelineSection(context, vaccines),
              const SizedBox(height: 24),

              // Upcoming Milestones
              _buildUpcomingMilestones(context, appState),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOverallProgressCard(BuildContext context, AppState appState) {
    final completion = appState.overallCompletion;
    final completedDoses = appState.totalDosesCompleted;
    final totalDoses = appState.totalDosesRequired;

    return Container(
      padding: const EdgeInsets.all(AppTheme.paddingLarge),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryBlue,
            AppTheme.accentCyan,
          ],
        ),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowColor,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Overall Immunization Progress',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          
          // Large circular progress
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 180,
                height: 180,
                child: CircularProgressIndicator(
                  value: completion / 100,
                  strokeWidth: 16,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${completion.toInt()}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Complete',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildWhiteStat('Completed', '$completedDoses'),
              Container(
                width: 1,
                height: 40,
                color: Colors.white.withOpacity(0.3),
              ),
              _buildWhiteStat('Total', '$totalDoses'),
              Container(
                width: 1,
                height: 40,
                color: Colors.white.withOpacity(0.3),
              ),
              _buildWhiteStat('Remaining', '${totalDoses - completedDoses}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWhiteStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildAgeAppropriateSection(
    BuildContext context,
    ChildProfile child,
    List<Vaccine> vaccines,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Age-Appropriate Status',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(AppTheme.paddingMedium),
          decoration: BoxDecoration(
            color: AppTheme.info.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
            border: Border.all(color: AppTheme.info.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(Icons.child_care, color: AppTheme.info, size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      child.formattedAge,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'On track for age-appropriate vaccinations',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVaccineStatusSection(BuildContext context, List<Vaccine> vaccines) {
    final completed = vaccines.where((v) => v.isCompleted).length;
    final inProgress = vaccines.where((v) => !v.isCompleted && v.completedDoses > 0).length;
    final notStarted = vaccines.where((v) => v.completedDoses == 0).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vaccine Status Breakdown',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        
        Row(
          children: [
            Expanded(
              child: _buildStatusCard(
                'Completed',
                completed,
                AppTheme.success,
                Icons.check_circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatusCard(
                'In Progress',
                inProgress,
                AppTheme.warning,
                Icons.pending,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatusCard(
                'Not Started',
                notStarted,
                Colors.grey,
                Icons.circle_outlined,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Individual vaccine cards
        ...vaccines.map((vaccine) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildVaccineProgressItem(vaccine),
        )).toList(),
      ],
    );
  }

  Widget _buildStatusCard(String label, int count, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildVaccineProgressItem(Vaccine vaccine) {
    final color = vaccine.isCompleted 
        ? AppTheme.success 
        : vaccine.completionPercentage >= 50 
            ? AppTheme.info 
            : AppTheme.warning;

    return Container(
      padding: const EdgeInsets.all(AppTheme.paddingMedium),
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
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: vaccine.isCompleted
                  ? Icon(Icons.check_circle, color: color, size: 28)
                  : Text(
                      vaccine.shortName,
                      style: TextStyle(
                        color: color,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vaccine.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: vaccine.completionPercentage / 100,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${vaccine.completedDoses}/${vaccine.totalDoses} doses',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${vaccine.completionPercentage.toInt()}%',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineSection(BuildContext context, List<Vaccine> vaccines) {
    // Get all doses and sort by date
    final allDoses = <Map<String, dynamic>>[];
    for (final vaccine in vaccines) {
      for (final dose in vaccine.doses) {
        if (dose.isAdministered && dose.administeredDate != null) {
          allDoses.add({
            'vaccine': vaccine,
            'dose': dose,
            'date': dose.administeredDate!,
          });
        }
      }
    }
    allDoses.sort((a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vaccination History',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        
        if (allDoses.isEmpty)
          Container(
            padding: const EdgeInsets.all(AppTheme.paddingLarge),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
            ),
            child: Center(
              child: Text(
                'No vaccination history yet',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          )
        else
          ...allDoses.take(5).map((item) {
            final vaccine = item['vaccine'] as Vaccine;
            final dose = item['dose'] as VaccineDose;
            final date = item['date'] as DateTime;
            
            return _buildTimelineItem(vaccine, dose, date);
          }).toList(),
      ],
    );
  }

  Widget _buildTimelineItem(Vaccine vaccine, VaccineDose dose, DateTime date) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: AppTheme.success,
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 2,
                height: 40,
                color: Colors.grey[300],
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${vaccine.name} - Dose ${dose.doseNumber}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(date),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                  if (dose.administeredBy != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'By ${dose.administeredBy}',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingMilestones(BuildContext context, AppState appState) {
    final upcomingDoses = appState.upcomingDoses;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upcoming Milestones',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        
        if (upcomingDoses.isEmpty)
          Container(
            padding: const EdgeInsets.all(AppTheme.paddingLarge),
            decoration: BoxDecoration(
              color: AppTheme.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
              border: Border.all(color: AppTheme.success.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.celebration, color: AppTheme.success, size: 32),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'All vaccinations are up to date! 🎉',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          ...upcomingDoses.take(3).map((doseInfo) {
            final vaccine = doseInfo['vaccine'] as Vaccine;
            final dose = doseInfo['dose'] as VaccineDose;
            final daysUntil = doseInfo['daysUntil'] as int;
            
            return _buildMilestoneCard(vaccine, dose, daysUntil);
          }).toList(),
      ],
    );
  }

  Widget _buildMilestoneCard(Vaccine vaccine, VaccineDose dose, int daysUntil) {
    final color = daysUntil < 0 
        ? AppTheme.error 
        : daysUntil <= 7 
            ? AppTheme.warning 
            : AppTheme.info;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(AppTheme.paddingMedium),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            daysUntil < 0 ? Icons.warning : Icons.event,
            color: color,
            size: 28,
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
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dose.scheduledDate != null 
                      ? _formatDate(dose.scheduledDate!)
                      : 'Not scheduled',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              daysUntil < 0 
                  ? 'Overdue' 
                  : daysUntil == 0 
                      ? 'Today' 
                      : '$daysUntil days',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
