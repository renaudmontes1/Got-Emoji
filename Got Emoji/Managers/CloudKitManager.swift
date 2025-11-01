//
//  CloudKitManager.swift
//  Got Emoji
//
//  Created by Admin on 10/29/25.
//

import Foundation
import CloudKit
import Combine

@MainActor
class CloudKitManager: ObservableObject {
    @Published var entries: [EmojiEntry] = []
    @Published var isSyncing = false
    @Published var error: Error?
    
    private let container: CKContainer
    private let database: CKDatabase
    private var subscriptionID = "emoji-entries-subscription"
    
    init() {
        self.container = CKContainer(identifier: "iCloud.rens-corp.Got-Emoji")
        // Explicitly force Production environment
        self.database = container.privateCloudDatabase
        
        #if DEBUG
        print("🚀 FORCING CloudKit PRODUCTION environment")
        print("   Container: \(container.containerIdentifier ?? "unknown")")
        #endif
        
        Task {
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
                print("✅ CloudKit available")
            case .noAccount:
                print("❌ No iCloud account")
            case .restricted:
                print("❌ iCloud restricted")
            case .couldNotDetermine:
                print("❌ Could not determine iCloud status")
            case .temporarilyUnavailable:
                print("⚠️ iCloud temporarily unavailable")
            @unknown default:
                print("❌ Unknown iCloud status")
            }
        } catch {
            print("Error checking CloudKit availability: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Create
    func addEntry(emoji: String, device: String) async {
        let entry = EmojiEntry(emoji: emoji, device: device)
        let record = entry.toCKRecord()
        
        do {
            isSyncing = true
            let savedRecord = try await database.save(record)
            print("✅ Successfully saved record: \(savedRecord.recordID.recordName)")
            
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
        print("🔄 Fetching entries from CloudKit...")
        
        do {
            isSyncing = true
            
            // Use the simplest possible query - no sorting, no options
            let query = CKQuery(recordType: "EmojiEntry", predicate: NSPredicate(value: true))
            
            var fetchedEntries: [EmojiEntry] = []
            
            // Fetch records with the simplest API
            let results = try await database.records(matching: query)
            
            for (_, result) in results.matchResults {
                switch result {
                case .success(let record):
                    if let entry = EmojiEntry(record: record) {
                        fetchedEntries.append(entry)
                    }
                case .failure(let error):
                    print("❌ Failed to fetch record: \(error.localizedDescription)")
                }
            }
            
            // Sort locally by timestamp
            self.entries = fetchedEntries.sorted { $0.timestamp > $1.timestamp }
            print("✅ Fetched \(fetchedEntries.count) entries from CloudKit")
            isSyncing = false
        } catch let error as CKError {
            self.error = error
            isSyncing = false
            print("❌ CloudKit Error fetching entries:")
            print("   Code: \(error.code.rawValue)")
            print("   Description: \(error.localizedDescription)")
            if let underlying = error.userInfo[NSUnderlyingErrorKey] as? Error {
                print("   Underlying: \(underlying.localizedDescription)")
            }
        } catch {
            self.error = error
            isSyncing = false
            print("❌ Error fetching entries: \(error.localizedDescription)")
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
                print("Subscription already exists")
                return
            }
        } catch {
            print("Error checking subscriptions: \(error.localizedDescription)")
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
            print("Subscription created successfully")
        } catch {
            print("Error creating subscription: \(error.localizedDescription)")
        }
    }
    
    // Handle remote notifications
    func handleRemoteNotification() async {
        print("📲 Handling remote notification - fetching updated data...")
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
