//
//  PermissionsHandler.swift
//  ScrollDirector
//
//  Created by Caoimhe on 11/06/2023.
//

import AppKit
import Foundation
import IOKit
import UserNotifications

class PermissionsHandler: ObservableObject {
    static let shared = PermissionsHandler()
    
    @Published var notificationsGranted: Bool = false
    @Published var inputMonitoringGranted: Bool = false

    private init() {
        self.pollPermissions()
    }
    
    func openNotificationsSettings() {
        NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.preference.notifications")!)
    }
    
    func openInputMonitoringSettings() {
        NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_ListenEvent")!)
    }
    
    func pollPermissions() {
        print("[PermissionsHandler] Checking permissions status.")
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            DispatchQueue.main.async {
                self.notificationsGranted = granted
            }
        }
        
        self.inputMonitoringGranted = IOHIDRequestAccess(kIOHIDRequestTypeListenEvent)
    }
}
