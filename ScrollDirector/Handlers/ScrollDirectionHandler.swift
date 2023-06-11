//
//  ScrollDirectionHandler.swift
//  ScrollDirector
//
//  Created by Caoimhe on 10/06/2023.
//

import Combine
import Foundation

enum ScrollDirection : String, CaseIterable {
    case natural = "Natural"
    case normal = "Normal"
}

class ScrollDirectionHandler : ObservableObject {
    private let settingsHandler: SettingsHandler
    
    var didSetScrollDirection: (ScrollDirection) -> () = { _ in }
    
    @Published var direction: ScrollDirection = .natural {
        didSet {
            // If we aren't actually changing the scroll direction, there's no need to churn the CPU some more.
            if (oldValue == self.direction) {
                return
            }
            
            print("[ScrollDirectionHandler] Setting direction to \(self.direction).")
            setSwipeScrollDirection(self.direction == .natural)
            
            self.didSetScrollDirection(self.direction)
        }
    }
    
    init(_ devices: [IOHIDDevice], _ settingsHandler: SettingsHandler) {
        self.settingsHandler = settingsHandler

        // Queries the system for the current scroll direction through PreferencesPaneSupport.framework.
        if devices.isEmpty {
            self.direction = swipeScrollDirection() ? .natural : .normal
        } else {
            self.adjustFor(devices: devices)
        }
    }
    
    func adjustFor(devices: [IOHIDDevice]) {
        // If there is none, we don't do anything.
        if devices.isEmpty {
            print("[ScrollDirectionHandler] Not changing scroll direction as there are no devices.")
            return
        }
        
        let mouseDetected = devices.contains(where: { it in it.isActualMouseDevice })
        let preferredScrollingMode = mouseDetected ? self.settingsHandler.preferredMouseScrollingMode : self.settingsHandler.preferredTrackpadScrollingMode
        self.direction = preferredScrollingMode
    }
}
