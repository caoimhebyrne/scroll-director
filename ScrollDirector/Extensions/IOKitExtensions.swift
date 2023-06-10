//
//  IOKitExtensions.swift
//  ScrollDirector
//
//  Created by Caoimhe on 10/06/2023.
//

import Foundation
import IOKit

// These are product IDs which are mistakenly reported as keyboards or other devices, when they are mice.
let mouseProductKeys = [45091]

extension IOHIDDevice : Identifiable {
    public var name: String {
        guard let product = IOHIDDeviceGetProperty(self, kIOHIDProductKey as CFString) as? String else {
            return "(Unknown device)"
        }
        
        return product
    }
    
    public var id: Int {
        guard let productId = IOHIDDeviceGetProperty(self, kIOHIDProductIDKey as CFString) as? Int else {
            return 0
        }
        
        return productId
    }
    
    public var primaryUsage: Int {
        guard let primaryUsage = IOHIDDeviceGetProperty(self, kIOHIDPrimaryUsageKey as CFString) as? Int else {
            return 0
        }
        
        return primaryUsage
    }
    
    public var isActualMouseDevice: Bool {
        // Override any product keys which should be a mouse, but aren't.
        if mouseProductKeys.contains(self.id) {
            return true
        }
        
        // Override the built-in trackpad as a trackpad, not a mouse.
        if self.name.contains("Trackpad") {
            return false
        }

        return self.primaryUsage == kHIDUsage_GD_Mouse
    }
}
