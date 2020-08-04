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
import PopupView

struct RecipeDetailView: View {
    @ObservedObject var recipeDetailVM: RecipeDetailViewModel
    
    @State var coordinates:[ChartDataEntry] = []
    @State var useBrewPagePresented:Bool = false
    @State var showConnectionPopUp:Bool = false
    
    var body: some View {
        ZStack {
            Color.backgroundColor
                .edgesIgnoringSafeArea(.all)
                .overlay(
                    VStack {
                        
                        /*
                         From connection popup, programatically present navigation
                         */
                        NavigationLink(destination: BrewView(isPresented: self.$useBrewPagePresented, templateCoordinates: recipeDetailVM.recipe.coordinates),isActive: self.$useBrewPagePresented){
                            EmptyView()
                        }
                        .isDetailLink(false)
                        HStack {
                            Spacer()
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.backgroundColor)
                                    .frame(height: 75)
                                    .softOuterShadow(darkShadow: Color.darkShadow, lightShadow: Color.lightShadow)
                                HStack {
                                    Spacer()
                                    VStack {
                                        Text("\(String(format: "%.1f",recipeDetailVM.recipe.coffee_in))g").font(.headline).bold()
                                        Text("in").font(.body)
                                    }
                                    Spacer()
                                    VStack {
                                        Text("\(String(format: "%.1f",recipeDetailVM.recipe.coffee_out))g").font(.headline).bold()
                                        Text("out").font(.body)
                                    }
                                    Spacer()
                                    VStack {
                                        Text("\(String(format: "%.0f",recipeDetailVM.recipe.time))s").font(.headline).bold()
                                        Text("time").font(.body)
                                    }
                                    Spacer()
                                }
                            }
                            Spacer()
                        }
                        .padding()
                        LineChartDetail(coordinates: recipeDetailVM.recipe.coordinates,textColor: UIColor.textOnBackground, lineColor: UIColor.highlightColor)
                            .frame(width: 310, height: 310, alignment: .center)
                        Spacer()
                        HStack {
                            Spacer()
                            Text(recipeDetailVM.recipe.comments)
                                .font(.body).bold()
                                .frame(alignment: .center)
                            Spacer()
                        }
                        .padding()
                        Spacer()
                        Button(action: {
                            
                            if let scale = AcaiaManager.shared().connectedScale {
                                print("Already connected to \(String(describing: scale.name))")
                                self.useBrewPagePresented = true
                            } else {
                                self.showConnectionPopUp = true
                            }
                        }) {
                            Text("Use Recipe").bold()
                                .frame(width: 200,height: 25)
                        }
                        .softButtonStyle(RoundedRectangle(cornerRadius: 30), mainColor: Color.highlightColor, textColor: Color.textOnHighlight,darkShadowColor: Color.highlightDarkShadow,lightShadowColor: Color.highlightLightShadow)
                        Spacer()
                    })
        }.popup(isPresented: self.$showConnectionPopUp, type: .toast, position: .bottom,closeOnTap: false,closeOnTapOutside: true) {
            ScaleConnectionPartialView(didConnect: self.$useBrewPagePresented,showPopUp: self.$showConnectionPopUp)
                .scaleConnectionStyle()
        }
        .onAppear {
            // Current workaround since onDisappear does not work with navigation in BrewView
            UIApplication.shared.isIdleTimerDisabled = false
        }
        .foregroundColor(.textOnBackground)
        .navigationBarTitle("\(recipeDetailVM.recipe.title)")
    }
}
