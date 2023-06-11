//
//  CompletePage.swift
//  ScrollDirector
//
//  Created by Caoimhe on 11/06/2023.
//

import SwiftUI

struct CompletePage: View {
    var body: some View {
        VStack {
            Spacer()

            Image("MenuBarScreenshot")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(8)
                .padding()
            
            Spacer()
            
            VStack(alignment: .center, spacing: 5) {
                Text("That's all!")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("ScrollDirector is ready! You can find it in your menu bar.")
                    .font(.title3)
            }
            .multilineTextAlignment(.center)
        }
    }
}

struct CompletePage_Previews: PreviewProvider {
    static var previews: some View {
        CompletePage()
    }
}
