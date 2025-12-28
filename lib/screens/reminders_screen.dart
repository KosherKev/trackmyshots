import 'package:flutter/material.dart';
import 'package:trackmyshots/widgets/standard_card.dart';
import 'package:trackmyshots/services/notification_service.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  // int _currentIndex = 4; // Managed by MainScreen

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back, color: Colors.black),
        //   onPressed: () => Navigator.pop(context),
        // ),
        title: const Text(
          'Reminders & Notifications',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {
              // Already on reminders screen
            },
          ),
        ],
      ),
      body: StandardScreenContainer(
        children: [
          // Title
          const SizedBox(height: 20),
          const Text(
            'Reminders &\nNotifications',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 32),
          
          // Reminder Cards
          StandardCard(
            text: 'PCV dose scheduled 23rd June',
            centerText: true,
          ),
          StandardCard(
            text: 'Hib dose was given on 15th July',
            centerText: true,
          ),
          StandardCard(
            text: 'Learn about potential side effects',
            centerText: true,
          ),
          StandardCard(
            text: 'Rotavirus will be given in 5 weeks time',
            centerText: true,
          ),

          const SizedBox(height: 32),
          const Text(
            'Developer Tools',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              await NotificationService().scheduleNotification(
                id: 999,
                title: 'Test Appointment Reminder',
                body: 'Tap to see appointment details',
                scheduledDate: DateTime.now().add(const Duration(seconds: 5)),
                payload: 'appointment|test_id',
              );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Notification scheduled in 5 seconds')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            child: const Text('Test Appointment Notification (5s)', style: TextStyle(color: Colors.black)),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () async {
              await NotificationService().scheduleNotification(
                id: 998,
                title: 'Test Overdue Reminder',
                body: 'Action Needed: Polio is overdue. Schedule now.',
                scheduledDate: DateTime.now().add(const Duration(seconds: 5)),
                payload: 'vaccine|test_id',
              );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Overdue Notification scheduled in 5 seconds')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Test Overdue Notification (5s)', style: TextStyle(color: Colors.white)),
          ),
          
          const SizedBox(height: 100), // Space for bottom nav
        ],
      ),
    );
  }
}
