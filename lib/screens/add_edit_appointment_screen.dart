import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackmyshots/models/models.dart';
import 'package:trackmyshots/services/app_state.dart';

class AddEditAppointmentScreen extends StatefulWidget {
  final Appointment? appointment;
  final bool isCopy;

  const AddEditAppointmentScreen({
    super.key,
    this.appointment,
    this.isCopy = false,
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
  late int _durationMinutes;
  late AppointmentType _type;
  late AppointmentStatus _status;
  
  // New: Track selected vaccines
  List<VaccineLink> _selectedVaccineLinks = [];

  @override
  void initState() {
    super.initState();
    final apt = widget.appointment;
    _doctorNameController = TextEditingController(text: apt?.doctorName ?? '');
    _specialtyController = TextEditingController(text: apt?.doctorSpecialty ?? '');
    _locationController = TextEditingController(text: apt?.location ?? '');
    _notesController = TextEditingController(text: apt?.notes ?? '');
    
    // If copying/rescheduling, default to tomorrow same time, or just keep original time but reset date if it's past
    if (widget.isCopy && apt != null) {
       final now = DateTime.now();
       if (apt.dateTime.isBefore(now)) {
         _selectedDate = now.add(const Duration(days: 1));
       } else {
         _selectedDate = apt.dateTime;
       }
    } else {
       _selectedDate = apt?.dateTime ?? DateTime.now().add(const Duration(days: 7));
    }

    _selectedTime = apt != null 
        ? TimeOfDay.fromDateTime(apt.dateTime)
        : const TimeOfDay(hour: 10, minute: 0);
    _durationMinutes = apt?.duration.inMinutes ?? 30;
    _type = apt?.type ?? AppointmentType.checkup;
    
    // Reset status to scheduled if copying
    _status = (widget.isCopy) ? AppointmentStatus.scheduled : (apt?.status ?? AppointmentStatus.scheduled);
    
    // Initialize selected vaccines
    if (apt != null) {
      _selectedVaccineLinks = List.from(apt.linkedVaccines);
    }
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
            const SizedBox(height: 24),
            
            // Vaccine Selection Section
            if (_type == AppointmentType.vaccination) ...[
              const Text(
                'Select Vaccines',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 8),
              _buildVaccineSelectionList(),
              const SizedBox(height: 24),
            ],

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
  
  Widget _buildVaccineSelectionList() {
    final appState = context.read<AppState>();
    final allVaccines = appState.vaccines;
    
    // 1. Collect all candidates (not administered OR already selected)
    // We want to show:
    // - Already selected doses (checked)
    // - Not administered doses (unchecked)
    // Sorted by scheduled date?
    
    List<Map<String, dynamic>> candidates = [];
    
    for (var vaccine in allVaccines) {
      for (var dose in vaccine.doses) {
        final isSelected = _selectedVaccineLinks.any((l) => l.vaccineId == vaccine.id && l.doseId == dose.id);
        
        if (!dose.isAdministered || isSelected) {
          candidates.add({
            'vaccine': vaccine,
            'dose': dose,
            'isSelected': isSelected,
          });
        }
      }
    }
    
    // Sort candidates: Selected first, then by date
    candidates.sort((a, b) {
      final aSelected = a['isSelected'] as bool;
      final bSelected = b['isSelected'] as bool;
      if (aSelected != bSelected) return aSelected ? -1 : 1;
      
      final aDose = a['dose'] as VaccineDose;
      final bDose = b['dose'] as VaccineDose;
      
      final aDate = aDose.scheduledDate ?? DateTime(2099);
      final bDate = bDose.scheduledDate ?? DateTime(2099);
      
      return aDate.compareTo(bDate);
    });
    
    if (candidates.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text('No upcoming vaccines available to select.'),
      );
    }
    
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      height: 200, // Fixed height with scroll
      child: ListView.builder(
        itemCount: candidates.length,
        itemBuilder: (context, index) {
          final item = candidates[index];
          final vaccine = item['vaccine'] as Vaccine;
          final dose = item['dose'] as VaccineDose;
          final isSelected = item['isSelected'] as bool;
          
          return CheckboxListTile(
            title: Text(vaccine.name),
            subtitle: Text('Dose ${dose.doseNumber} - Due: ${dose.scheduledDate?.toString().split(' ')[0] ?? 'N/A'}'),
            value: isSelected,
            activeColor: const Color(0xFF0066B3),
            onChanged: (bool? value) {
              setState(() {
                if (value == true) {
                  _selectedVaccineLinks.add(VaccineLink(vaccineId: vaccine.id, doseId: dose.id));
                } else {
                  _selectedVaccineLinks.removeWhere((l) => l.vaccineId == vaccine.id && l.doseId == dose.id);
                }
              });
            },
          );
        },
      ),
    );
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)), // Allow past dates for logging
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
        id: (widget.appointment == null || widget.isCopy) 
            ? 'apt_${DateTime.now().millisecondsSinceEpoch}' 
            : widget.appointment!.id,
        doctorName: _doctorNameController.text,
        doctorSpecialty: _specialtyController.text,
        doctorPhotoUrl: widget.appointment?.doctorPhotoUrl,
        dateTime: dateTime,
        duration: Duration(minutes: _durationMinutes),
        location: _locationController.text,
        type: _type,
        status: _status,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
        linkedVaccines: _selectedVaccineLinks, // Use the selected links
        fulfillment: widget.isCopy ? null : widget.appointment?.fulfillment, // Reset fulfillment if copying
      );

      final appState = context.read<AppState>();
      if (widget.appointment == null || widget.isCopy) {
        appState.addAppointment(appointment);
      } else {
        appState.updateAppointment(appointment);
      }

      // Sync vaccine schedules with appointment date
      if (_type == AppointmentType.vaccination) {
        if (_selectedVaccineLinks.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please select at least one vaccine for a vaccination appointment'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        for (var link in _selectedVaccineLinks) {
          appState.updateVaccineDose(
            link.vaccineId, 
            link.doseId, 
            scheduledDate: dateTime,
          );
        }
      }

      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            (widget.appointment == null || widget.isCopy)
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
