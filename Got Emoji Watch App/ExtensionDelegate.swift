//
//  ExtensionDelegate.swift
//  Got Emoji Watch App
//
//  Created by Admin on 10/30/25.
//

import WatchKit
import CloudKit

class ExtensionDelegate: NSObject, WKExtensionDelegate {
    func didRegisterForRemoteNotifications(withDeviceToken deviceToken: Data) {
        print("✅ Watch registered for remote notifications")
    }
    
    func didFailToRegisterForRemoteNotificationsWithError(_ error: Error) {
        print("❌ Watch failed to register for remote notifications: \(error.localizedDescription)")
    }
    
    func didReceiveRemoteNotification(_ userInfo: [AnyHashable : Any],
                                     fetchCompletionHandler completionHandler: @escaping (WKBackgroundFetchResult) -> Void) {
        print("📬 Watch received remote notification")
        
        let notification = CKNotification(fromRemoteNotificationDictionary: userInfo)
        
        if notification?.notificationType == .query {
            print("✅ Query notification - posting cloudKitDataChanged")
            NotificationCenter.default.post(name: .cloudKitDataChanged, object: nil)
            completionHandler(.newData)
        } else {
            print("ℹ️ Non-query notification type: \(notification?.notificationType.rawValue ?? -1)")
            completionHandler(.noData)
        }
    }
}

// Share the same notification name with iOS
extension Notification.Name {
    static let cloudKitDataChanged = Notification.Name("cloudKitDataChanged")
}
