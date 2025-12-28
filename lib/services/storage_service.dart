import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackmyshots/models/models.dart';

class StorageService {
  static const String _keyChild = 'child_profile'; // Legacy
  static const String _keyChildren = 'children_profiles'; // New
  static const String _keySelectedChildId = 'selected_child_id'; // New
  static const String _keyVaccines = 'vaccines'; // Legacy
  static const String _keyAppointments = 'appointments'; // Legacy
  static const String _keySettings = 'app_settings';

  // Save children profiles
  Future<bool> saveChildren(List<ChildProfile> children) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = children.map((c) => c.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      return await prefs.setString(_keyChildren, jsonString);
    } catch (e) {
      print('Error saving children profiles: $e');
      return false;
    }
  }

  // Load children profiles
  Future<List<ChildProfile>> loadChildren() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_keyChildren);
      if (jsonString == null) return [];
      
      final jsonList = jsonDecode(jsonString) as List;
      return jsonList.map((json) => ChildProfile.fromJson(json)).toList();
    } catch (e) {
      print('Error loading children profiles: $e');
      return [];
    }
  }

  // Save selected child ID
  Future<bool> saveSelectedChildId(String? childId) async {
    final prefs = await SharedPreferences.getInstance();
    if (childId == null) {
      return await prefs.remove(_keySelectedChildId);
    }
    return await prefs.setString(_keySelectedChildId, childId);
  }

  // Load selected child ID
  Future<String?> loadSelectedChildId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keySelectedChildId);
  }

  // Save child profile (Legacy support / Single update helper)
  Future<bool> saveChildProfile(ChildProfile child) async {
    // For backward compatibility or single updates, we'll update the list
    final children = await loadChildren();
    final index = children.indexWhere((c) => c.id == child.id);
    if (index >= 0) {
      children[index] = child;
    } else {
      children.add(child);
    }
    return await saveChildren(children);
  }

  // Load child profile (Legacy support)
  Future<ChildProfile?> loadChildProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // First try legacy key
      final jsonString = prefs.getString(_keyChild);
      if (jsonString != null) {
        final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
        return ChildProfile.fromJson(jsonMap);
      }
      // Fallback to selected child from list
      final selectedId = await loadSelectedChildId();
      if (selectedId == null) return null;
      final children = await loadChildren();
      return children.firstWhere((c) => c.id == selectedId);
    } catch (e) {
      print('Error loading child profile: $e');
      return null;
    }
  }

  // Clear legacy data
  Future<void> clearLegacyData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyChild);
    await prefs.remove(_keyVaccines);
    await prefs.remove(_keyAppointments);
  }

  // Save vaccines (Scoped by Child ID)
  Future<bool> saveVaccines(List<Vaccine> vaccines, {String? childId}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = childId != null ? 'vaccines_$childId' : _keyVaccines;
      
      final jsonList = vaccines.map((v) => v.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      return await prefs.setString(key, jsonString);
    } catch (e) {
      print('Error saving vaccines: $e');
      return false;
    }
  }

  // Load vaccines (Scoped by Child ID)
  Future<List<Vaccine>?> loadVaccines({String? childId}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Try child-specific key first, then fallback to legacy/global if childId is null
      String key = childId != null ? 'vaccines_$childId' : _keyVaccines;
      
      // If specific key doesn't exist and we asked for a specific child, 
      // check if we are in a migration state (maybe legacy key holds this child's data?)
      // For now, simple key lookup.
      
      final jsonString = prefs.getString(key);
      if (jsonString == null) return null;
      
      final jsonList = jsonDecode(jsonString) as List;
      return jsonList.map((json) => Vaccine.fromJson(json)).toList();
    } catch (e) {
      print('Error loading vaccines: $e');
      return null;
    }
  }

  // Save appointments (Scoped by Child ID)
  Future<bool> saveAppointments(List<Appointment> appointments, {String? childId}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = childId != null ? 'appointments_$childId' : _keyAppointments;

      final jsonList = appointments.map((a) => a.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      return await prefs.setString(key, jsonString);
    } catch (e) {
      print('Error saving appointments: $e');
      return false;
    }
  }

  // Load appointments (Scoped by Child ID)
  Future<List<Appointment>?> loadAppointments({String? childId}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = childId != null ? 'appointments_$childId' : _keyAppointments;
      
      final jsonString = prefs.getString(key);
      if (jsonString == null) return null;
      
      final jsonList = jsonDecode(jsonString) as List;
      return jsonList.map((json) => Appointment.fromJson(json)).toList();
    } catch (e) {
      print('Error loading appointments: $e');
      return null;
    }
  }

  // Save app settings
  Future<bool> saveSettings(Map<String, dynamic> settings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(settings);
      return await prefs.setString(_keySettings, jsonString);
    } catch (e) {
      print('Error saving settings: $e');
      return false;
    }
  }

  // Load app settings
  Future<Map<String, dynamic>?> loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_keySettings);
      if (jsonString == null) return null;
      
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      print('Error loading settings: $e');
      return null;
    }
  }

  // Clear all data
  Future<bool> clearAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyChild);
      await prefs.remove(_keyVaccines);
      await prefs.remove(_keyAppointments);
      await prefs.remove(_keySettings);
      return true;
    } catch (e) {
      print('Error clearing data: $e');
      return false;
    }
  }

  // Check if data exists
  Future<bool> hasData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(_keyChild) || prefs.containsKey(_keyChildren);
    } catch (e) {
      return false;
    }
  }

  // Export data as JSON string (for backup)
  Future<String?> exportData() async {
    try {
      final child = await loadChildProfile();
      final vaccines = await loadVaccines();
      final appointments = await loadAppointments();
      final settings = await loadSettings();

      final exportData = {
        'version': '1.0',
        'exportDate': DateTime.now().toIso8601String(),
        'child': child?.toJson(),
        'vaccines': vaccines?.map((v) => v.toJson()).toList(),
        'appointments': appointments?.map((a) => a.toJson()).toList(),
        'settings': settings,
      };

      return jsonEncode(exportData);
    } catch (e) {
      print('Error exporting data: $e');
      return null;
    }
  }

  // Import data from JSON string (for restore)
  Future<bool> importData(String jsonString) async {
    try {
      final data = jsonDecode(jsonString) as Map<String, dynamic>;
      
      // Import child
      if (data['child'] != null) {
        final child = ChildProfile.fromJson(data['child']);
        await saveChildProfile(child);
      }

      // Import vaccines
      if (data['vaccines'] != null) {
        final vaccines = (data['vaccines'] as List)
            .map((json) => Vaccine.fromJson(json))
            .toList();
        await saveVaccines(vaccines);
      }

      // Import appointments
      if (data['appointments'] != null) {
        final appointments = (data['appointments'] as List)
            .map((json) => Appointment.fromJson(json))
            .toList();
        await saveAppointments(appointments);
      }

      // Import settings
      if (data['settings'] != null) {
        await saveSettings(data['settings']);
      }

      return true;
    } catch (e) {
      print('Error importing data: $e');
      return false;
    }
  }
}
