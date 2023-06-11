//
//  WelcomePage.swift
//  ScrollDirector
//
//  Created by Caoimhe on 11/06/2023.
//

import SwiftUI

struct WelcomePage: View {
    var body: some View {
        VStack {
            Spacer()

            Image("Icon")
                .resizable()
                .frame(width: 180, height: 180)
            
            Spacer()
            
            VStack(alignment: .center, spacing: 5) {
                Text("Welcome to ScrollDirector")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Thanks for downloading ScrollDirector. Let's go through some things to get started.")
                    .font(.title3)
            }
            .multilineTextAlignment(.center)
        }
    }
}

struct WelcomePage_Previews: PreviewProvider {
    static var previews: some View {
        WelcomePage()
    }
}
