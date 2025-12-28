# 📱 Phase 1: Onboarding Flow

## Overview
Design the complete first-time user experience from app launch to having a functional vaccine tracking setup.

---

## 🎯 Goals
1. Welcome user and explain app purpose
2. Collect child's information
3. Generate appropriate vaccine schedule
4. Allow marking of already-completed vaccines (if applicable)
5. Land user on Home screen ready to use app

---

## 🌊 Complete User Flow

### Step 1: App Launch Detection
```
IF (no child profile exists):
    → Show Onboarding
ELSE:
    → Show Home Screen (existing user)
```

### Step 2: Welcome Screen
**Purpose:** Introduce app and set expectations

**Content:**
- App logo
- Welcome message
- Brief explanation: "Track your child's immunizations with ease"
- "Get Started" button

**Duration:** User-controlled (can skip after 2 seconds)

---

### Step 3: Child Information Collection
**Purpose:** Gather minimum required data

**Form Fields:**

**Required:**
1. **Child's Name** (Text input)
   - Validation: Not empty, max 50 characters

2. **Date of Birth** (Date picker)
   - Validation: Not in future, not more than 18 years ago
   - Format: DD/MM/YYYY or MM/DD/YYYY based on locale

3. **Country/Region** (Dropdown)
   - Options: Start with common countries
   - Default: Based on device locale
   - Purpose: Determines vaccine schedule standard

**Optional:**
4. **Blood Type** (Dropdown)
   - Options: A+, A-, B+, B-, AB+, AB-, O+, O-, Unknown

5. **Allergies** (Text area)
   - Placeholder: "List any known allergies"

6. **Medical Notes** (Text area)
   - Placeholder: "Any medical conditions or notes"

**Buttons:**
- "Continue" (primary, requires name + DOB + country)
- "Skip Optional Info" (secondary, if optionals unfilled)

---

### Step 4: Schedule Generation Confirmation
**Purpose:** Show user what will be created

**Screen Shows:**
- Child's name and age (calculated from DOB)
- Message: "We'll create a vaccination schedule based on [Country]'s standard immunization program"
- Number of vaccines to track (e.g., "12 vaccines, 35 total doses")
- Preview of first 3-4 vaccines

**Buttons:**
- "Looks Good!" (primary)
- "Change Country" (secondary, goes back to Step 3)

---

### Step 5: Historical Vaccines Check
**Purpose:** Determine if catch-up is needed

**Logic:**
```
age_in_months = Calculate from DOB

IF age_in_months > 2:
    → Ask: "Has [Child's Name] received any vaccines already?"
    → Options:
       - "Yes, some vaccines" → Go to Step 6
       - "No vaccines yet" → Go to Step 7
       - "Not sure" → Go to Step 7 (can add later)
ELSE:
    → Skip to Step 7 (newborn, no catch-up needed)
```

---

### Step 6: Mark Historical Vaccines (Conditional)
**Purpose:** Let user catch up past vaccinations

**Screen Design:**
- List of ALL vaccines in schedule
- Each vaccine shows doses (e.g., "Rotavirus: 3 doses")
- For each dose, user can mark as "Given" with optional date
- Quick actions:
  - "Mark All as Not Given" (default)
  - "Mark All as Given" (rare, but useful)

**Per-Dose Options:**
- ☐ Not Given (default)
- ☑ Given on [Date Picker] (optional)

**Buttons:**
- "Continue" (primary)
- "Skip for Now" (can do later in Tracking screen)

**Important:**
- This is OPTIONAL - user can do this later
- Don't overwhelm with too much data entry
- Make it easy to skip

---

### Step 7: Setup Complete
**Purpose:** Confirm and celebrate

**Screen Shows:**
- Success animation/icon
- Message: "All Set! [Child's Name]'s vaccination tracking is ready"
- Summary:
  - Profile created ✓
  - Schedule generated ✓
  - [X] vaccines marked as completed (if Step 6 done)

**Button:**
- "Start Tracking" → Navigate to Home Screen

---

## 🎨 Screen-by-Screen Design Specs

### Welcome Screen
```
┌─────────────────────────┐
│                         │
│     [App Logo Large]    │
│                         │
│   TrackMyShots          │
│                         │
│   Track your child's    │
│   immunizations         │
│   with ease             │
│                         │
│                         │
│   [Get Started Button]  │
│                         │
│   [Skip to Login]       │  ← If we add multi-user later
│                         │
└─────────────────────────┘
```

### Child Information
```
┌─────────────────────────┐
│ ← Back    Add Child     │
├─────────────────────────┤
│                         │
│ Let's get started!      │
│                         │
│ Child's Name *          │
│ [_________________]     │
│                         │
│ Date of Birth *         │
│ [DD] [MM] [YYYY] 📅     │
│   (6 months old)        │  ← Auto-calculated
│                         │
│ Country/Region *        │
│ [Ghana            ▼]    │
│                         │
│ ─── Optional ───        │
│                         │
│ Blood Type              │
│ [Select         ▼]      │
│                         │
│ Allergies               │
│ [_________________]     │
│ [_________________]     │
│                         │
│ Medical Notes           │
│ [_________________]     │
│ [_________________]     │
│                         │
│      [Continue]         │
│                         │
└─────────────────────────┘
```

### Schedule Confirmation
```
┌─────────────────────────┐
│ ← Back  Your Schedule   │
├─────────────────────────┤
│                         │
│ For Baby Alex           │
│ 6 months old            │
│                         │
│ Based on Ghana's        │
│ immunization schedule:  │
│                         │
│ • 12 vaccines           │
│ • 35 total doses        │
│                         │
│ Starting vaccines:      │
│                         │
│ ├─ Hepatitis B          │
│ ├─ BCG                  │
│ ├─ Polio                │
│ └─ Rotavirus            │
│                         │
│ [Change Country]        │
│                         │
│      [Looks Good!]      │
│                         │
└─────────────────────────┘
```

### Historical Vaccines
```
┌─────────────────────────┐
│ ← Back  Past Vaccines   │
├─────────────────────────┤
│                         │
│ Has Alex received any   │
│ vaccines already?       │
│                         │
│ Mark completed doses:   │
│                         │
│ Hepatitis B             │
│ ☑ Dose 1  [15 Mar 2024]│
│ ☐ Dose 2  [Select date]│
│ ☐ Dose 3                │
│                         │
│ Rotavirus               │
│ ☐ Dose 1                │
│ ☐ Dose 2                │
│ ☐ Dose 3                │
│                         │
│ [Skip for Now]          │
│      [Continue]         │
│                         │
└─────────────────────────┘
```

---

## 🔄 Data Flow

### What Gets Created:
1. **ChildProfile Object**
   ```dart
   ChildProfile(
     id: generated_uuid,
     name: user_input,
     dateOfBirth: user_input,
     country: user_input,
     bloodType: user_input_or_null,
     allergies: user_input_or_null,
     medicalNotes: user_input_or_null,
     createdAt: DateTime.now(),
   )
   ```

2. **Vaccine Schedule (List<Vaccine>)**
   - Generated based on country + age
   - Each vaccine has appropriate doses
   - Doses have recommended age ranges

3. **Completed Doses (if Step 6 done)**
   - Update VaccineDose.administeredDate
   - Update VaccineDose.status to completed

### What Gets Saved:
- All data persists via StorageService
- User sees data immediately on Home screen
- Can edit later via Profile screen

---

## 🛠️ Technical Requirements

### New Screens Needed:
1. ✅ `OnboardingWelcomeScreen` - New
2. ✅ `ChildInformationScreen` - New (different from edit dialog)
3. ✅ `ScheduleConfirmationScreen` - New
4. ✅ `HistoricalVaccinesScreen` - New

### Data Model Changes:
- None! Existing models support this

### State Management Changes:
```dart
class AppState {
  // Add:
  bool get isFirstTimeUser => currentChild == null;
  
  // Add:
  Future<void> completeOnboarding({
    required ChildProfile child,
    required String country,
    Map<String, List<DateTime>>? historicalDoses,
  }) async {
    // 1. Save child profile
    // 2. Generate vaccine schedule
    // 3. Mark historical doses if provided
    // 4. Save all to storage
    // 5. Notify listeners
  }
}
```

### Navigation Logic:
```dart
// In main.dart or splash screen
Future<void> checkFirstTime() async {
  final hasData = await storageService.hasData();
  
  if (!hasData) {
    Navigator.pushReplacementNamed(context, '/onboarding');
  } else {
    Navigator.pushReplacementNamed(context, '/home');
  }
}
```

---

## ⚠️ Edge Cases to Handle

1. **User closes app mid-onboarding**
   - Solution: Don't save anything until Step 7
   - Onboarding restarts from beginning

2. **User wants to change information later**
   - Solution: All editable via Profile screen
   - Can regenerate schedule if country changes

3. **User adds wrong birth date**
   - Solution: Edit in Profile, recalculate schedule
   - Warn: "Changing birth date will reset vaccine schedule"

4. **Country not in list**
   - Solution: Add "Other" option
   - Use WHO standard schedule as fallback

5. **User has multiple children (future)**
   - Solution: Phase 1 is single child only
   - Add "Switch Child" in Phase 7+

---

## 🧪 Testing Scenarios

### Test 1: Brand New User, Newborn Baby
- Install app
- Enter baby name, DOB (2 weeks old)
- Select country
- Should skip historical vaccines
- Should land on Home with full schedule

### Test 2: New User, 6-Month-Old Baby
- Install app  
- Enter baby name, DOB (6 months old)
- Select country
- Should ask about historical vaccines
- Mark some as complete
- Should show correct progress on Home

### Test 3: New User, Skips Historical
- Install app
- Enter baby info (any age)
- Skip historical vaccines screen
- Should land on Home
- Can mark later via Tracking screen

### Test 4: App Restart Mid-Onboarding
- Start onboarding
- Fill name + DOB
- Close app
- Reopen app
- Should restart onboarding (no partial data saved)

---

## 📝 Implementation Checklist

- [ ] Create OnboardingWelcomeScreen
- [ ] Create ChildInformationScreen
- [ ] Create ScheduleConfirmationScreen
- [ ] Create HistoricalVaccinesScreen
- [ ] Add country dropdown data
- [ ] Add first-time check in app startup
- [ ] Add completeOnboarding() to AppState
- [ ] Add navigation flow logic
- [ ] Test all scenarios
- [ ] Handle edge cases

---

**Next:** Review Phase 2 - Schedule Generation for details on how vaccine schedules are created.
