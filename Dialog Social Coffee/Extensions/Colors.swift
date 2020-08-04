//
//  Colors.swift
//  Dialog Social Coffee
//
//  Created by Craig Mathieson on 2020-07-23.
//  Copyright © 2020 Craig Mathieson. All rights reserved.
//

import Foundation
import SwiftUI

extension Color {
    
    // Main colors for app
    static let backgroundColor = Color("BackgroundColor")
    static let highlightColor = Color("HighlightColor")
    static let flatElementColor = Color("FlatElementColor")
    
    // Main colors for app text/icons
    static let textOnBackground = Color("TextOnBackground")
    static let textOnHighlight = Color("TextOnHighlight")
    
    // shadows
    static let lightShadow = Color("lightShadow")
    static let darkShadow = Color("darkShadow")
    static let highlightLightShadow = Color("highlightLightShadow")
    static let highlightDarkShadow = Color("highlightDarkShadow")
    
    // Charts
    static let lineChartBackground = Color("LineChartBackground")
    static let lineChartText = Color("TextOnChart")
    
}

extension UIColor {
    
    // Main colors for app
    static let backgroundColor = UIColor(named: "BackgroundColor")!
    static let highlightColor = UIColor(named: "HighlightColor")!
    static let flatElementColor = UIColor(named: "FlatElementColor")!
    static let lineChartColor = UIColor(named: "LineChartBackground")!
    
    // Main colors for app text/icons
    static let textOnBackground = UIColor(named: "TextOnBackground")!
    static let textOnHighlight = UIColor(named: "TextOnHighlight")!
    
    // shadows
    static let lightShadow = UIColor(named: "lightShadow")!
    static let darkShadow = UIColor(named: "darkShadow")!
    
    // Charts
    static let lineChartBackground = UIColor(named: "LineChartBackground")!
    static let lineChartText = UIColor(named: "TextOnChart")!
}
