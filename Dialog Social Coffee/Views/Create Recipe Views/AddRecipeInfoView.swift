//
//  AddRecipeInfoView.swift
//  Dialog Social Coffee
//
//  Created by Craig Mathieson on 2020-05-17.
//  Copyright © 2020 Craig Mathieson. All rights reserved.
//

// NOT MVVM - need to fix later

import SwiftUI
import Charts
import Combine
import UIKit
import Disk

struct AddRecipeInfoView: View {
    
    @State private var showImagePicker: Bool = false
    @State private var image: UIImage? = nil
    
    @Binding var isPresented: Bool
    @ObservedObject var recipeListVM = RecipeListViewModel()
    
    @State var coordinates:[ChartDataEntry]
    @State var recipe_name:String = ""
    @State var bean_id:String = ""
    @State var gramsIn:String = ""
    @State var comments:String = ""
    
    var body: some View {
        VStack {
            VStack{
                TextField("Recipe Name", text: $recipe_name).padding()
                TextField("coffee in (g)", text: $gramsIn)
                    .onReceive(Just(gramsIn)) { newValue in
                        let filtered = newValue.filter { "0123456789.".contains($0) }
                        if filtered != newValue {
                            self.gramsIn = filtered
                        }
                }.padding()
                TextField("any comments?",text: $comments).padding()
            }
            ScrollView(.horizontal) {
                HStack {
                    if bean_id == "" {
                        Button(action: {
                            self.bean_id = "3f24g430qjrgvs"
                        }) {
                            Text("Add Bean")
                        }
                    } else {
                        Text("\(bean_id)")
                    }
                    LineChartSwiftUI(coordinates: self.$coordinates)
                        //use frame to change the graph size within your SwiftUI view
                        .frame(width: 300, height: 300)
                    if self.image != nil {
                        Image(uiImage: self.image!)
                            .resizable()
                            .frame(width: 300,height:300)
                            .aspectRatio(contentMode: .fit)
                    } else {
                        Button(action: {
                            self.showImagePicker.toggle()
                        }) {
                            Text("Add Image")
                        }
                        .sheet(isPresented: self.$showImagePicker) {
                            CameraView(showCameraView: self.$showImagePicker, pickedImage: self.$image)
                        }
                    }
                }
            }
            Button(action: {
                // save image to disk and create identifiable name
                var image_location = ""
                if let recipe_image = self.image {
                    image_location = UUID().uuidString
                    do {
                        try Disk.save(recipe_image, to: .documents, as: "Recipe_Photos/\(image_location).png")
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
                
                self.recipeListVM.addRecipe(recipe: Recipe(title: self.recipe_name, image: "Recipe_Photos/\(image_location).png", comments: self.comments, coffee_in: self.convertToDouble(coffee_in: self.gramsIn), bean_id: self.bean_id, brew_curve: self.convertCoordinates(coordinates: self.coordinates)))
                self.isPresented = false
            }) {
                Text("Save")
            }
            .padding()
        }
        .navigationBarTitle(Text("Recipe Info"))
    }
    
    private func convertToDouble(coffee_in: String) -> Double {
        if let value = Double(self.gramsIn) {
            return value
        } else {
            return 19.5
        }
    }
    
    private func convertCoordinates(coordinates: [ChartDataEntry]) -> [Double] {
        var set:[Double] = []
        for i in coordinates {
            set.append(i.y)
        }
        return set
    }
}
