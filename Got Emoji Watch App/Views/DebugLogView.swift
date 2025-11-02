//
//  DebugLogView.swift
//  Got Emoji Watch App
//
//  Created by Renaud Montes on 11/1/25.
//

import SwiftUI

struct DebugLogView: View {
    @ObservedObject var cloudKitManager: CloudKitManager
    
    var body: some View {
        VStack(spacing: 0) {
            // Logs
            if cloudKitManager.debugLog.isEmpty {
                VStack {
                    Spacer()
                    Text("No logs yet")
                        .foregroundColor(.gray)
                        .font(.caption)
                    Spacer()
                }
            } else {
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 2) {
                            ForEach(Array(cloudKitManager.debugLog.enumerated()), id: \.offset) { index, log in
                                Text(log)
                                    .font(.system(size: 8, design: .monospaced))
                                    .padding(.horizontal, 4)
                                    .padding(.vertical, 1)
                                    .id(index)
                            }
                        }
                        .padding(.vertical, 4)
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
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button("Clear") {
                    cloudKitManager.debugLog.removeAll()
                }
                .font(.caption2)
            }
        }
    }
}
