#!/bin/bash

echo "🔍 CloudKit BAD_REQUEST Diagnostic"
echo "=================================="
echo ""

echo "📋 Checking code configuration..."
echo ""

# Check EmojiEntry record type name
echo "1️⃣ Record Type Name:"
RECORD_TYPE=$(grep 'recordType:' "Got Emoji/Models/EmojiEntry.swift" | grep -o '"[^"]*"' | tr -d '"')
echo "   Code uses: '$RECORD_TYPE'"
echo "   ✅ CloudKit Dashboard should show: 'EmojiEntry'"
if [ "$RECORD_TYPE" = "EmojiEntry" ]; then
    echo "   ✅ MATCH"
else
    echo "   ❌ MISMATCH - Update code or dashboard!"
fi

echo ""
echo "2️⃣ Field Names in Code:"
grep 'record\[' "Got Emoji/Models/EmojiEntry.swift" | grep -o '\["[^"]*"\]' | sort -u | while read line; do
    field=$(echo $line | tr -d '[]"')
    echo "   - $field"
done

echo ""
echo "3️⃣ Container Identifier:"
CONTAINER=$(grep 'CKContainer(identifier:' "Got Emoji/Managers/CloudKitManager.swift" | grep -o '"[^"]*"' | tr -d '"')
echo "   Code uses: '$CONTAINER'"
echo "   ✅ CloudKit Dashboard should show: 'iCloud.rens-corp.Got-Emoji'"

echo ""
echo "4️⃣ Required Field Types in CloudKit Dashboard:"
echo "   Field: emoji      → Type: String"
echo "   Field: timestamp  → Type: Date/Time"
echo "   Field: device     → Type: String"

echo ""
echo "=================================="
echo "🎯 ACTION ITEMS:"
echo ""
echo "1. Go to: https://icloud.developer.apple.com"
echo "2. Select container: $CONTAINER"
echo "3. Select: DEVELOPMENT (not Production!)"
echo "4. Go to: Schema → Record Types → EmojiEntry"
echo "5. Verify fields match exactly:"
echo "   - emoji: String"
echo "   - timestamp: Date/Time"
echo "   - device: String"
echo ""
echo "6. Go to: Logs tab"
echo "7. Find recent RecordSave errors"
echo "8. Click to expand"
echo "9. Look for 'Server Message' field"
echo "10. Report what it says!"
echo ""
echo "=================================="
echo ""
