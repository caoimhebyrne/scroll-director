//
//  SettingsView.swift
//  ScrollDirector
//
//  Created by Caoimhe on 11/06/2023.
//

import ServiceManagement
import SwiftUI

struct SettingsView: View {
    var body: some View {
        TabView {
            GeneralSettingsView()
                .tabItem {
                    Label("General", systemImage: "gear")
                }
        }
        .frame(minWidth: 400, minHeight: 200, alignment: .topLeading)
    }
}

struct GeneralSettingsView: View {
    @AppStorage("launchAtLogin") var launchAtLogin = false

    var body: some View {
        Form {
            Toggle(isOn: $launchAtLogin) {
                Text("Launch at login")
            }
        }
        .padding()
        .onChange(of: launchAtLogin) { newValue in
            do {
                print("[Settings] \(newValue ? "Enabling" : "Disabling") launch at login.")
                
                if newValue {
                    // Attempt to un-register if we are already registered, but don't bother catching an exception if it fails.
                    if SMAppService.mainApp.status == .enabled {
                        try? SMAppService.mainApp.unregister()
                    }
                    
                    try SMAppService.mainApp.register()
                } else {
                    try SMAppService.mainApp.unregister()
                }
            } catch {
                print("[Settings] Failed to \(newValue ? "enable" : "disable") launch at login!")
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
