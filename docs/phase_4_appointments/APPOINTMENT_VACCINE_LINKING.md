# 📅 Phase 4: Complete Appointment System

## Overview
Full appointment management with vaccine linking and fulfillment tracking.

---

## 🎯 Key Flows

### 1. Create Appointment with Vaccine Links

**User Journey:**
```
User books appointment with doctor for vaccines
↓
Opens app → Home screen
↓
Taps "Schedule Appointment" or sees upcoming vaccines
↓
Create Appointment Screen
↓
Fills in:
  - Doctor Name *
  - Specialty *
  - Date * (future date)
  - Time *
  - Location *
  - Duration
  - Select vaccines for this appointment:
    ☑ PCV Dose 2
    ☑ Rotavirus Dose 2
    ☑ DTP Dose 2
  - Notes (optional)
↓
Saves appointment
↓
Appointment shows on Home screen
↓
Reminders created for appointment
```

### 2. Mark Appointment as Kept → Auto-mark Vaccines

**Flow:**
```
Appointment day arrives
↓
User goes to appointment
↓
Vaccines administered
↓
User opens app
↓
Sees appointment on Home screen
↓
Taps appointment → Detail screen
↓
Taps "Mark as Kept" button
↓
Dialog: "Were the following vaccines given?
         ☑ PCV Dose 2
         ☑ Rotavirus Dose 2
         ☑ DTP Dose 2
         
         [No, Not All] [Yes, All Given]"
↓
If "Yes, All Given":
  - All linked vaccines marked as administered (date = appointment date)
  - Appointment status = Completed
  - Progress updates
↓
If "No, Not All":
  - Show checklist to select which were actually given
  - Can add notes about why some weren't given
  - Only selected vaccines marked
```

### 3. Reschedule Missed Appointment

**Flow:**
```
Appointment date passes
↓
User didn't attend
↓
Opens app → Sees "Past appointment"
↓
Taps appointment
↓
Options:
  [Mark as Kept] [Reschedule] [Cancel Appointment]
↓
Selects "Reschedule"
↓
New appointment form (pre-filled with same details)
↓
User changes date/time
↓
Saves
↓
Old appointment marked as "Rescheduled"
↓
New appointment created
↓
Vaccine links transferred to new appointment
```

---

## 🔗 Appointment-Vaccine Linking Logic

### Data Structure Enhancement:

```dart
class Appointment {
  // ... existing fields ...
  
  // NEW: Vaccine links
  List<VaccineLink> linkedVaccines;
  
  // NEW: Fulfillment tracking
  AppointmentFulfillment? fulfillment;
}

class VaccineLink {
  final String vaccineId;
  final int doseNumber;
  final bool wasAdministered; // Set when marking appointment
  final String? notGivenReason; // If not administered
}

class AppointmentFulfillment {
  final bool wasKept;
  final DateTime? actualDateTime; // Might differ from scheduled
  final String? notes;
  final List<String> vaccinesGiven; // Which vaccines were actually given
  final List<String> vaccinesNotGiven; // Which weren't
}
```

### Linking Logic:

**When Creating Appointment:**
```dart
// User selects vaccines from list of due/upcoming vaccines
final duevaccines = appState.vaccines
    .expand((v) => v.doses.where((d) => 
        d.status == VaccineDoseStatus.due || 
        d.status == VaccineDoseStatus.overdue
    ).map((d) => VaccineLink(vaccineId: v.id, doseNumber: d.doseNumber)))
    .toList();

// Show in multi-select list
// Save selected to appointment.linkedVaccines
```

**When Marking Appointment as Kept:**
```dart
void markAppointmentKept({
  required Appointment appointment,
  required Map<String, int> vaccinesActuallyGiven, // vaccineId -> doseNumber
}) {
  // 1. Update appointment
  appointment.status = AppointmentStatus.completed;
  appointment.fulfillment = AppointmentFulfillment(
    wasKept: true,
    actualDateTime: DateTime.now(),
    vaccinesGiven: vaccinesActuallyGiven.keys.toList(),
  );
  
  // 2. Mark vaccines as given
  for (var entry in vaccinesActuallyGiven.entries) {
    final vaccine = appState.getVaccineById(entry.key);
    final dose = vaccine.doses.firstWhere((d) => d.doseNumber == entry.value);
    
    dose.administeredDate = appointment.dateTime;
    dose.status = VaccineDoseStatus.completed;
    dose.doctorName = appointment.doctorName;
    dose.location = appointment.location;
  }
  
  // 3. Save everything
  appState.updateAppointment(appointment);
  appState.notifyListeners();
  await storageService.saveAll();
}
```

---

## 🎨 Enhanced Screens

### Appointment Creation Screen (Already Exists - Needs Enhancement)

**Add Vaccine Selection Section:**
```
┌─────────────────────────────┐
│ ← Create Appointment        │
├─────────────────────────────┤
│ [Doctor, Date, Time fields] │
│                             │
│ Vaccines for this visit:    │
│                             │
│ ☑ PCV Dose 2                │
│   Due: 10 weeks (Overdue)   │
│                             │
│ ☑ Rotavirus Dose 2          │
│   Due: 10 weeks (Overdue)   │
│                             │
│ ☑ DTP Dose 2                │
│   Due: 10 weeks (Overdue)   │
│                             │
│ ☐ Hepatitis B Dose 3        │
│   Due: 14 weeks (Upcoming)  │
│                             │
│      [Create Appointment]   │
└─────────────────────────────┘
```

### Appointment Detail Screen (Exists - Needs Enhancement)

**Show Linked Vaccines:**
```
┌─────────────────────────────┐
│ ← Appointment Details       │
├─────────────────────────────┤
│ [Doctor info card]          │
│                             │
│ Vaccines Planned:           │
│ • PCV Dose 2                │
│ • Rotavirus Dose 2          │
│ • DTP Dose 2                │
│                             │
│ Date: 28 Dec 2024           │
│ Time: 10:00 AM              │
│ Status: Scheduled           │
│                             │
│ [Mark as Kept]              │
│ [Reschedule]                │
│ [Delete]                    │
└─────────────────────────────┘
```

### Appointment Fulfillment Dialog (NEW)

```
┌─────────────────────────────┐
│ Mark Appointment as Kept    │
├─────────────────────────────┤
│                             │
│ Which vaccines were given?  │
│                             │
│ ☑ PCV Dose 2                │
│ ☑ Rotavirus Dose 2          │
│ ☐ DTP Dose 2                │
│                             │
│ Why wasn't DTP given?       │
│ [Baby had fever________]    │
│                             │
│ Additional Notes:           │
│ [____________________]      │
│                             │
│ [Cancel]  [Save]            │
│                             │
└─────────────────────────────┘
```

---

## ⚠️ Edge Cases

### 1. Appointment Kept But No Vaccines Given
```
User went to appointment but doctor said "Come back next week"

Solution:
- Mark appointment as "Completed" but with fulfillment.vaccinesGiven = []
- Don't mark any vaccine doses
- Add note explaining why
- Suggest creating new appointment
```

### 2. Vaccine Given Outside Appointment
```
User marked Rotavirus Dose 2 as given yesterday
Today they mark appointment as kept which also includes Rotavirus Dose 2

Solution:
- Detect dose already marked
- Show: "Rotavirus Dose 2 was already marked as given on [date].
         Keep that record or update to appointment date?"
- Options: [Keep Original] [Update to Appointment Date]
```

### 3. Partial Fulfillment
```
Appointment for 3 vaccines, only 2 given

Solution:
- Use fulfillment dialog
- Uncheck DTP Dose 2
- Require reason in notes
- Only mark PCV and Rotavirus as given
```

### 4. Rescheduling After Some Vaccines Given
```
Appointment was for 3 vaccines
User went, 2 were given, 1 wasn't
Now need to reschedule for the remaining 1

Solution:
- Mark appointment as "Partially Complete"
- When rescheduling, only carry over uncompleted vaccines
- New appointment only linked to DTP Dose 2
```

---

## 📝 Implementation Checklist

### Data Model Changes:
- [ ] Add VaccineLink model
- [ ] Add AppointmentFulfillment model
- [ ] Add linkedVaccines to Appointment
- [ ] Add fulfillment to Appointment

### UI Changes:
- [ ] Add vaccine selection to appointment creation
- [ ] Add vaccine list to appointment detail
- [ ] Create appointment fulfillment dialog
- [ ] Add reschedule functionality
- [ ] Show appointment status clearly

### Logic Changes:
- [ ] Link vaccines when creating appointment
- [ ] Auto-mark vaccines when appointment kept
- [ ] Handle partial fulfillment
- [ ] Transfer vaccine links when rescheduling
- [ ] Detect conflicts (dose already marked)

### Edge Case Handling:
- [ ] Appointment kept but no vaccines given
- [ ] Vaccine given outside appointment
- [ ] Partial fulfillment
- [ ] Rescheduling after partial fulfillment

---

**Next:** Review Phase 5 - Dynamic Reminders for real-time reminder generation.
