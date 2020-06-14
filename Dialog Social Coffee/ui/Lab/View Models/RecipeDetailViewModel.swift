//
//  RecipeDetailViewModel.swift
//  Dialog Social Coffee
//
//  Created by Craig Mathieson on 2020-05-18.
//  Copyright © 2020 Craig Mathieson. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class RecipeDetailViewModel: ObservableObject  {
    @Published var recipe: Recipe
    
    private var cancellables = Set<AnyCancellable>()
    
    init(recipe: Recipe) {
        self.recipe = recipe
    }
}
