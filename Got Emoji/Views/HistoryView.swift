//
//  HistoryView.swift
//  Got Emoji
//
//  Created by Admin on 10/29/25.
//

import SwiftUI

struct HistoryView: View {
    @ObservedObject var cloudKitManager: CloudKitManager
    
    var body: some View {
        VStack(spacing: 0) {
            if cloudKitManager.entries.isEmpty {
                emptyState
            } else {
                historyList
            }
        }
        .task {
            // Auto-refresh when view appears
            await cloudKitManager.fetchEntries()
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "tray")
                .font(.system(size: 40))
                .foregroundColor(.gray)
            Text("No entries yet")
                .font(.headline)
                .foregroundColor(.gray)
            Text("Select an emoji to get started!")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var historyList: some View {
        List {
            ForEach(cloudKitManager.entries) { entry in
                HStack(spacing: 12) {
                    // Emoji
                    Text(entry.emoji)
                        .font(.system(size: emojiSize))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        // Device name
                        HStack(spacing: 4) {
                            Image(systemName: entry.device == "iPhone" ? "iphone" : "applewatch")
                                .font(.caption)
                            Text(entry.device)
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                        
                        // Timestamp
                        Text(entry.timestamp, style: .relative)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                }
                .padding(.vertical, 4)
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        Task {
                            await cloudKitManager.deleteEntry(entry)
                        }
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
        #if os(iOS)
        .listStyle(.insetGrouped)
        .refreshable {
            await cloudKitManager.fetchEntries()
        }
        #else
        .listStyle(.plain)
        #endif
    }
    
    private var emojiSize: CGFloat {
        #if os(iOS)
        return 32
        #else
        return 24
        #endif
    }
}
