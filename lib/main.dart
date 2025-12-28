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
import 'package:trackmyshots/screens/onboarding_welcome_screen.dart';
import 'package:trackmyshots/screens/child_information_screen.dart';
import 'package:trackmyshots/screens/schedule_confirmation_screen.dart';
import 'package:trackmyshots/screens/appointment_detail_screen.dart';
import 'package:trackmyshots/utils/global_keys.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState()..initialize(),
      child: const TrackMyShotsApp(),
    ),
  );
}

class TrackMyShotsApp extends StatelessWidget {
  const TrackMyShotsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
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
        '/onboarding': (context) => const OnboardingWelcomeScreen(),
        '/child-info': (context) => const ChildInformationScreen(),
        '/schedule-confirmation': (context) => const ScheduleConfirmationScreen(),
        '/appointment-detail': (context) {
          final appointmentId = ModalRoute.of(context)!.settings.arguments as String;
          final appState = Provider.of<AppState>(context, listen: false);
          try {
            final appointment = appState.appointments.firstWhere((a) => a.id == appointmentId);
            return AppointmentDetailScreen(appointment: appointment);
          } catch (e) {
            // Fallback if appointment not found (e.g. deleted)
            return const HomeScreen();
          }
        },
      },
    );
  }
}
