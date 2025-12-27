# 🧪 Testing Guide - Phase 1 Complete

## Quick Start

```bash
cd /Users/kevinafenyo/Documents/GitHub/trackmyshots
flutter pub get
flutter run
```

## ✅ What to Test

### 1. App Launch
- **Expected**: Splash screen appears for 3 seconds
- **Shows**: TrackMyShots logo, loading indicator
- **Then**: Auto-navigates to Home screen

### 2. Home Screen - Data Display

#### Child Information
- **Check**: "Hello, Emily" greeting
- **Check**: Shows "6 months old" below name
- ✅ Should match sample data (6-month-old child)

#### Vaccine Quick Buttons
Each button should show:
- **Hepatitis B (H)**: Green checkmark (100% complete)
- **Rotavirus (R)**: Badge with "1" (1 dose completed)
- **PCV (P)**: Badge with "1" (1 dose completed)
- **DTP (D)**: Badge with "1" (1 dose completed)

**Test**: Tap any button → Should navigate to Tracking screen

#### Upcoming Appointment Card
- **Doctor**: Dr. Ray Alex
- **Specialty**: General Practitioner
- **Date**: Wed, 21 May 2025
- **Time**: 10:30 am - 11:30 am
- **Style**: Blue gradient card with white text

#### Recent Visit Card
- **Doctor**: Dr. Sarah Johnson
- **Status**: Green check icon
- **Date**: Should show date from 30 days ago
- **Note**: "Regular 6-week checkup completed successfully"

### 3. Bottom Navigation
Test all 5 tabs:
1. **Tracking** (left) → Navigate to Tracking screen
2. **Profile** → Navigate to Profile screen
3. **Home** (center) → Stay on Home (highlighted)
4. **Resources** → Navigate to Educational Resources
5. **Notes** → Navigate to Reminders

**Expected**: Current tab highlighted in white, others in white60

### 4. Navigation Flow

#### From Home:
```
Tap Tracking button → Tracking Screen ✓
Tap Notification bell → Reminders Screen ✓
Tap bottom nav items → Respective screens ✓
```

#### Back Navigation:
```
From any screen → Back button → Returns to previous screen ✓
```

## 🎯 Feature Checklist

### Data Layer
- [ ] Sample child data loads automatically
- [ ] All 5 vaccines present with correct doses
- [ ] Appointments show correct dates
- [ ] Progress percentages calculate correctly

### UI Components
- [ ] Vaccine buttons show correct completion status
- [ ] Appointment card displays all information
- [ ] Recent visit card shows past appointment
- [ ] Age calculation is accurate
- [ ] Theme colors match design

### Navigation
- [ ] Splash → Home transition works
- [ ] Bottom nav switches between screens
- [ ] Back button returns correctly
- [ ] Routes are defined and working

## 🔍 Detailed Testing

### Vaccine Progress Indicators

**Hepatitis B (100%)**
- Should show: Green checkmark
- Badge position: Top right of button
- Color: Green (#4CAF50)

**Rotavirus (50%)**
- Should show: Badge with "1"
- Means: 1 of 2 doses completed
- Badge color: White with colored number

**DTP (25%)**
- Should show: Badge with "1"
- Means: 1 of 4 doses completed

**Hib (75%)**
- Should show: Badge with "3"
- Means: 3 of 4 doses completed

**PCV (25%)**
- Should show: Badge with "1"
- Means: 1 of 4 doses completed

### Appointment Card Testing

**If Upcoming Appointment Exists:**
- Blue gradient background
- Doctor initial in avatar
- Full doctor name and specialty
- Formatted date and time
- White text on gradient

**If No Upcoming Appointment:**
- White card background
- Calendar icon
- "No upcoming appointments" text
- "Schedule Appointment" button

### Recent Visit Card Testing

**If Past Visits Exist:**
- White card background
- Green success icon
- Doctor name
- Visit date
- Visit notes (if any)

**If No Past Visits:**
- "No recent visits yet" message
- History icon

## 🎨 Visual Testing

### Colors to Verify
- Primary Dark: #003D6B (bottom nav)
- Primary Blue: #0066B3 (buttons)
- Primary Light: #4AA5D9 (accents)
- Cyan: #6DD4D4 (gradients)
- Background: #F5F9FC (screen background)

### Typography
- Headlines: Bold, 32px
- Titles: Semi-bold, 18-22px
- Body: Regular, 14-16px
- Labels: 12-14px

### Spacing
- Card padding: 16px
- Section spacing: 24-32px
- Element spacing: 8-16px

## 🐛 Common Issues & Solutions

### Issue: "Package not found" errors
**Solution**: Run `flutter pub get`

### Issue: Blank screen or loading forever
**Solution**: Check console for errors, restart app with `R`

### Issue: Sample data not showing
**Solution**: Provider should auto-load data. Check main.dart has `..loadSampleData()`

### Issue: Navigation not working
**Solution**: Ensure all routes are defined in main.dart

### Issue: UI looks different from design
**Solution**: Check AppTheme is properly imported and applied

## 📊 Expected Data Values

### Child Profile
```
Name: Emily Ross
Age: 6 months
Birth Date: 6 months before today
```

### Vaccine Counts
```
Hepatitis B: 3/3 doses (100%)
Rotavirus: 1/2 doses (50%)
DTP: 1/4 doses (25%)
Hib: 3/4 doses (75%)
PCV: 1/4 doses (25%)
```

### Upcoming Doses
- Rotavirus dose 2 (at 10 weeks)
- DTP dose 2 (at 10 weeks)
- PCV dose 2 (at 10 weeks)
- Multiple doses at 14 weeks
- Future doses at 12-18 months

## ✨ Success Criteria

Phase 1 is successful if:
- ✅ App launches without errors
- ✅ Home screen displays all components
- ✅ Sample data loads automatically
- ✅ Vaccine progress shows correctly
- ✅ Navigation works between screens
- ✅ UI matches the design theme
- ✅ No console errors or warnings

## 📝 Testing Checklist

```
□ App launches successfully
□ Splash screen shows for 3 seconds
□ Home screen displays child's name
□ Age shows "6 months old"
□ All 4 vaccine buttons visible
□ Vaccine badges show correct numbers
□ Hepatitis B shows checkmark
□ Appointment card displays data
□ Recent visit card shows past appointment
□ Bottom navigation has 5 tabs
□ Tapping vaccine button navigates
□ All navigation items work
□ Back button returns correctly
□ No errors in console
□ UI looks polished and professional
```

## 🚀 Next: Phase 2 Testing

Once Phase 1 passes all tests, we'll move to:
1. Tracking screen with full vaccine details
2. Interactive dose marking
3. Calendar view of upcoming doses
4. Vaccine detail modals
5. Progress animations

---

**Ready to test!** Run the app and verify each item above.
