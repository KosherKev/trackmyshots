import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:trackmyshots/models/models.dart';
import 'package:trackmyshots/services/sample_data_service.dart';
import 'package:trackmyshots/services/storage_service.dart';
import 'package:trackmyshots/services/notification_service.dart';
import 'package:trackmyshots/services/backup_service.dart';
import 'package:share_plus/share_plus.dart';

class AppState extends ChangeNotifier {
  final StorageService _storage = StorageService();
  final NotificationService _notificationService = NotificationService();
  
  List<ChildProfile> _children = [];
  String? _selectedChildId;
  List<Vaccine> _vaccines = [];
  List<Appointment> _appointments = [];
  bool _notificationsEnabled = true;
  bool _isLoading = false;

  // Getters
  List<ChildProfile> get children => _children;
  String? get selectedChildId => _selectedChildId;
  
  ChildProfile? get currentChild {
    if (_selectedChildId == null || _children.isEmpty) return null;
    try {
      return _children.firstWhere((c) => c.id == _selectedChildId);
    } catch (e) {
      return _children.isNotEmpty ? _children.first : null;
    }
  }

  bool get hasChildren => _children.isNotEmpty;

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
    final child = currentChild;
    if (child == null) return [];
    return SampleDataService.getUpcomingDoses(_vaccines, child);
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
      
      // 1. Load all children
      _children = await _storage.loadChildren();
      
      // 2. Check for legacy single-child data if no children found
      if (_children.isEmpty) {
        final legacyChild = await _storage.loadChildProfile();
        if (legacyChild != null) {
          print('Migrating legacy child profile...');
          // Migrate legacy child
          _children.add(legacyChild);
          await _storage.saveChildren(_children);
          
          // Migrate legacy vaccines/appointments to child-scoped storage
          final legacyVaccines = await _storage.loadVaccines(); // Loads from _keyVaccines
          if (legacyVaccines != null) {
            await _storage.saveVaccines(legacyVaccines, childId: legacyChild.id);
          }
          
          final legacyAppointments = await _storage.loadAppointments(); // Loads from _keyAppointments
          if (legacyAppointments != null) {
            await _storage.saveAppointments(legacyAppointments, childId: legacyChild.id);
          }
          
          // Set selection
          _selectedChildId = legacyChild.id;
          await _storage.saveSelectedChildId(_selectedChildId);
          
          // Clear legacy keys to finish migration
          await _storage.clearLegacyData();
        }
      } else {
        // 3. Load selection
        _selectedChildId = await _storage.loadSelectedChildId();
        
        // Auto-select first child if selection is invalid/missing
        if (_selectedChildId == null && _children.isNotEmpty) {
          _selectedChildId = _children.first.id;
          await _storage.saveSelectedChildId(_selectedChildId);
        }
      }

      // 4. Load data for the selected child
      if (_selectedChildId != null) {
        await _loadChildData(_selectedChildId!);
      }
      
    } catch (e) {
      print('Error initializing app: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load vaccines and appointments for a specific child
  Future<void> _loadChildData(String childId) async {
    _vaccines = await _storage.loadVaccines(childId: childId) ?? [];
    _appointments = await _storage.loadAppointments(childId: childId) ?? [];
    
    // Safety check: if vaccines are empty for a child (e.g. fresh migration failure or corruption),
    // regenerate them from sample data.
    if (_vaccines.isEmpty) {
       final child = _children.firstWhere((c) => c.id == childId);
       _vaccines = SampleDataService.generateScheduleForChild(child);
       await _storage.saveVaccines(_vaccines, childId: childId);
    }
  }

  // Add a new child (Onboarding or Settings)
  Future<void> addChild(ChildProfile child) async {
    _children.add(child);
    await _storage.saveChildren(_children);
    
    // Generate initial schedule
    final initialVaccines = SampleDataService.generateScheduleForChild(child);
    await _storage.saveVaccines(initialVaccines, childId: child.id);
    await _storage.saveAppointments([], childId: child.id); // Empty appointments
    
    // Switch to new child
    await selectChild(child.id);
  }

  // Switch active child
  Future<void> selectChild(String childId) async {
    if (_selectedChildId == childId) return;
    
    _isLoading = true;
    notifyListeners();
    
    _selectedChildId = childId;
    await _storage.saveSelectedChildId(childId);
    await _loadChildData(childId);
    
    _isLoading = false;
    notifyListeners();
    
    // Refresh notifications for the new child context
    await refreshReminders(); 
  }

  // Complete onboarding (Legacy method signature kept for compatibility, adapted behavior)
  Future<void> completeOnboarding(ChildProfile child) async {
    // In multi-profile, this is essentially adding the first child
    await addChild(child);
    
    if (_notificationsEnabled) {
      await _notificationService.requestPermissions();
      await refreshReminders();
    }
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
    if (_selectedChildId == null) return;
    
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

    // Check for cascading updates if administered
    if (isAdministered == true && administeredDate != null) {
      final cascadedVaccine = _cascadeScheduleUpdates(updatedVaccine, doseIndex, administeredDate);
      _vaccines[vaccineIndex] = cascadedVaccine;
    } else {
      _vaccines[vaccineIndex] = updatedVaccine;
    }

    notifyListeners();
    await _storage.saveVaccines(_vaccines, childId: _selectedChildId);
    await refreshReminders();
  }

  // Helper to cascade schedule updates
  Vaccine _cascadeScheduleUpdates(Vaccine vaccine, int administeredDoseIndex, DateTime administeredDate) {
    var updatedDoses = List<VaccineDose>.from(vaccine.doses);
    
    // We start checking from the next dose
    DateTime lastDate = administeredDate;
    
    for (int i = administeredDoseIndex + 1; i < updatedDoses.length; i++) {
      final currentDose = updatedDoses[i];
      final previousDose = updatedDoses[i - 1]; // This is safe because we start at index + 1
      
      // Calculate the minimum interval in weeks based on the standard schedule
      // We assume the standard gap is the difference in 'ageInWeeks'
      final int minIntervalWeeks = currentDose.ageInWeeks - previousDose.ageInWeeks;
      
      // If minInterval is 0 or negative (shouldn't happen in standard schedule), default to 4 weeks
      final int effectiveIntervalWeeks = minIntervalWeeks > 0 ? minIntervalWeeks : 4;
      
      // Calculate the minimum allowed date for this dose
      final minScheduledDate = lastDate.add(Duration(days: effectiveIntervalWeeks * 7));
      
      // If the current scheduled date is BEFORE the minimum allowed date, shift it
      // Or if it's already administered, we don't change it (historical record)
      if (!currentDose.isAdministered) {
        if (currentDose.scheduledDate == null || currentDose.scheduledDate!.isBefore(minScheduledDate)) {
          // Shift the schedule
          updatedDoses[i] = currentDose.copyWith(
            scheduledDate: minScheduledDate,
            notes: (currentDose.notes ?? '') + '\n[Auto-Rescheduled due to late previous dose]',
          );
        }
      }
      
      // Update lastDate for the next iteration
      // If this dose is already administered, use its administered date
      // If not, use its (potentially new) scheduled date
      if (updatedDoses[i].isAdministered && updatedDoses[i].administeredDate != null) {
        lastDate = updatedDoses[i].administeredDate!;
      } else if (updatedDoses[i].scheduledDate != null) {
        lastDate = updatedDoses[i].scheduledDate!;
      }
    }
    
    return vaccine.copyWith(doses: updatedDoses);
  }

  // Batch update doses (e.g. from Schedule Confirmation)
  Future<void> batchUpdateDoses(List<Map<String, dynamic>> updates) async {
    if (_selectedChildId == null) return;
    
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
      await _storage.saveVaccines(_vaccines, childId: _selectedChildId);
      await refreshReminders();
    }
  }

  // Load from storage (Internal helper, kept for structure but mostly handled in initialize now)
  Future<void> _loadFromStorage() async {
    // This is now redundant given initialize() logic, but kept empty or logic moved
    // Logic moved to initialize()
  }

  // Save to storage
  Future<void> _saveToStorage() async {
    if (_selectedChildId != null) {
      await _storage.saveVaccines(_vaccines, childId: _selectedChildId);
      await _storage.saveAppointments(_appointments, childId: _selectedChildId);
    }
  }

  // Update child profile
  Future<void> updateChildProfile(ChildProfile child) async {
    final index = _children.indexWhere((c) => c.id == child.id);
    if (index >= 0) {
      _children[index] = child;
      await _storage.saveChildren(_children);
      notifyListeners();
    }
  }

  // Add appointment
  Future<void> addAppointment(Appointment appointment) async {
    if (_selectedChildId == null) return;
    _appointments.add(appointment);
    notifyListeners();
    await _storage.saveAppointments(_appointments, childId: _selectedChildId);
    await refreshReminders();
  }

  // Update appointment
  Future<void> updateAppointment(Appointment appointment) async {
    if (_selectedChildId == null) return;
    final index = _appointments.indexWhere((a) => a.id == appointment.id);
    if (index != -1) {
      _appointments[index] = appointment;
      notifyListeners();
      await _storage.saveAppointments(_appointments, childId: _selectedChildId);
    }
  }

  // Delete appointment
  Future<void> deleteAppointment(String appointmentId) async {
    if (_selectedChildId == null) return;
    _appointments.removeWhere((a) => a.id == appointmentId);
    notifyListeners();
    await _storage.saveAppointments(_appointments, childId: _selectedChildId);
    await refreshReminders();
  }

  // Toggle notifications
  Future<void> toggleNotifications(bool enabled) async {
    _notificationsEnabled = enabled;
    notifyListeners();
    await _storage.saveSettings({
      'notificationsEnabled': enabled,
    });
    if (enabled) {
      await refreshReminders();
    } else {
      await _notificationService.cancelAllNotifications();
    }
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

  // Export encrypted data
  Future<void> exportEncryptedData(String password) async {
    final jsonString = await _storage.exportData();
    if (jsonString != null) {
      final file = await BackupService.createEncryptedBackup(
        jsonData: jsonString,
        password: password,
      );
      // Use share_plus to export
      await Share.shareXFiles(
        [XFile(file.path)], 
        text: 'TrackMyShots Encrypted Backup',
        subject: 'TrackMyShots Backup',
      );
    }
  }

  // Import data
  Future<bool> importData(String jsonString) async {
    final success = await _storage.importData(jsonString);
    if (success) {
      await initialize(); // Re-initialize to reload data
    }
    return success;
  }

  // Import encrypted data
  Future<bool> importEncryptedData(File file, String password) async {
    try {
      final content = await file.readAsString();
      final jsonString = BackupService.decryptBackup(
        fileContent: content,
        password: password,
      );
      return await importData(jsonString);
    } catch (e) {
      rethrow;
    }
  }

  // Reset to sample data (Debug only)
  Future<void> resetToSampleData() async {
    await _storage.clearAllData();
    // Re-initialize effectively
    _children = [];
    _selectedChildId = null;
    _vaccines = [];
    _appointments = [];
    notifyListeners();
  }

  // Clear all data
  Future<void> clearAllData() async {
    await _storage.clearAllData();
    _children = [];
    _selectedChildId = null;
    _vaccines = [];
    _appointments = [];
    _notificationsEnabled = true;
    notifyListeners();
  }

  // Schedule all reminders (Public Refresh Method)
  Future<void> refreshReminders() async {
    if (!_notificationsEnabled) {
      await _notificationService.cancelAllNotifications();
      return;
    }
    
    await _notificationService.cancelAllNotifications();
    
    // 1. Identify doses linked to upcoming appointments
    final Set<String> linkedDoseIds = {};
    for (final apt in _appointments) {
      if (apt.status != AppointmentStatus.cancelled && 
          apt.status != AppointmentStatus.completed &&
          apt.status != AppointmentStatus.noShow) {
            
        for (final link in apt.linkedVaccines) {
          linkedDoseIds.add('${link.vaccineId}|${link.doseId}');
        }
        
        // Schedule Appointment Reminders
        await _scheduleAppointmentReminders(apt);
      }
    }
    
    // 2. Schedule Vaccine Due Reminders (for those NOT linked)
    for (final vaccine in _vaccines) {
       for (final dose in vaccine.doses) {
         final key = '${vaccine.id}|${dose.id}';
         
         if (!dose.isAdministered && dose.scheduledDate != null && !linkedDoseIds.contains(key)) {
           await _scheduleVaccineReminders(vaccine, dose);
         }
       }
     }
  }

  // Schedule reminders for a specific appointment
  Future<void> _scheduleAppointmentReminders(Appointment apt) async {
    if (apt.dateTime.isBefore(DateTime.now())) return;

    // 24 Hours Before
    final remind24h = apt.dateTime.subtract(const Duration(hours: 24));
    if (remind24h.isAfter(DateTime.now())) {
      await _notificationService.scheduleNotification(
        id: _generateNotificationId('${apt.id}_24h'),
        title: 'Upcoming Appointment',
        body: 'Appointment with ${apt.doctorName} tomorrow at ${apt.formattedTime}.',
        scheduledDate: remind24h,
        payload: 'appointment|${apt.id}',
      );
    }

    // 2 Hours Before
    final remind2h = apt.dateTime.subtract(const Duration(hours: 2));
    if (remind2h.isAfter(DateTime.now())) {
      await _notificationService.scheduleNotification(
        id: _generateNotificationId('${apt.id}_2h'),
        title: 'Appointment Soon',
        body: 'You have an appointment in 2 hours with ${apt.doctorName}.',
        scheduledDate: remind2h,
        payload: 'appointment|${apt.id}',
      );
    }
  }

  // Schedule reminders for a specific vaccine dose
  Future<void> _scheduleVaccineReminders(Vaccine vaccine, VaccineDose dose) async {
    if (dose.scheduledDate == null) return;
    
    final scheduledDate = dose.scheduledDate!;
    
    // 7 Days Before
    final remind7d = scheduledDate.subtract(const Duration(days: 7));
    // Set to 9 AM
    final remind7dTime = DateTime(remind7d.year, remind7d.month, remind7d.day, 9, 0);
    
    if (remind7dTime.isAfter(DateTime.now())) {
      await _notificationService.scheduleNotification(
        id: _generateNotificationId('${dose.id}_7d'),
        title: 'Upcoming Vaccination',
        body: '${vaccine.name} (Dose ${dose.doseNumber}) is due next week.',
        scheduledDate: remind7dTime,
        payload: 'vaccine|${vaccine.id}',
      );
    }
    
    // 1 Day Before
    final remind1d = scheduledDate.subtract(const Duration(days: 1));
    // Set to 9 AM
    final remind1dTime = DateTime(remind1d.year, remind1d.month, remind1d.day, 9, 0);
    
    if (remind1dTime.isAfter(DateTime.now())) {
      await _notificationService.scheduleNotification(
        id: _generateNotificationId('${dose.id}_1d'),
        title: 'Vaccination Due Tomorrow',
        body: '${vaccine.name} (Dose ${dose.doseNumber}) is due tomorrow. Book an appointment!',
        scheduledDate: remind1dTime,
        payload: 'vaccine|${vaccine.id}',
      );
    }

    // 1 Week Overdue
    final overdue1w = scheduledDate.add(const Duration(days: 7));
    // Set to 9 AM
    final overdue1wTime = DateTime(overdue1w.year, overdue1w.month, overdue1w.day, 9, 0);

    if (overdue1wTime.isAfter(DateTime.now())) {
      await _notificationService.scheduleNotification(
        id: _generateNotificationId('${dose.id}_overdue_1w'),
        title: 'Vaccination Overdue',
        body: 'Action Needed: ${vaccine.name} (Dose ${dose.doseNumber}) was due a week ago. Schedule now.',
        scheduledDate: overdue1wTime,
        payload: 'vaccine|${vaccine.id}',
      );
    }
  }
  
  int _generateNotificationId(String key) {
    return key.hashCode;
  }
}
