//
//  AppDelegate.swift
//  ScrollDirector
//
//  Created by Caoimhe on 11/06/2023.
//

import AppKit
import Foundation
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate, ObservableObject {
    private let onboardingController = OnboardingController()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Show onboarding if this is the user's first launch
        if !UserDefaults.standard.bool(forKey: "didShowOnboarding") {
            // Poll permissions status when the onboarding view is refocused
            NotificationCenter.default.addObserver(self, selector: #selector(self.windowDidBecomeKey(_:)), name: NSWindow.didBecomeMainNotification, object: nil)
            
            self.onboardingController.show(content: OnboardingView()
                                                        .environmentObject(self)
                                                        .environmentObject(PermissionsHandler.shared)
            )
        } else {
            self.registerKeyNotifications()
        }
    }

    func endOnboarding() {
        self.onboardingController.hide()
        self.registerKeyNotifications()
    }
    
    private func registerKeyNotifications() {
        // Make the application an accessory again when the settings window is closed
        NotificationCenter.default.addObserver(self, selector: #selector(self.windowWillClose(_:)), name: NSWindow.willCloseNotification, object: nil)
        
        // Poll permissions status when the menu bar app, or settings view is shown
        NotificationCenter.default.addObserver(self, selector: #selector(self.windowDidBecomeKey(_:)), name: NSWindow.didBecomeKeyNotification, object: nil)
    }

    // MARK: Make the application an accessory again when the settings window is closed
    @objc func windowWillClose(_ notification: Notification) {
        guard let window = notification.object as? NSWindow else {
            return
        }
                
        // We need to ignore the fake-window created by the Picker/NSMenu, and any other windows.
        if window.className == "NSMenuWindowManagerWindow" || window.title == "Settings" {
            return
        }
        
        NSApplication.shared.deactivateMainWindow()
    }
    
    // MARK: Poll permissions status when the menu bar app, or settings view is shown
    @objc func windowDidBecomeKey(_ notification: Notification) {
        guard let window = notification.object as? NSWindow else {
            return
        }
                
        if window.title != "Settings" && !window.className.contains("MenuBarExtraWindow") {
            return
        }
                
        PermissionsHandler.shared.pollPermissions()
    }
}
