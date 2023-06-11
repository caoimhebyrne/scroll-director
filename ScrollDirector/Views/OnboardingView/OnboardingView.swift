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
    case tips
    
    @ViewBuilder
    func view() -> some View {
        switch self {
        case .welcome:
            WelcomePage()
        default:
            Text("NOT IMPLEMENTED")
        }
    }
}

struct OnboardingView: View {
    @State private var isLastPage: Bool = false
    @State private var currentPage: OnboardingPage = .welcome {
        didSet {
            if OnboardingPage.allCases.last == self.currentPage {
                self.isLastPage = true
            } else {
                self.isLastPage = false
            }
        }
    }
    
    @EnvironmentObject private var appDelegate: AppDelegate
    
    var body: some View {
        VStack {
            Spacer()

            self.currentPage.view()
            
            Spacer()
            
            HStack {
                Spacer()
                
                Button(self.isLastPage ? "Done" : "Next") {
                    if self.isLastPage {
                        self.done()
                    } else {
                        self.next()
                    }
                }
                .buttonStyle(RoundedRectangleButtonStyle())
                .padding(.top)
            }
        }
        .padding()
        .frame(minWidth: 500, minHeight: 400)
//        .background(BlurredWindowEffect())
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
