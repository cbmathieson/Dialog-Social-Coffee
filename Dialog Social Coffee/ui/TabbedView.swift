//
//  ContentView.swift
//  Dialog Social Coffee
//
//  Created by Craig Mathieson on 2020-05-16.
//  Copyright © 2020 Craig Mathieson. All rights reserved.
//

import SwiftUI

struct TabbedView: View {
    @State private var selection = 0
 
    var body: some View {
        TabView(selection: $selection){
            RecipeListView()
                .font(.title)
                .tabItem {
                    VStack {
                        Image(systemName: "lightbulb")
                        Text("Lab")
                    }
                }
                .tag(0)
        }.accentColor(.black)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TabbedView()
    }
}
