//
//  OnboardingController.swift
//  ScrollDirector
//
//  Created by Caoimhe on 11/06/2023.
//

import AppKit
import Foundation
import SwiftUI

class OnboardingController {
    private let window: NSWindow
    
    init() {
        self.window = NSWindow(contentRect: .zero, styleMask: [.closable, .titled, .unifiedTitleAndToolbar], backing: .buffered, defer: false)
        self.window.isOpaque = false
        self.window.titlebarAppearsTransparent = true
    }
    
    func show<Content: View>(content: Content) {
        self.window.contentView = NSHostingView(rootView: content)
        
        NSApplication.shared.setActivationPolicy(.regular)
        NSApplication.shared.activate(ignoringOtherApps: true)

        self.window.makeKeyAndOrderFront(nil)
        self.window.center()

        UserDefaults.standard.set(true, forKey: "didShowOnboarding")
    }
    
    func hide() {
        self.window.close()
        
        NSApplication.shared.setActivationPolicy(.accessory)
        NSApplication.shared.deactivate()
    }
}
