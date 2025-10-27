# Payment System Mobile Implementation Guide

## Overview
This guide explains how to update the Flutter mobile app to work with the new per-patient subscription system with 3-month free trials.

## Backend API Changes Summary

### New Endpoints Available
1. `GET /api/subscriptions/patient/{patientId}/status` - Check subscription status
2. `GET /api/subscriptions/guardian/{guardianId}/expired-patients` - Get expired patients list
3. `GET /api/subscriptions/patient/{patientId}` - Get subscription details
4. `POST /api/subscriptions/{subscriptionId}/cancel` - Cancel subscription

### Subscription Status Values
- `PENDING` - Patient added, waiting for caregiver assignment
- `TRIAL` - 3-month free trial active
- `ACTIVE` - Paid subscription active
- `EXPIRED` - Trial and/or paid subscription ended
- `CANCELLED` - Subscription cancelled by guardian

## Mobile Implementation Tasks

### 1. Create Subscription Service (Update existing)

**File**: `lib/services/subscription_service.dart`

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config.dart';

class SubscriptionService {
  // Check if patient subscription is active
  static Future<Map<String, dynamic>> checkPatientSubscription(int patientId) async {
    try {
      final response = await http.get(
        Uri.parse('${Config.apiBaseUrl}/api/subscriptions/patient/$patientId/status'),
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      throw Exception('Failed to check subscription status');
    } catch (e) {
      print('Error checking subscription: $e');
      rethrow;
    }
  }
  
  // Get expired patients for a guardian
  static Future<List<int>> getExpiredPatients(int guardianId) async {
    try {
      final response = await http.get(
        Uri.parse('${Config.apiBaseUrl}/api/subscriptions/guardian/$guardianId/expired-patients'),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<int>.from(data['expiredPatientIds']);
      }
      return [];
    } catch (e) {
      print('Error getting expired patients: $e');
      return [];
    }
  }
  
  // Get subscription details
  static Future<Map<String, dynamic>?> getSubscriptionDetails(int patientId) async {
    try {
      final response = await http.get(
        Uri.parse('${Config.apiBaseUrl}/api/subscriptions/patient/$patientId'),
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      print('Error getting subscription details: $e');
      return null;
    }
  }
}
```

### 2. Create Duration Selection Screen (Replace subscription_plan_screen.dart)

**File**: `lib/screens/guardian/subscription_duration_screen.dart`

Key Features:
- Remove BASIC/PREMIUM plan selection
- Show only 3 duration options: 3, 6, or 12 months
- Display prices: 499, 999, 1399 LKR
- Add "Skip Payment" button with info text about 3-month trial
- Pass `patientId` to payment screen
- Show if trial is active and calculate total months (trial + paid)

Example UI:
```
┌─────────────────────────────┐
│  Select Subscription Period │
├─────────────────────────────┤
│  ℹ️ 3-Month Free Trial       │
│     (starts when caregiver   │
│      accepts your request)   │
├─────────────────────────────┤
│  ⬜ 3 Months - LKR 499      │
│     (Total: 6 months)        │
├─────────────────────────────┤
│  ⬜ 6 Months - LKR 999      │
│     (Total: 9 months)        │
├─────────────────────────────┤
│  ⬜ 12 Months - LKR 1399    │
│     (Total: 15 months)       │
├─────────────────────────────┤
│  [ Skip Payment ]            │
│  You can pay later           │
└─────────────────────────────┘
```

### 3. Update Payment Screen

**File**: `lib/screens/guardian/payment_screen.dart`

Changes needed:
- Accept `patientId` parameter
- Accept `durationMonths` parameter (3, 6, or 12)
- Remove `planType` from payment request
- Update payment initiation to pass `patientId` and `durationMonths`
- Show message: "Adding {X} months to patient subscription"

### 4. Update Payment Service

**File**: `lib/services/payment_service.dart`

Update method signatures:
```dart
static Future<Map<String, dynamic>> initiatePayment({
  required int guardianId,
  required int patientId,
  required int durationMonths,
  required double amount,
  required String cardHolderName,
  required String cardLastFour,
}) async {
  final response = await http.post(
    Uri.parse('${Config.apiBaseUrl}/api/payments/create'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'guardianId': guardianId,
      'patientId': patientId,  // NEW
      'durationMonths': durationMonths,  // NEW (3, 6, or 12)
      'amount': amount,
      'paymentMethod': 'CARD',
      'cardHolderName': cardHolderName,
      'cardLastFour': cardLastFour,
      // Remove: 'planType'
    }),
  );
  // ...
}
```

### 5. Implement Patient Login Check

**File**: `lib/screens/patient/patient_login_screen.dart` or auth flow

After successful patient login:
```dart
// Check subscription status
final patientId = await AuthService.getCurrentPatientId();
final subscriptionStatus = await SubscriptionService.checkPatientSubscription(patientId);

if (subscriptionStatus['isActive'] == false) {
  // Show dialog: "Your subscription has expired. Please contact your guardian."
  // Then logout and return to login screen
  await AuthService.logout();
  Navigator.of(context).pushReplacementNamed('/login');
  return;
}

// Continue to patient dashboard if active
```

### 6. Update Guardian Dashboard

**File**: `lib/screens/guardian/guardian_dashboard_screen.dart`

On dashboard load:
```dart
// Check for expired patients
final guardianId = await AuthService.getCurrentGuardianId();
final expiredPatientIds = await SubscriptionService.getExpiredPatients(guardianId);

if (expiredPatientIds.isNotEmpty) {
  // Show banner or dialog:
  // "You have {count} patient(s) with expired subscriptions. 
  //  Please renew to continue care services."
  // [Renew Now] button → navigate to patient list with expired filter
}
```

**File**: `lib/screens/guardian/guardian_patients_list_screen.dart`

For each patient:
```dart
// Fetch subscription status
final subscription = await SubscriptionService.checkPatientSubscription(patient.id);

// Show badge on patient card:
if (subscription['status'] == 'TRIAL') {
  // Show: "🎁 Free Trial" badge
  // Show trial end date
} else if (subscription['status'] == 'ACTIVE') {
  // Show: "✅ Active" badge
  // Show expiry date
} else if (subscription['status'] == 'EXPIRED') {
  // Show: "⚠️ Expired" badge (red)
  // Show "Renew Subscription" button
}
```

### 7. Update Caregiver Patient List

**File**: `lib/screens/caregiver/caregiver_patients_list_screen.dart`

For each assigned patient:
```dart
// Check subscription status
final subscription = await SubscriptionService.checkPatientSubscription(patient.id);

if (subscription['status'] == 'EXPIRED' || subscription['isActive'] == false) {
  // Show patient card as disabled (greyed out)
  // Overlay message: "Free trial ended - Subscription required"
  // Disable navigation to patient details
  // Show lock icon 🔒
} else {
  // Normal patient card - clickable
  if (subscription['status'] == 'TRIAL') {
    // Show badge: "Free Trial ends: {date}"
  }
}
```

**File**: `lib/screens/caregiver/patient_care_screen.dart`

When viewing patient:
```dart
// Check subscription before allowing task creation/updates
final subscription = await SubscriptionService.checkPatientSubscription(patientId);

if (!subscription['isActive']) {
  // Disable all edit buttons
  // Show message: "Patient subscription expired - Contact guardian to renew"
  // Show all data as read-only
}
```

### 8. Update Guardian "Add Patient" Flow

**File**: `lib/screens/guardian/add_patient_screen.dart`

After successfully creating patient:
```dart
// Patient created with PENDING subscription automatically (backend does this)

// Show dialog or navigate to:
// "Patient added successfully! 
//  They will get a 3-month free trial when a caregiver accepts.
//  Would you like to add a paid subscription now?"
// 
// [Skip for Now]  [Add Subscription]
//
// If "Add Subscription" → navigate to SubscriptionDurationScreen(patientId: newPatientId)
```

### 9. Create Subscription Info Widget

**File**: `lib/widgets/subscription_info_card.dart`

Reusable widget to display subscription information:
```dart
class SubscriptionInfoCard extends StatelessWidget {
  final Map<String, dynamic> subscription;
  
  @override
  Widget build(BuildContext context) {
    final status = subscription['status'];
    final isActive = subscription['isActive'];
    
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Status badge
            _buildStatusBadge(status, isActive),
            
            // Trial info if applicable
            if (subscription['trialEndDate'] != null)
              _buildDateInfo('Trial Period', 
                subscription['trialStartDate'], 
                subscription['trialEndDate']),
            
            // Paid info if applicable  
            if (subscription['paidEndDate'] != null)
              _buildDateInfo('Paid Period',
                subscription['paidStartDate'],
                subscription['paidEndDate']),
                
            // Total months remaining
            _buildRemainingTime(subscription),
          ],
        ),
      ),
    );
  }
}
```

## Testing Checklist

### Patient Flow
- [ ] Patient login with active subscription → success
- [ ] Patient login with expired subscription → auto-logout with message
- [ ] Patient using app when subscription expires → handled gracefully

### Guardian Flow
- [ ] Add new patient → PENDING subscription created
- [ ] View patient list → see subscription badges (Trial/Active/Expired)
- [ ] Dashboard shows expired patient count
- [ ] Can navigate to payment for expired patient
- [ ] Duration selection screen shows 3/6/12 months options
- [ ] "Skip Payment" button works correctly
- [ ] Payment success → subscription shows paid period added
- [ ] Trial + paid periods stack correctly in UI

### Caregiver Flow
- [ ] Accept connection request → patient gets TRIAL status (check in guardian/patient view)
- [ ] View patient list → expired patients shown as disabled
- [ ] Try to access expired patient → blocked with message
- [ ] Active trial patients show "Free Trial" badge
- [ ] Active paid patients show "Active" badge

### Payment Flow
- [ ] Payment initiated with patientId and durationMonths
- [ ] PayHere integration works with new parameters
- [ ] Success → backend adds paid period correctly
- [ ] Failed payment → subscription remains unchanged

## API Integration Examples

### Check Before Action
```dart
// Before allowing any patient-related action
Future<bool> canAccessPatient(int patientId) async {
  final subscription = await SubscriptionService.checkPatientSubscription(patientId);
  return subscription['isActive'] == true;
}

// Usage:
if (!await canAccessPatient(patientId)) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Subscription Required'),
      content: Text('This patient\'s subscription has expired.'),
      actions: [/* ... */],
    ),
  );
  return;
}
```

### Calculate Total Months
```dart
int calculateTotalMonths(Map<String, dynamic> subscription) {
  int trialMonths = 0;
  int paidMonths = 0;
  
  if (subscription['trialStartDate'] != null && subscription['trialEndDate'] != null) {
    final start = DateTime.parse(subscription['trialStartDate']);
    final end = DateTime.parse(subscription['trialEndDate']);
    trialMonths = ((end.difference(start).inDays) / 30).round();
  }
  
  if (subscription['paidStartDate'] != null && subscription['paidEndDate'] != null) {
    final start = DateTime.parse(subscription['paidStartDate']);
    final end = DateTime.parse(subscription['paidEndDate']);
    paidMonths = ((end.difference(start).inDays) / 30).round();
  }
  
  return trialMonths + paidMonths;
}
```

## Files to Modify/Create

### New Files
- `lib/screens/guardian/subscription_duration_screen.dart`
- `lib/widgets/subscription_info_card.dart`
- `lib/widgets/subscription_status_badge.dart`

### Files to Modify
- `lib/services/subscription_service.dart` - Add new API methods
- `lib/services/payment_service.dart` - Update with patientId/duration
- `lib/screens/guardian/payment_screen.dart` - Accept new parameters
- `lib/screens/guardian/guardian_dashboard_screen.dart` - Check expired patients
- `lib/screens/guardian/guardian_patients_list_screen.dart` - Show status badges
- `lib/screens/guardian/add_patient_screen.dart` - Add payment prompt
- `lib/screens/patient/patient_login_screen.dart` - Add subscription check
- `lib/screens/caregiver/caregiver_patients_list_screen.dart` - Disable expired
- `lib/screens/caregiver/patient_care_screen.dart` - Block expired patient access

### Files to Remove/Deprecate
- `lib/screens/guardian/subscription_plan_screen.dart` (replace with duration screen)

## Next Steps

1. Start with updating `SubscriptionService` to add new API methods
2. Create the new `SubscriptionDurationScreen` 
3. Update payment screens to use duration instead of plan type
4. Implement login checks for patient
5. Update guardian and caregiver dashboards with subscription status
6. Test complete flow: patient creation → caregiver acceptance → trial → payment → expiry

## Important Notes

- **Trial starts automatically** when caregiver accepts - no payment needed
- **Paid period stacks** on top of trial (e.g., 3-month trial + 6-month paid = 9 total months)
- **Guardian can skip payment** initially and pay later when trial ends
- **Patient auto-logout** on expiry - they cannot use the app
- **Caregiver sees but cannot access** expired patients
- **Guardian can access other patients** even if one expires

## Questions or Issues?

Refer to `docs/PAYMENT_BACKEND_IMPLEMENTATION.md` for backend details and API documentation.
