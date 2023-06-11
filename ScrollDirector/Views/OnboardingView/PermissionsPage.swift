//
//  PermissionsPage.swift
//  ScrollDirector
//
//  Created by Caoimhe on 11/06/2023.
//

import SwiftUI

struct PermissionsPage: View {
    @EnvironmentObject private var hidHandler: HIDHandler
    @EnvironmentObject private var notificationHandler: NotificationHandler
    
    private var permissionGranted: some View {
        Label("Permission has been granted.", systemImage: "checkmark")
            .foregroundColor(.green)
            .padding(.vertical, 7.5)
            .padding(.horizontal, 10)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.green, lineWidth: 1)
            )
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Image(systemName: "gear")
                    .resizable()
                    .frame(width: 20, height: 20)
                
                Text("Adjust permissions")
                    .font(.title)
            }
            .fontWeight(.bold)
            
            Text("ScrollDirector needs certain permissions to work correctly.")
                .font(.title3)
            
            VStack(alignment: .leading, spacing: 15) {
                VStack(alignment: .leading) {
                    Label("Input Monitoring", systemImage: "computermouse.fill")
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Text("This is required. We need to be able to detect when a mouse or trackpad has been connected.")
                        .lineLimit(2, reservesSpace: true)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.secondary)
                    
                    VStack {
                        if hidHandler.permissionGranted {
                            self.permissionGranted
                        } else {
                            Button("Open System Settings") {
                                NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_ListenEvent")!)
                            }
                        }
                    }
                    .padding(.top, 1)
                }
                
                VStack(alignment: .leading) {
                    Label("Notifications", systemImage: "bell.fill")
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Text("This is optional, but recommended. You can receive notifications when the scrolling mode has been changed.")
                        .lineLimit(2, reservesSpace: true)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.secondary)
                    
                    VStack {
                        if notificationHandler.permissionGranted {
                            self.permissionGranted
                        } else {
                            Button("Open System Settings") {
                                NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.preference.notifications")!)
                            }
                        }
                    }
                    .padding(.top, 1)
                }
            }
            .padding(.top, 10)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct PermissionsPage_Previews: PreviewProvider {
    static var previews: some View {
        PermissionsPage()
    }
}
