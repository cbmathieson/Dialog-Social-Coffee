//
//  LineChartSwiftUI.swift
//  Dialog Social Coffee
//
//  Created by Craig Mathieson on 2020-05-17.
//  Copyright © 2020 Craig Mathieson. All rights reserved.
//

import SwiftUI
import Charts

struct LineChartSwiftUI: UIViewRepresentable {
    @Binding var coordinates:[ChartDataEntry]
    var templateCoordinates:[ChartDataEntry]
    let lineChart = LineChartView()
    
    func makeUIView(context: UIViewRepresentableContext<LineChartSwiftUI>) -> LineChartView {
        setUpChart()
        return lineChart
    }
    
    func updateUIView(_ uiView: LineChartView, context: UIViewRepresentableContext<LineChartSwiftUI>) {
        // on update, update data points for chart
        
        let set = LineChartDataSet(entries: self.coordinates)
        
        // edit set styling
        set.lineWidth = 3
        set.drawCirclesEnabled = false
        set.setColor(.red)
        
        let dataSets = [set,getTemplateSet(),createSetBoundary()]
        let data = LineChartData(dataSets: dataSets)
        
        // change data styling
        data.setDrawValues(false)
        
        // apply to line chart passed in
        uiView.data?.clearValues()
        uiView.data = data
        
        uiView.notifyDataSetChanged()
    }
    
    // line chart creation + styling
    func setUpChart() {
        //get data + set boundary
        let dataSets = [getLineChartDataSet(),getTemplateSet(),createSetBoundary()]
        let data = LineChartData(dataSets: dataSets)
        
        // change data styling
        data.setDrawValues(false)
        data.setValueFont(.systemFont(ofSize: 7, weight: .light))
        lineChart.data = data
        
        //set y axis stuff
        lineChart.rightAxis.enabled = false
        let YAxis = lineChart.leftAxis
        YAxis.labelFont = .boldSystemFont(ofSize: 12)
        YAxis.setLabelCount(5, force: false)
        YAxis.labelTextColor = .black
        YAxis.axisLineColor = .gray
        YAxis.labelPosition = .outsideChart
        
        //set x axis stuff
        lineChart.xAxis.labelPosition = .bottom
        lineChart.xAxis.labelFont = .boldSystemFont(ofSize: 12)
        lineChart.xAxis.setLabelCount(5, force: false)
        lineChart.xAxis.labelTextColor = .black
        lineChart.xAxis.axisLineColor = .gray
        
        //line chart stuff
        lineChart.xAxis.gridColor = .clear
        lineChart.leftAxis.gridColor = .clear
        lineChart.rightAxis.gridColor = .clear
        lineChart.setScaleEnabled(false)
        lineChart.backgroundColor = .white
        lineChart.legend.enabled = false
        lineChart.isUserInteractionEnabled = false
    }
    
    // Create template if one is passed
    func getTemplateSet() -> LineChartDataSet {
        let templateSet = LineChartDataSet(entries: self.templateCoordinates)
        
        // edit template set styling
        templateSet.lineWidth = 3
        templateSet.drawCirclesEnabled = false
        templateSet.setColor(.lightGray)
        
        return templateSet
    }
    
    // line chart data point creation + styling
    func getLineChartDataSet() -> LineChartDataSet {
        let set = LineChartDataSet(entries: coordinates)
        
        // edit set styling
        set.lineWidth = 3
        set.drawCirclesEnabled = false
        set.setColor(.red)
        return set
    }
    
    func createSetBoundary() -> LineChartDataSet {
        // check if new set has point within 10 of current set boundary
        var xBoundary:Double = 20.0
        var yBoundary:Double = 40.0
        
        if coordinates.count > 0 {
            if coordinates[coordinates.count-1].x > 10 {
                //round up in intervals of 10 with a 10p buffer
                xBoundary = (coordinates[coordinates.count-1].x / 10).rounded(.up) * 10 + 10
            }
            if coordinates[coordinates.count-1].y > 30 {
                yBoundary = (coordinates[coordinates.count-1].y / 10).rounded(.up) * 10 + 10
            }
        }
        
        // create set boundary point
        let setBoundaryPoint = [ChartDataEntry(x:xBoundary,y:yBoundary)]
        let setBoundary = LineChartDataSet(entries: setBoundaryPoint)
        setBoundary.drawCirclesEnabled = false
        
        return setBoundary
    }
    
    public func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print("Line selected")
    }
    
}
