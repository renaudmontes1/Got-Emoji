# CloudKit Schema Fix - recordName Index Required

## Problem
Both iPhone and Watch apps were getting `BAD_REQUEST` errors when fetching records:
```
Field 'recordName' is not marked queryable
```

## Root Cause
CloudKit queries require the `recordName` field to have a QUERYABLE index, even though it's a system field. This is not automatically indexed in custom record types.

## Solution

### 1. Add recordName Index in Development Environment
1. Go to CloudKit Dashboard → Development
2. Navigate to Record Types → **EmojiEntry**
3. Click **Edit Indexes**
4. Add new index:
   - Field: `recordName`
   - Type: QUERYABLE
5. Save changes

### 2. Deploy to Production
1. Go to Schema tab in Development
2. Click "Deploy Schema Changes..."
3. Select Production as destination
4. Confirm deployment
5. Wait 2-3 minutes for deployment

### 3. Final EmojiEntry Schema

| Field Name | Type | Indexes |
|------------|------|---------|
| `emoji` | String | QUERYABLE |
| `timestamp` | Date/Time | QUERYABLE, SORTABLE |
| `device` | String | QUERYABLE |
| `recordName` | System Field | QUERYABLE ⚠️ **Required!** |

## Key Learnings

1. ✅ System fields like `recordName` **are NOT automatically queryable** in custom record types
2. ✅ You **must manually add the index** for recordName if your queries need it
3. ✅ Both Development and Production must have matching schema
4. ✅ Always deploy schema changes from Development → Production
5. ✅ CloudKit renames `recordName` to `recordID` internally (this is normal)

## Result
After adding the recordName index and deploying to Production:
- ✅ Both iPhone and Watch apps fetch records successfully
- ✅ Cross-device sync works correctly
- ✅ No more BAD_REQUEST errors

## Date Fixed
November 1, 2025
