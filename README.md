# TrackMyShots

A Flutter application for tracking child immunization schedules and maintaining vaccination records.

## 🎯 Features

- **Immunization Schedule Management**: Track multiple vaccines (Rotavirus, Hepatitis B, DTP, Hib, PCV)
- **Progress Tracking**: Visual progress indicators showing completion percentage for each vaccine
- **Smart Reminders & Notifications**: Automated alerts for upcoming doses and past vaccinations
- **Educational Resources**: Information about vaccine purposes, side effects, and importance of adherence
- **Multilingual Support**: Available in Spanish, French, German, and Italian
- **Doctor Appointments**: Integration with healthcare providers and visit history
- **Profile Management**: Child profile management with PRO upgrade options

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>= 3.0.0)
- Dart SDK (>= 3.0.0)
- Android Studio / VS Code with Flutter extensions

### Installation

1. Navigate to the project directory:
```bash
cd /Users/kevinafenyo/Documents/GitHub/trackmyshots
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## 📱 Screens

1. **Splash Screen** - App loading and branding
2. **Home Screen** - Dashboard with appointments and quick vaccine access
3. **Tracking Screen** - Immunization schedule and progress monitoring
4. **Reminders Screen** - Notifications for upcoming and completed vaccinations
5. **Profile Screen** - User settings, PRO upgrade, and app preferences
6. **Educational Resources** - Information about vaccines and immunization
7. **Multilingual Screen** - Language selection
8. **Progress & Feedback** - Detailed vaccination progress tracking

## 🎨 Color Scheme

- **Primary Dark**: #003D6B (Dark navy blue)
- **Primary Blue**: #0066B3 (Medium blue)
- **Primary Light**: #4AA5D9 (Light blue)
- **Accent Cyan**: #6DD4D4 (Cyan accent)
- **Background Light**: #F5F9FC (Light blue-gray)

## 📂 Project Structure

```
trackmyshots/
├── lib/
│   ├── main.dart
│   ├── screens/          # All screen widgets
│   ├── models/           # Data models  
│   ├── services/         # Business logic
│   ├── theme/            # App theme & styling
│   ├── widgets/          # Reusable widgets
│   └── utils/            # Utility functions
├── assets/
│   ├── images/           # Image assets
│   └── fonts/            # Font files
├── test/                 # Tests
└── pubspec.yaml          # Dependencies
```

## 🛠️ Built With

- **Flutter** - UI framework
- **Provider** - State management
- **SharedPreferences** - Local storage
- **Flutter Local Notifications** - Push notifications
- **FL Chart** - Charts and graphs
- **Percent Indicator** - Progress indicators

## 📝 TODO

- [ ] Implement vaccine schedule calculations
- [ ] Add notification scheduling
- [ ] Create analytics charts
- [ ] Implement localization (i18n)
- [ ] Add user authentication
- [ ] Implement PRO features
- [ ] Create custom app logo
- [ ] Add unit and widget tests

## 📄 License

[Add your license here]

## 👥 Contact

[Add contact information]

---

**Created**: December 2024  
**Framework**: Flutter 3.x  
**Status**: Foundation Complete - Ready for Development
