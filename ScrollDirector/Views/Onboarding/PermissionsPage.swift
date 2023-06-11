//
//  PermissionsPage.swift
//  ScrollDirector
//
//  Created by Caoimhe on 11/06/2023.
//

import SwiftUI

struct PermissionsPage: View {
    @EnvironmentObject private var permissionsHandler: PermissionsHandler
    
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
                self.permissionDetails(
                    name: "Input Monitoring",
                    icon: "computermouse.fill",
                    description: "This is required. We need to be able to detect when a mouse or trackpad has been connected.",
                    granted: self.permissionsHandler.inputMonitoringGranted
                ) {
                    self.permissionsHandler.openInputMonitoringSettings()
                }
                
                self.permissionDetails(
                    name: "Notifications",
                    icon: "bell.fill",
                    description: "This is optional, but recommended. You can receive notifications when the scrolling mode has been changed.",
                    granted: self.permissionsHandler.notificationsGranted
                ) {
                    self.permissionsHandler.openNotificationsSettings()
                }
            }
            .padding(.top, 10)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
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
    
    private func permissionDetails(name: String, icon: String, description: String, granted: Bool, action: @escaping () -> ()) -> some View {
        return VStack(alignment: .leading) {
            Label(name, systemImage: icon)
                .font(.title3)
                .fontWeight(.semibold)
            
            Text(description)
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
                .foregroundColor(.secondary)
            
            VStack {
                if granted {
                    self.permissionGranted
                } else {
                    Button("Open System Settings") {
                        action()
                    }
                }
            }
            .padding(.top, 1)
        }
    }
}

struct PermissionsPage_Previews: PreviewProvider {
    static var previews: some View {
        PermissionsPage()
    }
}
