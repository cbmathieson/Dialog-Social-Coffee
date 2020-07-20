//
//  BrewView.swift
//  Dialog Social Coffee
//
//  Created by Craig Mathieson on 2020-05-17.
//  Copyright © 2020 Craig Mathieson. All rights reserved.
//

import SwiftUI
import AcaiaSDK
import Charts
import Combine
import PartialSheet

struct BrewView: View {
    
    @Binding var isPresented: Bool
    @EnvironmentObject var partialSheet: PartialSheetManager
    var templateCoordinates:[ChartDataEntry]
    
    @State var showInfoPage:Bool = false
    @State var coordinates = [ChartDataEntry(x:0,y:0)]
    @State var isConnected:Bool = true
    @State var lastWeight:Double = 0
    @State var lastTime:Double = 0
    @State var state:BrewState = .loaded
    // 1/4 second chart resolution
    @State var brewCoordinates:[Double] = [0]
    // takes most recent time from scale update and gets compared to each time pub updates
    @State var lastScaleTime:Double = 0
    @State var scaleInitiated:Bool = false
    
    //MARK: Observers
    @State var timer: Timer.TimerPublisher = Timer.publish (every: 0.25, on: .main, in: .common)
    let weightPub = NotificationCenter.default.publisher(for: NSNotification.Name(rawValue: AcaiaScaleWeight))
    // checks to see if time starts so you can initiate from scale
    let scaleSentTime = NotificationCenter.default.publisher(for: Notification.Name(rawValue: AcaiaScaleTimer))
    // Catches if the scale disconnects
    let didDisconnect = NotificationCenter.default.publisher(for: Notification.Name(rawValue: AcaiaScaleDidDisconnected))
    
    var body: some View {
        VStack {
            //MARK: LineChart
            LineChartSwiftUI(coordinates: self.$coordinates,templateCoordinates: self.templateCoordinates)
                .frame(width: 300, height: 300)
                .padding(.top)
            //MARK: Info Stack
            HStack(alignment: .center) {
                Spacer()
                VStack {
                    Spacer()
                    // round seconds
                    if scaleInitiated {
                        Text("\(Int(ceil(lastTime)))")
                            .font(.title).bold()
                    } else {
                        Text("\(Int(floor(lastTime)))")
                            .font(.title).bold()
                    }
                    Text("(s)")
                        .font(.headline).bold()
                    Spacer()
                    if self.state == .brewing {
                        Button(action: {
                            print("User clicked stop")
                            if let scale = AcaiaManager.shared().connectedScale {
                                scale.pauseTimer()
                                self.cancelTimer()
                                self.lastScaleTime = 0
                                self.cropData()
                                self.state = .done
                            } else {
                                self.isConnected = false
                            }
                        }){
                            Text("stop")
                                .font(.body).bold()
                                .lineLimit(1)
                                //.minimumScaleFactor(0.5)
                                .padding()
                                .foregroundColor(.white)
                                .background(!self.isConnected ? Color.gray : Color.black)
                        }
                        .disabled(!self.isConnected)
                        .onReceive(timer) {_ in
                            self.onTime()
                        }
                        // if timer is stopped from scale, stop in app
                        .onReceive(scaleSentTime) {_ in
                            if self.state == .brewing {
                                self.lastScaleTime = self.lastTime
                            }
                        }
                    } else {
                        Button(action: {
                            if let scale = AcaiaManager.shared().connectedScale {
                                self.brewCoordinates = [0,0]
                                self.coordinates = [ChartDataEntry(x:0,y:0)]
                                self.lastTime = 0
                                scale.stopTimer()
                                scale.startTimer()
                                self.instantiateTimer()
                                print(self.timer.connect())
                                self.scaleInitiated = false
                                self.state = .brewing
                            } else {
                                self.isConnected = false
                            }
                        }){
                            if self.state == .done {
                                Text("restart")
                                    .font(.body).bold()
                                    .lineLimit(1)
                                    //.minimumScaleFactor(0.5)
                                    .padding()
                                    .foregroundColor(.white)
                                    .background(!self.isConnected ? Color.gray : Color.black)
                            } else {
                                Text("start")
                                    .font(.body).bold()
                                    .lineLimit(1)
                                    //.minimumScaleFactor(0.5)
                                    .padding()
                                    .foregroundColor(.white)
                                    .background(!self.isConnected ? Color.gray : Color.black)
                            }
                        }
                        .disabled(!self.isConnected)
                        // if timer started from scale, start in app
                        .onReceive(scaleSentTime) { output in
                            print("received timer update")
                            guard let scaleTime = output.userInfo![AcaiaScaleTimer] as? NSNumber else {
                                return
                            }
                            print(scaleTime)
                            if Double(truncating: scaleTime) <= 1.0 {
                                self.brewCoordinates = [0,0]
                                self.coordinates = [ChartDataEntry(x:0,y:0)]
                                self.lastTime = 0
                                self.instantiateTimer()
                                print(self.timer.connect())
                                self.scaleInitiated = true
                                self.state = .brewing
                            }
                        }
                        //.padding(40)
                    }
                    Spacer()
                }
                Spacer()
                VStack {
                    Spacer()
                    Text(self.state == .loaded ? "\(String(format: "%.1f",lastWeight))" : "\(String(format: "%.1f",self.brewCoordinates[self.brewCoordinates.count-1]))")
                        .font(.title).bold()
                    Text("(g)")
                        .font(.headline).bold()
                        .onReceive(weightPub) { (output) in
                            let unit = output.userInfo![AcaiaScaleUserInfoKeyUnit]! as! NSNumber
                            let weight = output.userInfo![AcaiaScaleUserInfoKeyWeight]! as! Float
                            self.onWeight(unit: unit,newWeight: weight)
                        }
                    Spacer()
                    Button(action: {
                        if let scale = AcaiaManager.shared().connectedScale {
                            scale.tare()
                        } else {
                            self.isConnected = false
                        }
                    }) {
                        Text("tare")
                            .font(.body).bold()
                            .lineLimit(1)
                            //.minimumScaleFactor(0.5)
                            .padding()
                            .foregroundColor(.white)
                            .background(self.state  == .brewing || !self.isConnected ? Color.gray : Color.black)
                    }.disabled(self.state == .brewing || !self.isConnected)
                    //.padding(40)
                    Spacer()
                }
                Spacer()
            }
            //.padding([.top, .leading, .trailing], 40)
            if self.isConnected {
                Spacer()
            } else {
                Button(action: {
                    if let scale = AcaiaManager.shared().connectedScale {
                        print("Already connected to \(String(describing: scale.name))")
                        self.isConnected = true
                    } else {
                        withAnimation {
                            self.partialSheet.showPartialSheet({
                            }) {
                                ScaleConnectionPartialView(didConnect: self.$isConnected)
                            }
                        }
                    }
                }) {
                    Text("Reconnect to Scale")
                }
                .padding(.bottom)
            }
            if state == .done {
                NavigationLink(destination: AddRecipeInfoView(isPresented: self.$isPresented,coordinates: coordinates),isActive: self.$showInfoPage){
                    EmptyView()
                }
                .isDetailLink(false)
            }
        }
        .onReceive(didDisconnect) {_ in
            self.isConnected = false
        }
        .onAppear {
            // TODO: reset scale so hopefully we dont get that restarting problem
            instantiateScale()
            UIApplication.shared.isIdleTimerDisabled = true
        }.onDisappear {
            UIApplication.shared.isIdleTimerDisabled = false
        }
        .navigationBarTitle(Text("Brew"))
        .navigationBarItems(trailing: state == .done ? Button(action: {
            // if presented from detail list (templateCoordinates == []) go to addinfo
            // else go back
            if self.templateCoordinates.count > 0 {
                // Current workaround since onDisappear does not work with navigation
                UIApplication.shared.isIdleTimerDisabled = false
                self.isPresented = false
            } else {
                // Current workaround since onDisappear does not work with navigation
                UIApplication.shared.isIdleTimerDisabled = false
                self.showInfoPage = true
            }
        }) {
            Text("Done").font(.body)
        } : nil)
    }
    
    //MARK: Helper Funcs
    
    // crop extraneous data points
    func cropData() {
        // dont bother cropping if erroneous ( at most < 10 seconds )
        if coordinates.count < 10*4 {
            return
        }
        
        // find last significantly different value before final value
        for i in stride(from: coordinates.count-2, through: 0, by: -1) {
            
            if coordinates[coordinates.count-1].y - coordinates[i].y > 0.2 {
                // dont change if brew was stopped within 2 seconds of flow effectively ending
                if i + 8 > coordinates.count-1 {
                    return
                } else {
                    coordinates = Array(coordinates[0...i+4])
                    // update seconds label to show new value
                    lastTime = coordinates[i+4].x
                    return
                }
            }
        }
    }
    
    //reset scale - on appear we need to reset scale so user doesn't forget to tare or anything ya kno
    private func instantiateScale() {
        guard AcaiaManager.shared().connectedScale != nil else {
            self.isConnected = false
            return
        }
    }
    
    //timer helpers
    func instantiateTimer() {
        print("timer started")
        self.timer = Timer.publish (every: 0.25, on: .main, in: .common)
        return
    }
    
    func cancelTimer() {
        print("timer cancelled")
        self.timer.connect().cancel()
        return
    }
    
    // update lastWeight value
    private func onWeight(unit: NSNumber,newWeight: Float) {
        //change from ounces if necessary
        var weight = newWeight
        if unit.intValue != AcaiaScaleWeightUnit.gram.rawValue {
            weight = weight*28.34952313
        }
        if let brewIndex = Double(String(weight)) {
            self.lastWeight = brewIndex
        }
    }
    
    // add to BrewCoordinates
    private func onTime() {
        
        print("scale: \(self.lastScaleTime) | internal: \(self.lastTime)")
        
        // if scale was stopped externally, end capture
        if self.lastTime > self.lastScaleTime + 0.50 && self.lastTime > 1 {
            self.cropData()
            self.state = .done
            return
        }
        
        // if new val is lower, use old val
        // or new value is way higher than rate of flow for espresso: ignore it
        if self.brewCoordinates[self.brewCoordinates.count-1] > self.lastWeight ||  self.lastWeight - self.brewCoordinates[self.brewCoordinates.count - 1] > 5 {
            self.brewCoordinates.append(self.brewCoordinates[self.brewCoordinates.count-1])
        } else {
            self.brewCoordinates.append(self.lastWeight)
        }
        
        // Update chart
        var newChart = [ChartDataEntry(x:0,y:0)]
        var counter = 0.25
        
        for coordinate in self.brewCoordinates {
            newChart.append(ChartDataEntry(x:counter,y:coordinate))
            counter += 0.25
        }
        
        self.coordinates = newChart
        //print(self.coordinates)
        
        self.lastTime += 0.25
    }
}

enum BrewState {
    case loaded,brewing,done
}
