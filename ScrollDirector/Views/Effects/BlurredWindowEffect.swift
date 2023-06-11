//
//  BlurredWindowEffect.swift
//  ScrollDirector
//
//  Created by Caoimhe on 11/06/2023.
//

import AppKit
import Foundation
import SwiftUI

struct BlurredWindowEffect: NSViewRepresentable {
    func makeNSView(context: Context) -> NSVisualEffectView {
        let effectView = NSVisualEffectView()
        effectView.material = .sidebar
        effectView.blendingMode = .behindWindow
        
        return effectView
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {}
}
