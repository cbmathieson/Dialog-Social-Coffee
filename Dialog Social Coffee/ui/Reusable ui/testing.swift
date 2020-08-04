//
//  testing.swift
//  Dialog Social Coffee
//
//  Created by Craig Mathieson on 2020-07-23.
//  Copyright © 2020 Craig Mathieson. All rights reserved.
//

import SwiftUI
import Charts
import Combine

struct testing: View {
    
    @ObservedObject var addRecipeInfoVM = AddRecipeInfoViewModel()
    
    @State var coordinates:[ChartDataEntry]
    @State var recipe_name:String = ""
    @State var gramsIn:String = ""
    @State var comments:String = ""
    
    static var test:String = ""
    static var testBinding = Binding<String>(get: { test }, set: { test = $0 } )
    var body: some View {
        NavigationView {
            Color.backgroundColor
                .edgesIgnoringSafeArea(.all)
                .overlay(
                    VStack {
                        VStack(alignment: .leading) {
                            TextField("Recipe Name", text: $recipe_name).font(.system(size: 30, weight: .heavy, design: .default)).padding(.leading)
                            TextField("coffee in (g)", text: $gramsIn)
                                .onReceive(Just(gramsIn)) { newValue in
                                    let filtered = newValue.filter { "0123456789.".contains($0) }
                                    if filtered != newValue {
                                        self.gramsIn = filtered
                                    }
                                }.padding()
                        }
                        VStack(alignment: .center) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.backgroundColor)
                                    .frame(width: 300, height: 320, alignment: .center)
                                    .softOuterShadow(darkShadow: Color.darkShadow, lightShadow: Color.lightShadow)
                                LineChartSwiftUI(coordinates: self.$coordinates,templateCoordinates: [])
                                    //use frame to change the graph size within your SwiftUI view
                                    .frame(width: 280, height: 300,alignment: .center)
                            }
                            Spacer()
                            HStack {
                                Spacer()
                                VStack {
                                    Text("\(round(self.coordinates[coordinates.count].x))").font(.title).bold()
                                    Text("s").font(.headline)
                                }
                                Spacer()
                                VStack {
                                    Text("\(self.coordinates[coordinates.count].y)").font(.title).bold()
                                    Text("g").font(.headline)
                                }
                                Spacer()
                            }
                            Spacer()
                            Button(action: {
                            }) {
                                Text("Save").bold()
                                .frame(width: 150, alignment: .center)
                            }
                            .softButtonStyle(RoundedRectangle(cornerRadius: 20), mainColor: Color.backgroundColor, textColor: Color.highlightColor,darkShadowColor: Color.darkShadow,lightShadowColor: Color.lightShadow)
                            Spacer()
                        }
                    }
                    .padding()
                    .navigationBarTitle(Text(""), displayMode: .inline)
                )
        }
        
    }
}

struct testing_Previews: PreviewProvider {
    static var previews: some View {
        testing(coordinates: [ChartDataEntry(x: 0.0, y: 0.0),ChartDataEntry(x: 0.25, y: 0.0),ChartDataEntry(x: 0.5, y: 0.75),ChartDataEntry(x: 1.0, y: 0.0),ChartDataEntry(x: 1.25, y: 1.5),ChartDataEntry(x: 1.75, y: 0.4),ChartDataEntry(x: 2.0, y: 0.9),ChartDataEntry(x: 2.5, y: 1.4)])
    }
}
