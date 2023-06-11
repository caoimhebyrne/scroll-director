//
//  HIDHandler.swift
//  ScrollDirector
//
//  Created by Caoimhe on 10/06/2023.
//

import Combine
import Foundation
import IOKit

///
/// Handles the connection between ScrollDirector and whatever mouse is available, reported to us by IOKit.
///
class HIDHandler : ObservableObject {
    private let hidManager: IOHIDManager
    
    /// Contains the currently connected devices.
    @Published var devices: [IOHIDDevice] = []
        
    /// Called when a mouse or trackpad is connected.
    var onDeviceConnected: (IOHIDDevice) -> () = { _ in }
    
    /// Called when a mouse or trackpad is disconnected.
    var onDeviceDisconnected: (IOHIDDevice) -> () = { _ in }
    
    init() {
        // Create a connection to IOKit.
        self.hidManager = IOHIDManagerCreate(kCFAllocatorDefault, IOOptionBits(kIOHIDOptionsTypeNone))
        
        // The type of devices that we are asking IOKit to search for.
        let deviceDescriptors = [
            [
                kIOHIDDeviceUsagePageKey: kHIDPage_GenericDesktop,
                kIOHIDDeviceUsageKey: kHIDUsage_GD_Mouse
            ]
        ]
        
        let connectCallback: IOHIDDeviceCallback = { context, result, sender, device in
            let this: HIDHandler = unsafeBitCast(context, to: HIDHandler.self)
            if this.devices.contains(where: { it in it == device }) {
                return
            }
            
            print("[HIDHandler] Device connected: \(device.name) (Primary usage: \(device.primaryUsage), is mouse device: \(device.isActualMouseDevice))")

            this.devices.append(device)
            this.onDeviceConnected(device)
        }
        
        let disconnectCallback: IOHIDDeviceCallback = { context, result, sender, device in
            let this: HIDHandler = unsafeBitCast(context, to: HIDHandler.self)
            if !this.devices.contains(where: { it in it == device }) {
                return
            }
            
            print("[HIDHandler] Device disconnected: \(device.name) (Primary usage: \(device.primaryUsage), is mouse device: \(device.isActualMouseDevice))")

            this.devices.removeAll { it in it == device }
            this.onDeviceDisconnected(device)
        }
        

        // Configure our manager to search for the devices we specified.
        IOHIDManagerSetDeviceMatchingMultiple(self.hidManager, deviceDescriptors as CFArray)
        
        // Try to load the devices without waiting on callbacks.
        if let devicesSet = IOHIDManagerCopyDevices(hidManager) {
            self.devices = devicesSet.toArray() ?? []
        }
        
        let selfPointer = unsafeBitCast(self, to: UnsafeMutableRawPointer.self)
        IOHIDManagerRegisterDeviceMatchingCallback(self.hidManager, connectCallback, selfPointer)
        IOHIDManagerRegisterDeviceRemovalCallback(self.hidManager, disconnectCallback, selfPointer)
        
        // Poll IOKit to notify us for new device connections.
        IOHIDManagerScheduleWithRunLoop(hidManager, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue)
        
        let result = IOHIDManagerOpen(hidManager, IOOptionBits(kIOHIDOptionsTypeNone))
        if result != kIOReturnSuccess {
            print("[HIDManager] IOHidManagerOpen returned \(String(format: "%02X", result))!")
            PermissionsHandler.shared.inputMonitoringGranted = result != kIOReturnNotPermitted
        }
    }
}
