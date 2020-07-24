//
//  testing.swift
//  Dialog Social Coffee
//
//  Created by Craig Mathieson on 2020-07-23.
//  Copyright © 2020 Craig Mathieson. All rights reserved.
//

import SwiftUI

struct testing: View {
    var body: some View {
        NavigationView {
            Color.backgroundColor
                .edgesIgnoringSafeArea(.all)
                .overlay(
                    VStack {
                        Button("Show Menu", action: {
                            
                        }).buttonStyle(NeumorphicButtonStyle())
                    })
                .navigationTitle("Testing")
                .foregroundColor(.textOnBackground)
        }
    }
}

struct testing_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            testing()
        }
    }
}
