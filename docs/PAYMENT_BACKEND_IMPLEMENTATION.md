# Payment System Backend Implementation - Summary

## Overview
Implemented a per-patient subscription model with 3-month free trials that start when a caregiver accepts a connection request. Removed the old BASIC/PREMIUM plan types and replaced them with duration-based subscriptions (3/6/12 months).

## Database Changes

### Migration Applied
- **File**: `database/migrations/update-subscription-model-per-patient-trial.sql`
- **Changes**:
  - Added `trial_start_date`, `trial_end_date`, `paid_start_date`, `paid_end_date` columns
  - Made old columns (`plan_type`, `start_date`, `end_date`) nullable for backward compatibility
  - Updated status enum/check constraint to include 'TRIAL' status
  - Added indexes on `patient_id` and `status` for better performance

## Model Updates

### GuardianSubscription.java
- **Removed**: `PlanType` enum (BASIC, PREMIUM)
- **Added**: `TRIAL` status to `SubscriptionStatus` enum
- **New Fields**: 
  - `trialStartDate`, `trialEndDate` - tracks 3-month free trial period
  - `paidStartDate`, `paidEndDate` - tracks paid subscription period
- **Behavior**: Trial and paid periods can stack (e.g., 3 free + 6 paid = 9 months total)

## Service Layer Updates

### SubscriptionService.java - COMPLETELY REWRITTEN
Key methods:
- `createPendingSubscription(guardianId, patientId)` - Create subscription when patient added
- `startTrial(patientId)` - Start 3-month trial when caregiver accepts
- `addPaidSubscription(patientId, durationMonths)` - Add paid period (3/6/12 months)
- `isSubscriptionActive(patientId)` - Check if trial OR paid period is active
- `getSubscriptionStatus(patientId)` - Returns TRIAL/ACTIVE/EXPIRED/PENDING
- `getExpiredPatientIds(guardianId)` - Get all expired patients for a guardian
- `checkAndExpireSubscriptions()` - Scheduled task to auto-expire subscriptions

### PaymentService.java
- **Updated**: `updatePaymentStatus` and `updatePaymentStatusByOrderId` methods
- **Added**: `patientId` and `durationMonths` parameters
- **New Behavior**: On successful payment, calls `subscriptionService.addPaidSubscription()`
- **Backward Compatible**: Overloaded methods maintain old signatures

## Controller Updates

### SubscriptionController.java - NEW ENDPOINTS
- `GET /api/subscriptions/patient/{patientId}/status` - Get subscription status with dates
- `GET /api/subscriptions/guardian/{guardianId}/expired-patients` - List expired patients
- `GET /api/subscriptions/patient/{patientId}` - Get full subscription details
- `GET /api/subscriptions/guardian/{guardianId}` - Get all guardian subscriptions
- `POST /api/subscriptions/{subscriptionId}/cancel` - Cancel subscription

### CaregiverController.java
- **Updated**: `acceptConnectionRequest()` method
- **New Behavior**: When caregiver accepts, automatically calls `subscriptionService.startTrial(patientId)`
- **Added**: Autowired `SubscriptionService` dependency

### PatientController.java
- **Updated**: `addPatient()` method
- **New Behavior**: When patient created, automatically calls `subscriptionService.createPendingSubscription()`
- **Added**: Autowired `SubscriptionService` dependency

## Business Logic Flow

### 1. Patient Creation
```
Guardian adds patient → PatientController.addPatient()
→ SubscriptionService.createPendingSubscription()
→ Subscription created with status = PENDING
```

### 2. Trial Start (Caregiver Acceptance)
```
Caregiver accepts connection → CaregiverController.acceptConnectionRequest()
→ SubscriptionService.startTrial()
→ Subscription status = TRIAL, trial dates set (now to now+3 months)
```

### 3. Payment Processing
```
Guardian makes payment → PaymentService.updatePaymentStatus()
→ SubscriptionService.addPaidSubscription(patientId, duration)
→ Paid period starts after trial ends (or immediately if no trial)
→ Subscription status = ACTIVE
```

### 4. Subscription Expiry
```
Scheduled task runs → SubscriptionService.checkAndExpireSubscriptions()
→ Checks all TRIAL and ACTIVE subscriptions
→ Expired subscriptions marked as EXPIRED
```

## Pricing Structure
- **3 months**: 499 LKR
- **6 months**: 999 LKR  
- **12 months**: 1399 LKR

## Access Control Requirements (TO BE IMPLEMENTED IN MOBILE)

### Patient Login
- Check subscription status via `/api/subscriptions/patient/{patientId}/status`
- If `isActive = false`, auto-logout patient

### Guardian Dashboard
- Fetch expired patients via `/api/subscriptions/guardian/{guardianId}/expired-patients`
- Show payment prompt for expired patients
- Allow access to other non-expired patients

### Caregiver Dashboard
- Check each patient's subscription status
- Display expired patients as disabled with "Free trial ended" message
- Prevent task creation/updates for expired patients

## Testing Endpoints

### Check Patient Status
```bash
GET http://localhost:8080/api/subscriptions/patient/123/status

Response:
{
  "patientId": 123,
  "status": "TRIAL",
  "isActive": true,
  "trialStartDate": "2025-10-20",
  "trialEndDate": "2026-01-20",
  "paidStartDate": null,
  "paidEndDate": null
}
```

### Get Expired Patients
```bash
GET http://localhost:8080/api/subscriptions/guardian/40/expired-patients

Response:
{
  "guardianId": 40,
  "expiredPatientIds": [123, 456],
  "count": 2
}
```

## Next Steps (Mobile Implementation Required)

1. **Redesign Payment Screens**
   - Remove plan selection (BASIC/PREMIUM)
   - Show only duration options: 3/6/12 months with prices
   - Add "Skip Payment" button with message about 3-month trial
   - Link payment to specific patient

2. **Implement Login Checks**
   - Patient: Check subscription status on login, auto-logout if expired
   - Guardian: Check for expired patients, show payment prompt
   - Caregiver: Check patient status, disable expired patients in list

3. **Update Payment Flow**
   - Pass `patientId` and `durationMonths` to payment API
   - Show trial + paid period stacking in UI (e.g., "3 free + 6 paid = 9 months")

4. **Testing**
   - Test trial start when caregiver accepts
   - Test payment adds paid period after trial
   - Test subscription expiry logic
   - Test access control for all three user types

## Files Modified
- `backend/src/.../model/GuardianSubscription.java`
- `backend/src/.../service/SubscriptionService.java`
- `backend/src/.../service/PaymentService.java`
- `backend/src/.../controller/SubscriptionController.java`
- `backend/src/.../controller/CaregiverController.java`
- `backend/src/.../controller/PatientController.java`
- `backend/src/.../controller/ArticleController.java` (unrelated fix)
- `database/migrations/update-subscription-model-per-patient-trial.sql`

## Database Migration Status
✅ Migration successfully applied to PostgreSQL database (memora_db)

## Build Status
✅ Backend compiles successfully with no errors
