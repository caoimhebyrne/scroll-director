//
//  RoundedRectangleButtonStyle.swift
//  ScrollDirector
//
//  Created by Caoimhe on 11/06/2023.
//

import SwiftUI

struct RoundedRectangleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label.foregroundColor(.white)
            .padding()
            .buttonStyle(.borderless)
            .background(Color.accentColor.cornerRadius(8).brightness(configuration.isPressed ? 0.1 : 0.0))
    }
}
