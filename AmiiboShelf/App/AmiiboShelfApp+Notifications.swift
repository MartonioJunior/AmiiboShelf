//
//  AmiiboShelfApp+Notifications.swift
//  AmiiboShelf
//
//  Created by Martônio Júnior on 14/10/23.
//  Copyright © 2023 Martônio Júnior. All rights reserved.
//

import Core
import Foundation
import UserNotifications
import UIKit

extension AmiiboShelfApp {
    static var notificationManager: UNUserNotificationCenter { .current() }

    static func requestPermission() async throws -> Bool {
        try await notificationManager.requestAuthorization(options: [.alert, .badge, .sound])
    }

    static func notify(message: String, identifier: String, thread: String) async throws {
        let notificationContent = configure(UNMutableNotificationContent()) {
            $0.title = "Amiibo Shelf"
            $0.body = message
            $0.threadIdentifier = thread
        }

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.5, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: notificationContent, trigger: trigger)

        try await notificationManager.add(request)
    }

    @MainActor static func registerRemoteNotifications(in application: UIApplication) async {
        let settings = await notificationManager.notificationSettings()

        guard settings.authorizationStatus == .authorized else { return }

        application.registerForRemoteNotifications()
    }
}
