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
            ApplicationSettingsView()
                .tabItem {
                    Label("Application", systemImage: "app.badge.fill")
                }
                .navigationTitle("Settings")
            
            AboutSettingsView()
                .tabItem {
                    Label("About", systemImage: "info.circle.fill")
                }
        }
        .frame(minWidth: 400, minHeight: 200, alignment: .topLeading)
    }
}

struct ApplicationSettingsView: View {
    @EnvironmentObject private var settingsHandler: SettingsHandler
    @EnvironmentObject private var hidHandler: HIDHandler
    @EnvironmentObject private var notificationHandler: NotificationHandler

    var body: some View {
        Form {
            Toggle(isOn: $settingsHandler.launchAtLogin) {
                Text("Launch at login")
            }
            
            Toggle(isOn: $settingsHandler.scrollingModeNotifications) {
                Text("Send a notification when changing scrolling mode")
            }
            
            if !hidHandler.permissionGranted {
                VStack(alignment: .leading) {
                    Label("ScrollDirector doesn't have the correct permissions", systemImage: "exclamationmark.triangle")
                        .foregroundColor(.yellow)
                        .font(.headline)
                        .padding(.bottom, 2)
                    
                    Text("ScrollDirector needs the 'Input Monitoring' permission to detect when a mouse is connected. Go to **'Privacy and Security'** > **'Input Monitoring'** to re-enable it.")
                        .foregroundColor(.secondary)
                        .lineLimit(3, reservesSpace: true)
                    
                    Button("Go to System Settings") {
                        NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_ListenEvent")!)
                    }
                }
                .padding(.top, 5)
            }
            
            if !notificationHandler.permissionGranted && settingsHandler.scrollingModeNotifications {
                VStack(alignment: .leading) {
                    Label("ScrollDirector doesn't have the correct permissions", systemImage: "exclamationmark.triangle")
                        .foregroundColor(.yellow)
                        .font(.headline)
                        .padding(.bottom, 2)
                    
                    Text("ScrollDirector doesn't have permission to send notifications. Either disable **'Send a notification when changing scrolling mode'**, or, go to **'Notifications'** > **'ScrollDirector'** to re-enable them.")
                        .foregroundColor(.secondary)
                        .lineLimit(4, reservesSpace: true)
                    
                    Button("Go to System Settings") {
                        NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.preference.notifications")!)
                    }
                }
                .padding(.top, 5)
            }
        }
        .padding()
    }
}

struct AboutSettingsView: View {
    var body: some View {
        Form {
            Text("[GitHub](https://github.com/caoimhebyrne/scroll-director)")
        }
        .padding()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
