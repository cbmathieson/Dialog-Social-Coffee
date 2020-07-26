//
//  testing.swift
//  Dialog Social Coffee
//
//  Created by Craig Mathieson on 2020-07-23.
//  Copyright © 2020 Craig Mathieson. All rights reserved.
//

import SwiftUI

struct testing: View {
    
    @State var isPressed:Bool = false
    
    var body: some View {
        NavigationView {
            Color.backgroundColor
                .edgesIgnoringSafeArea(.all)
                .overlay(
                    VStack {
                        Button(action: {}) {
                            Text("Reconnect to Scale").bold()
                        }
                        .softButtonStyle(RoundedRectangle(cornerRadius: 20), mainColor: Color.backgroundColor, textColor: Color.highlightColor,darkShadowColor: Color.darkShadow,lightShadowColor: Color.lightShadow)
                    }
                )
                .navigationTitle("Brew")
                //.foregroundColor(.textOnBackground)
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
