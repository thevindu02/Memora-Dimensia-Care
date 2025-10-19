# Database Migrations Guide

## Migration: Allow NULL Passwords for Patient Accounts

### Overview
This migration removes the NOT NULL constraint from the `password` column in the `users` table to support patient accounts that don't require direct login credentials.

### Why This Change?
- **Patient accounts** are managed by guardians and do not need login access
- Guardians handle all patient-related actions through their own accounts
- Removing the NOT NULL constraint aligns the database schema with the application logic

### Migration File
- **File**: `allow-null-passwords-users.sql`
- **Date**: October 18, 2025

---

## How to Run the Migration

### Prerequisites
1. PostgreSQL database access
2. Backup your database before running migrations
3. Database credentials (username, password, database name)

### Option 1: Using psql Command Line

```bash
# Navigate to the migrations directory
cd "f:\UCSC\Third Year\Group Project II\dimentia-care-platform\database\migrations"

# Run the migration
psql -U your_username -d your_database_name -f allow-null-passwords-users.sql

# Example with actual values:
psql -U postgres -d memora_db -f allow-null-passwords-users.sql
```

### Option 2: Using pgAdmin
1. Open pgAdmin and connect to your database
2. Select your database (e.g., `memora_db`)
3. Click on **Tools** → **Query Tool**
4. Open the file `allow-null-passwords-users.sql` or copy its contents
5. Click **Execute/Run** (F5)
6. Verify the success message

### Option 3: Using DBeaver
1. Connect to your PostgreSQL database
2. Right-click on your database → **SQL Editor** → **Open SQL Script**
3. Select `allow-null-passwords-users.sql`
4. Click **Execute SQL Statement** (Ctrl+Enter)
5. Check the results panel for success

### Option 4: Using SQL Query in Any Tool
Simply execute this SQL command:

```sql
ALTER TABLE users 
ALTER COLUMN password DROP NOT NULL;

COMMENT ON COLUMN users.password IS 'Password can be null for patient accounts that are managed by guardians and do not require direct login access';
```

---

## Verification

After running the migration, verify it worked:

### Check the Column Definition
```sql
SELECT 
    column_name, 
    data_type, 
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_name = 'users' 
  AND column_name = 'password';
```

**Expected Result:**
- `is_nullable` should be `YES`

### Test Creating a Patient Without Password
```sql
-- This should now work without errors
INSERT INTO users (f_name, l_name, email, password, role, status, phone_number, created_at, updated_at)
VALUES ('Test', 'Patient', 'test.patient@example.com', NULL, 'PATIENT', 'ACTIVE', '1234567890', NOW(), NOW());
```

### Verify Existing Users Aren't Affected
```sql
SELECT id, email, role, 
       CASE WHEN password IS NULL THEN 'No Password' ELSE 'Has Password' END as password_status
FROM users
ORDER BY created_at DESC
LIMIT 10;
```

---

## Rollback (If Needed)

If you need to revert this migration:

```sql
-- WARNING: This will fail if any users have NULL passwords
-- You must first set passwords for those users

-- Step 1: Find users with null passwords
SELECT id, email, role FROM users WHERE password IS NULL;

-- Step 2: Set a default password for those users (if any)
-- UPDATE users SET password = 'TEMP_PASSWORD_HASH' WHERE password IS NULL;

-- Step 3: Restore the NOT NULL constraint
ALTER TABLE users 
ALTER COLUMN password SET NOT NULL;

-- Step 4: Remove the comment
COMMENT ON COLUMN users.password IS NULL;
```

---

## Testing After Migration

### Test Case 1: Create Patient Without Password (Frontend)
1. Login as a Guardian
2. Navigate to "Add Patient"
3. Fill in all patient details
4. Click "Save Patient"
5. **Expected**: Patient should be created successfully and redirected to subscription plans

### Test Case 2: Create Guardian With Password (Should Still Work)
1. Go to Guardian Signup
2. Fill in all details including password
3. Submit the form
4. **Expected**: Guardian account created with encrypted password

### Test Case 3: Verify Database
```sql
-- Check that patients can have null passwords
SELECT id, email, role, password IS NULL as no_password
FROM users 
WHERE role = 'PATIENT'
ORDER BY created_at DESC
LIMIT 5;

-- Check that other roles have passwords
SELECT id, email, role, password IS NULL as no_password
FROM users 
WHERE role != 'PATIENT'
ORDER BY created_at DESC
LIMIT 5;
```

---

## Troubleshooting

### Error: "permission denied for table users"
**Solution**: You need database owner or superuser privileges
```bash
psql -U postgres -d your_database_name -f allow-null-passwords-users.sql
```

### Error: "relation 'users' does not exist"
**Solution**: Check database name and table name
```sql
-- List all tables
\dt

-- Or in SQL:
SELECT tablename FROM pg_tables WHERE schemaname = 'public';
```

### Error: "cannot drop not null constraint"
**Solution**: The constraint might already be dropped
```sql
-- Check current constraint status
SELECT conname, contype, confupdtype, confdeltype
FROM pg_constraint
WHERE conrelid = 'users'::regclass;
```

---

## Impact Assessment

### What This Changes
✅ Patient accounts can be created without passwords  
✅ Guardians can add patients successfully  
✅ System can proceed to subscription flow  

### What This Doesn't Change
❌ No impact on existing user accounts  
❌ No impact on authentication system  
❌ No impact on guardian, caregiver, or admin accounts  
❌ No impact on login functionality  

---

## Next Steps After Migration

1. ✅ Run the migration script
2. ✅ Restart Spring Boot backend (to clear any caches)
3. ✅ Test patient creation flow
4. ✅ Verify guardian login still works
5. ✅ Test the full subscription flow
6. ✅ Monitor backend logs for any issues

---

## Related Files

### Frontend
- `mobile_app/lib/screens/guardian/guardian_add_patient_screen.dart` - Updated to send null password

### Backend
- `backend/src/main/java/Memora/DimensiaCareApplication/controller/UserController.java` - Handles null passwords
- `backend/src/main/java/Memora/DimensiaCareApplication/model/User.java` - Password marked as nullable

### Database
- `database/migrations/allow-null-passwords-users.sql` - This migration script

---

## Support

If you encounter any issues:
1. Check the backend console logs
2. Verify the migration ran successfully
3. Test with a simple SQL INSERT query
4. Review the troubleshooting section above
5. Check that the Spring Boot backend restarted after migration

---

## Production Checklist

Before running in production:
- [ ] Backup database
- [ ] Test migration in staging/dev environment first
- [ ] Schedule maintenance window (if needed)
- [ ] Notify team members
- [ ] Run migration during low-traffic period
- [ ] Monitor application logs after deployment
- [ ] Test patient creation immediately after
- [ ] Have rollback plan ready
