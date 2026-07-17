# App & Backend Integration Plan (Doctor Appointments)

## Goal
Connect the Flutter mobile app directly to the newly created backend API for booking and managing appointments.

## User Review Required
> [!IMPORTANT]
> The mobile app currently uses hardcoded (fake) data for doctors. To make the appointment booking work with real data, we must switch the app to fetch the actual doctors from the backend. This means the doctors you see in the app will change to match the ones registered in your database.

## Proposed Changes

### Backend (Laravel)
- **[MODIFY]** [routes/api.php](file:///Users/ibrahimpti/Desktop/Dr-Room/dr_room_backend/routes/api.php): Add public API routes to fetch the list of doctors (`GET /api/doctors`).
- **[MODIFY]** [AppController.php](file:///Users/ibrahimpti/Desktop/Dr-Room/dr_room_backend/app/Http/Controllers/Api/AppController.php): Implement the logic to return all doctors and doctor details.

---

### Frontend (Flutter)
- **[MODIFY]** [doctor_details_screen.dart](file:///Users/ibrahimpti/Desktop/Dr-Room/lib/features/doctors/doctor_details_screen.dart): 
  - Add `doctorId` parameter.
  - Make the "Book Appointment" button functional by sending a `POST` request to `/api/appointments` using the `ApiClient`.
  
- **[MODIFY]** [all_schedules_screen.dart](file:///Users/ibrahimpti/Desktop/Dr-Room/lib/features/appointments/all_schedules_screen.dart):
  - Convert to a `StatefulWidget`.
  - Fetch the user's real appointments using `GET /api/appointments`.
  - Add cancel appointment functionality `DELETE /api/appointments/{id}`.

- **[MODIFY]** Screens that navigate to `DoctorDetailsScreen` (like `all_doctors_screen.dart` and `home_screen.dart`):
  - Fetch real doctors from `/api/doctors`.
  - Pass the real `doctorId` to the details screen.

## Verification Plan
1. Ensure the Flutter app successfully fetches doctors from the backend database.
2. Book an appointment from the app and verify it returns a success message.
3. Open the doctor's web dashboard and verify the appointment appears there.
4. Verify the patient's "My Appointments" screen in the app shows the booked appointment.




	
Email	admin@drroom.com
Password	admin123456