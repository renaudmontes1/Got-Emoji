//
//  Got_EmojiApp.swift
//  Got Emoji Watch App
//
//  Created by Renaud Montes on 10/29/25.
//

import SwiftUI

@main
struct Got_Emoji_Watch_AppApp: App {
    @WKExtensionDelegateAdaptor(ExtensionDelegate.self) var extensionDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    // Watch apps automatically have notification permissions
                    // Just register for remote notifications
                    WKExtension.shared().registerForRemoteNotifications()
                }
        }
    }
}
