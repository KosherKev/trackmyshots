import 'package:flutter/foundation.dart';
import 'package:trackmyshots/models/models.dart';
import 'package:trackmyshots/services/sample_data_service.dart';
import 'package:trackmyshots/services/storage_service.dart';
import 'package:trackmyshots/services/notification_service.dart';

class AppState extends ChangeNotifier {
  final StorageService _storage = StorageService();
  final NotificationService _notificationService = NotificationService();
  
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
      await _notificationService.initialize();
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
    
    if (_notificationsEnabled) {
      // Request permissions first time
      await _notificationService.requestPermissions();
      await _scheduleAllReminders();
    }
    
    notifyListeners();
    await _saveToStorage();
  }

  // Update a specific vaccine dose
  Future<void> updateVaccineDose(String vaccineId, String doseId, {
    bool? isAdministered,
    DateTime? administeredDate,
    DateTime? scheduledDate,
    String? notes,
    String? batchNumber,
    String? administeredBy,
  }) async {
    final vaccineIndex = _vaccines.indexWhere((v) => v.id == vaccineId);
    if (vaccineIndex == -1) return;

    final vaccine = _vaccines[vaccineIndex];
    final doseIndex = vaccine.doses.indexWhere((d) => d.id == doseId);
    if (doseIndex == -1) return;

    final currentDose = vaccine.doses[doseIndex];
    final updatedDose = currentDose.copyWith(
      isAdministered: isAdministered,
      administeredDate: administeredDate,
      scheduledDate: scheduledDate,
      notes: notes,
      batchNumber: batchNumber,
      administeredBy: administeredBy,
    );

    final updatedDoses = List<VaccineDose>.from(vaccine.doses);
    updatedDoses[doseIndex] = updatedDose;

    final updatedVaccine = vaccine.copyWith(doses: updatedDoses);
    _vaccines[vaccineIndex] = updatedVaccine;

    notifyListeners();
    await _storage.saveVaccines(_vaccines);
  }

  // Batch update doses (e.g. from Schedule Confirmation)
  Future<void> batchUpdateDoses(List<Map<String, dynamic>> updates) async {
    bool hasChanges = false;

    for (final update in updates) {
      final vaccineId = update['vaccineId'] as String;
      final doseId = update['doseId'] as String;
      
      final vaccineIndex = _vaccines.indexWhere((v) => v.id == vaccineId);
      if (vaccineIndex == -1) continue;

      final vaccine = _vaccines[vaccineIndex];
      final doseIndex = vaccine.doses.indexWhere((d) => d.id == doseId);
      if (doseIndex == -1) continue;

      final currentDose = vaccine.doses[doseIndex];
      final updatedDose = currentDose.copyWith(
        isAdministered: update['isAdministered'] as bool?,
        administeredDate: update['administeredDate'] as DateTime?,
      );

      final updatedDoses = List<VaccineDose>.from(vaccine.doses);
      updatedDoses[doseIndex] = updatedDose;

      final updatedVaccine = vaccine.copyWith(doses: updatedDoses);
      _vaccines[vaccineIndex] = updatedVaccine;
      hasChanges = true;
    }

    if (hasChanges) {
      notifyListeners();
      await _storage.saveVaccines(_vaccines);
    }
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

  // Schedule all reminders
  Future<void> _scheduleAllReminders() async {
    if (!_notificationsEnabled) return;
    
    await _notificationService.cancelAllNotifications();
    
    for (final vaccine in _vaccines) {
       for (final dose in vaccine.doses) {
         if (!dose.isAdministered && dose.scheduledDate != null) {
           await _scheduleReminderForDose(vaccine, dose);
         }
       }
     }
   }
 
   // Update reminder for a specific dose
   Future<void> _updateReminderForDose(Vaccine vaccine, VaccineDose dose) async {
     final notificationId = dose.id.hashCode;
     await _notificationService.cancelNotification(notificationId);
     
     if (!dose.isAdministered && dose.scheduledDate != null && _notificationsEnabled) {
       await _scheduleReminderForDose(vaccine, dose);
     }
   }

  // Schedule reminder for a dose
  Future<void> _scheduleReminderForDose(Vaccine vaccine, VaccineDose dose) async {
    if (dose.scheduledDate == null) return;
    
    final notificationId = dose.id.hashCode;
    final scheduledDate = dose.scheduledDate!;
    
    // Remind 1 day before at 9:00 AM
    final reminderDate = DateTime(
      scheduledDate.year,
      scheduledDate.month,
      scheduledDate.day,
      9, // 9 AM
      0,
    ).subtract(const Duration(days: 1));
        
    // Only schedule if in future
    if (reminderDate.isAfter(DateTime.now())) {
      await _notificationService.scheduleNotification(
        id: notificationId,
        title: 'Upcoming Vaccination',
        body: '${vaccine.name} (Dose ${dose.doseNumber}) is due tomorrow.',
        scheduledDate: reminderDate,
        payload: '${vaccine.id}|${dose.id}',
      );
    }
  }
}
