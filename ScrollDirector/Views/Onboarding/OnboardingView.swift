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
        }
    }
}

struct OnboardingView: View {
    @EnvironmentObject private var appDelegate: AppDelegate
    @EnvironmentObject private var permissionsHandler: PermissionsHandler

    @State private var currentPage: OnboardingPage = .welcome

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
                .disabled(self.currentPage == OnboardingPage.permissions && !self.permissionsHandler.inputMonitoringGranted)
            }
        }
        .padding()
        .frame(minWidth: 500, minHeight: 400)
        .onReceive(NotificationCenter.default.publisher(for: NSWindow.didBecomeMainNotification)) { _ in
            self.permissionsHandler.pollPermissions()
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
