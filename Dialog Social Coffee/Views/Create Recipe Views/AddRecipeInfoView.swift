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
    
    @State private var showImagePicker: Bool = false
    @State private var image: UIImage? = nil
    
    @Binding var isPresented: Bool
    @ObservedObject var addRecipeInfoVM = AddRecipeInfoViewModel()
    
    @State var coordinates:[ChartDataEntry]
    @State var recipe_name:String = ""
    @State var bean_id:String = ""
    @State var gramsIn:String = ""
    @State var comments:String = ""
    
    var body: some View {
        ScrollView(.vertical) {
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
                VStack {
                    Image(uiImage: self.image!)
                        .resizable()
                        .aspectRatio(self.image!.size, contentMode: .fit)
                        .frame(width: 300)
                }
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
            Button(action: {
                // Passes off to Save to Disk
                self.addRecipeInfoVM.addRecipe(recipe_name: self.recipe_name, image: self.image, comments: self.comments, gramsIn: self.gramsIn, bean_id: self.bean_id, coordinates: self.coordinates)
                
                self.isPresented = false
            }) {
                Text("Save")
            }
            .padding()
        }
        .navigationBarTitle(Text("Recipe Info"))
    }
}
