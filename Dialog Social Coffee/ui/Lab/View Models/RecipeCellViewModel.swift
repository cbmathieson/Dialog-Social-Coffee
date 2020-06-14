//
//  RecipeCellViewModel.swift
//  Dialog Social Coffee
//
//  Created by Craig Mathieson on 2020-05-16.
//  Copyright © 2020 Craig Mathieson. All rights reserved.
//

/*
 (6) Identifiable since it's going into a list
 (7) every time the recipe attribute is changed, the value of id will be updated
 this is done by Recipe being @Published and subscribing in the init
 */

import Foundation
import Combine
import SwiftUI

class RecipeCellViewModel: ObservableObject, Identifiable  { // (6)
    @Published var recipe: Recipe
    
    private var cancellables = Set<AnyCancellable>()
    
    init(recipe: Recipe) {
        self.recipe = recipe
    }
}
