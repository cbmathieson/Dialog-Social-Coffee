//
//  RecipeListView.swift
//  Dialog Social Coffee
//
//  Created by Craig Mathieson on 2020-05-16.
//  Copyright © 2020 Craig Mathieson. All rights reserved.
//
/*
 
 (1) Simply using the cells present in our VM
 (2) Present Connect to Scale View on click
 (6) On button click, toggle
 (7) Reference to VM
 (8) Presents all recipes from VM reference
 
 */

import SwiftUI
import Disk // NOT MVVM DAWG

struct RecipeListView: View {
    
    @ObservedObject var recipeListVM = RecipeListViewModel() // (7)
    @State var showRecipeCreation = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                List {
                    ForEach (recipeListVM.recipeCellViewModels) { recipeCellVM in // (8)
                        RecipeCell(recipeCellVM: recipeCellVM) // (1)
                    }
                    .onDelete { indexSet in
                        self.recipeListVM.removeRecipes(atOffsets: indexSet)
                    }
                }
                Button(action: { self.showRecipeCreation = true }) { // (6)
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("New Recipe")
                    }
                }
                .padding()
                .accentColor(Color(UIColor.systemRed))
                    .sheet(isPresented: $showRecipeCreation) { // (2)
                        ConnectToScaleView(isPresented: self.$showRecipeCreation)
                }
            }
            .navigationBarTitle("Recipes")
        }
    }
}

struct RecipeListView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeListView()
    }
}

/*
 (0) RecipeCell is designed outside for simplicity
 (1) Accessing our ViewModel
 
 */

struct RecipeCell: View { // (0)
    @ObservedObject var recipeCellVM: RecipeCellViewModel // (1)
    @State var image:UIImage? = nil
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(recipeCellVM.recipe.title).font(.headline)
                Text("\(String(format: "%.1f",recipeCellVM.recipe.coffee_in)) -> \(String(format: "%.1f",recipeCellVM.recipe.coffee_out)) (\(recipeCellVM.recipe.brew_ratio))").font(.body)
                Text("@ \(String(format: "%.0f",recipeCellVM.recipe.time))s").font(.body)
            }
            GeometryReader{ (proxy : GeometryProxy) in  // New Code
                VStack(alignment: .trailing) {
                    if self.image != nil {
                        Image(uiImage: self.image!)
                            .resizable()
                            .frame(width: proxy.size.height, height: proxy.size.height)
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(2)
                    } else {
                        Image(systemName: "chevron.right")
                    }
                }
                    .frame(width: proxy.size.width, height:proxy.size.height , alignment: .trailing) // New Code
            }
        }
        .onTapGesture {
            // open detail view
        }
        .onAppear(perform: {
            //get image if available
            do {
                self.image = try Disk.retrieve(self.recipeCellVM.recipe.image, from: .documents, as: UIImage.self)
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
        })
    }
}

enum InputError: Error {
    case empty
}