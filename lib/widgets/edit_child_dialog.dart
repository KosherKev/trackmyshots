import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackmyshots/theme/app_theme.dart';
import 'package:trackmyshots/models/models.dart';
import 'package:trackmyshots/services/app_state.dart';

class EditChildDialog extends StatefulWidget {
  final ChildProfile child;

  const EditChildDialog({
    super.key,
    required this.child,
  });

  @override
  State<EditChildDialog> createState() => _EditChildDialogState();
}

class _EditChildDialogState extends State<EditChildDialog> {
  late TextEditingController _nameController;
  late TextEditingController _bloodTypeController;
  late TextEditingController _allergiesController;
  late TextEditingController _notesController;
  late DateTime _dateOfBirth;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.child.name);
    _bloodTypeController = TextEditingController(text: widget.child.bloodType ?? '');
    _allergiesController = TextEditingController(text: widget.child.allergies ?? '');
    _notesController = TextEditingController(text: widget.child.medicalNotes ?? '');
    _dateOfBirth = widget.child.dateOfBirth;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bloodTypeController.dispose();
    _allergiesController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Child Profile'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Child Name *',
                hintText: 'Enter child\'s name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),

            // Date of Birth
            const Text(
              'Date of Birth *',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _dateOfBirth,
                  firstDate: DateTime(2010),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  setState(() {
                    _dateOfBirth = date;
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.cake, color: AppTheme.primaryBlue),
                    const SizedBox(width: 12),
                    Text(
                      '${_dateOfBirth.day}/${_dateOfBirth.month}/${_dateOfBirth.year}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Spacer(),
                    Text(
                      _getAge(_dateOfBirth),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Blood Type
            TextField(
              controller: _bloodTypeController,
              decoration: const InputDecoration(
                labelText: 'Blood Type (Optional)',
                hintText: 'e.g., O+, A-, AB+',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.bloodtype),
              ),
              textCapitalization: TextCapitalization.characters,
            ),
            const SizedBox(height: 16),

            // Allergies
            TextField(
              controller: _allergiesController,
              decoration: const InputDecoration(
                labelText: 'Known Allergies (Optional)',
                hintText: 'List any allergies',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.warning_amber),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),

            // Medical Notes
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Medical Notes (Optional)',
                hintText: 'Any important medical information',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.note_alt),
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
          onPressed: _saveProfile,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryBlue,
          ),
          child: const Text('Save'),
        ),
      ],
    );
  }

  String _getAge(DateTime birthDate) {
    final now = DateTime.now();
    final difference = now.difference(birthDate);
    final ageInMonths = (difference.inDays / 30.44).floor();
    final ageInYears = now.year - birthDate.year;

    if (ageInYears < 1) {
      if (ageInMonths < 1) {
        final weeks = (difference.inDays / 7).floor();
        return '$weeks weeks old';
      }
      return '$ageInMonths months old';
    } else if (ageInYears == 1) {
      return '1 year old';
    } else {
      return '$ageInYears years old';
    }
  }

  void _saveProfile() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter child\'s name'),
          backgroundColor: AppTheme.error,
        ),
      );
      return;
    }

    final updatedChild = widget.child.copyWith(
      name: _nameController.text.trim(),
      dateOfBirth: _dateOfBirth,
      bloodType: _bloodTypeController.text.trim().isNotEmpty 
          ? _bloodTypeController.text.trim() 
          : null,
      allergies: _allergiesController.text.trim().isNotEmpty 
          ? _allergiesController.text.trim() 
          : null,
      medicalNotes: _notesController.text.trim().isNotEmpty 
          ? _notesController.text.trim() 
          : null,
      updatedAt: DateTime.now(),
    );

    final appState = Provider.of<AppState>(context, listen: false);
    appState.updateChildProfile(updatedChild);

    Navigator.pop(context);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated successfully'),
        backgroundColor: AppTheme.success,
      ),
    );
  }
}
