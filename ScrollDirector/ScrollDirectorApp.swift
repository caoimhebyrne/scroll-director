//
//  ScrollDirectorApp.swift
//  ScrollDirector
//
//  Created by Caoimhe on 10/06/2023.
//

import SwiftUI

@main
struct ScrollDirectorApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @StateObject private var hidHandler: HIDHandler
    @StateObject private var settingsHandler: SettingsHandler
    @StateObject private var scrollDirectionHandler: ScrollDirectionHandler
    @StateObject private var notificationHandler: NotificationHandler
    @StateObject private var permissionsHandler: PermissionsHandler
    
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
        self._permissionsHandler = StateObject(wrappedValue: PermissionsHandler.shared)
    }
    
    var body: some Scene {
        Settings {
            self.applyEnvironment {
                SettingsView()
                    .fixedSize()
            }
        }
        .windowResizability(.contentSize)
        
        MenuBarExtra("Scroll Director", systemImage: "computermouse.fill") {
            self.applyEnvironment { StatusView() }
        }
        .menuBarExtraStyle(.window)
    }
    
    func applyEnvironment<Content: View>(@ViewBuilder _ content: () -> Content) -> some View {
        return content()
            .environmentObject(self.hidHandler)
            .environmentObject(self.settingsHandler)
            .environmentObject(self.scrollDirectionHandler)
            .environmentObject(self.notificationHandler)
            .environmentObject(self.permissionsHandler)
    }
}
