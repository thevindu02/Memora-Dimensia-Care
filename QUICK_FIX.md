# Quick Start: Fix Patient Creation Error

## The Problem
Getting this error when adding patients:
```
ERROR: null value in column "password" of relation "users" violates not-null constraint
```

## The Solution (3 Steps)

### Step 1: Run Database Migration

Open your PostgreSQL terminal or pgAdmin and run:

```sql
ALTER TABLE users ALTER COLUMN password DROP NOT NULL;
```

**Or use the migration file:**
```bash
psql -U postgres -d memora_db -f database/migrations/allow-null-passwords-users.sql
```

### Step 2: Restart Backend

Stop and restart your Spring Boot application:
- Stop the Java terminal/server
- Run it again

### Step 3: Test

1. Login as guardian in the mobile app
2. Try to add a patient
3. Fill in all details
4. Click "Save Patient"
4. It should work now! ✅

---

## What Changed?

### Frontend (Flutter)
- Now sends `password: null` for patient accounts
- Patients don't need passwords (guardians manage them)

### Database
- Password column now allows NULL values
- Only needed for patient accounts

### Backend
- Already handled null passwords correctly
- Just added better logging

---

## Verify It Worked

```sql
-- Check that password is now nullable
SELECT column_name, is_nullable
FROM information_schema.columns
WHERE table_name = 'users' AND column_name = 'password';
-- Should show: is_nullable = 'YES'
```

---

## Troubleshooting

**Still getting the error?**
1. Make sure migration ran successfully
2. Restart the backend
3. Check you're on the latest code

**Can't run migration?**
- Make sure you have database admin privileges
- Try using `psql -U postgres` (superuser)

---

## Need More Details?

See full documentation:
- `database/migrations/README.md` - Complete migration guide
- `docs/patient-password-fix.md` - Detailed explanation

---

**That's it! Your patient creation should work now.** 🎉
