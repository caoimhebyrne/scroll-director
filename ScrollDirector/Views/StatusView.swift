//
//  StatusView.swift
//  ScrollDirector
//
//  Created by Caoimhe on 10/06/2023.
//

import SwiftUI

struct StatusView: View {
    @Environment(\.openURL) private var openURL

    @EnvironmentObject private var hidHandler: HIDHandler
    @EnvironmentObject private var scrollDirectionHandler: ScrollDirectionHandler
    @EnvironmentObject private var notificationHandler: NotificationHandler
    
    var body: some View {
        VStack(alignment: .leading) {
            self.header
            
            self.scrollDirectionStatus
                .padding(.bottom, 6)
            
            if !notificationHandler.permissionGranted || !hidHandler.permissionGranted {
                self.permissionsWarning
            }
            
            self.actions
        }
        .padding()
    }
    
    private var header: some View {
        HStack {
            Text("Scroll Director")
                .font(.headline)
            
            Spacer()
            
            Button(action: self.settings) {
                Image(systemName: "gear")
            }
            .buttonStyle(.borderless)
        }
    }
    
    private var scrollDirectionStatus: some View {
        VStack(alignment: .leading) {
            Text("Scroll direction: \(self.scrollDirectionHandler.direction.rawValue)")
                .opacity(0.65)
            
            Text("Recognized Devices")
                .fontWeight(.medium)
                .padding(.top, 3)
            
            LazyVStack(alignment: .leading, spacing: 3) {
                ForEach(self.hidHandler.devices) { device in
                    HStack {
                        Text(device.name)
                            .opacity(0.65)
                        
                        Spacer()
                        
                        if device.isActualMouseDevice {
                            Image(systemName: "computermouse.fill")
                        } else {
                            Image(systemName: "rectangle.and.hand.point.up.left.fill")
                        }
                    }
                }
            }
            .padding(.top, -5)
        }
    }
    
    private var actions: some View {
        VStack {
            Button("Quit", action: self.quit)
                .keyboardShortcut("q")
                .buttonStyle(.borderless)
        }
    }
    
    private var permissionsWarning: some View {
        VStack(alignment: .leading) {
            Label("Open settings to fix permissions!", systemImage: "exclamationmark.triangle.fill")
                .foregroundColor(.yellow)
        }
        .padding(.bottom, 2)
    }
    
    private func settings() {
        NSApplication.shared.showSettings()
    }
    
    private func quit() {
        NSApplication.shared.terminate(self)
    }
}

struct StatusView_Previews: PreviewProvider {
    static var previews: some View {
        StatusView()
    }
}
