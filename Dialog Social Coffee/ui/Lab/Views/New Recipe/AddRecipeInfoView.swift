//
//  AddRecipeInfoView.swift
//  Dialog Social Coffee
//
//  Created by Craig Mathieson on 2020-05-17.
//  Copyright © 2020 Craig Mathieson. All rights reserved.
//

import SwiftUI
import Charts
import Combine

struct AddRecipeInfoView: View {
    
    @Binding var isPresented: Bool
    @ObservedObject var addRecipeInfoVM = AddRecipeInfoViewModel()
    
    @State var coordinates:[ChartDataEntry]
    @State var recipe_name:String = ""
    @State var bean_id:String = ""
    @State var gramsIn:String = ""
    @State var comments:String = ""
    
    var body: some View {
        ScrollView {
            TextField("Recipe Name", text: $recipe_name).font(.system(size: 30, weight: .heavy, design: .default)).padding(.leading)
            VStack{
                TextField("coffee in (g)", text: $gramsIn)
                    .onReceive(Just(gramsIn)) { newValue in
                        let filtered = newValue.filter { "0123456789.".contains($0) }
                        if filtered != newValue {
                            self.gramsIn = filtered
                        }
                }.padding()
                TextField("comments",text: $comments).padding(.bottom).padding(.leading)
                LineChartSwiftUI(coordinates: self.$coordinates,templateCoordinates: [])
                    //use frame to change the graph size within your SwiftUI view
                    .frame(width: 300, height: 300)
                    .padding(.bottom)
                Button(action: {
                    // Passes off to Save to Disk
                    self.addRecipeInfoVM.addRecipe(recipe_name: self.recipe_name, comments: self.comments, gramsIn: self.gramsIn, bean_id: self.bean_id, coordinates: self.coordinates)
                    self.isPresented = false
                }) {
                    Text("save")
                        .font(.body).bold()
                        .lineLimit(1)
                        //.minimumScaleFactor(0.5)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.black)
                }
            }
        }
            //.navigationBarHidden(true)
            //.navigationBarTitle(Text(""))
            //.edgesIgnoringSafeArea([.top, .bottom])
    }
}
