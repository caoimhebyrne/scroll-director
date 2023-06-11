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
                .navigationTitle("Settings")
        }
        .frame(minWidth: 450, maxWidth: 450, minHeight: 250, alignment: .topLeading)
    }
}

struct ApplicationSettingsView: View {
    @EnvironmentObject private var settingsHandler: SettingsHandler
    @EnvironmentObject private var hidHandler: HIDHandler
    @EnvironmentObject private var notificationHandler: NotificationHandler

    var body: some View {
        VStack {
            Form {
                Picker("Mouse scrolling mode", selection: $settingsHandler.preferredMouseScrollingMode) {
                    ForEach(ScrollDirection.allCases, id: \.self) { direction in
                        Text(direction.rawValue)
                    }
                }
                
                Picker("Trackpad scrolling mode", selection: $settingsHandler.preferredTrackpadScrollingMode) {
                    ForEach(ScrollDirection.allCases, id: \.self) { direction in
                        Text(direction.rawValue)
                    }
                }
                
                Toggle(isOn: $settingsHandler.launchAtLogin) {
                    Text("Launch at login")
                }
                
                Toggle(isOn: $settingsHandler.scrollingModeNotifications) {
                    Text("Send scrolling mode notifications")
                }
            }
            
            self.warnings
        }
        .padding()
    }
    
    private var warnings: some View {
        VStack(alignment: .leading) {
            if !hidHandler.permissionGranted {
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
            
            if !notificationHandler.permissionGranted && settingsHandler.scrollingModeNotifications {
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
        }
        .padding(.top, 5)
    }
}

struct AboutSettingsView: View {
    @Environment(\.openURL) private var openURL: OpenURLAction
    @EnvironmentObject private var settingsHandler: SettingsHandler
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image("Icon")
                    .resizable()
                    .frame(width: 75, height: 75)
                
                VStack(alignment: .leading) {
                    Text("ScrollDirector")
                        .font(.title)
                    
                    Text("Version 1.0.0")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
            }
            
            HStack {
                Button {
                    if let url = URL(string: "https://github.com/caoimhebyrne/scroll-director") {
                        openURL(url)
                    }
                } label: {
                    Text("View on GitHub")
                        .frame(maxWidth: .infinity)
                }
                
                Button {
                    if let url = URL(string: "https://github.com/caoimhebyrne/scroll-director/issues/new/choose") {
                        openURL(url)
                    }
                } label: {
                    Text("Report an issue")
                        .frame(maxWidth: .infinity)
                }
                
                Button {
                    settingsHandler.reset()
                } label: {
                    Text("Reset settings")
                        .frame(maxWidth: .infinity)
                }
            }
            
            Spacer()
            
            Text("Developed by [Caoimhe Byrne](https://caoimhe.dev) with ❤️")
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
