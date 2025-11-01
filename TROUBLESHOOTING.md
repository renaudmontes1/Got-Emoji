# 🔧 Troubleshooting Guide

## Common Issues and Solutions

### 🚫 Build Errors

#### Error: "No such module 'CloudKit'"
**Cause:** Building for iOS Simulator
**Solution:**
- Select a physical device as build destination
- CloudKit only works on real devices
- Cannot test in Simulator

#### Error: "Cannot find 'EmojiEntry' in scope" (Watch App)
**Cause:** Shared files not added to Watch target
**Solution:**
1. Select `EmojiEntry.swift` in Project Navigator
2. Open File Inspector (⌘+⌥+1)
3. Check "Got Emoji Watch App" under Target Membership
4. Repeat for all 4 shared files
5. Clean build folder (⌘+Shift+K)
6. Build again (⌘+B)

#### Error: "Undefined symbol _$s9Got_Emoji..."
**Cause:** Missing file in target
**Solution:**
- Same as above - ensure all shared files in both targets
- Verify in Build Phases → Compile Sources

#### Error: "Signing for 'Got Emoji' requires a development team"
**Cause:** No team selected
**Solution:**
1. Select project in Navigator
2. Select target
3. Signing & Capabilities tab
4. Choose your Team from dropdown
5. Enable "Automatically manage signing"

### ☁️ CloudKit Errors

#### Error: "Account Temporarily Unavailable"
**Cause:** iCloud account issues
**Solution:**
1. Open Settings on device
2. Tap your name at top
3. Tap iCloud
4. Ensure iCloud Drive is ON
5. Sign out and sign back in if needed
6. Restart device

#### Error: "Network unavailable"
**Cause:** No internet connection
**Solution:**
- Connect to WiFi or cellular
- Entries will queue and sync when online
- Check Settings → Cellular → Got Emoji (enable if needed)

#### Error: "Zone Not Found"
**Cause:** CloudKit zone not initialized
**Solution:**
- This is normal on first launch
- CloudKit creates zone automatically
- Wait 10-30 seconds and try again
- Force quit and relaunch app

#### Error: "Request rate limited"
**Cause:** Too many CloudKit requests
**Solution:**
- Wait 1 minute before trying again
- CloudKit has rate limits
- App will retry automatically

### 🔄 Sync Issues

#### Emoji selected but doesn't appear in history
**Possible causes:**
1. **No internet** - Check connection
2. **CloudKit delay** - Wait 5-10 seconds
3. **Subscription not set up** - Force quit and relaunch
4. **iCloud disabled** - Check Settings

**Solutions:**
- Pull down to refresh history
- Tap refresh button (↻)
- Check internet connection
- Verify iCloud is enabled
- Force quit both apps and relaunch

#### Changes on iPhone don't appear on Watch
**Possible causes:**
1. **Watch offline** - Watch needs Bluetooth or WiFi
2. **Watch app not running** - Background updates delayed
3. **Different iCloud accounts** - Must use same account

**Solutions:**
- Ensure Watch is connected (check Control Center)
- Open Watch app to force foreground sync
- Settings → [Your Name] → verify same iCloud account
- Wait 30 seconds for background sync
- Force restart Watch app

#### Changes on Watch don't appear on iPhone
**Possible causes:**
1. **iPhone in low power mode** - Delays background updates
2. **iPhone offline** - No internet connection
3. **App in background** - May delay updates

**Solutions:**
- Open iPhone app to foreground
- Disable Low Power Mode temporarily
- Ensure iPhone has internet
- Tap refresh button
- Enable Background App Refresh for Got Emoji

### 📱 Device-Specific Issues

#### iPhone Issues

**App crashes on launch**
- Check Xcode console for error message
- Verify code signing is valid
- Delete app and reinstall
- Clean build folder and rebuild
- Check for iOS version compatibility (iOS 17+)

**History shows but can't delete entries**
- Swipe from right edge of cell to left
- Ensure you're swiping on the cell, not between cells
- Try swiping slower
- Check if CloudKit is accessible

**Tabs not working**
- Force quit and relaunch
- Restart iPhone
- Reinstall app

#### Apple Watch Issues

**App not installing on Watch**
- Ensure Watch and iPhone are paired
- Open Watch app on iPhone → My Watch → check app is installed
- Toggle app off and on in Watch app
- Restart both devices

**Watch app crashes immediately**
- Shared files missing from Watch target
- Check build logs in Xcode
- Reinstall Watch app
- Unpair and re-pair Watch (last resort)

**Can't scroll to see all emojis**
- Try scrolling with Digital Crown
- Swipe up/down on screen
- Restart Watch app

### 🔐 Permission Issues

#### "Notifications Not Allowed"
**Solution:**
1. Settings → Got Emoji
2. Notifications → Enable
3. Allow notifications for background sync

#### "iCloud Not Available"
**Solution:**
1. Settings → [Your Name]
2. iCloud → Ensure signed in
3. iCloud Drive → Enable
4. Scroll down → Got Emoji → Enable

### 💾 Data Issues

#### History shows duplicates
**Cause:** Sync conflict or bug
**Solution:**
- Delete duplicates manually
- Force quit both apps
- Wait 1 minute
- Relaunch and check

#### All history disappeared
**Cause:** CloudKit data deleted or account changed
**Solution:**
- Check CloudKit Dashboard for data
- Verify same iCloud account on both devices
- Check if accidentally deleted
- Data is stored in CloudKit (cloud only, no local backup)

#### Can't delete entries
**Cause:** CloudKit permission or network issue
**Solution:**
- Check internet connection
- Try again in a few seconds
- Force refresh
- Restart app

### 🛠️ Development Issues

#### Xcode shows "iPhone is busy" when trying to run
**Solution:**
- Wait for iPhone to finish indexing
- Disconnect and reconnect cable
- Restart Xcode
- Restart iPhone

#### Watch app not appearing in scheme selector
**Solution:**
1. Close Xcode
2. Delete DerivedData:
   ```bash
   rm -rf ~/Library/Developer/Xcode/DerivedData
   ```
3. Reopen project
4. Watch scheme should appear

#### Build succeeds but app doesn't launch
**Solution:**
- Check device logs in Xcode → Window → Devices and Simulators
- Look for crash logs
- Verify code signing
- Check for runtime errors

### 📊 CloudKit Dashboard Issues

#### Can't see my data in CloudKit Dashboard
**Solution:**
1. Ensure you're logged into correct Apple ID
2. Select correct container: `iCloud.rens-corp.Got-Emoji`
3. Switch to "Development" environment
4. Data tab → Select "EmojiEntry" record type
5. Refresh page

#### Subscription not showing in Dashboard
**Solution:**
- Subscriptions created on first app launch
- May take 30 seconds to appear
- Launch app on device first
- Refresh Dashboard

## 🐛 Debugging Tips

### Enable Detailed Logging
Add to CloudKitManager.swift:
```swift
// Add this line after CloudKit operations
print("DEBUG: CloudKit operation completed")
```

### Check Console Output
In Xcode:
1. Run app on device
2. Open Console (⌘+Shift+C)
3. Look for error messages
4. Filter by "Got Emoji" or "CloudKit"

### Test Sync Manually
1. Select emoji on iPhone
2. Wait 5 seconds
3. Check CloudKit Dashboard → Data
4. Verify record exists
5. Check if Watch receives notification

### Verify Network Requests
1. Settings → Developer → Network Link Conditioner
2. Enable poor network simulation
3. Test app behavior
4. Verify offline queueing works

## 🆘 When All Else Fails

### Nuclear Options (In Order)

1. **Soft Reset**
   - Force quit both apps
   - Wait 10 seconds
   - Relaunch both apps

2. **App Reset**
   - Delete app from iPhone
   - Delete app from Watch
   - Clean build in Xcode (⌘+Shift+K)
   - Rebuild and reinstall

3. **Data Reset**
   - CloudKit Dashboard → Development → Data
   - Delete all EmojiEntry records
   - Relaunch apps
   - Will start with clean slate

4. **Full Reset**
   - Delete apps from devices
   - Xcode → Derived Data → Delete
   - Clean build folder
   - Sign out of iCloud on devices
   - Sign back in
   - Rebuild and reinstall

5. **Container Reset**
   - CloudKit Dashboard → Development
   - Reset Development Environment
   - ⚠️ Deletes ALL development data
   - Use only as last resort

## 📞 Getting Help

### Before Asking for Help

Gather this information:
- [ ] iOS version
- [ ] watchOS version
- [ ] Xcode version
- [ ] Error message (exact text)
- [ ] Console logs from Xcode
- [ ] Steps to reproduce issue
- [ ] When did it start happening?
- [ ] Did it ever work?

### Useful Commands

Check Xcode version:
```bash
xcodebuild -version
```

Check device iOS version:
```bash
xcrun devicectl list devices
```

Clean all builds:
```bash
rm -rf ~/Library/Developer/Xcode/DerivedData
```

## ✅ Prevention Checklist

Avoid common issues by verifying:

- [ ] Physical devices (not simulator)
- [ ] iOS 17+ and watchOS 10+
- [ ] Same iCloud account on both devices
- [ ] iCloud enabled in Settings
- [ ] Internet connection active
- [ ] Background App Refresh enabled
- [ ] Notifications allowed
- [ ] Shared files in both targets
- [ ] Code signing configured
- [ ] Valid provisioning profiles

---

**Most issues are solved by ensuring shared files are in both targets and using physical devices!** 🎯
