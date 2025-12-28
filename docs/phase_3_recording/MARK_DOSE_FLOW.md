# 💉 Phase 3: Recording Vaccinations

## Overview
Complete the logic for marking vaccine doses as administered, both for current vaccinations and historical catch-up.

---

## 🎯 Goals
1. Mark individual doses as given with date
2. Support optional doctor/batch/notes
3. Update all related screens automatically
4. Recalculate progress and next due dates
5. Link to appointments if applicable

---

## 🌊 User Flows

### Flow 1: Mark Dose After Doctor Visit (Most Common)

```
User goes to doctor
↓
Doctor administers Rotavirus Dose 2
↓
User opens app
↓
Goes to Tracking screen
↓
Taps "Rotavirus" card
↓
Vaccine detail modal opens
↓
Sees "Dose 2 - Due"
↓
Taps "Mark as Given" button
↓
Mark Dose Dialog appears:
  - Date Given: [Today] (can change)
  - Doctor/Clinic: [Optional text]
  - Batch Number: [Optional text]
  - Notes: [Optional text]
↓
User fills info (or just confirms date)
↓
Taps "Save"
↓
Dose marked as completed
↓
Modal closes
↓
Progress updates everywhere:
  - Home screen badge updates
  - Tracking progress bar updates
  - Progress screen updates
  - Reminders screen updates
```

### Flow 2: Mark Historical Dose (Catch-Up)

```
User has 6-month-old with past vaccines
↓
Opens Tracking screen
↓
Sees "Hepatitis B - 0 of 3 doses" (all overdue)
↓
Taps card → Modal opens
↓
Sees all 3 doses marked "Overdue"
↓
Taps "Mark as Given" on Dose 1
↓
Dialog: "When was this dose given?"
  - Date: [Select past date]
  - [Optional details]
↓
Saves → Dose 1 now "Completed"
↓
Repeats for Dose 2, Dose 3
↓
Vaccine now shows "3 of 3 doses" ✓
```

### Flow 3: Mark Multiple Doses at Once

```
User went to appointment
↓
Baby received 3 vaccines: PCV, DTP, Rotavirus
↓
Opens app
↓
Options:
  A) Mark each vaccine individually
  B) Use "Quick Mark" feature (future enhancement)
```

---

## 🎨 Enhanced Mark Dose Dialog

### Current Dialog (Needs Enhancement):
```dart
class MarkDoseDialog extends StatefulWidget {
  final VaccineDose dose;
  final Vaccine vaccine;
  // ...
}
```

### Required Fields:
1. **Date Given** (Required)
   - Default: Today
   - Can select past date (not future)
   - Date picker

2. **Doctor/Clinic** (Optional)
   - Text input
   - Suggestion: Use last doctor entered
   - Saved for future autofill

3. **Batch Number** (Optional)
   - Text input
   - Important for record-keeping
   - Displayed in dose history

4. **Any Reactions?** (Optional)
   - Text area
   - "Did baby have any reactions?"
   - Saved as notes

5. **Location** (Optional)
   - Text input
   - Clinic/hospital name

### Enhanced Dialog UI:
```
┌─────────────────────────────┐
│   Mark Rotavirus Dose 2     │
├─────────────────────────────┤
│                             │
│ When was this dose given?   │
│                             │
│ Date Given *                │
│ [28 Dec 2024]  📅           │
│                             │
│ Doctor/Clinic               │
│ [Dr. Mensah, Ridge Hosp.]  │
│   ↑ Last used              │
│                             │
│ Batch Number                │
│ [ABC123456]                 │
│                             │
│ Location                    │
│ [Ridge Hospital]            │
│                             │
│ Any Reactions or Notes?     │
│ [____________________]      │
│ [____________________]      │
│                             │
│  [Cancel]     [Save]        │
│                             │
└─────────────────────────────┘
```

---

## 🔄 Data Updates After Marking Dose

### 1. Update VaccineDose Object:
```dart
dose.administeredDate = selectedDate;
dose.status = VaccineDoseStatus.completed;
dose.doctorName = doctorInput;
dose.batchNumber = batchInput;
dose.location = locationInput;
dose.notes = notesInput;
```

### 2. Update Vaccine Completion:
```dart
vaccine.completedDoses++;
vaccine.completionPercentage = (completedDoses / totalDoses) * 100;
```

### 3. Update AppState:
```dart
appState.updateVaccineDose(vaccineId, doseNumber, updatedDose);
appState.notifyListeners(); // Triggers UI updates
```

### 4. Save to Storage:
```dart
await storageService.saveVaccines(appState.vaccines);
```

### 5. Check for Next Dose:
```dart
if (hasNextDose) {
  // Calculate next dose due date based on minimum interval
  nextDose.scheduledDate = administeredDate + minimumInterval;
  nextDose.status = VaccineDoseStatus.pending;
}
```

### 6. Update Reminders:
```dart
// Remove reminder for completed dose
reminders.removeWhere((r) => r.vaccineId == vaccineId && r.doseNumber == doseNumber);

// Add reminder for next dose if applicable
if (hasNextDose && isWithinReminderWindow(nextDose.scheduledDate)) {
  reminders.add(createReminder(vaccine, nextDose));
}
```

---

## 📊 Progress Calculation

### Individual Vaccine Progress:
```dart
class Vaccine {
  int get completedDoses => doses.where((d) => d.status == VaccineDoseStatus.completed).length;
  int get totalDoses => doses.length;
  double get completionPercentage => (completedDoses / totalDoses) * 100;
  bool get isCompleted => completedDoses == totalDoses;
}
```

### Overall Progress:
```dart
class AppState {
  int get totalDosesCompleted => vaccines.fold(0, (sum, v) => sum + v.completedDoses);
  int get totalDosesRequired => vaccines.fold(0, (sum, v) => sum + v.totalDoses);
  double get overallCompletion => (totalDosesCompleted / totalDosesRequired) * 100;
}
```

---

## 🔗 Appointment Linking

### When Marking Dose as Given:

**Check if there's a related appointment:**
```dart
final relatedAppointment = appointments.firstWhereOrNull(
  (apt) => apt.relatedVaccineIds.contains(vaccineId) &&
           apt.dateTime.isSameDay(administeredDate)
);

if (relatedAppointment != null) {
  // Ask user: "This was from your appointment on [date]. Mark appointment as kept?"
  // If yes:
  relatedAppointment.status = AppointmentStatus.completed;
}
```

---

## ⚠️ Validation Rules

### Date Validation:
1. ✅ Cannot be in future
2. ✅ Cannot be before child's DOB
3. ✅ Should warn if before previous dose (but allow with confirmation)
4. ✅ Should warn if very old date (>2 years ago)

### Dose Order Validation:
```
Example: Marking Dose 3 before Dose 2

Dialog: "Warning: Dose 2 hasn't been given yet. 
         Are you sure you want to mark Dose 3?
         
         [Cancel] [Yes, Continue]"
```

### Minimum Interval Validation:
```
Example: Doses should be 4 weeks apart

If administeredDate < previousDose.date + minimumInterval:
  
  Dialog: "Warning: Recommended minimum interval is 4 weeks.
           This dose is only X weeks after the previous dose.
           
           Consult your doctor if you're unsure.
           
           [Cancel] [Mark Anyway]"
```

---

## 🎯 UI Updates After Marking

### Tracking Screen:
- Vaccine card progress bar updates
- Percentage updates
- Completed badge appears if all doses done

### Home Screen:
- Vaccine quick buttons show updated badge numbers
- Recent visits section may update

### Progress Screen:
- Overall percentage recalculates
- Vaccine status breakdown updates
- Timeline adds new entry

### Reminders Screen:
- Completed dose reminder removed
- Next dose reminder appears (if applicable)

---

## 🧪 Testing Scenarios

### Test 1: Mark Dose Normally
- Open Rotavirus vaccine
- Dose 2 is "Due"
- Mark as given today
- Enter doctor name
- Save
- Verify: Status = Completed, Progress updates

### Test 2: Mark Historical Dose
- 6-month-old child
- Hep B Dose 1 is "Overdue"
- Mark as given 5 months ago
- Save
- Verify: Still shows as completed

### Test 3: Mark Out of Order
- Mark Dose 3 before Dose 2
- Should show warning
- Allow with confirmation
- Both marked as completed

### Test 4: Mark With Appointment
- Create appointment for today
- Link to PCV vaccine
- Mark PCV dose as given
- Should suggest marking appointment as kept

### Test 5: Undo/Edit Marked Dose
- Mark dose as given
- Realize wrong date
- Edit the dose
- Change date
- Save
- Verify: Updated correctly

---

## 📝 New Features Needed

### 1. Edit Completed Dose
```dart
// Add to VaccineDetailModal
IconButton(
  icon: Icon(Icons.edit),
  onPressed: () => _editDose(dose),
)
```

### 2. Undo Marked Dose
```dart
// Add confirmation dialog
showDialog(
  context: context,
  builder: (_) => AlertDialog(
    title: Text('Unmark this dose?'),
    content: Text('This will mark Dose X as not given.'),
    actions: [
      TextButton('Cancel'),
      TextButton('Unmark', onPressed: () {
        dose.administeredDate = null;
        dose.status = VaccineDoseStatus.pending; // or overdue
        dose.doctorName = null;
        dose.batchNumber = null;
        // etc.
      }),
    ],
  ),
);
```

### 3. Quick Mark Multiple
Future enhancement: Mark multiple vaccines from single screen

---

## 📝 Implementation Checklist

- [ ] Enhance MarkDoseDialog with all fields
- [ ] Add date validation logic
- [ ] Add dose order warnings
- [ ] Add minimum interval warnings
- [ ] Implement progress recalculation
- [ ] Add edit completed dose feature
- [ ] Add undo marked dose feature
- [ ] Link to appointments when applicable
- [ ] Update all screens after marking
- [ ] Persist changes to storage
- [ ] Test all scenarios

---

**Next:** Review Phase 4 - Appointment Management for complete appointment system.
