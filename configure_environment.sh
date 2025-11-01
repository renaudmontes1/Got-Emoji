#!/bin/bash

echo "🔧 CloudKit Environment Configuration Helper"
echo "==========================================="
echo ""
echo "This script helps you choose which CloudKit environment to use."
echo ""
echo "Options:"
echo ""
echo "1️⃣  Use PRODUCTION for both iPhone and Watch (RECOMMENDED)"
echo "   - Remove environment keys from entitlements"
echo "   - Both apps use Production"
echo "   - Requires schema deployed to Production"
echo "   - Cleanest solution"
echo ""
echo "2️⃣  Keep current (iPhone=Dev, Watch=Prod)"
echo "   - Keep environment key in iPhone entitlements"
echo "   - Watch ignores it anyway, uses Production"
echo "   - Requires schema in BOTH environments"
echo ""
echo "3️⃣  Cancel - Do nothing"
echo ""
read -p "Choose option (1, 2, or 3): " choice

case $choice in
    1)
        echo ""
        echo "📝 Removing environment keys from entitlements..."
        
        # Backup files
        cp "Got Emoji/Got Emoji.entitlements" "Got Emoji/Got Emoji.entitlements.backup"
        cp "Got Emoji Watch App/Got Emoji Watch App.entitlements" "Got Emoji Watch App/Got Emoji Watch App.entitlements.backup"
        echo "✅ Backed up entitlements files"
        
        # Remove environment key from iOS entitlements
        sed -i '' '/<key>com.apple.developer.icloud-container-environment<\/key>/,/<string>Development<\/string>/d' "Got Emoji/Got Emoji.entitlements"
        
        # Remove environment key from Watch entitlements
        sed -i '' '/<key>com.apple.developer.icloud-container-environment<\/key>/,/<string>Development<\/string>/d' "Got Emoji Watch App/Got Emoji Watch App.entitlements"
        
        echo "✅ Removed environment keys from both entitlements"
        echo ""
        echo "🎯 Next steps:"
        echo "1. Deploy schema to Production in CloudKit Dashboard"
        echo "   https://icloud.developer.apple.com"
        echo "   Development → Schema → Deploy Schema Changes"
        echo ""
        echo "2. In Xcode:"
        echo "   - Clean build (⌘+Shift+K)"
        echo "   - Delete apps from devices"
        echo "   - Rebuild and install"
        echo ""
        echo "3. Both apps will use Production ✅"
        echo ""
        echo "Backup files saved as *.backup if you want to restore"
        ;;
    2)
        echo ""
        echo "✅ Keeping current configuration"
        echo ""
        echo "🎯 Next steps:"
        echo "1. Deploy schema to Production in CloudKit Dashboard"
        echo "   (Watch needs it in Production)"
        echo ""
        echo "2. Schema should exist in Development too"
        echo "   (iPhone uses Development)"
        echo ""
        echo "3. Both apps will sync via same container ✅"
        ;;
    3)
        echo ""
        echo "❌ Cancelled - No changes made"
        ;;
    *)
        echo ""
        echo "❌ Invalid choice"
        ;;
esac

echo ""
