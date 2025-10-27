# PayHere "Unauthorized Domain" Error - Fix Guide

## 🐛 Problem
Payment fails with error: **"Unauthorized domain"**

This error occurs because PayHere requires you to register your app's package name or domain in their merchant dashboard before accepting payments.

## 📋 Error Details from Logs
```
D/PaymentMethodFragment: Init Payment method call failed 
I/flutter: Payment Error: Unauthorized domain
```

## 🔧 Solution

### Step 1: Login to PayHere Sandbox Dashboard
1. Go to: https://sandbox.payhere.lk/
2. Login with your credentials
3. Navigate to **Settings → Domains & Credentials**

### Step 2: Add Your App Package Name

#### For Android App:
Add your app's package name: `com.example.mobile_app`

**How to verify your package name:**
- Check `mobile_app/android/app/build.gradle`
- Look for `applicationId` under `defaultConfig`
- Example: `applicationId "com.example.mobile_app"`

#### For iOS App:
Add your app's bundle identifier (if testing on iOS)

#### For Web Testing:
If testing web payment flow, add your localhost or ngrok domain:
- Local: `http://localhost:3000` or `http://192.168.8.102:3000`
- Ngrok: `https://your-ngrok-url.ngrok.io`

### Step 3: Current Configuration

Your current PayHere config (from `mobile_app/lib/constants/payhere_config.dart`):

```dart
Sandbox Mode: true
Merchant ID: 1232508
Backend URL: http://192.168.8.102:8080
App Package: com.example.mobile_app (default Flutter package)
```

### Step 4: Register Domain in PayHere

1. Login to https://sandbox.payhere.lk/
2. Go to **Settings → Domains & Credentials**
3. Click **"Add Domain"** or **"Add App"**
4. Add: `com.example.mobile_app`
5. Save changes
6. Wait 2-5 minutes for changes to propagate

### Step 5: Test Again

After registering the domain:
1. Hot restart your app
2. Add a patient
3. Select subscription duration
4. Click "Continue to Payment"
5. Complete payment

## 📝 Alternative: Use Custom Package Name

If you want to use a custom package name instead of the default:

### For Android:

1. Update `mobile_app/android/app/build.gradle`:
```gradle
android {
    defaultConfig {
        applicationId "lk.memora.dimensiacare"  // Your custom package
        // ... other settings
    }
}
```

2. Register `lk.memora.dimensiacare` in PayHere dashboard

3. Update app imports and references (if needed)

### For iOS:

1. Open project in Xcode
2. Change Bundle Identifier
3. Register in PayHere dashboard

## 🎯 Quick Checklist

Before testing payment again:

- [ ] Logged into PayHere Sandbox: https://sandbox.payhere.lk/
- [ ] Added app package name: `com.example.mobile_app`
- [ ] Waited 2-5 minutes for changes to apply
- [ ] Verified Merchant ID matches: `1232508`
- [ ] Backend is running on: `http://192.168.8.102:8080`
- [ ] Phone and PC are on same network
- [ ] Hot restarted the app

## 🔍 Verification

After registering domain, you should see in logs:
```
✅ Payment initialization successful
✅ PayHere payment sheet opened
```

Instead of:
```
❌ Init Payment method call failed
❌ Payment Error: Unauthorized domain
```

## 📱 Payment Flow After Fix

```
1. Add patient ✅
   ↓
2. Select subscription duration (3/6/12 months) ✅
   ↓
3. Click "Continue to Payment" ✅
   ↓
4. PayHere payment sheet opens ✅ (Should work after domain registered)
   ↓
5. Enter test card details
   ↓
6. Payment success → Backend adds paid subscription period
   ↓
7. Total subscription = 3 months free trial + paid period
```

## 🧪 Test Card Details (Sandbox)

After fixing domain issue, use these test cards:

**Success:**
- Card: 5555 5555 5555 4444
- Expiry: 12/25
- CVV: 123

**Failed:**
- Card: 5555 5555 5555 0001
- Expiry: 12/25
- CVV: 123

## 📚 References

- PayHere Documentation: https://support.payhere.lk/
- PayHere Sandbox: https://sandbox.payhere.lk/
- App Package Name: `com.example.mobile_app`
- Current Merchant ID: `1232508`

---

**Note**: This error is expected for first-time PayHere integration. Once you register your app's package name in the PayHere dashboard, payments will work correctly.
