import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackmyshots/theme/app_theme.dart';
import 'package:trackmyshots/services/app_state.dart';
import 'package:trackmyshots/models/models.dart';
import 'package:intl/intl.dart';

class ScheduleConfirmationScreen extends StatefulWidget {
  const ScheduleConfirmationScreen({super.key});

  @override
  State<ScheduleConfirmationScreen> createState() => _ScheduleConfirmationScreenState();
}

class _ScheduleConfirmationScreenState extends State<ScheduleConfirmationScreen> {
  // Map of vaccineId_doseId -> bool (isChecked)
  final Map<String, bool> _administeredDoses = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize checks based on due dates
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeDefaults();
    });
  }

  void _initializeDefaults() {
    final appState = Provider.of<AppState>(context, listen: false);
    final now = DateTime.now();

    for (final vaccine in appState.vaccines) {
      for (final dose in vaccine.doses) {
        if (dose.scheduledDate != null && dose.scheduledDate!.isBefore(now)) {
          final key = '${vaccine.id}_${dose.id}';
          // Default to checked if it's in the past
          setState(() {
            _administeredDoses[key] = true;
          });
        }
      }
    }
  }

  Future<void> _confirmSchedule() async {
    setState(() {
      _isLoading = true;
    });

    final appState = Provider.of<AppState>(context, listen: false);
    final updates = <Map<String, dynamic>>[];

    _administeredDoses.forEach((key, isAdministered) {
      if (isAdministered) {
        final parts = key.split('_');
        final vaccineId = parts[0];
        final doseId = parts[1];
        
        // Find the scheduled date to use as administered date (approximate)
        // or just use today if we don't know
        DateTime? adminDate;
        final vaccine = appState.vaccines.firstWhere((v) => v.id == vaccineId);
        final dose = vaccine.doses.firstWhere((d) => d.id == doseId);
        adminDate = dose.scheduledDate;

        updates.add({
          'vaccineId': vaccineId,
          'doseId': doseId,
          'isAdministered': true,
          'administeredDate': adminDate ?? DateTime.now(),
        });
      }
    });

    if (updates.isNotEmpty) {
      await appState.batchUpdateDoses(updates);
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final childName = appState.currentChild?.name ?? 'your child';
    
    // Filter for past doses only
    final now = DateTime.now();
    final pastDoses = <Map<String, dynamic>>[];

    for (final vaccine in appState.vaccines) {
      for (final dose in vaccine.doses) {
        if (dose.scheduledDate != null && dose.scheduledDate!.isBefore(now)) {
          pastDoses.add({
            'vaccine': vaccine,
            'dose': dose,
            'key': '${vaccine.id}_${dose.id}',
          });
        }
      }
    }

    // Sort by date
    pastDoses.sort((a, b) {
      final dateA = (a['dose'] as VaccineDose).scheduledDate!;
      final dateB = (b['dose'] as VaccineDose).scheduledDate!;
      return dateA.compareTo(dateB);
    });

    if (pastDoses.isEmpty) {
      // If no past doses, we can skip this screen or show a message
      // For now, let's just show a "All set" message
      return Scaffold(
        backgroundColor: AppTheme.backgroundLight,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, size: 80, color: AppTheme.primaryBlue),
              const SizedBox(height: 24),
              const Text(
                'All Set!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text('Your schedule is ready.'),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false),
                child: const Text('Go to Home'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Review Schedule'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.paddingLarge),
            color: AppTheme.backgroundWhite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Past Vaccinations',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryDark,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Based on $childName\'s age, these vaccines should have been given already. Please uncheck any that haven\'t been administered.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(AppTheme.paddingMedium),
              itemCount: pastDoses.length,
              itemBuilder: (context, index) {
                final item = pastDoses[index];
                final vaccine = item['vaccine'] as Vaccine;
                final dose = item['dose'] as VaccineDose;
                final key = item['key'] as String;
                final isChecked = _administeredDoses[key] ?? false;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: isChecked ? AppTheme.primaryBlue.withOpacity(0.3) : Colors.transparent,
                    ),
                  ),
                  child: CheckboxListTile(
                    value: isChecked,
                    activeColor: AppTheme.primaryBlue,
                    onChanged: (bool? value) {
                      setState(() {
                        _administeredDoses[key] = value ?? false;
                      });
                    },
                    title: Text(
                      vaccine.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      'Dose ${dose.doseNumber} • Due: ${DateFormat.yMMMd().format(dose.scheduledDate!)}',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                    secondary: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isChecked ? AppTheme.primaryBlue.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.vaccines,
                        color: isChecked ? AppTheme.primaryBlue : Colors.grey,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(AppTheme.paddingLarge),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _confirmSchedule,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Confirm & Continue',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}