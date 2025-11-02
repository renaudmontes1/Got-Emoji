//
//  CloudKitManager.swift
//  Got Emoji
//
//  Created by Renaud Montes on 10/29/25.
//

import Foundation
import CloudKit
import Combine

@MainActor
class CloudKitManager: ObservableObject {
    @Published var entries: [EmojiEntry] = []
    @Published var isSyncing = false
    @Published var error: Error?
    @Published var debugLog: [String] = []
    
    private let container: CKContainer
    private let database: CKDatabase
    private var subscriptionID = "emoji-entries-subscription"
    
    private func log(_ message: String) {
        print(message)
        debugLog.append("\(Date().formatted(date: .omitted, time: .standard)) - \(message)")
        // Keep only last 50 logs
        if debugLog.count > 50 {
            debugLog.removeFirst()
        }
    }
    
    init() {
        self.container = CKContainer(identifier: "iCloud.rens-corp.Got-Emoji")
        // Explicitly force Production environment
        self.database = container.privateCloudDatabase
        
        Task {
            log("🚀 FORCING CloudKit PRODUCTION environment")
            log("   Container: \(container.containerIdentifier ?? "unknown")")
            await verifyCloudKitAvailability()
            await setupSubscription()
            await fetchEntries()
        }
    }
    
    // MARK: - CloudKit Availability Check
    private func verifyCloudKitAvailability() async {
        do {
            let status = try await container.accountStatus()
            switch status {
            case .available:
                log("✅ CloudKit available")
            case .noAccount:
                log("❌ No iCloud account")
            case .restricted:
                log("❌ iCloud restricted")
            case .couldNotDetermine:
                log("❌ Could not determine iCloud status")
            case .temporarilyUnavailable:
                log("⚠️ iCloud temporarily unavailable")
            @unknown default:
                log("❌ Unknown iCloud status")
            }
        } catch {
            log("Error checking CloudKit availability: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Create
    func addEntry(emoji: String, device: String) async {
        let entry = EmojiEntry(emoji: emoji, device: device)
        let record = entry.toCKRecord()
        
        do {
            isSyncing = true
            let savedRecord = try await database.save(record)
            log("✅ Successfully saved record: \(savedRecord.recordID.recordName)")
            
            // Add to local array and sort
            entries.append(entry)
            sortEntries()
            
            isSyncing = false
        } catch let error as CKError {
            self.error = error
            isSyncing = false
            
            // Detailed error logging
            print("❌ CloudKit Error saving entry:")
            print("   Code: \(error.code.rawValue)")
            print("   Description: \(error.localizedDescription)")
            
            if let underlyingError = error.userInfo[NSUnderlyingErrorKey] as? Error {
                print("   Underlying: \(underlyingError.localizedDescription)")
            }
            
            // Specific error handling
            switch error.code {
            case .networkFailure, .networkUnavailable:
                print("   → Network issue, entry will be saved when online")
            case .notAuthenticated:
                print("   → User not signed into iCloud")
            case .quotaExceeded:
                print("   → iCloud storage quota exceeded")
            case .serverRejectedRequest:
                print("   → Server rejected request - check schema")
            default:
                print("   → Other CloudKit error")
            }
        } catch {
            self.error = error
            isSyncing = false
            print("❌ Non-CloudKit error saving entry: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Read
    func fetchEntries() async {
        log("🔄 Fetching entries from CloudKit...")
        isSyncing = true
        
        do {
            // Use the absolute simplest query possible - just fetch all EmojiEntry records
            let predicate = NSPredicate(value: true) // Fetch everything
            let query = CKQuery(recordType: "EmojiEntry", predicate: predicate)
            
            // Don't sort on server - we'll sort locally
            // This avoids any index issues
            
            let (matchResults, _) = try await database.records(matching: query, inZoneWith: nil)
            
            log("📦 CloudKit returned \(matchResults.count) results")
            
            var fetchedEntries: [EmojiEntry] = []
            
            for (_, result) in matchResults {
                switch result {
                case .success(let record):
                    if let entry = EmojiEntry(record: record) {
                        fetchedEntries.append(entry)
                        log("  ✅ Parsed: \(entry.emoji) from \(entry.device)")
                    } else {
                        log("  ⚠️ Failed to parse record: \(record.recordID)")
                    }
                case .failure(let error):
                    log("  ❌ Error fetching individual record: \(error.localizedDescription)")
                }
            }
            
            // Sort locally by timestamp (newest first)
            fetchedEntries.sort { $0.timestamp > $1.timestamp }
            
            entries = fetchedEntries
            log("✅ Fetched \(entries.count) entries from CloudKit")
            
            isSyncing = false
            
        } catch {
            log("❌ CloudKit Error fetching entries:")
            log("   Code: \((error as NSError).code)")
            log("   Description: \(error.localizedDescription)")
            if let ckError = error as? CKError {
                log("   Underlying: \(ckError.errorUserInfo)")
            }
            self.error = error
            isSyncing = false
        }
    }
    
    // MARK: - Delete
    func deleteEntry(_ entry: EmojiEntry) async {
        let recordID = CKRecord.ID(recordName: entry.id)
        
        do {
            isSyncing = true
            _ = try await database.deleteRecord(withID: recordID)
            
            // Remove from local array
            entries.removeAll { $0.id == entry.id }
            
            isSyncing = false
        } catch {
            self.error = error
            isSyncing = false
            print("Error deleting entry: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Subscription for Real-time Sync
    private func setupSubscription() async {
        // Check if subscription already exists
        do {
            let existingSubscriptions = try await database.allSubscriptions()
            if existingSubscriptions.contains(where: { $0.subscriptionID == subscriptionID }) {
                log("Subscription already exists")
                return
            }
        } catch {
            log("Error checking subscriptions: \(error.localizedDescription)")
        }
        
        // Create new subscription
        let predicate = NSPredicate(value: true)
        let subscription = CKQuerySubscription(
            recordType: "EmojiEntry",
            predicate: predicate,
            subscriptionID: subscriptionID,
            options: [.firesOnRecordCreation, .firesOnRecordDeletion, .firesOnRecordUpdate]
        )
        
        let notificationInfo = CKSubscription.NotificationInfo()
        notificationInfo.shouldSendContentAvailable = true
        subscription.notificationInfo = notificationInfo
        
        do {
            _ = try await database.save(subscription)
            log("Subscription created successfully")
        } catch {
            log("Error creating subscription: \(error.localizedDescription)")
        }
    }
    
    // Handle remote notifications
    func handleRemoteNotification() async {
        log("📲 Handling remote notification - fetching updated data...")
        await fetchEntries()
    }
    
    // MARK: - Helper Methods
    private func sortEntries() {
        entries.sort { $0.timestamp > $1.timestamp }
    }
    
    // Clear all entries (for testing)
    func clearAllEntries() async {
        for entry in entries {
            await deleteEntry(entry)
        }
    }
}
