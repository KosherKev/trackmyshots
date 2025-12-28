import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackmyshots/models/models.dart';
import 'package:trackmyshots/services/app_state.dart';
import 'package:trackmyshots/screens/add_edit_appointment_screen.dart';

class AppointmentDetailScreen extends StatefulWidget {
  final Appointment appointment;

  const AppointmentDetailScreen({
    super.key,
    required this.appointment,
  });

  @override
  State<AppointmentDetailScreen> createState() => _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends State<AppointmentDetailScreen> {
  @override
  Widget build(BuildContext context) {
    // Re-fetch appointment from state to get latest updates
    final appState = context.watch<AppState>();
    final appointment = appState.appointments.firstWhere(
      (a) => a.id == widget.appointment.id,
      orElse: () => widget.appointment,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (appointment.status != AppointmentStatus.completed && 
              appointment.status != AppointmentStatus.cancelled)
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddEditAppointmentScreen(
                      appointment: appointment,
                    ),
                  ),
                );
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: appointment.doctorPhotoUrl != null
                      ? NetworkImage(appointment.doctorPhotoUrl!)
                      : null,
                  child: appointment.doctorPhotoUrl == null
                      ? const Icon(Icons.person, size: 40, color: Colors.grey)
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.doctorName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        appointment.doctorSpecialty,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildInfoRow(Icons.calendar_today, appointment.formattedDate),
            const SizedBox(height: 16),
            _buildInfoRow(Icons.access_time, appointment.formattedTime),
            const SizedBox(height: 16),
            _buildInfoRow(Icons.location_on, appointment.location),
            
            if (appointment.notes != null && appointment.notes!.isNotEmpty) ...[
              const SizedBox(height: 24),
              const Text(
                'Notes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                appointment.notes!,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade800,
                  height: 1.5,
                ),
              ),
            ],

            if (appointment.linkedVaccines.isNotEmpty) ...[
              const SizedBox(height: 24),
              const Text(
                'Vaccines',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...appointment.linkedVaccines.map((link) {
                final vaccine = appState.getVaccineById(link.vaccineId);
                // We need to find the dose number
                String doseInfo = '';
                if (vaccine != null) {
                  try {
                    final dose = vaccine.doses.firstWhere((d) => d.id == link.doseId);
                    doseInfo = 'Dose ${dose.doseNumber}';
                  } catch (_) {}
                }
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.vaccines, color: Color(0xFF0066B3), size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '${vaccine?.name ?? 'Unknown Vaccine'} ($doseInfo)',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      if (link.wasAdministered)
                        const Icon(Icons.check_circle, color: Colors.green, size: 20),
                    ],
                  ),
                );
              }),
            ],

            const SizedBox(height: 32),

            if (appointment.status != AppointmentStatus.completed && 
                appointment.status != AppointmentStatus.cancelled) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _showFulfillmentDialog(context, appointment),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Mark as Kept',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddEditAppointmentScreen(
                          appointment: appointment,
                          isCopy: true,
                        ),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: Color(0xFF0066B3)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Reschedule',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0066B3),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => _showCancelDialog(context, appointment),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Cancel Appointment',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ] else if (appointment.status == AppointmentStatus.completed && appointment.fulfillment != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green),
                        SizedBox(width: 8),
                        Text(
                          'Appointment Kept',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Date: ${appointment.fulfillment!.actualDateTime?.toString().split(' ')[0] ?? 'Unknown'}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    if (appointment.fulfillment!.notes?.isNotEmpty == true) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Notes: ${appointment.fulfillment!.notes}',
                        style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                      ),
                    ],
                    const SizedBox(height: 12),
                    const Text(
                      'Administered Vaccines:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    if (appointment.linkedVaccines.where((l) => l.wasAdministered).isEmpty)
                      const Text('None recorded'),
                    ...appointment.linkedVaccines
                        .where((l) => l.wasAdministered)
                        .map((link) {
                          final vaccine = appState.getVaccineById(link.vaccineId);
                          return Padding(
                            padding: const EdgeInsets.only(left: 8, top: 4),
                            child: Row(
                              children: [
                                const Icon(Icons.vaccines, size: 16, color: Colors.grey),
                                const SizedBox(width: 8),
                                Text(vaccine?.name ?? 'Unknown Vaccine'),
                              ],
                            ),
                          );
                        }),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey.shade600),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF1A1A1A),
          ),
        ),
      ],
    );
  }

  void _showFulfillmentDialog(BuildContext context, Appointment appointment) {
    final appState = context.read<AppState>();
    showDialog(
      context: context,
      builder: (context) => _FulfillmentDialog(
        appointment: appointment,
        vaccines: appState.vaccines,
      ),
    );
  }

  void _showCancelDialog(BuildContext context, Appointment appointment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Appointment'),
        content: const Text('Are you sure you want to cancel this appointment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No, Keep It'),
          ),
          TextButton(
            onPressed: () {
              final appState = context.read<AppState>();
              appState.updateAppointment(
                appointment.copyWith(status: AppointmentStatus.cancelled),
              );
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to list
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Appointment cancelled')),
              );
            },
            child: const Text('Yes, Cancel', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _FulfillmentDialog extends StatefulWidget {
  final Appointment appointment;
  final List<Vaccine> vaccines;

  const _FulfillmentDialog({
    required this.appointment,
    required this.vaccines,
  });

  @override
  State<_FulfillmentDialog> createState() => _FulfillmentDialogState();
}

class _FulfillmentDialogState extends State<_FulfillmentDialog> {
  final Set<String> _selectedDoseIds = {}; // Format: vaccineId|doseId
  final TextEditingController _notesController = TextEditingController();
  late DateTime _administeredDate;

  @override
  void initState() {
    super.initState();
    _administeredDate = DateTime.now();
    // Default select all linked vaccines that are NOT already administered (internally or externally)
    for (var link in widget.appointment.linkedVaccines) {
      if (!link.wasAdministered) {
        // Check if externally administered
        bool isExternallyAdministered = false;
        try {
          final vaccine = widget.vaccines.firstWhere((v) => v.id == link.vaccineId);
          final dose = vaccine.doses.firstWhere((d) => d.id == link.doseId);
          if (dose.isAdministered) {
            isExternallyAdministered = true;
          }
        } catch (_) {}

        if (!isExternallyAdministered) {
          _selectedDoseIds.add('${link.vaccineId}|${link.doseId}');
        }
      }
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Mark Appointment as Kept'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Which vaccines were administered?'),
            const SizedBox(height: 12),
            if (widget.appointment.linkedVaccines.isEmpty)
              const Text('No vaccines linked to this appointment.', style: TextStyle(fontStyle: FontStyle.italic)),
            
            ...widget.appointment.linkedVaccines.map((link) {
              final vaccine = context.read<AppState>().getVaccineById(link.vaccineId);
              VaccineDose? dose;
              if (vaccine != null) {
                try {
                  dose = vaccine.doses.firstWhere((d) => d.id == link.doseId);
                } catch (_) {}
              }
              
              if (link.wasAdministered) return const SizedBox.shrink(); // Skip already administered in this appointment

              final key = '${link.vaccineId}|${link.doseId}';
              final isExternallyAdministered = dose?.isAdministered == true;

              if (isExternallyAdministered) {
                 return ListTile(
                   title: Text(vaccine?.name ?? 'Unknown'),
                   subtitle: Text(
                     'Already marked as given on ${dose!.administeredDate?.toString().split(' ')[0] ?? 'Unknown date'}.\nUpdate to this appointment?',
                     style: const TextStyle(color: Colors.orange),
                   ),
                   leading: const Icon(Icons.warning_amber, color: Colors.orange),
                   trailing: Switch(
                     value: _selectedDoseIds.contains(key),
                     activeColor: Colors.orange,
                     onChanged: (bool value) {
                       setState(() {
                         if (value) {
                           _selectedDoseIds.add(key);
                         } else {
                           _selectedDoseIds.remove(key);
                         }
                       });
                     },
                   ),
                 );
              }
              
              return CheckboxListTile(
                title: Text(vaccine?.name ?? 'Unknown'),
                subtitle: dose != null ? Text('Dose ${dose.doseNumber}') : null,
                value: _selectedDoseIds.contains(key),
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      _selectedDoseIds.add(key);
                    } else {
                      _selectedDoseIds.remove(key);
                    }
                  });
                },
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
              );
            }),
            
            const SizedBox(height: 16),
            const Text('Administered Date:'),
            const SizedBox(height: 8),
            InkWell(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _administeredDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  setState(() {
                    _administeredDate = date;
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16),
                    const SizedBox(width: 8),
                    Text('${_administeredDate.day}/${_administeredDate.month}/${_administeredDate.year}'),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes / Remarks',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
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
          onPressed: _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4CAF50),
          ),
          child: const Text('Confirm'),
        ),
      ],
    );
  }

  void _submit() {
    final appState = context.read<AppState>();
    
    // 1. Update Appointment
    // Update linked vaccines status
    final updatedLinks = widget.appointment.linkedVaccines.map((link) {
      final key = '${link.vaccineId}|${link.doseId}';
      if (_selectedDoseIds.contains(key)) {
        return VaccineLink(
          vaccineId: link.vaccineId,
          doseId: link.doseId,
          wasAdministered: true,
        );
      }
      return link;
    }).toList();

    final fulfillment = AppointmentFulfillment(
      wasKept: true,
      actualDateTime: _administeredDate,
      notes: _notesController.text,
      vaccineLinks: updatedLinks, // This duplicates info but keeps record in fulfillment
    );

    final updatedAppointment = widget.appointment.copyWith(
      status: AppointmentStatus.completed,
      fulfillment: fulfillment,
      linkedVaccines: updatedLinks, // Update main list too
    );
    
    appState.updateAppointment(updatedAppointment);

    // 2. Update Vaccines in AppState
    for (var key in _selectedDoseIds) {
      final parts = key.split('|');
      final vaccineId = parts[0];
      final doseId = parts[1];
      
      appState.updateVaccineDose(
        vaccineId, 
        doseId,
        isAdministered: true,
        administeredDate: _administeredDate,
        notes: 'Administered during appointment with ${widget.appointment.doctorName}',
        administeredBy: widget.appointment.doctorName,
      );
    }

    Navigator.pop(context); // Close dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Appointment marked as kept and vaccines updated!'),
        backgroundColor: Color(0xFF4CAF50),
      ),
    );
  }
}
