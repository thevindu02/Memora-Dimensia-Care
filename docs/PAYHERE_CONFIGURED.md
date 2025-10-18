# ✅ PayHere Configuration Complete!

## 📋 Your Configuration:

### PayHere Credentials:
- ✅ **Merchant ID**: `1232508` (Your real PayHere sandbox ID)
- ⚠️ **Merchant Secret**: Using temporary test secret
  - You'll need to get your real secret after adding a domain/app in PayHere

### Backend Connection:
- ✅ **PC IP Address**: `192.168.21.233`
- ✅ **Backend URL**: `http://192.168.21.233:8080`
- ⚠️ **Make sure**: Your phone and PC are on the same Wi-Fi network

---

## 🎯 Next Steps:

### 1. Get Your Real Merchant Secret (Optional but Recommended)

In PayHere dashboard:
1. Click **"+ Add Domain/App"** button
2. Fill in:
   - **Type**: Mobile App
   - **App Name**: Memora
   - **Domain**: `*` or `localhost`
3. **Save** and copy the **Merchant Secret**
4. Update `payhere_config.dart` with the real secret

### 2. Make Sure Backend is Running

In a terminal, run:
```powershell
cd "f:\UCSC\Third Year\Group Project II\dimentia-care-platform\backend"
mvn spring-boot:run
```

Check for:
```
Started DimensiaCareApplication in X.XXX seconds
```

### 3. Hot Restart Your Flutter App

In the terminal where Flutter is running, press **`R`** (capital R)

Or stop and run:
```powershell
cd "f:\UCSC\Third Year\Group Project II\dimentia-care-platform\mobile_app"
flutter run
```

### 4. Test the Payment Flow

On your phone:
1. ✅ **Login** as Guardian
2. ✅ **Add Patient** (fill all details and submit)
3. ✅ **Select Plan** (Basic or Premium, choose duration)
4. ✅ **Click "Proceed to Payment"**
5. ✅ **Fill payment form**:
   - Name: Any name
   - Card: `4242 4242 4242 4242`
   - Expiry: `12/26`
   - CVV: `123`
6. ✅ **Click "Pay Now"**
7. ✅ PayHere checkout should open!

---

## 🔧 Troubleshooting:

### If Payment Fails:
- **"Network error"**: 
  - Check backend is running
  - Make sure phone and PC are on same Wi-Fi
  - Verify IP address is correct: `192.168.21.233`

- **"Invalid merchant"**:
  - Add domain/app in PayHere and get real merchant secret
  - Update `payhere_config.dart`

### Check Backend Connection:
On your phone's browser, try opening:
```
http://192.168.21.233:8080/api/subscriptions/guardian/1
```

If you see JSON data, backend connection is working!

---

## 📁 Files Modified:
- ✅ `mobile_app/lib/constants/payhere_config.dart`
  - Merchant ID: `1232508`
  - Backend URL: `http://192.168.21.233:8080`

---

## ✅ Current Status:

- [x] PayHere sandbox account created
- [x] Merchant ID found: `1232508`
- [ ] Merchant Secret obtained (using temp for now)
- [x] PC IP address found: `192.168.21.233`
- [x] Config file updated
- [ ] Backend running
- [ ] App hot restarted on phone
- [ ] Ready to test payment!

---

**Now:**
1. Make sure backend is running
2. Hot restart the Flutter app on your phone (press `R`)
3. Try the payment flow!

Let me know when you're ready or if you encounter any errors! 🚀
