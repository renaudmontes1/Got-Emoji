# 🏛️ Got Emoji Architecture

## System Overview

```
┌─────────────────┐                    ┌──────────────────┐
│                 │                    │                  │
│  iPhone App     │◄──────────────────►│  Apple Watch App │
│                 │    CloudKit Sync   │                  │
└────────┬────────┘                    └────────┬─────────┘
         │                                      │
         │         ┌──────────────────┐        │
         └────────►│   CloudKit DB    │◄───────┘
                   │  (iCloud Private)│
                   └──────────────────┘
```

## Data Flow

### Emoji Selection Flow
```
User Taps Emoji
      ↓
Local State Update
      ↓
Save to CloudKit
      ↓
CloudKit Notification
      ↓
Other Device Receives Push
      ↓
Fetch Updated Data
      ↓
UI Refreshes
```

### Sync Architecture
```
┌──────────────────────────────────────────┐
│           CloudKitManager                │
│  ┌────────────────────────────────────┐  │
│  │  @Published var entries: [Entry]  │  │
│  └────────────────────────────────────┘  │
│                                          │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐  │
│  │ Create  │  │  Read   │  │ Delete  │  │
│  └─────────┘  └─────────┘  └─────────┘  │
│        ↓            ↓            ↓        │
│  ┌──────────────────────────────────┐    │
│  │      CKDatabase Operations       │    │
│  └──────────────────────────────────┘    │
└──────────────────────────────────────────┘
```

## Component Hierarchy

### iPhone App Structure
```
Got_EmojiApp (AppDelegate for notifications)
    └── ContentView
        └── TabView
            ├── Select Tab
            │   └── NavigationView
            │       └── EmojiSelectionView
            │           └── [Emoji Buttons]
            │
            └── History Tab
                └── NavigationView
                    └── HistoryView
                        └── List
                            └── [EmojiEntryRow]
```

### Watch App Structure
```
Got_Emoji_Watch_AppApp
    └── ContentView
        └── NavigationView
            └── ScrollView
                ├── EmojiSelectionView
                │   └── [Emoji Buttons]
                │
                └── NavigationLink
                    └── HistoryView
                        └── List
                            └── [EmojiEntryRow]
```

## State Management

### ObservableObject Pattern
```swift
@MainActor
class CloudKitManager: ObservableObject {
    @Published var entries: [EmojiEntry] = []
    @Published var isSyncing = false
    @Published var error: Error?
}
```

### View Integration
```swift
struct ContentView: View {
    @StateObject private var cloudKitManager = CloudKitManager()
    // CloudKitManager shared across all child views
}
```

## CloudKit Schema

### Record Type: EmojiEntry
```
┌──────────────────────────────────┐
│         EmojiEntry Record        │
├──────────────────────────────────┤
│ recordName: UUID String          │
│ emoji: String                    │
│ timestamp: Date                  │
│ device: String                   │
└──────────────────────────────────┘
```

### Subscription Configuration
```
Type: CKQuerySubscription
Predicate: NSPredicate(value: true) // All records
Options:
  - firesOnRecordCreation
  - firesOnRecordDeletion
  - firesOnRecordUpdate
Notification: Silent (background)
```

## Network Architecture

### CloudKit Container Setup
```
Container ID: iCloud.rens-corp.Got-Emoji
Database: Private (user-specific)
Schema: Auto-created on first use
```

### Notification Flow
```
Device A: User selects emoji
    ↓
Save to CloudKit
    ↓
CloudKit processes save
    ↓
Triggers subscription
    ↓
Silent push to Device B
    ↓
App on Device B wakes up
    ↓
Fetches new/updated records
    ↓
Updates UI
```

## Cross-Platform Code Sharing

### Shared Files (Both Targets)
```
┌──────────────────────────────────┐
│  Models/EmojiEntry.swift         │ ← Data structure
├──────────────────────────────────┤
│  Managers/CloudKitManager.swift  │ ← Sync logic
├──────────────────────────────────┤
│  Views/EmojiSelectionView.swift  │ ← Selection UI
├──────────────────────────────────┤
│  Views/HistoryView.swift         │ ← History UI
└──────────────────────────────────┘
```

### Platform-Specific Code
```swift
#if os(iOS)
    // iPhone-specific UI
    LazyVGrid(columns: columns) { ... }
#else
    // Watch-specific UI
    VStack { ... }
#endif
```

## Background Sync

### iOS Background Modes
```
- Remote notifications ✓
- Background fetch ✓
```

### Watch Background Sync
```
- Automatic via WatchKit
- No special configuration needed
```

## Error Handling

### Error Flow
```
CloudKit Operation
    ↓
Try/Catch Block
    ↓
Error Caught?
    ├─ Yes → Store in @Published error
    │         ↓
    │         UI can display alert
    │         ↓
    │         Log to console
    │
    └─ No → Success
              ↓
              Update @Published entries
              ↓
              UI automatically refreshes
```

## Performance Considerations

### Optimization Strategies
1. **Local-first updates**: UI updates immediately, syncs in background
2. **Batch fetching**: Query fetches all at once, sorted by CloudKit
3. **Subscription-based sync**: Only fetch when data changes
4. **Main actor isolation**: All UI updates on main thread

### Memory Management
```
- CloudKitManager: Single instance per app
- Entries array: In-memory cache
- No persistent local storage (CloudKit is source of truth)
```

## Security Architecture

### Authentication
```
User's iCloud Account
    ↓
Automatic CloudKit authentication
    ↓
Access to private database only
```

### Data Isolation
```
User A's Data ─┐
               ├─► CloudKit Private DB ─► Only User A can access
User B's Data ─┘
```

### Encryption
- In transit: TLS/SSL
- At rest: Apple's encryption
- No custom encryption needed

## Scalability

### Current Limitations
- Private database: ~1GB storage
- API calls: Rate limited by Apple
- Records: Unlimited count (within storage)

### Growth Considerations
- Each emoji entry: ~200 bytes
- 1000 entries ≈ 200KB
- Years of usage still under 1MB

## Testing Strategy

### Unit Testing Targets
- EmojiEntry model creation
- CloudKit record conversion
- Date formatting

### Integration Testing
- CloudKit save/fetch operations
- Cross-device sync (manual)
- Offline queue handling

### UI Testing
- Emoji selection tap
- History list display
- Delete swipe action

---

**This architecture prioritizes simplicity, reliability, and seamless cross-device sync.** 🚀
