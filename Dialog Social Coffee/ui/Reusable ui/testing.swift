//
//  testing.swift
//  Dialog Social Coffee
//
//  Created by Craig Mathieson on 2020-07-23.
//  Copyright © 2020 Craig Mathieson. All rights reserved.
//

import SwiftUI
import Neumorphic

struct testing: View {
    
    @State var isPressed:Bool = false
    
    var body: some View {
        NavigationView {
            Color.backgroundColor
                .edgesIgnoringSafeArea(.all)
                .overlay(
                    VStack {
                        Spacer()
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.backgroundColor).softOuterShadow()
                            .frame(width: 280, height: 300, alignment: .center)
                            .padding(.top)
                        Spacer()
                        HStack {
                            Spacer()
                            VStack {
                                Spacer()
                                VStack {
                                    Text("29").font(.largeTitle).bold()
                                    Text("(s)").font(.title)
                                }
                                Spacer()
                                if (self.isPressed) {
                                    Button(action: { self.isPressed.toggle()}){
                                    ZStack {
                                        //Circle()
                                        Image(systemName: "stop.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 30, height: 30)
                                    }
                                    .frame(width: 50, height: 50)
                                }
                                .softButtonStyle(Circle(), mainColor: Color.highlightColor, textColor: Color.backgroundColor,darkShadowColor: Color.darkShadow,lightShadowColor: Color.lightShadow)
                                } else {
                                    Button(action: {self.isPressed.toggle()}){
                                        ZStack {
                                            //Circle()
                                            Image(systemName: "play.fill")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 30, height: 30)
                                                .offset(x: 3)
                                        }
                                        .frame(width: 50, height: 50)
                                    }
                                    .softButtonStyle(Circle(), mainColor: Color.backgroundColor, textColor: Color.highlightColor,darkShadowColor: Color.darkShadow,lightShadowColor: Color.lightShadow)
                                }
                                Spacer()
                            }
                            Spacer()
                            VStack {
                                Spacer()
                                VStack {
                                    Text("40.0").font(.largeTitle).bold()
                                    Text("(g)").font(.title)
                                }
                                Spacer()
                                Button(action: {}){
                                    ZStack {
                                        Circle()
                                        Text("T")
                                            .font(.largeTitle).bold()
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(Color.textOnBackground)
                                    }
                                    .frame(width: 50, height: 50)
                                }.softButtonStyle(Circle(), mainColor: Color.backgroundColor, textColor: Color.textOnHighlight,darkShadowColor: Color.darkShadow,lightShadowColor: Color.lightShadow)
                                Spacer()
                            }
                            Spacer()
                        }
                        Spacer()
                    }
                )
                .navigationTitle("Brew")
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
