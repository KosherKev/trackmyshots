# 📅 Phase 2: Vaccine Schedule Generation

## Overview
Logic for generating appropriate vaccination schedules based on child's age and country's immunization program.

---

## 🎯 Goals
1. Generate age-appropriate vaccine schedule
2. Show recommended timeframes (not hard dates)
3. Support different countries' schedules
4. Handle catch-up scenarios for older children
5. Update schedule as child ages

---

## 🧬 Vaccine Schedule Data Structure

### Core Vaccine Information
Each vaccine needs:

```dart
class VaccineScheduleTemplate {
  final String id;
  final String name;
  final String shortName;
  final String fullName;
  final String description;
  final List<DoseSchedule> doses;
  final String? notes;
  
  // Recommended age ranges
  final List<AgeRange> recommendedAges;
  
  // Which countries use this vaccine
  final List<String> countries;
}

class DoseSchedule {
  final int doseNumber;
  final AgeRange recommendedAge;
  final Duration? minimumInterval; // From previous dose
  final bool isRequired;
  final String? specialInstructions;
}

class AgeRange {
  final int minWeeks;
  final int maxWeeks;
  
  String get display {
    if (minWeeks == maxWeeks) return '${minWeeks} weeks';
    return '$minWeeks-$maxWeeks weeks';
  }
  
  // Helper: Convert to months for display
  String get displayMonths {
    final minMonths = (minWeeks / 4.33).round();
    final maxMonths = (maxWeeks / 4.33).round();
    if (minMonths == maxMonths) return '$minMonths months';
    return '$minMonths-$maxMonths months';
  }
}
```

---

## 📊 Standard Immunization Schedules

### Ghana Standard Schedule (Example)

```dart
final ghanaSchedule = [
  VaccineScheduleTemplate(
    id: 'bcg',
    name: 'BCG',
    fullName: 'Bacillus Calmette-Guérin',
    description: 'Protects against tuberculosis',
    doses: [
      DoseSchedule(
        doseNumber: 1,
        recommendedAge: AgeRange(minWeeks: 0, maxWeeks: 0), // At birth
        isRequired: true,
      ),
    ],
    recommendedAges: [AgeRange(minWeeks: 0, maxWeeks: 0)],
    countries: ['ghana', 'nigeria', 'kenya'],
  ),
  
  VaccineScheduleTemplate(
    id: 'hep_b',
    name: 'Hepatitis B',
    fullName: 'Hepatitis B Vaccine',
    description: 'Protects against hepatitis B virus',
    doses: [
      DoseSchedule(
        doseNumber: 1,
        recommendedAge: AgeRange(minWeeks: 0, maxWeeks: 0), // At birth
        isRequired: true,
      ),
      DoseSchedule(
        doseNumber: 2,
        recommendedAge: AgeRange(minWeeks: 6, maxWeeks: 8),
        minimumInterval: Duration(days: 28), // 4 weeks from dose 1
        isRequired: true,
      ),
      DoseSchedule(
        doseNumber: 3,
        recommendedAge: AgeRange(minWeeks: 14, maxWeeks: 16),
        minimumInterval: Duration(days: 56), // 8 weeks from dose 2
        isRequired: true,
      ),
    ],
    countries: ['ghana', 'universal'],
  ),
  
  VaccineScheduleTemplate(
    id: 'polio',
    name: 'Polio (OPV/IPV)',
    fullName: 'Poliomyelitis Vaccine',
    description: 'Protects against polio virus',
    doses: [
      DoseSchedule(
        doseNumber: 0,
        recommendedAge: AgeRange(minWeeks: 0, maxWeeks: 0), // Birth dose
        isRequired: true,
        specialInstructions: 'OPV given at birth',
      ),
      DoseSchedule(
        doseNumber: 1,
        recommendedAge: AgeRange(minWeeks: 6, maxWeeks: 6),
        isRequired: true,
      ),
      DoseSchedule(
        doseNumber: 2,
        recommendedAge: AgeRange(minWeeks: 10, maxWeeks: 10),
        minimumInterval: Duration(days: 28),
        isRequired: true,
      ),
      DoseSchedule(
        doseNumber: 3,
        recommendedAge: AgeRange(minWeeks: 14, maxWeeks: 14),
        minimumInterval: Duration(days: 28),
        isRequired: true,
      ),
    ],
    countries: ['ghana', 'universal'],
  ),
  
  VaccineScheduleTemplate(
    id: 'dtp',
    name: 'DTP/Pentavalent',
    fullName: 'Diphtheria, Tetanus, Pertussis',
    description: 'Protects against diphtheria, tetanus, and whooping cough',
    doses: [
      DoseSchedule(
        doseNumber: 1,
        recommendedAge: AgeRange(minWeeks: 6, maxWeeks: 6),
        isRequired: true,
      ),
      DoseSchedule(
        doseNumber: 2,
        recommendedAge: AgeRange(minWeeks: 10, maxWeeks: 10),
        minimumInterval: Duration(days: 28),
        isRequired: true,
      ),
      DoseSchedule(
        doseNumber: 3,
        recommendedAge: AgeRange(minWeeks: 14, maxWeeks: 14),
        minimumInterval: Duration(days: 28),
        isRequired: true,
      ),
    ],
    countries: ['ghana', 'universal'],
  ),
  
  VaccineScheduleTemplate(
    id: 'pcv',
    name: 'PCV',
    fullName: 'Pneumococcal Conjugate Vaccine',
    description: 'Protects against pneumococcal disease',
    doses: [
      DoseSchedule(
        doseNumber: 1,
        recommendedAge: AgeRange(minWeeks: 6, maxWeeks: 6),
        isRequired: true,
      ),
      DoseSchedule(
        doseNumber: 2,
        recommendedAge: AgeRange(minWeeks: 10, maxWeeks: 10),
        minimumInterval: Duration(days: 28),
        isRequired: true,
      ),
      DoseSchedule(
        doseNumber: 3,
        recommendedAge: AgeRange(minWeeks: 14, maxWeeks: 14),
        minimumInterval: Duration(days: 28),
        isRequired: true,
      ),
    ],
    countries: ['ghana', 'universal'],
  ),
  
  VaccineScheduleTemplate(
    id: 'rotavirus',
    name: 'Rotavirus',
    fullName: 'Rotavirus Vaccine',
    description: 'Protects against rotavirus infections',
    doses: [
      DoseSchedule(
        doseNumber: 1,
        recommendedAge: AgeRange(minWeeks: 6, maxWeeks: 6),
        isRequired: true,
      ),
      DoseSchedule(
        doseNumber: 2,
        recommendedAge: AgeRange(minWeeks: 10, maxWeeks: 10),
        minimumInterval: Duration(days: 28),
        isRequired: true,
      ),
    ],
    countries: ['ghana', 'universal'],
  ),
  
  VaccineScheduleTemplate(
    id: 'mmr',
    name: 'MMR',
    fullName: 'Measles, Mumps, Rubella',
    description: 'Protects against measles, mumps, and rubella',
    doses: [
      DoseSchedule(
        doseNumber: 1,
        recommendedAge: AgeRange(minWeeks: 39, maxWeeks: 39), // 9 months
        isRequired: true,
      ),
      DoseSchedule(
        doseNumber: 2,
        recommendedAge: AgeRange(minWeeks: 78, maxWeeks: 78), // 18 months
        minimumInterval: Duration(days: 112), // 16 weeks
        isRequired: true,
      ),
    ],
    countries: ['ghana', 'universal'],
  ),
  
  VaccineScheduleTemplate(
    id: 'yellow_fever',
    name: 'Yellow Fever',
    fullName: 'Yellow Fever Vaccine',
    description: 'Protects against yellow fever',
    doses: [
      DoseSchedule(
        doseNumber: 1,
        recommendedAge: AgeRange(minWeeks: 39, maxWeeks: 39), // 9 months
        isRequired: true,
      ),
    ],
    countries: ['ghana', 'nigeria', 'other_endemic'],
  ),
  
  VaccineScheduleTemplate(
    id: 'meningitis_a',
    name: 'Meningitis A',
    fullName: 'Meningococcal A Vaccine',
    description: 'Protects against meningitis A',
    doses: [
      DoseSchedule(
        doseNumber: 1,
        recommendedAge: AgeRange(minWeeks: 39, maxWeeks: 39), // 9 months
        isRequired: true,
      ),
    ],
    countries: ['ghana', 'meningitis_belt'],
  ),
];
```

---

## 🔄 Schedule Generation Logic

### Function: Generate Schedule for Child

```dart
class ScheduleGenerator {
  
  /// Generate vaccine schedule based on child's age and country
  static List<Vaccine> generateSchedule({
    required DateTime childDOB,
    required String country,
  }) {
    final ageInWeeks = _calculateAgeInWeeks(childDOB);
    final templates = _getScheduleTemplates(country);
    
    List<Vaccine> vaccines = [];
    
    for (var template in templates) {
      vaccines.add(_createVaccineFromTemplate(
        template: template,
        childDOB: childDOB,
        currentAgeInWeeks: ageInWeeks,
      ));
    }
    
    return vaccines;
  }
  
  /// Calculate child's age in weeks
  static int _calculateAgeInWeeks(DateTime dob) {
    final now = DateTime.now();
    final difference = now.difference(dob);
    return (difference.inDays / 7).floor();
  }
  
  /// Get schedule templates for country
  static List<VaccineScheduleTemplate> _getScheduleTemplates(String country) {
    // Filter templates by country
    // Return appropriate schedule
    
    switch (country.toLowerCase()) {
      case 'ghana':
        return ghanaSchedule;
      case 'nigeria':
        return nigeriaSchedule; // Define separately
      case 'kenya':
        return kenyaSchedule; // Define separately
      default:
        return whoStandardSchedule; // WHO recommended schedule
    }
  }
  
  /// Create Vaccine object from template
  static Vaccine _createVaccineFromTemplate({
    required VaccineScheduleTemplate template,
    required DateTime childDOB,
    required int currentAgeInWeeks,
  }) {
    List<VaccineDose> doses = [];
    
    for (var doseSchedule in template.doses) {
      doses.add(_createDose(
        doseSchedule: doseSchedule,
        childDOB: childDOB,
        currentAgeInWeeks: currentAgeInWeeks,
      ));
    }
    
    return Vaccine(
      id: template.id,
      name: template.name,
      shortName: template.shortName,
      fullName: template.fullName,
      description: template.description,
      doses: doses,
      ageGroup: _determineAgeGroup(template.recommendedAges),
    );
  }
  
  /// Create individual dose
  static VaccineDose _createDose({
    required DoseSchedule doseSchedule,
    required DateTime childDOB,
    required int currentAgeInWeeks,
  }) {
    // Calculate recommended date
    final recommendedWeeks = doseSchedule.recommendedAge.minWeeks;
    final recommendedDate = childDOB.add(Duration(days: recommendedWeeks * 7));
    
    // Determine status
    VaccineDoseStatus status;
    if (currentAgeInWeeks < doseSchedule.recommendedAge.minWeeks) {
      status = VaccineDoseStatus.pending;
    } else if (currentAgeInWeeks >= doseSchedule.recommendedAge.minWeeks &&
               currentAgeInWeeks <= doseSchedule.recommendedAge.maxWeeks) {
      status = VaccineDoseStatus.due;
    } else {
      status = VaccineDoseStatus.overdue;
    }
    
    return VaccineDose(
      doseNumber: doseSchedule.doseNumber,
      scheduledDate: recommendedDate,
      status: status,
      administeredDate: null, // Not given yet
      doctorName: null,
      batchNumber: null,
      notes: doseSchedule.specialInstructions,
      recommendedAgeRange: '${doseSchedule.recommendedAge.displayMonths}',
    );
  }
  
  /// Determine age group for vaccine
  static String _determineAgeGroup(List<AgeRange> ages) {
    if (ages.isEmpty) return 'Unknown';
    
    final minWeeks = ages.map((a) => a.minWeeks).reduce((a, b) => a < b ? a : b);
    final minMonths = (minWeeks / 4.33).round();
    
    if (minMonths == 0) return 'Birth';
    if (minMonths <= 2) return '0-2 months';
    if (minMonths <= 6) return '2-6 months';
    if (minMonths <= 12) return '6-12 months';
    if (minMonths <= 24) return '12-24 months';
    return '2+ years';
  }
}
```

---

## 🎯 Recommended vs Actual Dates

### Important Distinction:

**Recommended Age Range (Advisory):**
- "Should be given between 6-8 weeks"
- "Recommended at 9 months"
- These are EDUCATIONAL - shown in tracking screens

**Scheduled Date (Calculated):**
- App calculates a suggested date within the range
- Example: If range is 6-8 weeks, suggest 6 weeks exactly
- This is just a REFERENCE DATE for ordering
- NOT a hard appointment

**Actual Appointment Date (User-Created):**
- Only exists if user creates an appointment
- This is the REAL booking with a clinic
- Has specific time, doctor, location

---

## 🔄 Dynamic Schedule Updates

### When Child Ages:
```dart
class ScheduleUpdater {
  
  /// Update vaccine statuses based on current age
  static void updateVaccineStatuses(List<Vaccine> vaccines, DateTime childDOB) {
    final currentAgeInWeeks = _calculateAgeInWeeks(childDOB);
    
    for (var vaccine in vaccines) {
      for (var dose in vaccine.doses) {
        if (dose.administeredDate != null) continue; // Already given
        
        dose.status = _calculateDoseStatus(
          doseSchedule: dose,
          currentAgeInWeeks: currentAgeInWeeks,
        );
      }
    }
  }
}
```

**When to Update:**
- App launch (check if any new doses are now due)
- Daily background check (if notifications enabled)
- When user opens Tracking screen

---

## 📊 Catch-Up Schedule Logic

### For Older Children:

```dart
class CatchUpScheduler {
  
  /// Adjust schedule for child who is already past recommended age
  static List<Vaccine> generateCatchUpSchedule({
    required DateTime childDOB,
    required String country,
    Map<String, List<DateTime>>? alreadyGivenDoses,
  }) {
    final standardSchedule = ScheduleGenerator.generateSchedule(
      childDOB: childDOB,
      country: country,
    );
    
    final currentAgeInWeeks = _calculateAgeInWeeks(childDOB);
    
    // Mark doses as overdue if child is past recommended age
    for (var vaccine in standardSchedule) {
      for (var dose in vaccine.doses) {
        if (dose.administeredDate != null) continue;
        
        // Check if dose is overdue
        if (currentAgeInWeeks > dose.maxRecommendedWeeks) {
          dose.status = VaccineDoseStatus.overdue;
        }
      }
    }
    
    // Apply any historical doses
    if (alreadyGivenDoses != null) {
      _applyHistoricalDoses(standardSchedule, alreadyGivenDoses);
    }
    
    return standardSchedule;
  }
}
```

---

## 🧪 Testing Scenarios

### Test 1: Newborn (0-2 months)
- Generate schedule
- All birth doses should be "due"
- All future doses should be "pending"
- No doses should be "overdue"

### Test 2: 6-Month-Old
- Generate schedule
- Birth doses should be "overdue"
- 6-week, 10-week, 14-week doses should be "overdue"
- 9-month doses should be "pending"

### Test 3: Different Countries
- Generate for Ghana → 10 vaccines
- Generate for Nigeria → Different set
- Generate for USA → Different schedule

### Test 4: Age Calculation
- Child born today → 0 weeks
- Child born 42 days ago → 6 weeks
- Child born 270 days ago → 9 months (39 weeks)

---

## 📝 Implementation Checklist

- [ ] Create VaccineScheduleTemplate model
- [ ] Create AgeRange model
- [ ] Create DoseSchedule model
- [ ] Define Ghana standard schedule
- [ ] Define WHO standard schedule
- [ ] Add ScheduleGenerator class
- [ ] Add age calculation logic
- [ ] Add status determination logic
- [ ] Add catch-up schedule logic
- [ ] Test with various ages
- [ ] Test with different countries

---

**Next:** Review Phase 3 - Recording Vaccinations for marking doses as given.
