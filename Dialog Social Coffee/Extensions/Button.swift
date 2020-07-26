//
//  Button.swift
//  Dialog Social Coffee
//
//  Created by Craig Mathieson on 2020-07-23.
//  Copyright © 2020 Craig Mathieson. All rights reserved.
//

import Foundation
import SwiftUI
import Neumorphic

extension Button {
    
    func MainChartStyle() -> some View {
        self.modifier(MainChart())
    }
    
}

// Button Modifiers
struct NeumorphicButtonStyle: ButtonStyle {
    
    @Environment(\.colorScheme) var colorScheme

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(20)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .shadow(color: .lightShadow, radius: configuration.isPressed ? 7: 10, x: configuration.isPressed ? -5: -10, y: configuration.isPressed ? -5: -10)
                        .shadow(color: .darkShadow, radius: configuration.isPressed ? 7: 10, x: configuration.isPressed ? 5: 10, y: configuration.isPressed ? 5: 10)
                        .blendMode(colorScheme == .dark ? .darken : .overlay)
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color.elementColor)
                }
        )
            .scaleEffect(configuration.isPressed ? 0.92: 1)
            .foregroundColor(.textOnHighlight)
            .animation(.spring())
    }
}
