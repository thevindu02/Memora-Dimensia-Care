# Fix: Method 'PUT' is not supported

## Problem
Error: `Method 'PUT' is not supported` when trying to update user profile.

## Root Cause
The backend Spring Boot application was running when the new `@PutMapping` endpoint was added to `UserController.java`. Spring needs to be restarted to recognize the new endpoint.

## Solution

### Step 1: Stop the Backend
Press `Ctrl + C` in the terminal where Spring Boot is running, or:

**In IntelliJ/Eclipse:**
- Click the red stop button

**In Terminal:**
```bash
# Press Ctrl + C to stop the application
```

### Step 2: Restart the Backend

**Option A: Using Maven**
```bash
cd backend
mvn spring-boot:run
```

**Option B: Using IDE**
- Click the green "Run" button again

**Option C: Using JAR**
```bash
cd backend/target
java -jar DimensiaCareApplication-0.0.1-SNAPSHOT.jar
```

### Step 3: Verify Endpoint is Loaded
Check the console output for:
```
Mapped "{[/api/users/{id}],methods=[PUT]}"
```

This confirms the PUT endpoint is registered.

### Step 4: Test Again
1. Open the mobile app
2. Go to Profile screen
3. Click "Edit"
4. Make a change
5. Click "Save Changes"
6. ✅ Should work now!

## Verification

### Check Backend Logs
You should see:
```
User updated successfully with ID: 6
```

Instead of:
```
Request method 'PUT' is not supported
```

### Check Mobile App
- ✅ Green success message: "User updated successfully"
- ❌ Red error bar: "Method 'PUT' is not supported"

## Why This Happens

Spring Boot loads all controller mappings at startup:
1. Application starts → Scans controllers
2. Registers endpoints (GET, POST, etc.)
3. Runs application

If you add a new endpoint (like `@PutMapping`) after startup:
- Spring doesn't know about it
- Requests to that endpoint fail
- **Solution:** Restart to re-scan controllers

## Alternative: Hot Reload (For Development)

To avoid restarting every time, add Spring DevTools:

**pom.xml**
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-devtools</artifactId>
    <scope>runtime</scope>
    <optional>true</optional>
</dependency>
```

This enables automatic restart when code changes.

## Quick Checklist

- [ ] Stop the backend (Ctrl + C)
- [ ] Start the backend (mvn spring-boot:run)
- [ ] Wait for "Started DimensiaCareApplication"
- [ ] Check logs for PUT mapping
- [ ] Test profile edit in mobile app
- [ ] Verify success message appears

## Common Issues

**Issue:** Backend won't stop
- **Solution:** Use `Ctrl + C` or kill process: `taskkill /F /IM java.exe` (Windows)

**Issue:** Port 8080 already in use
- **Solution:** Kill existing process or use different port

**Issue:** Still getting "PUT not supported"
- **Solution:** Check you're hitting the right URL: `http://192.168.8.100:8080/api/users/6`
- **Solution:** Verify backend console shows PUT endpoint registered

## Success Indicators

✅ Backend console shows: `Mapped "{[/api/users/{id}],methods=[PUT]}"`
✅ Backend console shows: `User updated successfully with ID: 6`
✅ Mobile app shows: Green success message
✅ Profile data actually changes in database

---

**TL;DR:** Just restart the backend! 🔄
