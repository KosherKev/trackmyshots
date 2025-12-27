import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackmyshots/models/models.dart';

class StorageService {
  static const String _keyChild = 'child_profile';
  static const String _keyVaccines = 'vaccines';
  static const String _keyAppointments = 'appointments';
  static const String _keySettings = 'app_settings';

  // Save child profile
  Future<bool> saveChildProfile(ChildProfile child) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(child.toJson());
      return await prefs.setString(_keyChild, jsonString);
    } catch (e) {
      print('Error saving child profile: $e');
      return false;
    }
  }

  // Load child profile
  Future<ChildProfile?> loadChildProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_keyChild);
      if (jsonString == null) return null;
      
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      return ChildProfile.fromJson(jsonMap);
    } catch (e) {
      print('Error loading child profile: $e');
      return null;
    }
  }

  // Save vaccines
  Future<bool> saveVaccines(List<Vaccine> vaccines) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = vaccines.map((v) => v.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      return await prefs.setString(_keyVaccines, jsonString);
    } catch (e) {
      print('Error saving vaccines: $e');
      return false;
    }
  }

  // Load vaccines
  Future<List<Vaccine>?> loadVaccines() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_keyVaccines);
      if (jsonString == null) return null;
      
      final jsonList = jsonDecode(jsonString) as List;
      return jsonList.map((json) => Vaccine.fromJson(json)).toList();
    } catch (e) {
      print('Error loading vaccines: $e');
      return null;
    }
  }

  // Save appointments
  Future<bool> saveAppointments(List<Appointment> appointments) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = appointments.map((a) => a.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      return await prefs.setString(_keyAppointments, jsonString);
    } catch (e) {
      print('Error saving appointments: $e');
      return false;
    }
  }

  // Load appointments
  Future<List<Appointment>?> loadAppointments() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_keyAppointments);
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
      return prefs.containsKey(_keyChild);
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
