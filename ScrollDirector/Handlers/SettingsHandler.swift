//
//  SettingsHandler.swift
//  ScrollDirector
//
//  Created by Caoimhe on 11/06/2023.
//

import ServiceManagement
import SwiftUI
import Foundation

class SettingsHandler : ObservableObject {
    @AppStorage("launchAtLogin") var launchAtLogin: Bool = false {
        didSet {
            self.registerForLaunchAtLogin()
        }
    }
    
    @AppStorage("scrollingModeNotifications") var scrollingModeNotifications: Bool = true
    
    func reset() {
        self.launchAtLogin = false
        self.scrollingModeNotifications = true
    }

    func registerForLaunchAtLogin() {
        do {
            print("[Settings] \(self.launchAtLogin ? "Enabling" : "Disabling") launch at login.")
            
            if self.launchAtLogin {
                // Attempt to un-register if we are already registered, but don't bother catching an exception if it fails.
                if SMAppService.mainApp.status == .enabled {
                    try? SMAppService.mainApp.unregister()
                }
                
                try SMAppService.mainApp.register()
            } else {
                try SMAppService.mainApp.unregister()
            }
        } catch {
            print("[Settings] Failed to \(self.launchAtLogin ? "enable" : "disable") launch at login!")
        }
    }
}
