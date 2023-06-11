//
//  OnboardingView.swift
//  ScrollDirector
//
//  Created by Caoimhe on 11/06/2023.
//

import SwiftUI

enum OnboardingPage: CaseIterable {
    case welcome
    case permissions
    case complete
    
    @ViewBuilder
    func view() -> some View {
        switch self {
        case .welcome:
            WelcomePage()
        case .permissions:
            PermissionsPage()
        case .complete:
            CompletePage()
        default:
            Text("NOT IMPLEMENTED")
        }
    }
}

struct OnboardingView: View {
    @State private var currentPage: OnboardingPage = .welcome
    
    @EnvironmentObject private var appDelegate: AppDelegate
    
    @StateObject private var hidHandler: HIDHandler
    @StateObject private var settingsHandler: SettingsHandler
    @StateObject private var scrollDirectionHandler: ScrollDirectionHandler
    @StateObject private var notificationHandler: NotificationHandler
        
    init() {
        let hidHandler = HIDHandler()
        let settingsHandler = SettingsHandler()
        let scrollDirectionHandler = ScrollDirectionHandler(hidHandler.devices, settingsHandler)

        self._hidHandler = StateObject(wrappedValue: hidHandler)
        self._settingsHandler = StateObject(wrappedValue: settingsHandler)
        self._scrollDirectionHandler = StateObject(wrappedValue: scrollDirectionHandler)
        self._notificationHandler = StateObject(wrappedValue: NotificationHandler())
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()

            self.currentPage.view()
                .frame(maxWidth: .infinity)

            Spacer()
            
            HStack {
                Spacer()
                
                Button {
                    withAnimation(.easeInOut(duration: 0.15)) {
                        if self.currentPage == OnboardingPage.allCases.last {
                            self.done()
                        } else {
                            self.next()
                        }
                    }
                } label: {
                    self.buttonLabel
                }
                .buttonStyle(RoundedRectangleButtonStyle())
                .padding(.top)
                .disabled(self.currentPage == OnboardingPage.permissions && !hidHandler.permissionGranted)
            }
        }
        .padding()
        .frame(minWidth: 500, minHeight: 400)
        .environmentObject(hidHandler)
        .environmentObject(notificationHandler)
        .environmentObject(settingsHandler)
        .environmentObject(scrollDirectionHandler)
        .onReceive(NotificationCenter.default.publisher(for: NSWindow.didBecomeMainNotification)) { _ in
            // Make sure our permission status is up to date.
            notificationHandler.requestAuthorization()
            hidHandler.requestAuthorization()
        }
    }
    
    private var buttonLabel: some View {
        VStack {
            if self.currentPage == OnboardingPage.allCases.last {
                Text("Done")
            } else {
                if self.currentPage == OnboardingPage.allCases.first {
                    Text("Get Started")
                } else {
                    Text("Next")
                }
            }
        }
    }
    
    private func next() {
        if let currentIndex = OnboardingPage.allCases.firstIndex(of: self.currentPage) {
            let nextIndex = currentIndex + 1
            if nextIndex >= OnboardingPage.allCases.count {
                return
            }
            
            self.currentPage = OnboardingPage.allCases[nextIndex]
        }
    }
    
    private func done() {
        self.appDelegate.endOnboarding()
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
