import 'package:flutter/foundation.dart';
import 'package:trackmyshots/models/models.dart';
import 'package:trackmyshots/services/sample_data_service.dart';
import 'package:trackmyshots/services/storage_service.dart';

class AppState extends ChangeNotifier {
  final StorageService _storage = StorageService();
  
  ChildProfile? _currentChild;
  List<Vaccine> _vaccines = [];
  List<Appointment> _appointments = [];
  bool _notificationsEnabled = true;
  bool _isLoading = false;

  // Getters
  ChildProfile? get currentChild => _currentChild;
  List<Vaccine> get vaccines => _vaccines;
  List<Appointment> get appointments => _appointments;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get isLoading => _isLoading;

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

  // Get overall completion percentage
  double get overallCompletion {
    if (_vaccines.isEmpty) return 0;
    final totalCompletion = _vaccines.fold<double>(
      0,
      (sum, vaccine) => sum + vaccine.completionPercentage,
    );
    return totalCompletion / _vaccines.length;
  }

  // Get total doses completed
  int get totalDosesCompleted {
    return _vaccines.fold<int>(
      0,
      (sum, vaccine) => sum + vaccine.completedDoses,
    );
  }

  // Get total doses required
  int get totalDosesRequired {
    return _vaccines.fold<int>(
      0,
      (sum, vaccine) => sum + vaccine.totalDoses,
    );
  }

  // Initialize app - load from storage or use sample data
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      final hasData = await _storage.hasData();
      
      if (hasData) {
        await _loadFromStorage();
      } else {
        // Do NOT load sample data automatically for production flow
        // The UI will detect _currentChild == null and show onboarding
        // loadSampleData(); // Commented out for real flow
        // await _saveToStorage();
      }
    } catch (e) {
      print('Error initializing app: $e');
      // On error, maybe we should safe fail, but for now let's just leave it empty
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Complete onboarding
  Future<void> completeOnboarding(ChildProfile child) async {
    _currentChild = child;
    
    // Generate vaccine schedule based on child's age
    // For now, we reuse the sample data logic but this should ideally be a dedicated generator
    _vaccines = SampleDataService.generateScheduleForChild(child);
    
    // Initialize empty appointments
    _appointments = [];
    
    notifyListeners();
    await _saveToStorage();
  }

  // Load from storage
  Future<void> _loadFromStorage() async {
    final child = await _storage.loadChildProfile();
    final vaccines = await _storage.loadVaccines();
    final appointments = await _storage.loadAppointments();
    final settings = await _storage.loadSettings();

    if (child != null) _currentChild = child;
    if (vaccines != null) _vaccines = vaccines;
    if (appointments != null) _appointments = appointments;
    if (settings != null) {
      _notificationsEnabled = settings['notificationsEnabled'] ?? true;
    }

    notifyListeners();
  }

  // Save to storage
  Future<void> _saveToStorage() async {
    if (_currentChild != null) {
      await _storage.saveChildProfile(_currentChild!);
    }
    await _storage.saveVaccines(_vaccines);
    await _storage.saveAppointments(_appointments);
    await _storage.saveSettings({
      'notificationsEnabled': _notificationsEnabled,
    });
  }

  // Initialize with sample data
  void loadSampleData() {
    _currentChild = SampleDataService.getSampleChild();
    _vaccines = SampleDataService.getVaccinesForChild(_currentChild!);
    _appointments = SampleDataService.getSampleAppointments();
    notifyListeners();
  }

  // Update child profile
  Future<void> updateChildProfile(ChildProfile child) async {
    _currentChild = child;
    notifyListeners();
    await _storage.saveChildProfile(child);
  }

  // Update vaccine dose
  Future<void> updateVaccineDose({
    required String vaccineId,
    required String doseId,
    required bool isAdministered,
    DateTime? administeredDate,
    String? administeredBy,
    String? batchNumber,
    String? notes,
  }) async {
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
    await _storage.saveVaccines(_vaccines);
  }

  // Add appointment
  Future<void> addAppointment(Appointment appointment) async {
    _appointments.add(appointment);
    notifyListeners();
    await _storage.saveAppointments(_appointments);
  }

  // Update appointment
  Future<void> updateAppointment(Appointment appointment) async {
    final index = _appointments.indexWhere((a) => a.id == appointment.id);
    if (index != -1) {
      _appointments[index] = appointment;
      notifyListeners();
      await _storage.saveAppointments(_appointments);
    }
  }

  // Delete appointment
  Future<void> deleteAppointment(String appointmentId) async {
    _appointments.removeWhere((a) => a.id == appointmentId);
    notifyListeners();
    await _storage.saveAppointments(_appointments);
  }

  // Toggle notifications
  Future<void> toggleNotifications(bool enabled) async {
    _notificationsEnabled = enabled;
    notifyListeners();
    await _storage.saveSettings({
      'notificationsEnabled': enabled,
    });
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

  // Export data
  Future<String?> exportData() async {
    return await _storage.exportData();
  }

  // Import data
  Future<bool> importData(String jsonString) async {
    final success = await _storage.importData(jsonString);
    if (success) {
      await _loadFromStorage();
    }
    return success;
  }

  // Reset to sample data
  Future<void> resetToSampleData() async {
    await _storage.clearAllData();
    loadSampleData();
    await _saveToStorage();
  }

  // Clear all data
  Future<void> clearAllData() async {
    await _storage.clearAllData();
    _currentChild = null;
    _vaccines = [];
    _appointments = [];
    _notificationsEnabled = true;
    notifyListeners();
  }
}
