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

struct RecipeListView: View {
    
    @ObservedObject var recipeListVM = RecipeListViewModel() // (7)
    @State var showRecipeCreation = false
    @State var showRecipeDetail = false
    
    @State private var connectionActionSheetVisible = false
    @State private var recipeActionSheetVisible = false
    @State private var showConnectionPopUp:Bool = false
    
    // To add visual border to selected recipe
    @State var selectedRecipeId:String = ""
    
    
    /*private var scaleConnectionActionSheet: ActionSheet {
     // future development
     }*/
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundColor
                    .edgesIgnoringSafeArea(.all)
                    .overlay(
                        VStack {
                            /*
                             Current SwiftUI bug for popping to root from navbaritem. Will clean up
                             when fixed
                             */
                            NavigationLink(destination: BrewView(isPresented: self.$showRecipeCreation, templateCoordinates: []),isActive: $showRecipeCreation){
                                EmptyView()
                            }
                            .isDetailLink(false)
                            
                            
                            QGrid(recipeListVM.recipeCellViewModels, columns: 2) { recipeCellVM in
                                ZStack {
                                    /*RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.flatElementColor)*/
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
                                        
                                        /*Button(action: {
                                            self.selectedRecipeId = recipeCellVM.recipe.id
                                            self.recipeActionSheetVisible = true
                                        }) {
                                            if recipeCellVM.recipe.id == self.selectedRecipeId && self.recipeActionSheetVisible {
                                                RecipeCell(recipeCellVM: recipeCellVM)
                                                    .border(Color.black, width: 4)
                                            } else {
                                                RecipeCell(recipeCellVM: recipeCellVM)
                                                .padding()
                                            }
                                        }*/
                                            Button(action: {
                                                self.selectedRecipeId = recipeCellVM.recipe.id
                                                self.recipeActionSheetVisible = true
                                            }) {
                                                RecipeCell(recipeCellVM: recipeCellVM)
                                            }.softButtonStyle(RoundedRectangle(cornerRadius: 20), mainColor: Color.backgroundColor, textColor: Color.textOnBackground,darkShadowColor: Color.darkShadow,lightShadowColor: Color.lightShadow,isDepressed: recipeCellVM.recipe.id == self.selectedRecipeId && self.recipeActionSheetVisible)
                                            .disabled(self.showConnectionPopUp)
                                    }
                                    .padding(8)
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
                            .padding(.top)
                            .edgesIgnoringSafeArea(.bottom)
                        })
                    .onAppear {
                        // Current workaround since onDisappear does not work with navigation in BrewView
                        UIApplication.shared.isIdleTimerDisabled = false
                    }
            }
            .popup(isPresented: self.$showConnectionPopUp, type: .toast, position: .bottom,closeOnTap: false,closeOnTapOutside: true) {
                ScaleConnectionPartialView(didConnect: self.$showRecipeCreation,showPopUp: self.$showConnectionPopUp)
                    .scaleConnectionStyle()
            }
            .navigationBarTitle("Lab")
            .navigationBarItems(trailing: Button(action: {
                                        if let scale = AcaiaManager.shared().connectedScale {
                                            print("Already connected to \(String(describing: scale.name))")
                                            self.showRecipeCreation = true
                                        } else {
                                            self.showConnectionPopUp = true
                                        }
                                    }) { // (6)
                                        Text("+").font(.largeTitle)
                                    })
        }
        .foregroundColor(.textOnBackground)
        .navigationViewStyle(StackNavigationViewStyle())
        .accentColor(.textOnBackground)
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
                LineChartPreview(coordinates: self.recipeCellVM.recipe.coordinates,lineColor: UIColor.highlightColor).frame(width: p.size.width, height: 100, alignment: .center)
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
