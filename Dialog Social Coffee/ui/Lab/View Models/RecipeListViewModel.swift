//
//  RecipeListViewModel.swift
//  Dialog Social Coffee
//
//  Created by Craig Mathieson on 2020-05-16.
//  Copyright © 2020 Craig Mathieson. All rights reserved.
//

/*
 (1) ObservableObject means we can access the obejct from anwhere using @Published
 (3) This on init takes the values and can be accessed on the RecipeListView
 (4) Remove recipes from the repository
 
 (6) Use the Repository as our data source on init so we can sync data across views
 (7) We are linking the recipeCells to the recipeRepository on init
*/

import Foundation
import Combine
import Resolver

class RecipeListViewModel: ObservableObject { // (1)
    @Published var recipeRepository: RecipeRepository = Resolver.resolve() // (6)
    @Published var recipeCellViewModels = [RecipeCellViewModel]() // (3)
    
    private var cancellables = Set<AnyCancellable>()
    
    init() { // (7)
        recipeRepository.$recipes.map { recipes in
            recipes.map { recipe in
                RecipeCellViewModel(recipe: recipe)
            }
        }
        .assign(to: \.recipeCellViewModels, on: self)
        .store(in: &cancellables)
    }
    
    func removeRecipe(recipeId: String) {
        //print("recipe: \(recipe.title) deleted")
        recipeRepository.removeRecipe(recipeId)
    }
    
    /*func removeRecipes(atOffsets indexSet: IndexSet) { // (4)
        let viewModels = indexSet.lazy.map { self.recipeCellViewModels[$0] }
        viewModels.forEach { recipeCellViewModel in
            recipeRepository.removeRecipe(recipeCellViewModel.recipe)
        }
    }*/
}
