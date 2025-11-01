# Got Emoji 🎮

A playful iOS and watchOS app demonstrating seamless emoji selection and synchronization across devices using CloudKit.

## 📱 Features

### iPhone App
- **Emoji Selection**: Choose from 5 fun emojis (😀, 😎, 🐶, 🚀, 🍕)
- **History View**: See all emoji selections with device identifiers
- **Tab Interface**: Easy navigation between selection and history
- **Real-time Sync**: Automatically syncs with Apple Watch
- **Haptic Feedback**: Satisfying tactile response on selection

### ⌚ Apple Watch App
- **Compact Selection**: Same 5 emojis optimized for watch display
- **History Access**: View full selection history on your wrist
- **Navigation**: Simple tap-through interface
- **Instant Sync**: Changes appear on iPhone immediately

## 🏗️ Architecture

### Data Model
```swift
struct EmojiEntry {
    var id: String          // Unique identifier
    let emoji: String       // Selected emoji
    let timestamp: Date     // When it was selected
    let device: String      // "iPhone" or "Apple Watch"
}
```

### Key Components

1. **CloudKitManager**: Handles all CloudKit operations
   - Create, read, and delete entries
   - Automatic subscription setup for real-time sync
   - Background sync support
   - Error handling and retry logic

2. **EmojiSelectionView**: Reusable selection interface
   - Cross-platform (iOS/watchOS)
   - Grid layout on iPhone
   - Vertical layout on Watch
   - Haptic feedback on selection

3. **HistoryView**: Displays entry history
   - Chronological ordering (newest first)
   - Device identification icons
   - Relative timestamps
   - Swipe-to-delete functionality

## 🔄 Sync Behavior

### How It Works
1. User selects an emoji on any device
2. Entry is saved to CloudKit private database
3. CloudKit sends silent push notification to other devices
4. Other devices fetch updated data automatically
5. UI updates to show new entry

### Offline Support
- Selections are queued locally when offline
- Automatically synced when connection is restored
- CloudKit handles conflict resolution

## 🚀 Setup Instructions

### Prerequisites
- Xcode 15.0+
- iOS 17.0+ / watchOS 10.0+
- Apple Developer Account (for CloudKit)
- iCloud enabled device for testing

### Configuration Steps

1. **Open Project in Xcode**
   ```bash
   open "Got Emoji.xcodeproj"
   ```

2. **Add Shared Files to Watch Target**
   - In Xcode, select the following files:
     - `Models/EmojiEntry.swift`
     - `Managers/CloudKitManager.swift`
     - `Views/EmojiSelectionView.swift`
     - `Views/HistoryView.swift`
   - In File Inspector (right panel), check "Got Emoji Watch App" target
   - This ensures code is shared between iOS and watchOS

3. **Configure CloudKit**
   - Both targets already have CloudKit entitlements configured
   - Container ID: `iCloud.rens-corp.Got-Emoji`
   - Update this in both `.entitlements` files if needed

4. **Sign & Build**
   - Select your Team in Signing & Capabilities
   - Build for iPhone target: `⌘ + B`
   - Build for Watch target: Select watch scheme, `⌘ + B`

5. **Run on Device**
   - CloudKit requires a physical device (won't work in Simulator)
   - Run on iPhone to test iOS app
   - Run on Watch to test watchOS app

## 📊 CloudKit Schema

The app automatically creates the following CloudKit schema:

### Record Type: `EmojiEntry`
| Field      | Type   | Description              |
|------------|--------|--------------------------|
| emoji      | String | The selected emoji       |
| timestamp  | Date   | Selection timestamp      |
| device     | String | Device identifier        |

### Subscription
- **Type**: Query Subscription
- **ID**: `emoji-entries-subscription`
- **Triggers**: Create, Update, Delete
- **Notification**: Silent push for background sync

## 🧪 Testing

### Test Cross-Device Sync
1. Run app on iPhone
2. Run app on Apple Watch (paired to same iPhone)
3. Select emoji on iPhone → Should appear on Watch
4. Select emoji on Watch → Should appear on iPhone
5. Delete entry on either device → Removes from both

### Verify Offline Behavior
1. Enable Airplane Mode
2. Select emojis (they queue locally)
3. Disable Airplane Mode
4. Entries sync automatically

## 🎨 Customization

### Change Available Emojis
Edit `EmojiConstants.swift`:
```swift
static let availableEmojis = ["😀", "😎", "🐶", "🚀", "🍕"]
```

### Modify Device Names
In `ContentView.swift` (both iOS and watchOS):
```swift
EmojiSelectionView(
    cloudKitManager: cloudKitManager,
    deviceName: "Your Custom Name"  // Change here
)
```

## 🐛 Troubleshooting

### Sync Not Working
- Verify iCloud is enabled in device Settings
- Check internet connection
- Ensure same iCloud account on both devices
- Check CloudKit Dashboard for errors

### Build Errors
- Make sure shared files are added to Watch target
- Verify code signing is configured
- Clean build folder: `⌘ + Shift + K`

### CloudKit Errors
- Check container identifier matches in both entitlements files
- Verify CloudKit capability is enabled in Xcode
- Review CloudKit Dashboard logs

## 📝 Code Structure

```
Got Emoji/
├── Got Emoji/                      # iOS App
│   ├── Models/
│   │   └── EmojiEntry.swift       # Shared data model
│   ├── Managers/
│   │   └── CloudKitManager.swift  # CloudKit operations
│   ├── Views/
│   │   ├── EmojiSelectionView.swift
│   │   └── HistoryView.swift
│   ├── ContentView.swift          # Main iOS UI
│   ├── Got_EmojiApp.swift         # iOS App entry
│   └── AppDelegate.swift          # Push notifications
│
├── Got Emoji Watch App/           # watchOS App
│   ├── ContentView.swift          # Main Watch UI
│   └── Got_EmojiApp.swift         # Watch App entry
│
└── Shared Files (add to Watch target):
    ├── EmojiEntry.swift
    ├── CloudKitManager.swift
    ├── EmojiSelectionView.swift
    └── HistoryView.swift
```

## 🔐 Privacy & Security

- All data stored in CloudKit private database
- Only accessible by authenticated user
- No data shared between users
- Encrypted in transit and at rest

## 📄 License

This project is for educational purposes. Feel free to use and modify as needed.

## 🙏 Acknowledgments

- Built with SwiftUI
- Powered by CloudKit
- Designed for iOS 17+ and watchOS 10+

---

**Enjoy tracking your emoji selections! 🎉**
