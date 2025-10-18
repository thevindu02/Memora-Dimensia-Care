# Debugging: Patient Information Missing Error

## Issue
When adding a patient and proceeding to subscription plans, you're getting:
**"Error: Patient information missing"**

## What This Means
The `patientId` is null when reaching the subscription plan screen, which triggers the validation check in `_proceedToPayment()`.

## Debug Logging Added

I've added comprehensive debug logging to track the data flow:

### 1. Patient Service (`patient_service.dart`)
```dart
// Logs what the backend returns after creating a patient
print('Backend response: $responseData');
print('Extracted patientId: ${responseData['patientId']}');
```

### 2. Guardian Add Patient Screen (`guardian_add_patient_screen.dart`)
```dart
// Logs what's being sent to the subscription screen
print('patientId: ${patientResult.patientId}');
print('guardianId: $guardianId');
```

### 3. Subscription Plan Screen (`subscription_plan_screen.dart`)
```dart
// Logs what's received on the subscription screen
print('Arguments received: $args');
print('Extracted patientId: $patientId');
print('Extracted guardianId: $guardianId');
```

## How to Debug

### Step 1: Hot Restart the App
```powershell
cd "f:\UCSC\Third Year\Group Project II\dimentia-care-platform\mobile_app"
flutter run
# Or press 'r' in the running terminal to hot reload
# Or press 'R' to hot restart
```

### Step 2: Try Adding a Patient Again
1. Login as Guardian
2. Add a new patient
3. Watch the console/terminal output

### Step 3: Check the Console Output

You should see three debug sections in order:

```
=== Patient Service Debug ===
Backend response: {patientId: 123, ...}
Extracted patientId: 123
Type: int
=============================

=== Navigation Debug ===
Navigating to subscription plans with:
patientId: 123
guardianId: 456
========================

=== SubscriptionPlanScreen Debug ===
Arguments received: {patientId: 123, guardianId: 456}
Extracted patientId: 123
Extracted guardianId: 456
===================================
```

## Possible Issues and Solutions

### Issue 1: Backend Not Returning patientId
**Console shows:**
```
Backend response: {message: Patient added successfully}  ← No patientId!
```

**Solution:** Check the backend `PatientController.java` to ensure it returns the patientId in the response:
```java
// Should return:
return ResponseEntity.ok(Map.of(
    "patientId", savedPatient.getId(),
    "message", "Patient added successfully"
));
```

### Issue 2: patientId is String Instead of Int
**Console shows:**
```
Type: _InternalLinkedHashMap<String, dynamic>  ← Wrong type!
```

**Solution:** The backend might be returning nested data. Update extraction:
```dart
patientId: responseData['patient']?['id'] ?? responseData['patientId']
```

### Issue 3: Arguments Not Passed
**Console shows:**
```
Arguments received: null  ← Navigation arguments missing!
```

**Solution:** This is unlikely since we're using `Navigator.pushNamedAndRemoveUntil` with arguments, but check if there's a route interceptor.

### Issue 4: Backend Not Running
**Console shows:**
```
Network error: Failed host lookup: 'localhost'
```

**Solution:** 
1. Check if backend is running:
```powershell
cd "f:\UCSC\Third Year\Group Project II\dimentia-care-platform\backend"
mvn spring-boot:run
```
2. Check `api_constants.dart` has correct backend URL

## Quick Fixes to Try

### Fix 1: Add Fallback ID
If backend is inconsistent, add a fallback in the navigation:

```dart
Navigator.pushNamedAndRemoveUntil(
  context,
  AppRoutes.guardianSubscriptionPlans,
  (route) => false,
  arguments: {
    'patientId': patientResult.patientId ?? 0,  // Fallback to 0 if null
    'guardianId': guardianId,
  },
);
```

### Fix 2: Pass Data Differently
Instead of relying on route arguments, use a state management solution or pass data through a provider.

### Fix 3: Skip Validation Temporarily
For testing, comment out the validation:
```dart
void _proceedToPayment() {
  // if (patientId == null) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text('Error: Patient information missing'),
  //       backgroundColor: Colors.red,
  //     ),
  //   );
  //   return;
  // }
  
  // Use hardcoded ID for testing
  final testPatientId = patientId ?? 999;
  
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PaymentScreen(
        planType: selectedPlan!,
        duration: selectedDuration!,
        price: _getPrice(selectedPlan!, selectedDuration!),
        patientId: testPatientId,
      ),
    ),
  );
}
```

## Next Steps

1. **Hot restart** the app to apply the debug logging
2. **Try adding a patient** again
3. **Copy the console output** and share it
4. Based on the output, we'll know exactly where the data is getting lost

## Files Modified

- ✅ `mobile_app/lib/services/patient_service.dart` - Added response logging
- ✅ `mobile_app/lib/screens/guardian/guardian_add_patient_screen.dart` - Added navigation logging
- ✅ `mobile_app/lib/screens/guardian/subscription_plan_screen.dart` - Added argument reception logging

All changes are non-breaking and only add debug print statements.
