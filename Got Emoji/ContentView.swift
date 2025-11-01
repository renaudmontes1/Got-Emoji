//
//  ContentView.swift
//  Got Emoji
//
//  Created by Admin on 10/29/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var cloudKitManager = CloudKitManager()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Selection Tab
            NavigationView {
                VStack {
                    if cloudKitManager.isSyncing {
                        ProgressView()
                            .padding()
                    }
                    
                    EmojiSelectionView(
                        cloudKitManager: cloudKitManager,
                        deviceName: "iPhone"
                    )
                    
                    Spacer()
                }
                .navigationTitle("Got Emoji")
                .navigationBarTitleDisplayMode(.large)
            }
            .tabItem {
                Label("Select", systemImage: "hand.tap")
            }
            .tag(0)
            
            // History Tab
            NavigationView {
                VStack {
                    if cloudKitManager.isSyncing {
                        ProgressView()
                            .padding(.top, 8)
                    }
                    
                    HistoryView(cloudKitManager: cloudKitManager)
                }
                .navigationTitle("History")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            Task {
                                await cloudKitManager.fetchEntries()
                            }
                        }) {
                            Image(systemName: "arrow.clockwise")
                        }
                        .disabled(cloudKitManager.isSyncing)
                    }
                }
            }
            .tabItem {
                Label("History", systemImage: "clock.arrow.circlepath")
            }
            .tag(1)
        }
        .onReceive(NotificationCenter.default.publisher(for: .cloudKitDataChanged)) { _ in
            print("🔔 ContentView received cloudKitDataChanged notification")
            Task {
                await cloudKitManager.handleRemoteNotification()
            }
        }
    }
}

#Preview {
    ContentView()
}
