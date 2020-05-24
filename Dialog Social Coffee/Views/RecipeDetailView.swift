//
//  RecipeDetailView.swift
//  Dialog Social Coffee
//
//  Created by Craig Mathieson on 2020-05-24.
//  Copyright © 2020 Craig Mathieson. All rights reserved.
//

import SwiftUI

struct RecipeDetailView: View {
    @ObservedObject var recipeDetailVM: RecipeDetailViewModel
    
    var body: some View {
        VStack {
            if recipeDetailVM.image != nil {
                Image(uiImage: recipeDetailVM.image!)
            } else {
                Text("No image bro")
            }
        }
    }
}
