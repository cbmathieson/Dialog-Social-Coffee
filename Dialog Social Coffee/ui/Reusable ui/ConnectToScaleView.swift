//
//  ConnectToScaleView.swift
//  Dialog Social Coffee
//
//  Created by Craig Mathieson on 2020-05-17.
//  Copyright © 2020 Craig Mathieson. All rights reserved.
//

import SwiftUI
import AcaiaSDK

struct ConnectToScaleView: View {
    
    @Binding var isPresented: Bool
    
    @State var connection:Connection = .none
    
    var body: some View {
        
        AcaiaConnectionView(connection: $connection)
        .navigationBarTitle("Connect")
        .navigationBarItems(trailing: connection != .none ? NavigationLink("Brew",destination: BrewView(isPresented: self.$isPresented,connection: $connection)).isDetailLink(false) : nil)
    }
}

enum Connection {
    case none,acaia
}

//MARK: Acaia Scale Connection

// This is NOT MVVM - will need to clean up in the future

struct AcaiaConnectionView: View {
    
    @Binding var connection:Connection
    
    @State private var prompt = "Hit Search to find nearby scales"
    @State private var state:ConnectionState = .loaded
    @State private var selectedScale = 0
    @State private var acaiaScales:[AcaiaScale] = []
    
    // Scale Observers
    let finishedScanPub = NotificationCenter.default
        .publisher(for: NSNotification.Name(rawValue: AcaiaScaleDidFinishScan))
    let connectedPub = NotificationCenter.default
        .publisher(for: NSNotification.Name(rawValue: AcaiaScaleDidConnected))
    let disconnectedPub = NotificationCenter.default
        .publisher(for: NSNotification.Name(rawValue: AcaiaScaleDidDisconnected))
    
    //MARK: View
    var body: some View {
        VStack {
            Spacer()
            //MARK: Prompt + Picker
            Text("\(prompt)")
            if state == .searching || state == .connecting || state == .disconnecting {
                Text("")
                    .onReceive(finishedScanPub) { _ in
                        self.finishedScan()
                }
                .onReceive(connectedPub) { _ in
                    self.onConnect()
                }
                .onReceive(disconnectedPub) { _ in
                    self.onDisconnect()
                }
            } else if state == .found {
                Picker(selection: $selectedScale,label: Text("Scales in range:")) {
                    ForEach(acaiaScales,id: \.self) { scale in
                        Text(scale.name)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .labelsHidden()
            }
            Spacer()
            //MARK: Action Buttons
            if state == .loaded {
                Button(action: {
                    // Scan and add scales to state array
                    self.acaiaScales = []
                    self.state = .searching
                    self.prompt = "Searching..."
                    AcaiaManager.shared().startScan(2.5)
                }) {
                    Text("Search")
                }
            } else if state == .found {
                Button(action: {
                    if let scale = AcaiaManager.shared().scaleList?[self.selectedScale] as? AcaiaScale{
                        self.prompt = "Connecting to \(scale.name ?? "")..."
                        self.state = .connecting
                        scale.connect()
                        self.startConnectTimer()
                    }
                }) {
                    Text("Pair")
                }
            } else if state == .connected {
                Button(action: {
                    self.acaiaScales = []
                    if let scale = AcaiaManager.shared().connectedScale {
                        self.state = .disconnecting
                        self.prompt = "Disconnecting..."
                        scale.disconnect()
                    }
                }) {
                    Text("disconnects broken, silly acaia")
                }
            } else {
                Button(action: {}) {
                    Text("Pair")
                }
                .hidden()
            }
            Spacer()
        }
        .onAppear(perform: { self.checkConnection() })
    }
    
    private func checkConnection() {
        if let scale = AcaiaManager.shared().connectedScale {
            self.prompt = "Connected to: \(scale.name ?? "?")"
            self.state = .connected
            self.connection = .acaia
        } else {
            self.prompt = "Hit Search to find nearby scales"
            self.state = .loaded
            self.connection = .none
        }
    }
    
    //MARK: Functions
    private func startConnectTimer() {
        // Delay of 5.0 seconds before checking if still trying
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            if self.state == .connecting {
                self.prompt = "failed to connect, turn the scale off/on and try again"
                self.state = .loaded
            }
        }
    }
    
    // Update UI after connection
    private func onConnect() {
        if let scale = AcaiaManager.shared().connectedScale {
            self.prompt = "Connected to: \(scale.name ?? "?")"
            self.state = .connected
            self.connection = .acaia
        }
    }
    
    // Update UI after disconnecting
    private func onDisconnect() {
        self.prompt = "Disconnected from scale"
        self.state = .loaded
        self.connection = .none
    }
    
    // Update array with scales found and update state
    private func finishedScan() {
        var scales:[AcaiaScale] = []
        for newScale in AcaiaManager.shared().scaleList {
            if let unwrappedScale = newScale as? AcaiaScale {
                scales.append(unwrappedScale)
            }
        }
        self.acaiaScales = scales
        print("# scales found: \(self.acaiaScales.count)")
        if self.acaiaScales.count == 0 {
            self.prompt = "No scales found :("
            self.state = .loaded
        } else {
            self.prompt = "Select your scale"
            self.state = .found
        }
    }
    
    enum ConnectionState {
        case loaded,searching,found,connecting,connected,disconnecting
    }
}
