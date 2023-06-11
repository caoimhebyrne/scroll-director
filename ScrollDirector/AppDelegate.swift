//
//  AppDelegate.swift
//  ScrollDirector
//
//  Created by Caoimhe on 11/06/2023.
//

import AppKit
import Foundation
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate, ObservableObject {
    private var onboardingController = OnboardingController()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
//        if !self.settingsHandler.didShowOnboarding {
        self.onboardingController.show(content: OnboardingView().environmentObject(self))
//        }
    }
   
    func endOnboarding() {
        self.onboardingController.hide()
    }
}
