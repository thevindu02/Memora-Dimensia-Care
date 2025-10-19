# 🚨 ACTION REQUIRED: Download google-services.json

## What You Need to Do RIGHT NOW

Your Android app **CANNOT** work without the `google-services.json` file!

### Quick Steps (5 minutes):

#### 1. Open Firebase Console

**Go to:** https://console.firebase.google.com/

#### 2. Select Your Project

Click on **"memora-2025"**

#### 3. Add Android App (or download config)

**If you haven't added Android app yet:**

1. Click **"Add app"** button
2. Click the **Android icon**
3. Enter package name: `com.example.mobile_app`
4. Give it a nickname (optional): "Memora Android"
5. Click **"Register app"**
6. Click **"Download google-services.json"**

**If Android app already exists:**

1. Click the **gear icon** (⚙️) → **Project settings**
2. Scroll to **"Your apps"** section
3. Find your Android app
4. Click **"google-services.json"** button to download

#### 4. Place the File

**Move the downloaded file to:**

```
mobile_app\android\app\google-services.json
```

**Full path:**

```
C:\Users\ASUS\OneDrive\Desktop\3rd Year\Group project 2\Memora-Dimensia-Care\mobile_app\android\app\google-services.json
```

**Drag and drop it there!**

#### 5. Rebuild

```bash
cd mobile_app
flutter clean
flutter run
```

---

## ✅ How to Know It's Working

After adding the file and rebuilding, you should see:

```
✓ No more "API key not valid" errors
✓ Console shows: "FCM Token: dGhpc..."
✓ No Firebase errors in logs
```

---

## 📁 File Location Visual

```
Memora-Dimensia-Care/
└── mobile_app/
    └── android/
        ├── build.gradle.kts
        └── app/
            ├── build.gradle.kts
            ├── google-services.json  ← PUT FILE HERE!
            └── src/
```

---

## 🎯 Package Name

**Important:** When registering the Android app in Firebase, use this exact package name:

```
com.example.mobile_app
```

This is defined in your `android/app/build.gradle.kts`:

```kotlin
namespace = "com.example.mobile_app"
```

---

## ⚡ I've Already Updated:

✅ Removed web credentials from `main.dart`  
✅ Added Google Services plugin  
✅ Configured desugaring for notifications  
✅ Updated Android manifest

**Only thing left: You need to download and add `google-services.json`!**

---

## 🆘 Need Help?

If you can't find the download button:

1. Firebase Console → Your Project
2. Settings (⚙️) → Project Settings
3. Scroll down to "Your apps"
4. If no Android app exists, click "Add app" → Android
5. Download the JSON file

---

**Once you have the file, just drag it to the `android/app/` folder and run `flutter clean && flutter run`!**
