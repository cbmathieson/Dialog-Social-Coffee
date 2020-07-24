//
//  RecipeDetailView.swift
//  Dialog Social Coffee
//
//  Created by Craig Mathieson on 2020-05-24.
//  Copyright © 2020 Craig Mathieson. All rights reserved.
//

import SwiftUI
import Charts
import AcaiaSDK
import PartialSheet

struct RecipeDetailView: View {
    @ObservedObject var recipeDetailVM: RecipeDetailViewModel
    @EnvironmentObject var partialSheet: PartialSheetManager
    
    @State var coordinates:[ChartDataEntry] = []
    
    @State var useBrewPagePresented:Bool = false
    
    var body: some View {
        Color.backgroundColor
            .edgesIgnoringSafeArea(.all)
            .overlay(
                VStack {
                    
                    /*
                     From partialsheet, programatically present navigation
                     */
                    NavigationLink(destination: BrewView(isPresented: self.$useBrewPagePresented, templateCoordinates: recipeDetailVM.recipe.coordinates),isActive: self.$useBrewPagePresented){
                        EmptyView()
                    }
                    .isDetailLink(false)
                    
                    HStack {
                        Text(recipeDetailVM.recipe.comments)
                            .font(.body).bold()
                            .frame(alignment: .leading)
                        Spacer()
                    }
                    .padding()
                    VStack {
                        HStack {
                            Text("\(String(format: "%.0f",recipeDetailVM.recipe.time))s").font(.body).bold()
                                .frame(alignment: .leading)
                            Spacer()
                        }
                        .padding()
                        HStack {
                            
                            Text("\(String(format: "%.1f",recipeDetailVM.recipe.coffee_in))g  →  \(String(format: "%.1f",recipeDetailVM.recipe.coffee_out))g")
                                .font(.body).bold()
                                .frame(alignment: .leading)
                            Spacer()
                        }
                        .padding()
                    }
                    LineChartDetail(coordinates: recipeDetailVM.recipe.coordinates)
                        //use frame to change the graph size within your SwiftUI view
                        .cornerRadius(10)
                        .frame(width: 280, height: 300)
                        .padding()
                        .NeumorphicViewStyle()
                    Button(action: {
                        if let scale = AcaiaManager.shared().connectedScale {
                            print("Already connected to \(String(describing: scale.name))")
                            self.useBrewPagePresented = true
                        } else {
                            withAnimation {
                                self.partialSheet.showPartialSheet({
                                }) {
                                    ScaleConnectionPartialView(didConnect: self.$useBrewPagePresented)
                                }
                            }
                        }
                    }) {
                        Text("use recipe")
                    }
                    .buttonStyle(NeumorphicButtonStyle())
                    .padding()
                })
            .onAppear {
                // Current workaround since onDisappear does not work with navigation in BrewView
                UIApplication.shared.isIdleTimerDisabled = false
            }
            .foregroundColor(.textOnBackground)
            .navigationBarTitle("\(recipeDetailVM.recipe.title)")
    }
}

