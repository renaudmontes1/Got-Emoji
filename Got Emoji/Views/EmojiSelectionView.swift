//
//  EmojiSelectionView.swift
//  Got Emoji
//
//  Created by Admin on 10/29/25.
//

import SwiftUI

struct EmojiSelectionView: View {
    @ObservedObject var cloudKitManager: CloudKitManager
    let deviceName: String
    
    #if os(iOS)
    let columns = [
        GridItem(.adaptive(minimum: 60))
    ]
    #endif
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Choose an Emoji")
                .font(.headline)
                .padding(.top)
            
            #if os(iOS)
            // iOS: Grid layout
            LazyVGrid(columns: columns, spacing: 20) {
                emojiButtons
            }
            .padding()
            #else
            // watchOS: Vertical stack
            VStack(spacing: 12) {
                emojiButtons
            }
            #endif
        }
    }
    
    @ViewBuilder
    private var emojiButtons: some View {
        ForEach(EmojiConstants.availableEmojis, id: \.self) { emoji in
            Button(action: {
                Task {
                    await cloudKitManager.addEntry(emoji: emoji, device: deviceName)
                }
                
                // Haptic feedback
                #if os(iOS)
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
                #else
                WKInterfaceDevice.current().play(.click)
                #endif
            }) {
                Text(emoji)
                    .font(.system(size: emojiSize))
                    .frame(width: buttonSize, height: buttonSize)
                    .background(
                        Circle()
                            .fill(Color.gray.opacity(0.1))
                    )
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    private var emojiSize: CGFloat {
        #if os(iOS)
        return 44
        #else
        return 30
        #endif
    }
    
    private var buttonSize: CGFloat {
        #if os(iOS)
        return 60
        #else
        return 50
        #endif
    }
}
