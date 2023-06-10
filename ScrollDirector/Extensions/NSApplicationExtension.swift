//
//  NSApplicationExtension.swift
//  ScrollDirector
//
//  Created by Caoimhe on 11/06/2023.
//

import AppKit
import Foundation

extension NSApplication {
    func showSettings() {
        NSApplication.shared.setActivationPolicy(.regular)
        NSApplication.shared.activate(ignoringOtherApps: true)
        NSApplication.shared.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
        
        for window in NSApplication.shared.windows {
            if !window.title.contains("Settings") { return }
            window.center()
        }
    }
    
    func deactivateMainWindow() {
        NSApplication.shared.setActivationPolicy(.accessory)
        NSApplication.shared.deactivate()
    }
}
