//
//  AppDelegate.swift
//  Got Emoji
//
//  Created by Renaud Montes on 10/29/25.
//

import UIKit
import CloudKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        application.registerForRemoteNotifications()
        return true
    }
    
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable : Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        print("📬 Received remote notification")
        // Handle CloudKit remote notification
        let notification = CKNotification(fromRemoteNotificationDictionary: userInfo)
        
        if notification?.notificationType == .query {
            print("✅ Query notification - posting cloudKitDataChanged")
            // Post notification to refresh data
            NotificationCenter.default.post(name: .cloudKitDataChanged, object: nil)
            completionHandler(.newData)
        } else {
            print("ℹ️ Non-query notification type: \(notification?.notificationType.rawValue ?? -1)")
            completionHandler(.noData)
        }
    }
}

extension Notification.Name {
    static let cloudKitDataChanged = Notification.Name("cloudKitDataChanged")
}
