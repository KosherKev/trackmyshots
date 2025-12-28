# 🔔 Phase 5: Dynamic Reminders & Smart Notifications

## 🎯 Goal
Implement a proactive notification system that ensures users never miss a vaccination or appointment. The system must be "smart" enough to avoid redundant alerts (e.g., don't nag about a vaccine being due if there's already an appointment scheduled for it).

## 🧠 Smart Scheduling Strategy

### 1. Notification Types

| Type | Trigger | Message Example | Action |
|------|---------|-----------------|--------|
| **Vaccine Due** | Scheduled Date (if no appointment) | "Hepatitis B Dose 2 is due today." | Open Tracking Screen |
| **Appointment** | 24h & 2h before Appointment | "Reminder: Vaccination appointment tomorrow at 10:00 AM." | Open Appointment Detail |
| **Overdue** | 1 Week after Scheduled Date | "Action Needed: Polio Dose 1 is overdue. Schedule now." | Open Scheduling Screen |

### 2. Conflict Resolution (The "Smart" Part)
To prevent notification fatigue, we apply the following rules:
*   **Priority:** Appointment Reminders > Vaccine Due Reminders.
*   **Rule:** If a specific vaccine dose is linked to an *upcoming* appointment, **suppress** the generic "Vaccine Due" reminder for that dose.
    *   *Why?* The user has already taken action by booking. They need to remember the *appointment*, not the abstract "due date".
*   **Fallback:** If an appointment is cancelled or marked "No Show", immediately **restore** the "Vaccine Due" reminder.

## 🛠 Technical Implementation Plan

### A. Notification Service Enhancements (`NotificationService`)
*   **Payload Management**: Update payload format to support routing.
    *   Format: `type|id` (e.g., `appointment|apt_12345` or `vaccine|vac_hep_b`).
*   **Channels**: Ensure high-importance channels for immediate alerts.
*   **Deep Linking**:
    *   `appointment|...` -> Navigate to `AppointmentDetailScreen`.
    *   `vaccine|...` -> Navigate to `TrackingScreen` (scroll to item).

### B. State Management Logic (`AppState`)
*   **`refreshReminders()` Method**:
    *   Clears all pending local notifications.
    *   Iterates through **Appointments**:
        *   Schedules 24h and 2h alerts.
        *   Collects a set of `linkedDoseIds`.
    *   Iterates through **Vaccines**:
        *   Checks if `dose.id` is in `linkedDoseIds`.
        *   If **NO**: Schedules "Vaccine Due" reminder based on `scheduledDate`.
        *   If **YES**: Skips (suppressed).

### C. ID Management (Crucial for Updates)
*   We need deterministic Integer IDs for `flutter_local_notifications`.
*   **Strategy**: Use `hashCode` of unique string keys.
    *   Vaccine Reminder ID: `('vaccine:' + vaccineId + doseId).hashCode`
    *   Appointment Reminder ID: `('appointment:' + appointmentId).hashCode`
*   This allows us to cancel specific notifications if needed, though a full `cancelAll() + reschedule` is often safer for data consistency.

## � Task List

1.  **[Infrastructure]** Update `NotificationService` to handle `appointment` vs `vaccine` payloads explicitly.
2.  **[Logic]** Implement `refreshReminders()` in `AppState` with the suppression logic.
3.  **[Integration]** Call `refreshReminders()` whenever:
    *   An appointment is created/edited/cancelled.
    *   A vaccine is marked as administered (to remove future reminders).
    *   The app creates a new child profile.
4.  **[UX]** Add a "Test Notification" button in Settings (dev only) to verify routing.

## 🧪 Verification
*   **Scenario 1**: Create Appointment -> Verify "Vaccine Due" reminder is NOT scheduled, but "Appointment" reminder IS.
*   **Scenario 2**: Cancel Appointment -> Verify "Vaccine Due" reminder reappears.
*   **Scenario 3**: Tap Notification -> Verify app opens to correct screen.
