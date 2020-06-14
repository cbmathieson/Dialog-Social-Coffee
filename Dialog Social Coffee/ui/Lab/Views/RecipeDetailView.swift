//
//  RecipeDetailView.swift
//  Dialog Social Coffee
//
//  Created by Craig Mathieson on 2020-05-24.
//  Copyright © 2020 Craig Mathieson. All rights reserved.
//

import SwiftUI
import Charts

struct RecipeDetailView: View {
    @ObservedObject var recipeDetailVM: RecipeDetailViewModel
    @State var showScaleConnectionScreen:Bool = false
    @State var coordinates:[ChartDataEntry] = []
    
    var body: some View {
        VStack {
            HStack {
                Text(String(format: "%.1f",recipeDetailVM.recipe.coffee_in))
                Text("->")
                Text(String(format: "%.1f",recipeDetailVM.recipe.coffee_out))
                Text("in")
                Text(String(format: "%.0f",recipeDetailVM.recipe.time) + "s")
            }
            Text(recipeDetailVM.recipe.comments)
                .font(.footnote)
            LineChartSwiftUI(coordinates: self.$coordinates,templateCoordinates: [])
                //use frame to change the graph size within your SwiftUI view
                .frame(width: 300, height: 300)
            Button(action: {
                self.showScaleConnectionScreen.toggle()
            }) {
                Text("Use Recipe")
            }
            .sheet(isPresented: self.$showScaleConnectionScreen) {
                Text("Go team")
            }
        }
        .navigationBarTitle("\(recipeDetailVM.recipe.title)")
        .onAppear(perform: {
            var counter:Double = 0
            for i in self.recipeDetailVM.recipe.brew_curve {
                self.coordinates.append(ChartDataEntry(x: counter * 0.25,y: i))
                counter += 1
            }
        })
    }
}

