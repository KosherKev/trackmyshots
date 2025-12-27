import 'package:flutter/foundation.dart';
import 'package:trackmyshots/models/models.dart';
import 'package:trackmyshots/services/sample_data_service.dart';

class AppState extends ChangeNotifier {
  ChildProfile? _currentChild;
  List<Vaccine> _vaccines = [];
  List<Appointment> _appointments = [];

  // Getters
  ChildProfile? get currentChild => _currentChild;
  List<Vaccine> get vaccines => _vaccines;
  List<Appointment> get appointments => _appointments;

  // Get upcoming appointment
  Appointment? get upcomingAppointment {
    final upcoming = _appointments
        .where((apt) => apt.isUpcoming || apt.isToday)
        .toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return upcoming.isNotEmpty ? upcoming.first : null;
  }

  // Get vaccines with progress
  List<Map<String, dynamic>> get vaccinesWithProgress {
    return _vaccines.map((vaccine) {
      return {
        'vaccine': vaccine,
        'percentage': vaccine.completionPercentage,
        'completed': vaccine.completedDoses,
        'total': vaccine.totalDoses,
      };
    }).toList();
  }

  // Get upcoming doses
  List<Map<String, dynamic>> get upcomingDoses {
    if (_currentChild == null) return [];
    return SampleDataService.getUpcomingDoses(_vaccines, _currentChild!);
  }

  // Initialize with sample data
  void loadSampleData() {
    _currentChild = SampleDataService.getSampleChild();
    _vaccines = SampleDataService.getVaccinesForChild(_currentChild!);
    _appointments = SampleDataService.getSampleAppointments();
    notifyListeners();
  }

  // Update vaccine dose
  void updateVaccineDose({
    required String vaccineId,
    required String doseId,
    required bool isAdministered,
    DateTime? administeredDate,
    String? administeredBy,
    String? batchNumber,
    String? notes,
  }) {
    final vaccineIndex = _vaccines.indexWhere((v) => v.id == vaccineId);
    if (vaccineIndex == -1) return;

    final vaccine = _vaccines[vaccineIndex];
    final doseIndex = vaccine.doses.indexWhere((d) => d.id == doseId);
    if (doseIndex == -1) return;

    final updatedDose = vaccine.doses[doseIndex].copyWith(
      isAdministered: isAdministered,
      administeredDate: administeredDate,
      administeredBy: administeredBy,
      batchNumber: batchNumber,
      notes: notes,
    );

    final updatedDoses = List<VaccineDose>.from(vaccine.doses);
    updatedDoses[doseIndex] = updatedDose;

    _vaccines[vaccineIndex] = vaccine.copyWith(doses: updatedDoses);
    notifyListeners();
  }

  // Get vaccine by ID
  Vaccine? getVaccineById(String id) {
    try {
      return _vaccines.firstWhere((v) => v.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get vaccine by short name
  Vaccine? getVaccineByShortName(String shortName) {
    try {
      return _vaccines.firstWhere((v) => v.shortName == shortName);
    } catch (e) {
      return null;
    }
  }
}
