# 📱 Got Emoji - User Interface Guide

## iPhone Interface

### Selection Tab (Home Screen)
```
┌─────────────────────────────────────┐
│  ◁  Got Emoji                    ↻  │
├─────────────────────────────────────┤
│                                     │
│        Choose an Emoji              │
│                                     │
│     ┌─────┐  ┌─────┐  ┌─────┐     │
│     │ 😀  │  │ 😎  │  │ 🐶  │     │
│     └─────┘  └─────┘  └─────┘     │
│                                     │
│     ┌─────┐  ┌─────┐               │
│     │ 🚀  │  │ 🍕  │               │
│     └─────┘  └─────┘               │
│                                     │
│                                     │
│                                     │
│                                     │
│                                     │
│                                     │
├─────────────────────────────────────┤
│   ✋ Select    🕐 History            │
│     ────                            │
└─────────────────────────────────────┘
```

### History Tab
```
┌─────────────────────────────────────┐
│  ◁  History                       ↻ │
├─────────────────────────────────────┤
│                                     │
│  ┌──────────────────────────────┐  │
│  │ 🍕  📱 iPhone      2m ago     │  │
│  ├──────────────────────────────┤  │
│  │ 🚀  ⌚ Apple Watch 5m ago     │  │
│  ├──────────────────────────────┤  │
│  │ 😎  📱 iPhone      10m ago    │  │
│  ├──────────────────────────────┤  │
│  │ 🐶  ⌚ Apple Watch 1h ago     │  │
│  ├──────────────────────────────┤  │
│  │ 😀  📱 iPhone      2h ago     │  │
│  └──────────────────────────────┘  │
│                                     │
│  ← Swipe left to delete             │
│                                     │
├─────────────────────────────────────┤
│     Select    🕐 History            │
│                 ────                │
└─────────────────────────────────────┘
```

### Empty History State
```
┌─────────────────────────────────────┐
│  ◁  History                       ↻ │
├─────────────────────────────────────┤
│                                     │
│                                     │
│            📂                        │
│                                     │
│       No entries yet                │
│                                     │
│  Select an emoji to get started!   │
│                                     │
│                                     │
│                                     │
├─────────────────────────────────────┤
│     Select    🕐 History            │
│                 ────                │
└─────────────────────────────────────┘
```

## Apple Watch Interface

### Main Screen (Selection)
```
        ┌─────────────────┐
        │  Got Emoji      │
        ├─────────────────┤
        │                 │
        │   Choose Emoji  │
        │                 │
        │   ┌───────┐     │
        │   │  😀   │     │
        │   └───────┘     │
        │   ┌───────┐     │
        │   │  😎   │     │
        │   └───────┘     │
        │   ┌───────┐     │
        │   │  🐶   │     │
        │   └───────┘     │
        │   ┌───────┐     │
        │   │  🚀   │     │
        │   └───────┘     │
        │   ┌───────┐     │
        │   │  🍕   │     │
        │   └───────┘     │
        │                 │
        │  ┌──────────┐   │
        │  │ History  │   │
        │  └──────────┘   │
        │                 │
        └─────────────────┘
```

### History Screen
```
        ┌─────────────────┐
        │ ◁ History     ↻ │
        ├─────────────────┤
        │                 │
        │ 🍕 📱 iPhone    │
        │     2m ago      │
        │ ─────────────── │
        │ 🚀 ⌚ Watch     │
        │     5m ago      │
        │ ─────────────── │
        │ 😎 📱 iPhone    │
        │     10m ago     │
        │ ─────────────── │
        │ 🐶 ⌚ Watch     │
        │     1h ago      │
        │                 │
        └─────────────────┘
```

### Loading State
```
        ┌─────────────────┐
        │  Got Emoji      │
        ├─────────────────┤
        │                 │
        │      ⌛         │
        │   Syncing...    │
        │                 │
        │   ┌───────┐     │
        │   │  😀   │     │
        │   └───────┘     │
        │       ...       │
        │                 │
        └─────────────────┘
```

## Interaction Patterns

### Selection Flow (iPhone)
```
1. User opens app
   ↓
2. Sees emoji grid
   ↓
3. Taps emoji (e.g., 🚀)
   ↓
4. Feels haptic feedback
   ↓
5. Brief loading indicator
   ↓
6. Entry appears in history
   ↓
7. Watch receives notification
   ↓
8. Watch updates history
```

### Selection Flow (Watch)
```
1. User raises wrist
   ↓
2. Opens Got Emoji
   ↓
3. Scrolls to desired emoji
   ↓
4. Taps emoji (e.g., 🍕)
   ↓
5. Feels haptic click
   ↓
6. Brief loading indicator
   ↓
7. Can tap History to see entry
   ↓
8. iPhone receives notification
   ↓
9. iPhone updates history
```

### Delete Flow
```
1. User swipes left on entry
   ↓
2. Red "Delete" button appears
   ↓
3. User taps Delete
   ↓
4. Entry removed from list
   ↓
5. CloudKit deletes record
   ↓
6. Other device notified
   ↓
7. Other device removes entry
```

## Visual Elements

### Colors
- **Primary**: System default (blue)
- **Background**: System background (white/black adaptive)
- **Emoji buttons**: Light gray background (opacity 0.1)
- **Text**: System foreground (black/white adaptive)
- **Secondary text**: Gray
- **Delete**: System red

### Typography
- **Title**: Large, bold
- **Headline**: Medium, semibold
- **Body**: Regular
- **Caption**: Small, for timestamps
- **Emoji**: Large (44pt iOS, 30pt Watch)

### Spacing
- **Grid spacing**: 20pt between emojis
- **List padding**: 12pt vertical
- **Section spacing**: 16pt
- **Tab bar**: Standard system height

### Icons
- **iPhone indicator**: 📱 iphone system icon
- **Watch indicator**: ⌚ applewatch system icon
- **Refresh**: ↻ arrow.clockwise
- **History**: 🕐 clock.arrow.circlepath
- **Select**: ✋ hand.tap
- **Empty state**: 📂 tray

## Animations

### On Selection
1. Button press: Scale down slightly
2. Haptic feedback: Medium impact
3. Progress spinner: Fade in
4. History update: Slide in from top
5. Progress spinner: Fade out

### On Sync
1. Background refresh
2. List items update smoothly
3. No jarring reloads
4. Maintain scroll position

### On Delete
1. Swipe reveals delete button
2. Row slides out left
3. Gap closes smoothly
4. Other items slide up

## Accessibility

### VoiceOver Support
- All buttons have labels
- Emojis announced by name
- Timestamps read naturally
- Delete actions confirmed

### Dynamic Type
- All text scales with system settings
- Layout adjusts for larger text
- Emojis remain readable

### Color Contrast
- Passes WCAG AA standards
- Works in light and dark mode
- Sufficient contrast for all text

## Dark Mode

All views automatically adapt to dark mode:
- Backgrounds darken
- Text lightens
- Emoji buttons subtle in dark
- System colors adapt

## State Indicators

### Loading
- Circular progress indicator
- "Syncing..." text (Watch only)
- Disabled interaction during save

### Empty
- Tray icon
- "No entries yet" message
- Helpful prompt

### Error
- Logged to console
- Graceful degradation
- Retry on next action

---

**This interface is designed to be simple, intuitive, and delightful!** ✨
