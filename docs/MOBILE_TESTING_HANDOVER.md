# 🚀 PayHere Integration - Setup Guide for Mobile Testing

## 📌 Overview

This project now has **complete PayHere payment integration** for guardian subscription plans. The backend, database, and Flutter code are all ready. This guide will help you test it on Android emulator/device.

---

## ✅ What's Already Done

### Backend (100% Complete)
- ✅ Database tables: `guardian_subscriptions`, `payments`
- ✅ Controllers: `SubscriptionController`, `PaymentController`
- ✅ Services: `SubscriptionService`, `PaymentService`
- ✅ Repositories: All configured
- ✅ Webhook endpoint: `/api/payments/webhook/payhere`

### Flutter Mobile App (Ready for Testing)
- ✅ Patient creation flow (with patientId passing)
- ✅ Subscription plan selection screen
- ✅ Payment screen with PayHere SDK
- ✅ Success/failure screens
- ✅ Configuration file: `payhere_config.dart`
- ✅ Web simulation mode (for development)
- ✅ Mobile mode (real PayHere - needs testing)

### PayHere Configuration
- ✅ Merchant ID: `1232508`
- ⚠️ Merchant Secret: Needs real secret from PayHere dashboard
- ✅ Sandbox mode enabled
- ✅ Test cards documented

---

## 🎯 Your Task: Mobile Testing

### Step 1: Pull Latest Code
```bash
cd path/to/dimentia-care-platform
git checkout volunteer
git pull origin volunteer
```

### Step 2: Setup PayHere Credentials

#### A) Get Real Merchant Secret
1. Go to https://sandbox.payhere.lk/
2. Login (credentials should be shared by team)
3. Navigate: **Integrations** → Click **"+ Add Domain/App"**
4. Fill form:
   - Type: Mobile App
   - App Name: Memora
   - Domain: `*` (for testing)
5. Save and copy the **Merchant Secret**

#### B) Update Configuration
File: `mobile_app/lib/constants/payhere_config.dart`

```dart
// Line ~25: Replace the merchant secret
static const String sandboxMerchantSecret = "YOUR_REAL_MERCHANT_SECRET_HERE";

// Line ~31: Update with your PC's IP (if testing from physical device)
// Run 'ipconfig' to find your IPv4 address
static const String backendUrl = "http://YOUR_PC_IP:8080";
// For emulator, use: "http://10.0.2.2:8080"
```

### Step 3: Run Backend
```bash
cd backend
mvn spring-boot:run
```

Verify it starts: Look for `Started DimensiaCareApplication`

### Step 4: Run Mobile App

#### Option A: Android Emulator
```bash
cd mobile_app
flutter clean
flutter pub get
flutter run
```

#### Option B: Physical Android Device
1. Enable Developer Mode on phone
2. Enable USB Debugging
3. Connect via USB
4. Run: `flutter devices` (verify phone is detected)
5. Run: `flutter run`

### Step 5: Test Complete Flow

#### Test Scenario:
1. **Login** as Guardian
   - Use existing guardian account or create new
   
2. **Add Patient**
   - Navigate: Dashboard → Add Patient
   - Fill all required fields:
     - Name, DOB, Gender
     - Contact, Address
     - Dementia Stage, Type, Diagnosis Date
     - Relationship
   - Click **Submit**
   - ✅ Should navigate to Subscription Plans

3. **Select Subscription Plan**
   - Choose: Basic or Premium
   - Select: 3/6/12 months
   - Click **"Proceed to Payment"**
   - ✅ Should navigate to Payment Screen

4. **Complete Payment**
   - Fill payment form:
     - Cardholder Name: Any name
     - Card Number: `4242 4242 4242 4242` (Visa test card)
     - Expiry: Any future date (e.g., `12/26`)
     - CVV: Any 3 digits (e.g., `123`)
   - Click **"Pay Now"**
   - ✅ PayHere checkout should open in the app
   - Complete the payment in PayHere
   - ✅ Should redirect to Success Screen

5. **Verify in Database**
   ```sql
   -- Check subscription created
   SELECT * FROM guardian_subscriptions 
   WHERE patient_id = [YOUR_PATIENT_ID] 
   ORDER BY created_at DESC LIMIT 1;
   
   -- Check payment recorded
   SELECT * FROM payments 
   ORDER BY created_at DESC LIMIT 1;
   ```

---

## 🧪 Test Cards

### Visa (Success)
- **Card Number**: `4242 4242 4242 4242`
- **Expiry**: Any future date (e.g., `12/26`)
- **CVV**: Any 3 digits (e.g., `123`)
- **Name**: Any name

### Mastercard (Success)
- **Card Number**: `5555 5555 5555 4444`
- **Expiry**: Any future date
- **CVV**: Any 3 digits
- **Name**: Any name

---

## 📊 Expected Results

### Success Flow:
```
1. Patient Created ✓
   → patientId generated (e.g., 5)
   
2. Navigate to Subscription Plans ✓
   → patientId & guardianId passed correctly
   
3. Select Plan ✓
   → Basic/Premium, 3/6/12 months
   
4. Navigate to Payment ✓
   → Plan details shown
   
5. Submit Payment ✓
   → Subscription created (status: PENDING)
   → Payment record created (status: PENDING)
   
6. PayHere Opens ✓
   → User completes payment on PayHere
   
7. Payment Success ✓
   → Payment status: SUCCESS
   → Subscription status: ACTIVE
   → Redirect to success screen
   
8. Database Updated ✓
   → guardian_subscriptions has ACTIVE record
   → payments has SUCCESS record
```

---

## 🐛 Troubleshooting

### Issue: PayHere doesn't open
**Solution**: 
- Check PayHere SDK is installed: `flutter pub get`
- Verify merchant credentials are correct
- Check you're NOT running on web (PayHere doesn't support web)

### Issue: "Network error"
**Solution**:
- Verify backend is running (port 8080)
- If using physical device, check PC IP is correct
- Ensure phone and PC are on same WiFi network

### Issue: Payment succeeds but subscription not activated
**Solution**:
- Check backend logs for webhook notification
- Verify PayHere webhook URL is configured in dashboard
- Check `PaymentService.updatePaymentStatusByOrderId()` method

### Issue: "Patient information missing"
**Solution**:
- This was fixed! PatientId is now extracted as `patientID` (capital ID)
- If still happening, check console logs for debug output

---

## 📹 Demo Video Checklist

For your university presentation, record:
1. ✅ Starting the app
2. ✅ Guardian login
3. ✅ Adding a new patient (show form filling)
4. ✅ Automatic navigation to subscription plans
5. ✅ Selecting a plan (show pricing)
6. ✅ Proceeding to payment
7. ✅ **PayHere checkout opening** (important!)
8. ✅ Completing payment with test card
9. ✅ Success screen showing
10. ✅ (Optional) Show database records in pgAdmin

---

## 📁 Key Files to Understand

### Flutter
```
mobile_app/lib/
├── screens/guardian/
│   ├── guardian_add_patient_screen.dart  (Patient creation)
│   ├── subscription_plan_screen.dart     (Plan selection)
│   └── payment_screen.dart               (PayHere integration)
├── services/
│   ├── patient_service.dart              (Patient APIs)
│   ├── subscription_service.dart         (Subscription APIs)
│   └── payment_service.dart              (Payment APIs)
└── constants/
    └── payhere_config.dart               (PayHere credentials)
```

### Backend
```
backend/src/main/java/.../
├── controller/
│   ├── SubscriptionController.java
│   └── PaymentController.java
├── service/
│   ├── SubscriptionService.java
│   └── PaymentService.java
├── model/
│   ├── GuardianSubscription.java
│   └── Payment.java
└── repository/
    ├── GuardianSubscriptionRepository.java
    └── PaymentRepository.java
```

---

## 🎯 Success Criteria

For your university project demonstration:

✅ **Functional Requirements:**
- [ ] Guardian can add patients
- [ ] Patient information persists correctly
- [ ] Subscription plans display with pricing
- [ ] Payment flow works end-to-end
- [ ] PayHere integration is functional
- [ ] Database records are created correctly
- [ ] Success/failure handling works

✅ **Technical Implementation:**
- [ ] RESTful API design
- [ ] Database normalization (foreign keys, constraints)
- [ ] Error handling
- [ ] Payment gateway integration
- [ ] Mobile app UI/UX
- [ ] Cross-platform considerations (web vs mobile)

✅ **Presentation Points:**
- [ ] Live demo on Android device
- [ ] Code walkthrough
- [ ] Database schema explanation
- [ ] Payment flow diagram
- [ ] Security considerations (sandbox vs production)

---

## 📞 Contact & Collaboration

**Current Status**: 
- Backend: ✅ 100% Complete
- Flutter UI: ✅ 100% Complete
- PayHere Integration: ✅ Code Complete, Needs Mobile Testing
- Web Simulation: ✅ Working (for development)

**Next Steps**:
1. Test on Android emulator/device
2. Verify PayHere checkout works
3. Record demo video
4. Document any issues found
5. Merge to main branch

---

## 🎓 University Project Notes

### What Makes This Project Strong:

1. **Real Payment Gateway**: Not simulated - actual PayHere integration
2. **Complete Backend**: RESTful APIs, database design, business logic
3. **Mobile Development**: Cross-platform Flutter app
4. **Security**: Sandbox testing, proper credentials management
5. **Error Handling**: Comprehensive validation and error messages
6. **Scalability**: Modular architecture, separate services

### Possible Improvements (For Extra Credit):
- Add payment history screen for guardians
- Implement subscription renewal reminders
- Add email notifications on successful payment
- Create admin dashboard for managing subscriptions
- Add refund/cancellation functionality
- Implement subscription auto-renewal

---

## 📚 Documentation

All documentation is in the `docs/` folder:
- `payhere-setup-guide.md` - Full PayHere setup
- `PAYHERE_QUICK_START.md` - Quick reference
- `payhere-dashboard-guide.md` - Dashboard navigation
- `WEB_PAYMENT_TESTING.md` - Web simulation info
- `ISSUE_RESOLVED_PATIENT_ID.md` - Bug fix documentation

---

**Good luck with testing! The code is solid and ready for demonstration.** 🚀

If you encounter any issues, check the troubleshooting section or review the debug logs in the Flutter console.
