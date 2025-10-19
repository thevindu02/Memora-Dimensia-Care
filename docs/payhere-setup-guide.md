# PayHere Integration Setup Guide

## 📋 Prerequisites
- PayHere Sandbox account
- Backend server running (local or deployed)
- Flutter development environment

## 🚀 Step-by-Step Setup

### Step 1: Create PayHere Sandbox Account

1. Visit **https://sandbox.payhere.lk/**
2. Click **"Sign Up"** and complete registration
3. Verify your email address
4. Login to your sandbox dashboard

### Step 2: Get Your Credentials

1. After logging in, navigate to:
   ```
   Settings → Domains & Credentials
   ```

2. Copy the following credentials:
   - **Merchant ID** (7-digit number, e.g., `1234567`)
   - **Merchant Secret** (long string for webhook verification)

3. Screenshot for reference:
   ```
   [Settings] → [Domains & Credentials]
   ├── Merchant ID: 1234567
   ├── Merchant Secret: xxxxxxxxxxxx
   └── Notify URL: (add your webhook URL here)
   ```

### Step 3: Configure Webhook URL

You need to configure where PayHere sends payment notifications.

#### Option A: Using ngrok (Local Development)

1. **Install ngrok**: https://ngrok.com/download

2. **Run your backend** (from backend directory):
   ```powershell
   cd "f:\UCSC\Third Year\Group Project II\dimentia-care-platform\backend"
   mvn spring-boot:run
   ```

3. **Start ngrok** in a new terminal:
   ```powershell
   ngrok http 8080
   ```

4. **Copy the HTTPS URL** from ngrok output:
   ```
   Forwarding: https://abc123-xx-xx-xxx-xxx.ngrok-free.app → http://localhost:8080
   ```

5. Your webhook URL will be:
   ```
   https://abc123-xx-xx-xxx-xxx.ngrok-free.app/api/payments/webhook/payhere
   ```

#### Option B: Using Deployed Backend

If your backend is already deployed:
```
https://api.yourdomain.com/api/payments/webhook/payhere
```

### Step 4: Add Webhook URL to PayHere

1. In PayHere sandbox dashboard, go to **Settings → Domains & Credentials**
2. Find the **Notify URL** field
3. Paste your webhook URL
4. Click **Save**

### Step 5: Update Flutter Configuration

1. Open: `mobile_app/lib/constants/payhere_config.dart`

2. Replace the placeholder values:

```dart
// Replace these values:
static const String sandboxMerchantId = "1234567"; // Your 7-digit merchant ID
static const String sandboxMerchantSecret = "YOUR_SECRET_HERE"; // Your merchant secret
static const String backendUrl = "https://abc123.ngrok.io"; // Your ngrok or deployed URL
```

**Example:**
```dart
static const String sandboxMerchantId = "1234567";
static const String sandboxMerchantSecret = "MjM0NTY3ODkwMTIzNDU2Nzg5MDEyMzQ1Njc4OTAxMjM0NTY3ODkw";
static const String backendUrl = "https://abc123-xx-xx-xxx-xxx.ngrok-free.app";
```

### Step 6: Test the Integration

1. **Run Flutter app**:
   ```powershell
   cd "f:\UCSC\Third Year\Group Project II\dimentia-care-platform\mobile_app"
   flutter run
   ```

2. **Test flow**:
   - Login as Guardian
   - Add a new patient
   - Select a subscription plan
   - Proceed to payment
   - Use test card: `4242 4242 4242 4242`
   - Any future expiry date (e.g., 12/26)
   - Any 3-digit CVV (e.g., 123)

3. **Check backend logs** for webhook notification:
   ```
   Payment notification received: {order_id, payment_id, status_code}
   ```

4. **Verify in database**:
   ```sql
   -- Check subscription was created
   SELECT * FROM guardian_subscriptions ORDER BY created_at DESC LIMIT 1;
   
   -- Check payment was recorded
   SELECT * FROM payments ORDER BY created_at DESC LIMIT 1;
   ```

## 🧪 Test Cards (Sandbox Only)

| Card Number | Type | Result |
|-------------|------|--------|
| 4242 4242 4242 4242 | Visa | Success |
| 5555 5555 5555 4444 | Mastercard | Success |

- **Expiry**: Any future date (e.g., 12/26)
- **CVV**: Any 3 digits (e.g., 123)
- **Name**: Any name

## 🔒 Production Setup

When ready for production:

1. Create account at **https://www.payhere.lk/** (production)
2. Complete business verification
3. Get production credentials
4. Update `payhere_config.dart`:
   ```dart
   static const bool useSandbox = false; // Switch to production
   static const String productionMerchantId = "YOUR_PROD_MERCHANT_ID";
   static const String productionMerchantSecret = "YOUR_PROD_SECRET";
   static const String productionBackendUrl = "https://api.yourdomain.com";
   ```

## 📝 Configuration File Structure

```
mobile_app/lib/constants/payhere_config.dart
├── Sandbox Configuration
│   ├── sandboxMerchantId
│   ├── sandboxMerchantSecret
│   └── backendUrl (ngrok or dev server)
├── Production Configuration
│   ├── productionMerchantId
│   ├── productionMerchantSecret
│   └── productionBackendUrl
└── Test Cards (sandbox only)
```

## 🐛 Troubleshooting

### Issue: Payment doesn't complete
- Check if backend is running
- Verify ngrok tunnel is active
- Check PayHere sandbox dashboard logs

### Issue: Webhook not received
- Ensure notify_url is correct in PayHere dashboard
- Check backend logs for incoming requests
- Verify webhook endpoint: `/api/payments/webhook/payhere`

### Issue: Invalid merchant ID error
- Double-check merchant ID from PayHere dashboard
- Ensure no extra spaces in configuration
- Verify sandbox mode is enabled

## 📞 Support

- **PayHere Sandbox Dashboard**: https://sandbox.payhere.lk/
- **PayHere Documentation**: https://support.payhere.lk/
- **PayHere API Docs**: https://support.payhere.lk/api-&-mobile-sdk/

## ✅ Checklist

- [ ] PayHere sandbox account created
- [ ] Merchant ID copied from dashboard
- [ ] Merchant Secret copied from dashboard
- [ ] Backend running (local or deployed)
- [ ] ngrok tunnel created (if local)
- [ ] Webhook URL added to PayHere dashboard
- [ ] `payhere_config.dart` updated with real credentials
- [ ] Flutter app tested with test card
- [ ] Database verified with subscription/payment records

---

**Note**: Never commit real merchant secrets to git. Use environment variables or secure configuration for production.
