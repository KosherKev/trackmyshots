# TrackMyShots - App Documentation

**Version:** 1.0.0
**Last Updated:** December 2025
**Platform:** Flutter (iOS & Android)

---

## 1. Executive Summary
**TrackMyShots** is a privacy-first mobile application designed to help parents and guardians track their child's immunization schedule. It simplifies the complexity of vaccine management by providing automated schedules, appointment tracking, educational resources, and smart reminders—all stored securely on the user's device without requiring cloud synchronization.

---

## 2. Core Features

### 📅 Smart Scheduling & Tracking
*   **Automated Schedule Generation:** Upon entering a child's birth date, the app automatically generates a complete vaccination schedule based on standard health guidelines (e.g., CDC/WHO patterns).
*   **Status Tracking:** Visual indicators for each vaccine dose:
    *   🔵 **Upcoming:** Scheduled for a future date.
    *   🔴 **Overdue:** Passed the recommended date without record of administration.
    *   🟢 **Completed:** Administered and logged.
*   **Linked Appointments:** Seamlessly link a vaccine dose to a physical doctor's appointment.

### 🔔 Dynamic Reminders System
*   **Priority Notifications:** The app intelligently prioritizes alerts:
    *   **Appointment Reminders:** 24 hours and 2 hours before a scheduled visit.
    *   **Due Date Reminders:** 2 weeks before a vaccine is due (suppressed if an appointment is already booked).
    *   **Overdue Alerts:** 1 week after a missed due date.
*   **Conflict Resolution:** Prevents "alert fatigue" by ensuring you don't receive generic "due soon" reminders if you already have a doctor's appointment confirmed for that vaccine.

### 📚 Educational Hub
*   **Vaccine Encyclopedia:** Detailed, easy-to-understand information for every tracked vaccine.
*   **Content Includes:**
    *   **Purpose:** What disease it prevents.
    *   **Description:** How the vaccine works.
    *   **Side Effects:** Common reactions to watch for.

### 🔒 Privacy-First Architecture
*   **Local Storage:** All data (child profiles, medical history, appointments) is stored locally on the device using `SharedPreferences` and JSON serialization.
*   **No Cloud Dependency:** The app functions fully offline, ensuring data privacy and security.

---

## 3. User Flow

### A. Onboarding (First Run)
1.  **Welcome:** Introduction to the app's benefits.
2.  **Child Profile:** User enters the child's name and Date of Birth.
3.  **Schedule Generation:** The app instantly calculates due dates for all standard vaccines from birth to 18 months+.
4.  **Confirmation:** User reviews the generated schedule before entering the main dashboard.

### B. Main Navigation (Dashboard)
The app features a persistent navigation bar with 5 key sections, accessible via smooth swipe gestures:

1.  **Home (Center Tab):**
    *   **Next Up:** Immediate view of the next upcoming vaccine or appointment.
    *   **Quick Actions:** Shortcuts to log a past vaccine or book a new appointment.
    *   **Recent Activity:** A log of recently completed actions.

2.  **Tracking (Left Tab):**
    *   **Master List:** A chronological timeline of all vaccines.
    *   **Filtering:** Users can filter by status (Completed, To Do).
    *   **Action:** Tapping a vaccine allows the user to "Mark as Administered" or "Book Appointment."

3.  **Profile (Far Left Tab):**
    *   **Child Management:** View and edit child details.
    *   **Data Control:** Options to reset data or manage app settings.

4.  **Education (Right Tab):**
    *   **Resource Library:** Browse vaccines by name.
    *   **Detail View:** Read comprehensive medical information about specific immunizations.

5.  **Reminders (Far Right Tab):**
    *   **Notification Center:** A unified list of all active alerts.
    *   **Status:** See pending notifications for appointments and overdue items.

---

## 4. Key Workflows

### 🏥 Booking an Appointment
1.  Navigate to **Home** or **Tracking**.
2.  Tap **"Add Appointment"** or select a specific vaccine.
3.  Choose **Date & Time**.
4.  **Link Vaccines:** Select which vaccines will be administered during this visit.
5.  **Save:** The app creates the appointment and automatically suppresses generic "due soon" reminders for the selected vaccines, replacing them with specific appointment alerts.

### ✅ Completing a Vaccination
1.  **Via Appointment:** When an appointment concludes, the user opens the appointment details and checks off the administered vaccines.
2.  **Via Tracking List:** User taps a vaccine and selects **"Mark as Administered."**
3.  **Outcome:** The vaccine status updates to "Completed" (Green), and it moves to the history log.

---

## 5. Technical Specifications
*   **Framework:** Flutter (Dart)
*   **State Management:** Provider pattern for reactive UI updates.
*   **Local Persistence:** JSON-based storage for lightweight, secure data management.
*   **Notifications:** `flutter_local_notifications` with deterministic ID generation to handle scheduling conflicts and updates reliably.
