//
//  ContentView.swift
//  Got Emoji Watch App
//
//  Created by Admin on 10/29/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var cloudKitManager = CloudKitManager()
    @State private var showingHistory = false
    
    var body: some View {
        NavigationView {
            VStack {
                if cloudKitManager.isSyncing {
                    ProgressView()
                        .padding(.bottom, 8)
                }
                
                ScrollView {
                    VStack(spacing: 16) {
                        Text("Got Emoji")
                            .font(.headline)
                        
                        EmojiSelectionView(
                            cloudKitManager: cloudKitManager,
                            deviceName: "Apple Watch"
                        )
                        
                        // History Button
                        NavigationLink(destination: historyView) {
                            HStack {
                                Image(systemName: "clock.arrow.circlepath")
                                Text("History")
                            }
                            .font(.caption)
                            .padding(.vertical, 8)
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding(.vertical)
                }
            }
        }
    }
    
    private var historyView: some View {
        VStack {
            if cloudKitManager.isSyncing {
                ProgressView()
                    .padding(.top, 8)
            }
            
            HistoryView(cloudKitManager: cloudKitManager)
        }
        .navigationTitle("History")
        .toolbar {
            ToolbarItem(placement: .automatic) {
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
        .onReceive(NotificationCenter.default.publisher(for: .cloudKitDataChanged)) { _ in
            print("🔔 Watch ContentView received cloudKitDataChanged notification")
            Task {
                await cloudKitManager.handleRemoteNotification()
            }
        }
    }
}

#Preview {
    ContentView()
}

