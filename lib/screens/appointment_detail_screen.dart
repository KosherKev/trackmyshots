import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackmyshots/models/models.dart';
import 'package:trackmyshots/services/app_state.dart';

class AppointmentDetailScreen extends StatelessWidget {
  final Appointment appointment;

  const AppointmentDetailScreen({
    super.key,
    required this.appointment,
  });

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
          'Appointment Details',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Color(0xFF0066B3)),
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
          IconButton(
            icon: const Icon(Icons.delete, color: Color(0xFFEF5350)),
            onPressed: () => _deleteAppointment(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor Info Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0066B3), Color(0xFF4AA5D9)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Text(
                      appointment.doctorName.substring(0, 1),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0066B3),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    appointment.doctorName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    appointment.doctorSpecialty,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Appointment Details
            _buildDetailSection('Date & Time', [
              _buildDetailRow(Icons.calendar_today, 'Date', appointment.formattedDate),
              _buildDetailRow(Icons.access_time, 'Time', appointment.formattedTime),
              _buildDetailRow(Icons.timer, 'Duration', '${appointment.duration.inMinutes} minutes'),
            ]),
            const SizedBox(height: 20),

            _buildDetailSection('Location', [
              _buildDetailRow(Icons.location_on, 'Address', appointment.location),
            ]),
            const SizedBox(height: 20),

            _buildDetailSection('Appointment Info', [
              _buildDetailRow(Icons.medical_services, 'Type', _formatType(appointment.type)),
              _buildDetailRow(Icons.info, 'Status', _formatStatus(appointment.status)),
            ]),

            if (appointment.notes != null) ...[
              const SizedBox(height: 20),
              _buildDetailSection('Notes', [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F9FC),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    appointment.notes!,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                ),
              ]),
            ],

            if (appointment.relatedVaccineIds.isNotEmpty) ...[
              const SizedBox(height: 20),
              _buildDetailSection('Related Vaccines', [
                ...appointment.relatedVaccineIds.map((id) {
                  final vaccine = context.read<AppState>().getVaccineById(id);
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F9FC),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.vaccines, color: Color(0xFF0066B3)),
                        const SizedBox(width: 12),
                        Text(
                          vaccine?.name ?? 'Unknown Vaccine',
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ]),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF0066B3)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF757575),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatType(AppointmentType type) {
    switch (type) {
      case AppointmentType.vaccination:
        return 'Vaccination';
      case AppointmentType.checkup:
        return 'Check-up';
      case AppointmentType.consultation:
        return 'Consultation';
      case AppointmentType.followUp:
        return 'Follow-up';
      case AppointmentType.emergency:
        return 'Emergency';
    }
  }

  String _formatStatus(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.scheduled:
        return 'Scheduled';
      case AppointmentStatus.confirmed:
        return 'Confirmed';
      case AppointmentStatus.completed:
        return 'Completed';
      case AppointmentStatus.cancelled:
        return 'Cancelled';
      case AppointmentStatus.noShow:
        return 'No Show';
    }
  }

  void _deleteAppointment(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Appointment?'),
        content: const Text('Are you sure you want to delete this appointment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<AppState>().deleteAppointment(appointment.id);
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close detail screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Appointment deleted'),
                  backgroundColor: Color(0xFFEF5350),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF5350),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// Add/Edit Appointment Screen
class AddEditAppointmentScreen extends StatefulWidget {
  final Appointment? appointment;

  const AddEditAppointmentScreen({
    super.key,
    this.appointment,
  });

  @override
  State<AddEditAppointmentScreen> createState() => _AddEditAppointmentScreenState();
}

class _AddEditAppointmentScreenState extends State<AddEditAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _doctorNameController;
  late TextEditingController _specialtyController;
  late TextEditingController _locationController;
  late TextEditingController _notesController;
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  late int _durationMinutes; // Changed from _duration to _durationMinutes
  late AppointmentType _type;
  late AppointmentStatus _status;

  @override
  void initState() {
    super.initState();
    final apt = widget.appointment;
    _doctorNameController = TextEditingController(text: apt?.doctorName ?? '');
    _specialtyController = TextEditingController(text: apt?.doctorSpecialty ?? '');
    _locationController = TextEditingController(text: apt?.location ?? '');
    _notesController = TextEditingController(text: apt?.notes ?? '');
    _selectedDate = apt?.dateTime ?? DateTime.now().add(const Duration(days: 7));
    _selectedTime = apt != null 
        ? TimeOfDay.fromDateTime(apt.dateTime)
        : const TimeOfDay(hour: 10, minute: 0);
    _durationMinutes = apt?.duration.inMinutes ?? 30; // Fixed: convert Duration to minutes
    _type = apt?.type ?? AppointmentType.checkup;
    _status = apt?.status ?? AppointmentStatus.scheduled;
  }

  @override
  void dispose() {
    _doctorNameController.dispose();
    _specialtyController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

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
        title: Text(
          widget.appointment == null ? 'New Appointment' : 'Edit Appointment',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            TextFormField(
              controller: _doctorNameController,
              decoration: const InputDecoration(
                labelText: 'Doctor Name *',
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter doctor name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _specialtyController,
              decoration: const InputDecoration(
                labelText: 'Specialty *',
                prefixIcon: Icon(Icons.medical_services),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter specialty';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Date picker
            InkWell(
              onTap: _pickDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Date *',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(
                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Time picker
            InkWell(
              onTap: _pickTime,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Time *',
                  prefixIcon: Icon(Icons.access_time),
                ),
                child: Text(_selectedTime.format(context)),
              ),
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<int>(
              value: _durationMinutes,
              decoration: const InputDecoration(
                labelText: 'Duration (minutes)',
                prefixIcon: Icon(Icons.timer),
              ),
              items: [15, 30, 45, 60, 90].map((min) {
                return DropdownMenuItem(
                  value: min,
                  child: Text('$min minutes'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _durationMinutes = value!;
                });
              },
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location *',
                prefixIcon: Icon(Icons.location_on),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter location';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<AppointmentType>(
              value: _type,
              decoration: const InputDecoration(
                labelText: 'Appointment Type',
                prefixIcon: Icon(Icons.category),
              ),
              items: AppointmentType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(_formatType(type)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _type = value!;
                });
              },
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<AppointmentStatus>(
              value: _status,
              decoration: const InputDecoration(
                labelText: 'Status',
                prefixIcon: Icon(Icons.info),
              ),
              items: AppointmentStatus.values.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(_formatStatus(status)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _status = value!;
                });
              },
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (Optional)',
                prefixIcon: Icon(Icons.note),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: _saveAppointment,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0066B3),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                widget.appointment == null ? 'Create Appointment' : 'Update Appointment',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (time != null) {
      setState(() {
        _selectedTime = time;
      });
    }
  }

  void _saveAppointment() {
    if (_formKey.currentState!.validate()) {
      final dateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      final appointment = Appointment(
        id: widget.appointment?.id ?? 'apt_${DateTime.now().millisecondsSinceEpoch}',
        doctorName: _doctorNameController.text,
        doctorSpecialty: _specialtyController.text,
        doctorPhotoUrl: widget.appointment?.doctorPhotoUrl,
        dateTime: dateTime,
        duration: Duration(minutes: _durationMinutes), // Fixed: convert minutes to Duration
        location: _locationController.text,
        type: _type,
        status: _status,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
        relatedVaccineIds: widget.appointment?.relatedVaccineIds ?? [],
      );

      final appState = context.read<AppState>();
      if (widget.appointment == null) {
        appState.addAppointment(appointment);
      } else {
        appState.updateAppointment(appointment);
      }

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.appointment == null 
                ? 'Appointment created' 
                : 'Appointment updated',
          ),
          backgroundColor: const Color(0xFF4CAF50),
        ),
      );
    }
  }

  String _formatType(AppointmentType type) {
    switch (type) {
      case AppointmentType.vaccination:
        return 'Vaccination';
      case AppointmentType.checkup:
        return 'Check-up';
      case AppointmentType.consultation:
        return 'Consultation';
      case AppointmentType.followUp:
        return 'Follow-up';
      case AppointmentType.emergency:
        return 'Emergency';
    }
  }

  String _formatStatus(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.scheduled:
        return 'Scheduled';
      case AppointmentStatus.confirmed:
        return 'Confirmed';
      case AppointmentStatus.completed:
        return 'Completed';
      case AppointmentStatus.cancelled:
        return 'Cancelled';
      case AppointmentStatus.noShow:
        return 'No Show';
    }
  }
}
