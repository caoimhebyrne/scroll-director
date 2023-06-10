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
    @StateObject private var scrollDirectionHandler: ScrollDirectionHandler
    @StateObject private var notificationHandler: NotificationHandler
    
    init() {
        let hidHandler = HIDHandler()
        let scrollDirectionHandler = ScrollDirectionHandler(hidHandler.devices)
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
        self._scrollDirectionHandler = StateObject(wrappedValue: scrollDirectionHandler)
        self._notificationHandler = StateObject(wrappedValue: notificationHandler)
    }
    
    var body: some Scene {
        MenuBarExtra("Scroll Director", systemImage: "computermouse.fill") {
            StatusView()
                .environmentObject(self.hidHandler)
                .environmentObject(self.scrollDirectionHandler)
                .environmentObject(self.notificationHandler)
        }
        .menuBarExtraStyle(.window)
    }

}
