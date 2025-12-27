import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackmyshots/theme/app_theme.dart';
import 'package:trackmyshots/models/models.dart';
import 'package:trackmyshots/services/app_state.dart';

class VaccineDetailModal extends StatelessWidget {
  final Vaccine vaccine;

  const VaccineDetailModal({
    super.key,
    required this.vaccine,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Header
              Padding(
                padding: const EdgeInsets.all(AppTheme.paddingMedium),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: _getVaccineColor(vaccine).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          vaccine.shortName,
                          style: TextStyle(
                            color: _getVaccineColor(vaccine),
                            fontSize: 32,
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
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                vaccine.isCompleted ? Icons.check_circle : Icons.pending,
                                color: vaccine.isCompleted 
                                    ? AppTheme.success 
                                    : AppTheme.warning,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                vaccine.isCompleted 
                                    ? 'Completed' 
                                    : '${vaccine.completedDoses}/${vaccine.totalDoses} doses',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              // Content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(AppTheme.paddingMedium),
                  children: [
                    // Progress Section
                    _buildProgressSection(context, vaccine),
                    const SizedBox(height: 24),

                    // About Section
                    _buildSection(
                      'About this vaccine',
                      vaccine.purpose.isNotEmpty 
                          ? vaccine.purpose 
                          : vaccine.description,
                      Icons.info_outline,
                    ),
                    const SizedBox(height: 20),

                    // Schedule Section
                    _buildSection(
                      'Vaccination Schedule',
                      vaccine.administrationSchedule,
                      Icons.calendar_today,
                    ),
                    const SizedBox(height: 20),

                    // Side Effects Section
                    if (vaccine.sideEffects.isNotEmpty)
                      _buildSection(
                        'Common Side Effects',
                        vaccine.sideEffects,
                        Icons.warning_amber,
                      ),
                    const SizedBox(height: 24),

                    // Doses List
                    _buildDosesSection(context, vaccine),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProgressSection(BuildContext context, Vaccine vaccine) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.paddingLarge),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _getVaccineColor(vaccine),
            _getVaccineColor(vaccine).withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Overall Progress',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${vaccine.completionPercentage.toInt()}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: vaccine.completionPercentage / 100,
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 12,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${vaccine.completedDoses} completed',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              Text(
                '${vaccine.totalDoses - vaccine.completedDoses} remaining',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: AppTheme.primaryBlue),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(AppTheme.paddingMedium),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Text(
            content,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[800],
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDosesSection(BuildContext context, Vaccine vaccine) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.vaccines, size: 20, color: AppTheme.primaryBlue),
            const SizedBox(width: 8),
            const Text(
              'Dose History',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...vaccine.doses.asMap().entries.map((entry) {
          final index = entry.key;
          final dose = entry.value;
          final isLast = index == vaccine.doses.length - 1;

          return _buildDoseItem(context, dose, vaccine, isLast);
        }).toList(),
      ],
    );
  }

  Widget _buildDoseItem(
    BuildContext context,
    VaccineDose dose,
    Vaccine vaccine,
    bool isLast,
  ) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: dose.isAdministered 
                      ? AppTheme.success 
                      : Colors.grey[300],
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 3,
                  ),
                ),
                child: Center(
                  child: Icon(
                    dose.isAdministered ? Icons.check : Icons.circle,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: Colors.grey[300],
                    margin: const EdgeInsets.symmetric(vertical: 4),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          
          // Dose Info
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(AppTheme.paddingMedium),
              decoration: BoxDecoration(
                color: dose.isAdministered 
                    ? AppTheme.success.withOpacity(0.05)
                    : Colors.grey[50],
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                border: Border.all(
                  color: dose.isAdministered 
                      ? AppTheme.success.withOpacity(0.3)
                      : Colors.grey[200]!,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Dose ${dose.doseNumber}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (dose.isAdministered)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.success,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Given',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      else if (dose.isOverdue)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.error,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Overdue',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      else if (dose.isDue)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.warning,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Due Soon',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  if (dose.isAdministered) ...[
                    _buildInfoRow(Icons.check_circle, 
                        'Given on ${_formatDate(dose.administeredDate!)}'),
                    if (dose.administeredBy != null)
                      _buildInfoRow(Icons.person, 'By ${dose.administeredBy}'),
                    if (dose.batchNumber != null)
                      _buildInfoRow(Icons.qr_code, 'Batch: ${dose.batchNumber}'),
                    if (dose.notes != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        dose.notes!,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ] else ...[
                    if (dose.scheduledDate != null)
                      _buildInfoRow(Icons.event, 
                          'Scheduled for ${_formatDate(dose.scheduledDate!)}'),
                    _buildInfoRow(Icons.child_care, 
                        'At ${dose.ageInWeeks} weeks of age'),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        _markAsAdministered(context, vaccine, dose);
                      },
                      icon: const Icon(Icons.check, size: 18),
                      label: const Text('Mark as Given'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.success,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
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

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
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

  Color _getVaccineColor(Vaccine vaccine) {
    switch (vaccine.id) {
      case 'hep_b':
        return AppTheme.primaryBlue;
      case 'rotavirus':
        return AppTheme.primaryDark;
      case 'dtp':
        return AppTheme.accentCyan;
      case 'hib':
        return AppTheme.primaryBlue;
      case 'pcv':
        return AppTheme.primaryLight;
      default:
        return AppTheme.primaryBlue;
    }
  }

  void _markAsAdministered(BuildContext context, Vaccine vaccine, VaccineDose dose) {
    showDialog(
      context: context,
      builder: (context) => MarkDoseDialog(
        vaccine: vaccine,
        dose: dose,
      ),
    );
  }
}

// Dialog for marking dose as administered
class MarkDoseDialog extends StatefulWidget {
  final Vaccine vaccine;
  final VaccineDose dose;

  const MarkDoseDialog({
    super.key,
    required this.vaccine,
    required this.dose,
  });

  @override
  State<MarkDoseDialog> createState() => _MarkDoseDialogState();
}

class _MarkDoseDialogState extends State<MarkDoseDialog> {
  late DateTime selectedDate;
  final TextEditingController _doctorController = TextEditingController();
  final TextEditingController _batchController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
  }

  @override
  void dispose() {
    _doctorController.dispose();
    _batchController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Mark ${widget.vaccine.name} - Dose ${widget.dose.doseNumber}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Date Administered',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  setState(() {
                    selectedDate = date;
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 18),
                    const SizedBox(width: 12),
                    Text(
                      '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _doctorController,
              decoration: const InputDecoration(
                labelText: 'Administered by (Optional)',
                hintText: 'Dr. Smith',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _batchController,
              decoration: const InputDecoration(
                labelText: 'Batch Number (Optional)',
                hintText: 'VAC2024-001',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (Optional)',
                hintText: 'Any reactions or observations',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final appState = Provider.of<AppState>(context, listen: false);
            appState.updateVaccineDose(
              vaccineId: widget.vaccine.id,
              doseId: widget.dose.id,
              isAdministered: true,
              administeredDate: selectedDate,
              administeredBy: _doctorController.text.isNotEmpty 
                  ? _doctorController.text 
                  : null,
              batchNumber: _batchController.text.isNotEmpty 
                  ? _batchController.text 
                  : null,
              notes: _notesController.text.isNotEmpty 
                  ? _notesController.text 
                  : null,
            );
            Navigator.pop(context); // Close dialog
            Navigator.pop(context); // Close modal
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${widget.vaccine.name} dose marked as administered'),
                backgroundColor: AppTheme.success,
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.success,
          ),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
