//
//  RecipeRepository.swift
//  Dialog Social Coffee
//
//  Created by Craig Mathieson on 2020-05-18.
//  Copyright © 2020 Craig Mathieson. All rights reserved.
//

import Foundation
import Disk

import Combine
import Resolver

class BaseRecipeRepository {
    @Published var recipes = [Recipe]()
}

protocol RecipeRepository: BaseRecipeRepository {
    func addRecipe(_ recipe: Recipe)
    func removeRecipe(_ recipe: Recipe)
    func updateRecipe(_ recipe: Recipe)
}

class LocalRecipeRepository: BaseRecipeRepository, RecipeRepository, ObservableObject {

    override init() {
        super.init()
        loadData()
    }
    
    func addRecipe(_ recipe: Recipe) {
        recipes.append(recipe)
        saveData()
    }
    
    func removeRecipe(_ recipe: Recipe) {
        if let index = recipes.firstIndex(where: { $0.id == recipe.id }) {
            recipes.remove(at: index)
            saveData()
        }
    }
    
    func updateRecipe(_ recipe: Recipe) {
        if let index = self.recipes.firstIndex(where: { $0.id == recipe.id }) {
            self.recipes[index] = recipe
            saveData()
        }
    }
    
    private func loadData() {
        if let retrievedRecipes = try? Disk.retrieve("recipes.json", from: .documents, as: [Recipe].self) { // (1)
            self.recipes = retrievedRecipes
        }
    }
    
    private func saveData() {
        do {
            try Disk.save(self.recipes, to: .documents, as: "recipes.json")
        }
        catch let error as NSError {
            fatalError("""
            Domain: \(error.domain)
            Code: \(error.code)
            Description: \(error.localizedDescription)
            Failure Reason: \(error.localizedFailureReason ?? "")
            Suggestions: \(error.localizedRecoverySuggestion ?? "")
            """)
        }
    }
    
}
