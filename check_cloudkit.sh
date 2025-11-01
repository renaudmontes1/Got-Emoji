#!/bin/bash

# Got Emoji - CloudKit Diagnostic Script
# Run this to check your CloudKit configuration

echo "🔍 Got Emoji - CloudKit Configuration Check"
echo "============================================"
echo ""

# Check if we're in the right directory
if [ ! -d "Got Emoji" ]; then
    echo "❌ Error: Run this script from the 'Got Emoji' project root"
    echo "   Example: cd '/Users/admin/Documents/Got Emoji' && ./check_cloudkit.sh"
    exit 1
fi

echo "📱 Checking iOS Entitlements..."
if grep -q "iCloud.rens-corp.Got-Emoji" "Got Emoji/Got Emoji.entitlements"; then
    echo "   ✅ iOS container ID: iCloud.rens-corp.Got-Emoji"
else
    echo "   ❌ iOS entitlements missing or incorrect"
fi

echo ""
echo "⌚ Checking Watch Entitlements..."
if grep -q "iCloud.rens-corp.Got-Emoji" "Got Emoji Watch App/Got Emoji Watch App.entitlements"; then
    echo "   ✅ Watch container ID: iCloud.rens-corp.Got-Emoji"
else
    echo "   ❌ Watch entitlements missing or incorrect"
fi

echo ""
echo "🔧 Checking CloudKitManager..."
if grep -q 'CKContainer(identifier: "iCloud.rens-corp.Got-Emoji")' "Got Emoji/Managers/CloudKitManager.swift"; then
    echo "   ✅ CloudKitManager container ID matches"
else
    echo "   ❌ CloudKitManager container ID mismatch"
fi

echo ""
echo "📂 Checking Shared Files..."
files=("Models/EmojiEntry.swift" "Managers/CloudKitManager.swift" "Views/EmojiSelectionView.swift" "Views/HistoryView.swift")
for file in "${files[@]}"; do
    if [ -f "Got Emoji/$file" ]; then
        echo "   ✅ $file exists"
    else
        echo "   ❌ $file missing"
    fi
done

echo ""
echo "🌐 Checking Network..."
if ping -c 1 icloud.developer.apple.com &> /dev/null; then
    echo "   ✅ Can reach iCloud servers"
else
    echo "   ⚠️  Cannot reach iCloud servers (check internet)"
fi

echo ""
echo "✅ Configuration check complete!"
echo ""
echo "Next Steps:"
echo "1. Verify all items show ✅"
echo "2. If any show ❌, fix those issues"
echo "3. Check CloudKit Dashboard: https://icloud.developer.apple.com"
echo "4. Rebuild app in Xcode"
echo ""
