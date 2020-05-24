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

class RecipeDetailViewModel: ObservableObject  { // (6)
    @Published var recipe: Recipe
    @Published var image: UIImage?
    
    private var cancellables = Set<AnyCancellable>()
    
    init(recipe: Recipe,image: UIImage?) {
        self.recipe = recipe
        self.image = image
    }
}
