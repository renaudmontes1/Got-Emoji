//
//  DebugLogView.swift
//  Got Emoji
//
//  Created by Renaud Montes on 11/1/25.
//

import SwiftUI

struct DebugLogView: View {
    @ObservedObject var cloudKitManager: CloudKitManager
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Debug Logs")
                    .font(.headline)
                Spacer()
                Button("Clear") {
                    cloudKitManager.debugLog.removeAll()
                }
                .font(.caption)
                .buttonStyle(.bordered)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            
            // Logs
            if cloudKitManager.debugLog.isEmpty {
                VStack {
                    Spacer()
                    Text("No logs yet")
                        .foregroundColor(.gray)
                    Spacer()
                }
            } else {
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 4) {
                            ForEach(Array(cloudKitManager.debugLog.enumerated()), id: \.offset) { index, log in
                                Text(log)
                                    .font(.system(.caption, design: .monospaced))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 2)
                                    .id(index)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    .onChange(of: cloudKitManager.debugLog.count) { _ in
                        if let lastIndex = cloudKitManager.debugLog.indices.last {
                            withAnimation {
                                proxy.scrollTo(lastIndex, anchor: .bottom)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Debug")
        .navigationBarTitleDisplayMode(.inline)
    }
}
