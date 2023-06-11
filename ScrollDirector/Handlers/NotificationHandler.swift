//
//  NotificationHandler.swift
//  ScrollDirector
//
//  Created by Caoimhe on 10/06/2023.
//

import Combine
import Foundation
import UserNotifications

class NotificationHandler : ObservableObject {
    func push(title: String, message: String) {
        if !PermissionsHandler.shared.notificationsGranted {
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request)
    }
}
