//
//  Recipe.swift
//  Dialog Social Coffee
//
//  Created by Craig Mathieson on 2020-05-16.
//  Copyright © 2020 Craig Mathieson. All rights reserved.
//

import Foundation
import SwiftUI
import Charts

struct Recipe : Codable, Identifiable {
    // Basic Info
    var id: String = UUID().uuidString
    var title:String
    var comments:String
    // Brew Parameters
    var coffee_in:Double
    var bean_id: String
    var brew_curve:[Double]

    // calculated values
    var coffee_out: Double {
        if brew_curve.count > 0 {
            return brew_curve[brew_curve.count-1]
        }
        return 0
    }

    var time: Double {
        if brew_curve.count > 0 {
            return Double(brew_curve.count - 1) * 0.25
        }
        return 0
    }
    
    var brew_ratio: String {
        return "1:" + String(format: "%.1f",coffee_out/coffee_in)
    }
    
    var coordinates: [ChartDataEntry] {
        var set:[ChartDataEntry] = []
        var counter = 0
        for index in self.brew_curve {
            set.append(ChartDataEntry(x: 0.25*Double(counter),y: index))
            counter += 1
        }
        return set
    }
}
