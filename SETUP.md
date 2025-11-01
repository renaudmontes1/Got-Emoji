# 🛠️ Xcode Project Setup Guide

This guide will help you properly configure the Got Emoji project in Xcode to ensure code sharing between iOS and watchOS targets.

## ✅ Critical Setup Steps

### Step 1: Add Shared Files to Watch App Target

The following files MUST be included in both the iOS and watchOS targets:

1. **Models/EmojiEntry.swift**
2. **Managers/CloudKitManager.swift**
3. **Views/EmojiSelectionView.swift**
4. **Views/HistoryView.swift**

#### How to Add Files to Watch Target:

**Method 1: Using File Inspector (Recommended)**
1. Open the project in Xcode
2. Select `EmojiEntry.swift` in the Project Navigator
3. Open the File Inspector (right panel, first tab - folder icon)
4. Under "Target Membership", check ☑️ **Got Emoji Watch App**
5. Repeat for all four files above

**Method 2: Using Target Settings**
1. Select the project in Project Navigator
2. Select "Got Emoji Watch App" target
3. Go to "Build Phases" tab
4. Expand "Compile Sources"
5. Click "+" and add:
   - EmojiEntry.swift
   - CloudKitManager.swift
   - EmojiSelectionView.swift
   - HistoryView.swift

### Step 2: Verify Code Signing

1. Select the project in Project Navigator
2. For **Got Emoji** target:
   - Select your Team under "Signing & Capabilities"
   - Verify "Automatically manage signing" is checked
   - Bundle Identifier: `rens-corp.Got-Emoji` (or your custom identifier)

3. For **Got Emoji Watch App** target:
   - Select your Team under "Signing & Capabilities"
   - Verify "Automatically manage signing" is checked
   - Bundle Identifier: `rens-corp.Got-Emoji.watchkitapp` (should match parent)

### Step 3: Verify CloudKit Configuration

Both entitlements files are already configured with:
- Container: `iCloud.rens-corp.Got-Emoji`
- Services: CloudKit
- Environment: Development

**If you need to change the container identifier:**

1. Update `Got Emoji.entitlements`:
   ```xml
   <key>com.apple.developer.icloud-container-identifiers</key>
   <array>
       <string>iCloud.YOUR-TEAM-ID.YOUR-APP-NAME</string>
   </array>
   ```

2. Update `Got Emoji Watch App.entitlements` with the SAME identifier

3. Update `CloudKitManager.swift`:
   ```swift
   self.container = CKContainer(identifier: "iCloud.YOUR-TEAM-ID.YOUR-APP-NAME")
   ```

### Step 4: Configure Background Modes (iOS Only)

1. Select "Got Emoji" target
2. Go to "Signing & Capabilities"
3. Click "+ Capability"
4. Add "Background Modes"
5. Check:
   - ☑️ Remote notifications
   - ☑️ Background fetch

### Step 5: Build and Run

#### Build iPhone App:
1. Select "Got Emoji" scheme
2. Select a physical iOS device (CloudKit requires real device)
3. Press `⌘ + R` to build and run

#### Build Watch App:
1. Select "Got Emoji Watch App" scheme
2. Select your paired Apple Watch
3. Press `⌘ + R` to build and run

## 🔍 Verification Checklist

Before running the app, verify:

- [ ] All 4 shared files are in both target memberships
- [ ] Code signing is configured for both targets
- [ ] CloudKit capability is enabled for both targets
- [ ] Same iCloud container ID in both entitlements files
- [ ] Background modes enabled for iOS target
- [ ] Testing on physical devices (not simulator)
- [ ] Same iCloud account logged in on both devices

## 🐛 Common Issues & Fixes

### Issue: "No such module 'CloudKit'"
**Fix**: Make sure you're building for a device, not simulator

### Issue: Shared files not found in Watch app
**Fix**: Verify files are added to "Got Emoji Watch App" target membership

### Issue: CloudKit errors on launch
**Fix**: 
- Check internet connection
- Verify iCloud is enabled in Settings
- Confirm correct container identifier
- Check CloudKit Dashboard for your app

### Issue: Different bundle identifiers
**Fix**: Watch app bundle ID must be: `<iOS Bundle ID>.watchkitapp`

### Issue: Code signing failed
**Fix**:
- Select your Team in both targets
- Ensure certificates are valid
- Try "Automatically manage signing"

## 📱 Testing Tips

### Test Sync Flow:
1. Launch iPhone app
2. Launch Watch app (on paired watch)
3. Select emoji on iPhone
4. Wait 2-3 seconds
5. Verify it appears on Watch
6. Repeat from Watch → iPhone

### Test Offline Mode:
1. Enable Airplane Mode
2. Select multiple emojis
3. Disable Airplane Mode
4. Emojis should sync within 10 seconds

### Reset CloudKit Data:
If you need to start fresh:
1. Go to CloudKit Dashboard
2. Select your container
3. Development → Data
4. Delete all records in `EmojiEntry`

## 🎯 Project Structure Verification

Your file structure should look like:

```
Got Emoji/
├── Got Emoji/
│   ├── Models/
│   │   └── EmojiEntry.swift              ← Add to Watch ✅
│   ├── Managers/
│   │   └── CloudKitManager.swift         ← Add to Watch ✅
│   ├── Views/
│   │   ├── EmojiSelectionView.swift      ← Add to Watch ✅
│   │   └── HistoryView.swift             ← Add to Watch ✅
│   ├── ContentView.swift                  ← iOS only
│   ├── Got_EmojiApp.swift                 ← iOS only
│   ├── AppDelegate.swift                  ← iOS only
│   └── Got Emoji.entitlements
│
└── Got Emoji Watch App/
    ├── ContentView.swift                   ← Watch only
    ├── Got_EmojiApp.swift                  ← Watch only
    └── Got Emoji Watch App.entitlements
```

## ✨ Next Steps

After setup:
1. Build both targets to verify no errors
2. Run on physical devices
3. Test emoji selection and sync
4. Check CloudKit Dashboard for data
5. Test offline/online scenarios

---

**Need help?** Check the main README.md for troubleshooting tips!
