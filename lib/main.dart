import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackmyshots/theme/app_theme.dart';
import 'package:trackmyshots/services/app_state.dart';
import 'package:trackmyshots/screens/splash_screen.dart';
import 'package:trackmyshots/screens/home_screen.dart';
import 'package:trackmyshots/screens/tracking_screen.dart';
import 'package:trackmyshots/screens/reminders_screen.dart';
import 'package:trackmyshots/screens/profile_screen.dart';
import 'package:trackmyshots/screens/educational_resources_screen.dart';
import 'package:trackmyshots/screens/multilingual_screen.dart';
import 'package:trackmyshots/screens/progress_feedback_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState()..loadSampleData(),
      child: const TrackMyShotsApp(),
    ),
  );
}

class TrackMyShotsApp extends StatelessWidget {
  const TrackMyShotsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TrackMyShots',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
        '/tracking': (context) => const TrackingScreen(),
        '/reminders': (context) => const RemindersScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/educational': (context) => const EducationalResourcesScreen(),
        '/multilingual': (context) => const MultilingualScreen(),
        '/progress': (context) => const ProgressFeedbackScreen(),
      },
    );
  }
}
