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
    @Published var permissionGranted = false
    
    init() {
        requestAuthorization()
    }
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            DispatchQueue.main.async {
                self.permissionGranted = granted
            }
        }
    }
    
    func push(title: String, message: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request)
    }
}
