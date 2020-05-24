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
import Disk

class RecipeCellViewModel: ObservableObject, Identifiable  { // (6)
  @Published var recipe: Recipe
    @Published var image: UIImage?
  
  private var cancellables = Set<AnyCancellable>()
  
  init(recipe: Recipe) {
    self.recipe = recipe
    
    //get image if available
    if self.recipe.image != "" {
        do {
            let imageData = try Disk.retrieve(self.recipe.image, from: .documents, as: Data.self)
            self.image = UIImage(data: imageData)
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
}
