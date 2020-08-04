//
//  ScaleConnectionPartialView.swift
//  Dialog Social Coffee
//
//  Created by Craig Mathieson on 2020-06-14.
//  Copyright © 2020 Craig Mathieson. All rights reserved.
//

import SwiftUI
import AcaiaSDK

struct ScaleConnectionPartialView: View {
    
    @Binding var didConnect:Bool
    @Binding var showPopUp:Bool
    @Environment(\.colorScheme) var colorScheme
    
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Connect to Scale").font(.title).padding()
            Image(colorScheme == .dark ? "acaia-silver" : "acaia_scale")
                .resizable()
                .frame(width: 100,height:100)
            //.padding(.bottom)
            AcaiaConnectionStatus(didConnect: $didConnect,showPopUp: $showPopUp).padding(.bottom)
        }
        .foregroundColor(.textOnBackground)
    }
}

//MARK: Acaia Scale Connection

struct AcaiaConnectionStatus: View {
    
    @Binding var didConnect:Bool
    @Binding var showPopUp:Bool
    
    @State private var shouldAnimate = false
    
    @State private var prompt = "find nearby scales"
    @State private var state:ConnectionState = .loaded
    @State private var selectedScale = 0
    @State private var acaiaScales:[AcaiaScale] = []
    
    // Scale Observers
    let finishedScanPub = NotificationCenter.default
        .publisher(for: NSNotification.Name(rawValue: AcaiaScaleDidFinishScan))
    let connectedPub = NotificationCenter.default
        .publisher(for: NSNotification.Name(rawValue: AcaiaScaleDidConnected))
    
    //MARK: View
    var body: some View {
        VStack {
            if state == .searching || state == .connecting {
                ActivityIndicator(shouldAnimate: self.$shouldAnimate).padding()
                    .onReceive(finishedScanPub) { _ in
                        self.finishedScan()
                    }
                    .onReceive(connectedPub) { _ in
                        self.onConnect()
                    }
                //Text("")
            } else if state == .found {
                Picker(selection: $selectedScale,label: Text("")) {
                    ForEach(acaiaScales,id: \.self) { scale in
                        Text(scale.name)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .labelsHidden()
                Button(action: {
                    if let scale = AcaiaManager.shared().scaleList?[self.selectedScale] as? AcaiaScale {
                        self.shouldAnimate = true
                        self.state = .connecting
                        scale.connect()
                        self.startConnectTimer()
                    }
                }) {
                    Text("Pair")
                        .frame(width: 100,height: 20)
                }.softButtonStyle(RoundedRectangle(cornerRadius: 20), mainColor: Color.flatElementColor, textColor: Color.textOnBackground,darkShadowColor: Color.highlightDarkShadow,lightShadowColor: Color.highlightLightShadow)
                
            } else if state == .loaded {
                Text("\(prompt)").font(.body).minimumScaleFactor(0.5).padding().multilineTextAlignment(.center)
                Button(action: {
                    // Scan and add scales to state array
                    self.acaiaScales = []
                    self.state = .searching
                    self.shouldAnimate = true
                    AcaiaManager.shared().startScan(2.5)
                }) {
                    Text("Search")
                        .frame(width: 100,height: 20)
                }.softButtonStyle(RoundedRectangle(cornerRadius: 20), mainColor: Color.flatElementColor, textColor: Color.textOnBackground,darkShadowColor: Color.highlightDarkShadow,lightShadowColor: Color.highlightLightShadow)
            } else if state == .connected {
                    Text("\(prompt)").font(.body).padding().multilineTextAlignment(.center)
                    Text("")
                }
        }.onAppear {
            self.state = .loaded
        }
    }
    
    //MARK: Functions
    private func startConnectTimer() {
        // Delay of 5.0 seconds before checking if still trying
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            if self.state == .connecting {
                self.prompt = "failed to connect\nturn the scale off/on and try again"
                self.state = .loaded
            }
        }
    }
    
    // Update UI after connection
    private func onConnect() {
        self.shouldAnimate = true
        if let scale = AcaiaManager.shared().connectedScale {
            self.prompt = "Connected to: \(scale.name ?? "?")"
            self.state = .connected
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.showPopUp = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.didConnect = true
                }
            }
        }
    }
    
    // Update array with scales found and update state
    private func finishedScan() {
        self.shouldAnimate = false
        var scales:[AcaiaScale] = []
        for newScale in AcaiaManager.shared().scaleList {
            if let unwrappedScale = newScale as? AcaiaScale {
                scales.append(unwrappedScale)
            }
        }
        self.acaiaScales = scales
        if self.acaiaScales.count == 0 {
            self.prompt = "No scales found :("
            self.state = .loaded
        } else {
            self.prompt = "Select your scale"
            self.state = .found
        }
    }
    
    enum ConnectionState {
        case loaded,searching,found,connecting,connected
    }
}

