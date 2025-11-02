//
//  EmojiEntry.swift
//  Got Emoji
//
//  Created by Renaud Montes on 10/29/25.
//

import Foundation
import CloudKit

struct EmojiEntry: Identifiable, Codable {
    var id: String
    let emoji: String
    let timestamp: Date
    let device: String
    
    init(id: String = UUID().uuidString, emoji: String, timestamp: Date = Date(), device: String) {
        self.id = id
        self.emoji = emoji
        self.timestamp = timestamp
        self.device = device
    }
    
    // CloudKit conversion
    init?(record: CKRecord) {
        guard let emoji = record["emoji"] as? String,
              let timestamp = record["timestamp"] as? Date,
              let device = record["device"] as? String else {
            return nil
        }
        
        self.id = record.recordID.recordName
        self.emoji = emoji
        self.timestamp = timestamp
        self.device = device
    }
    
    func toCKRecord() -> CKRecord {
        // Explicitly create record in default zone
        let zoneID = CKRecordZone.default().zoneID
        let recordID = CKRecord.ID(recordName: id, zoneID: zoneID)
        let record = CKRecord(recordType: "EmojiEntry", recordID: recordID)
        record["emoji"] = emoji as CKRecordValue
        record["timestamp"] = timestamp as CKRecordValue
        record["device"] = device as CKRecordValue
        return record
    }
}

// Available emojis
struct EmojiConstants {
    static let availableEmojis = ["😀", "😎", "🐶", "🚀", "🍕"]
}
