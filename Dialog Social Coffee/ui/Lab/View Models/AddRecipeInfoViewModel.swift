//
//  CreateRecipeViewModel.swift
//  Dialog Social Coffee
//
//  Created by Craig Mathieson on 2020-05-23.
//  Copyright © 2020 Craig Mathieson. All rights reserved.
//

import Foundation
import Combine
import Resolver
import Charts
import Disk

class AddRecipeInfoViewModel: ObservableObject {
    @Published var recipeRepository: RecipeRepository = Resolver.resolve()
    
    private var cancellables = Set<AnyCancellable>()
    
    // Handles conversion from view values to save to disk
    func addRecipe(recipe_name: String,comments: String,gramsIn: String,bean_id: String,coordinates: [ChartDataEntry]) {
        
        let newRecipe = Recipe(title: recipe_name, comments: comments, coffee_in: convertToDouble(coffee_in: gramsIn), bean_id: bean_id, brew_curve: convertCoordinates(coordinates: coordinates))
        
        recipeRepository.addRecipe(newRecipe)
    }
    
    private func convertToDouble(coffee_in: String) -> Double {
        if let value = Double(coffee_in) {
            return value
        } else {
            return 19.5
        }
    }
    
    private func convertCoordinates(coordinates: [ChartDataEntry]) -> [Double] {
        var set:[Double] = []
        for i in coordinates {
            set.append(i.y)
        }
        return set
    }
    
}



