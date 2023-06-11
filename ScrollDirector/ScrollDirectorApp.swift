//
//  ScrollDirectorApp.swift
//  ScrollDirector
//
//  Created by Caoimhe on 10/06/2023.
//

import SwiftUI

@main
struct ScrollDirectorApp: App {
    @StateObject private var hidHandler: HIDHandler
    @StateObject private var settingsHandler: SettingsHandler
    @StateObject private var scrollDirectionHandler: ScrollDirectionHandler
    @StateObject private var notificationHandler: NotificationHandler
    
    init() {
        let hidHandler = HIDHandler()
        let settingsHandler = SettingsHandler()
        let scrollDirectionHandler = ScrollDirectionHandler(hidHandler.devices, settingsHandler)
        let notificationHandler = NotificationHandler()
        
        hidHandler.onDeviceConnected = { _ in
            scrollDirectionHandler.adjustFor(devices: hidHandler.devices)
        }
        
        hidHandler.onDeviceDisconnected = { _ in
            scrollDirectionHandler.adjustFor(devices: hidHandler.devices)
        }
        
        scrollDirectionHandler.didSetScrollDirection = { direction in
            notificationHandler.push(title: "ScrollDirector", message: "Setting scrolling mode to \(direction).")
        }
        
        self._hidHandler = StateObject(wrappedValue: hidHandler)
        self._settingsHandler = StateObject(wrappedValue: settingsHandler)
        self._scrollDirectionHandler = StateObject(wrappedValue: scrollDirectionHandler)
        self._notificationHandler = StateObject(wrappedValue: notificationHandler)
    }
    
    var body: some Scene {
        Settings {
            SettingsView()
                .environmentObject(self.hidHandler)
                .environmentObject(self.settingsHandler)
                .environmentObject(self.scrollDirectionHandler)
                .environmentObject(self.notificationHandler)
                // When the settings window is going be closed
                .onReceive(NotificationCenter.default.publisher(for: NSWindow.willCloseNotification)) { info in
                    // We need to ignore the fake-window created by the Picker/NSMenu.
                    if let window = info.object as? NSWindow, window.className == "NSMenuWindowManagerWindow" {
                        return
                    }
                    
                    NSApplication.shared.deactivateMainWindow()
                }
                // When the settings window is shown...
                .onReceive(NotificationCenter.default.publisher(for: NSWindow.didBecomeMainNotification)) { _ in
                    // Make sure our permission status is up to date.
                    notificationHandler.requestAuthorization()
                }
                .fixedSize()
        }
        .windowResizability(.contentSize)
        
        MenuBarExtra("Scroll Director", systemImage: "computermouse.fill") {
            StatusView()
                .environmentObject(self.hidHandler)
                .environmentObject(self.scrollDirectionHandler)
                .environmentObject(self.notificationHandler)
                .onReceive(NotificationCenter.default.publisher(for: NSWindow.didBecomeKeyNotification)) { a in
                    notificationHandler.requestAuthorization()
                }
        }
        .menuBarExtraStyle(.window)
 
    }

}
