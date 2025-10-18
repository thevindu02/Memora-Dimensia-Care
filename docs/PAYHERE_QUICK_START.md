# 🚀 Quick Setup: PayHere Integration

## TL;DR - Fast Track Setup

### 1️⃣ Get PayHere Credentials (2 minutes)
```
1. Go to: https://sandbox.payhere.lk/
2. Sign up & login
3. Navigate: Settings → Domains & Credentials
4. Copy:
   - Merchant ID (e.g., 1234567)
   - Merchant Secret (long string)
```

### 2️⃣ Expose Backend with ngrok (1 minute)
```powershell
# Terminal 1: Start backend
cd "f:\UCSC\Third Year\Group Project II\dimentia-care-platform\backend"
mvn spring-boot:run

# Terminal 2: Start ngrok
ngrok http 8080

# Copy the HTTPS URL: https://xxxx-xx-xxx.ngrok-free.app
```

### 3️⃣ Configure PayHere Dashboard (30 seconds)
```
1. In PayHere dashboard: Settings → Domains & Credentials
2. Notify URL: https://your-ngrok-url.ngrok-free.app/api/payments/webhook/payhere
3. Click Save
```

### 4️⃣ Update Flutter Config (1 minute)
Open: `mobile_app/lib/constants/payhere_config.dart`

```dart
static const String sandboxMerchantId = "1234567"; // FROM STEP 1
static const String sandboxMerchantSecret = "YOUR_SECRET_HERE"; // FROM STEP 1
static const String backendUrl = "https://xxxx.ngrok-free.app"; // FROM STEP 2
```

### 5️⃣ Run & Test (2 minutes)
```powershell
cd "f:\UCSC\Third Year\Group Project II\dimentia-care-platform\mobile_app"
flutter run

# In app:
# - Login as Guardian
# - Add Patient
# - Select Plan
# - Pay with: 4242 4242 4242 4242
```

---

## 📋 What You Need

| Item | Where to Get It | Example |
|------|----------------|---------|
| Merchant ID | PayHere Dashboard → Settings | `1234567` |
| Merchant Secret | PayHere Dashboard → Settings | `MjM0NTY3ODkw...` |
| Backend URL | ngrok or deployed URL | `https://abc.ngrok-free.app` |
| Webhook URL | Backend URL + path | `{backend_url}/api/payments/webhook/payhere` |

---

## 🧪 Test Card

**Card Number**: `4242 4242 4242 4242`  
**Expiry**: Any future date (e.g., `12/26`)  
**CVV**: Any 3 digits (e.g., `123`)  
**Name**: Any name

---

## ⚠️ Common Mistakes

❌ **Don't use**: `1228024` (example merchant ID)  
✅ **Use**: Your real merchant ID from PayHere dashboard

❌ **Don't use**: `http://` URLs (must be HTTPS)  
✅ **Use**: `https://` URLs from ngrok or your server

❌ **Don't forget**: Add webhook URL to PayHere dashboard  
✅ **Remember**: Settings → Domains & Credentials → Notify URL

---

## 🔍 Quick Verify

### Check if setup is correct:
```dart
// Open: payhere_config.dart
// Should NOT see:
❌ static const String sandboxMerchantId = "YOUR_SANDBOX_MERCHANT_ID";

// Should see:
✅ static const String sandboxMerchantId = "1234567"; // Your actual ID
```

### Check if backend receives webhooks:
```bash
# Watch backend logs while testing payment
# You should see:
✅ "Payment notification received from PayHere"
```

### Check database:
```sql
-- Should have records:
SELECT * FROM guardian_subscriptions ORDER BY created_at DESC LIMIT 1;
SELECT * FROM payments ORDER BY created_at DESC LIMIT 1;
```

---

## 🆘 Still Having Issues?

1. **Payment screen shows error**:
   - Check if backend is running (`mvn spring-boot:run`)
   - Check if ngrok tunnel is active (`ngrok http 8080`)

2. **Webhook not working**:
   - Verify notify URL in PayHere dashboard
   - Check backend logs for incoming POST requests
   - Ensure URL is HTTPS (not HTTP)

3. **Invalid merchant ID**:
   - Double-check you copied the correct ID from PayHere
   - No extra spaces before/after the ID
   - Make sure you're using SANDBOX merchant ID, not production

---

## 📚 Full Documentation

For detailed setup: See `docs/payhere-setup-guide.md`
