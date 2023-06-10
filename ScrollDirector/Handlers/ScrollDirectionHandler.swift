//
//  ScrollDirectionHandler.swift
//  ScrollDirector
//
//  Created by Caoimhe on 10/06/2023.
//

import Combine
import Foundation

enum ScrollDirection : String {
    case natural = "Natural"
    case normal = "Normal"
    case unknown = "Unknown"
}

class ScrollDirectionHandler : ObservableObject {
    var didSetScrollDirection: (ScrollDirection) -> () = { _ in }
    
    @Published var direction: ScrollDirection = .unknown {
        didSet {
            // If we aren't actually changing the scroll direction, there's no need to churn the CPU some more.
            if (oldValue == self.direction) {
                return
            }
            
            self.setScrollDirection(self.direction)
            self.didSetScrollDirection(self.direction)
        }
    }
    
    init(_ devices: [IOHIDDevice]) {
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
        
        // If any of the devices are an actual mouse, we should use the normal mode, otherwise, back to natural.
        if devices.contains(where: { it in it.isActualMouseDevice }) {
            self.direction = .normal
        } else {
            self.direction = .natural
        }
    }
    
    private func setScrollDirection(_ direction: ScrollDirection) {
        print("[ScrollDirectionHandler] Setting direction to \(direction).")
        setSwipeScrollDirection(direction == .natural)
    }
}
