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
import Charts
import QGrid
import AcaiaSDK
import PartialSheet

struct RecipeListView: View {
    
    @ObservedObject var recipeListVM = RecipeListViewModel() // (7)
    @State var showRecipeCreation = false
    @State var showRecipeDetail = false
    
    @EnvironmentObject var partialSheet: PartialSheetManager
    @State private var connectionActionSheetVisible = false
    @State private var recipeActionSheetVisible = false
    
    // To add visual border to selected recipe
    @State var selectedRecipeId:String = ""
    
    
    /*private var scaleConnectionActionSheet: ActionSheet {
     // future development
     }*/
    
    var body: some View {
        NavigationView {
            VStack {
                /*
                 Current SwiftUI bug for popping to root from navbaritem. Will clean up
                 when fixed
                 */
                NavigationLink(destination: BrewView(isPresented: self.$showRecipeCreation),isActive: $showRecipeCreation){
                    EmptyView()
                }
                .isDetailLink(false)
                
                QGrid(recipeListVM.recipeCellViewModels, columns: 2,hPadding: 20) { recipeCellVM in
                    VStack {
                        
                        /*
                         From action sheet, programatically present navigation
                         - May be a better way but only make this an option if cell is selected
                         since it would trigger all detail views when showRecipeDetail == true
                         */
                        if recipeCellVM.recipe.id == self.selectedRecipeId {
                            NavigationLink(destination: RecipeDetailView(recipeDetailVM: RecipeDetailViewModel(recipe: recipeCellVM.recipe)),isActive: self.$showRecipeDetail){
                                EmptyView()
                            }
                            .isDetailLink(false)
                        }
                        
                        Button(action: {
                            self.selectedRecipeId = recipeCellVM.recipe.id
                            self.recipeActionSheetVisible = true
                        }) {
                            if recipeCellVM.recipe.id == self.selectedRecipeId && self.recipeActionSheetVisible {
                                RecipeCell(recipeCellVM: recipeCellVM)
                                    .border(Color.black, width: 4)
                                    .foregroundColor(.black)
                            } else {
                                RecipeCell(recipeCellVM: recipeCellVM)
                                    .foregroundColor(.black)
                            }
                        }
                    }
                    .actionSheet(isPresented: self.$recipeActionSheetVisible) {
                        ActionSheet(
                            title: Text("Recipe"), buttons: [
                                .default(Text("View"),action: {
                                    self.showRecipeDetail = true
                                }),
                                .destructive(Text("Delete"),action: {
                                    self.recipeListVM.removeRecipe(recipeId: self.selectedRecipeId)
                                }),
                                .cancel()])
                    }
                }
            }
            .navigationBarTitle("Lab")
            .navigationBarItems(trailing:
                Button(action: {
                    if let scale = AcaiaManager.shared().connectedScale {
                        print("Already connected to \(String(describing: scale.name))")
                        self.showRecipeCreation = true
                    } else {
                        withAnimation {
                            self.partialSheet.showPartialSheet({
                            }) {
                                ScaleConnectionPartialView(didConnect: self.$showRecipeCreation)
                            }
                        }
                    }
                }) { // (6)
                    Text("+").foregroundColor(.black)
            })
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .addPartialSheet()
    }
}

struct RecipeListView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeListView()
    }
}

struct RecipeCell: View {
    @ObservedObject var recipeCellVM: RecipeCellViewModel
    
    var body: some View {
        VStack {
            Text("\(self.recipeCellVM.recipe.title)").bold().font(.body).padding(.top)
            GeometryReader { p in
                LineChartPreview(coordinates: self.recipeCellVM.recipe.coordinates).frame(width: p.size.width, height: 100, alignment: .center)
            }
            Spacer().frame(height: 100) // geometry reader is causing overlapping so had to add
            VStack(alignment: .center) {
                Text(" \(String(format: "%.0f",self.recipeCellVM.recipe.time))s").font(.footnote)
                HStack {
                    Text("\(String(format: "%.1f",self.recipeCellVM.recipe.coffee_in))g  →  \(String(format: "%.1f",self.recipeCellVM.recipe.coffee_out))g").font(.footnote)
                }
            }.padding()
        }
    }
}
