//
//  RecipeDetailViewModel.swift
//  Dialog Social Coffee
//
//  Created by Craig Mathieson on 2020-05-18.
//  Copyright © 2020 Craig Mathieson. All rights reserved.
//

import Foundation
import Combine

class RecipeDetailViewModel: ObservableObject  { // (6)
  @Published var recipe: Recipe
  
  private var cancellables = Set<AnyCancellable>()
  
  init(recipe: Recipe) {
    self.recipe = recipe

    /*$recipe // (7)
      .map { $0.id }
      .assign(to: \.id, on: self)
      .store(in: &cancellables)
*/
  }
}
