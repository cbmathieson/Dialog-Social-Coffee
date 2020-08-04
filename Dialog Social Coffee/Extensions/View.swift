//
//  View.swift
//  Dialog Social Coffee
//
//  Created by Craig Mathieson on 2020-07-23.
//  Copyright © 2020 Craig Mathieson. All rights reserved.
//

import Foundation
import SwiftUI

extension View {
    
    func scaleConnectionStyle() -> some View {
        self.modifier(ScaleConnectionViewModifier())
    }
    
    func MainChartStyle() -> some View {
        self.modifier(MainChart())
    }
    
    func LineChartStyle() -> some View {
        self.modifier(LineChartModifier())
    }
    
}

// View Modifiers

struct ScaleConnectionViewModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .background(Color.flatElementColor)
            .cornerRadius(30.0)
            .padding(.bottom)
            .padding(.leading)
            .padding(.trailing)
    }
}

struct MainChart: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .padding(5)
            .cornerRadius(20)
    }
    
}


struct LineChartModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .background(Color.lineChartBackground)
            .padding(10)
            .cornerRadius(20)
    }
}


