//
//  View.swift
//  Dialog Social Coffee
//
//  Created by Craig Mathieson on 2020-07-23.
//  Copyright © 2020 Craig Mathieson. All rights reserved.
//

import Foundation
import SwiftUI
import Neumorphic

extension View {
    
    func NeumorphicViewStyle() -> ModifiedContent<Self, NeumorphicViewModifier> {
        return modifier(NeumorphicViewModifier())
    }
    
    func MainChartStyle() -> some View {
        self.modifier(MainChart())
    }
    
}

// View Modifiers

struct MainChart: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .padding(5)
            .cornerRadius(20)
            .softOuterShadow()
            .background(Neumorphic.shared.mainColor())
    }
    
}

struct NeumorphicViewModifier: ViewModifier {
    
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content
            .padding(10)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .shadow(color: .white, radius: 10, x: -7, y: -7)
                        .shadow(color: .black, radius: 10, x: 7, y: 7)
                        .blendMode(colorScheme == .dark ? .darken : .overlay)
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .fill(Color.elementColor)
                }
            )
            .foregroundColor(.textOnHighlight)
    }
}


