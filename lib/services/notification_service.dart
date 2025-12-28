import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/foundation.dart';
import 'package:trackmyshots/utils/global_keys.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  String? _pendingPayload;

  String? get pendingPayload {
    final payload = _pendingPayload;
    _pendingPayload = null; // Consume the payload
    return payload;
  }

  Future<void> initialize() async {
    if (_isInitialized) return;

    tz.initializeTimeZones();

    // Android initialization
    // We use the app icon (mipmap/ic_launcher)
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification: (id, title, body, payload) async {
        // Handle iOS 9 and below (not really needed for modern Flutter)
      },
    );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap
        if (response.payload != null) {
          if (kDebugMode) {
            print('Notification tapped: ${response.payload}');
          }
          
          final parts = response.payload!.split('|');
          if (parts.isNotEmpty) {
            final type = parts[0];
            final id = parts.length > 1 ? parts[1] : null;
            
            if (type == 'appointment' && id != null) {
              navigatorKey.currentState?.pushNamed(
                '/appointment-detail',
                arguments: id,
              );
            } else if (type == 'vaccine') {
              // For vaccines, we go to tracking screen
              // We could potentially highlight the specific vaccine if we passed that as arg
              navigatorKey.currentState?.pushNamed(
                '/tracking',
                arguments: id, // Optional: pass ID if tracking screen supports it
              );
            } else {
              // Default fallback
              navigatorKey.currentState?.pushNamed('/tracking');
            }
          }
        }
      },
    );

    // Check if app was launched by notification
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    
    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      _pendingPayload = notificationAppLaunchDetails?.notificationResponse?.payload;
    }

    _isInitialized = true;
  }

  Future<bool> requestPermissions() async {
    bool? result;
    
    // Android 13+
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
            
    if (androidImplementation != null) {
      result = await androidImplementation.requestNotificationsPermission();
    }

    // iOS
    final IOSFlutterLocalNotificationsPlugin? iOSImplementation =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();
            
    if (iOSImplementation != null) {
      result = await iOSImplementation.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
    
    return result ?? false;
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    if (!_isInitialized) await initialize();

    // Ensure scheduled date is in the future
    if (scheduledDate.isBefore(DateTime.now())) {
      if (kDebugMode) {
        print('Skipping notification for past date: $scheduledDate');
      }
      return;
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'vaccine_reminders',
          'Vaccine Reminders',
          channelDescription: 'Reminders for upcoming vaccinations',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
