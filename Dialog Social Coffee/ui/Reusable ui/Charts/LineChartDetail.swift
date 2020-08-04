//
//  ChartPreviewView.swift
//  Dialog Social Coffee
//
//  Created by Craig Mathieson on 2020-06-14.
//  Copyright © 2020 Craig Mathieson. All rights reserved.
//

import SwiftUI
import Charts

struct LineChartDetail: UIViewRepresentable {
    var coordinates:[ChartDataEntry]
    var textColor:UIColor
    var lineColor:UIColor
    let lineChart = LineChartView()
    
    func makeUIView(context: UIViewRepresentableContext<LineChartDetail>) -> LineChartView {
        setUpChart()
        return lineChart
    }
    
    func updateUIView(_ uiView: LineChartView, context: UIViewRepresentableContext<LineChartDetail>) {
    }
    
    // line chart creation + styling
    func setUpChart() {
        //get data + set boundary
        let dataSets = [getLineChartDataSet()]
        let data = LineChartData(dataSets: dataSets)
        
        // change data styling
        data.setDrawValues(false)
        lineChart.data = data
        
        //set y axis stuff
        lineChart.rightAxis.enabled = false
        let YAxis = lineChart.leftAxis
        YAxis.labelTextColor = textColor
        YAxis.labelFont = UIFont.boldSystemFont(ofSize: 12)
        YAxis.drawAxisLineEnabled = false
        
        //set x axis stuff
        //lineChart.xAxis.drawLabelsEnabled = false
        lineChart.xAxis.drawAxisLineEnabled = false
        lineChart.xAxis.labelPosition = .bottom
        lineChart.xAxis.gridColor = .clear
        lineChart.xAxis.labelFont = UIFont.boldSystemFont(ofSize: 12)
        lineChart.xAxis.setLabelCount(5, force: false)
        lineChart.xAxis.labelTextColor = textColor
        
        //line chart stuff
        lineChart.leftAxis.gridColor = .clear
        lineChart.rightAxis.gridColor = .clear
        lineChart.setScaleEnabled(false)
        lineChart.backgroundColor = .clear
        lineChart.legend.enabled = false
        lineChart.isUserInteractionEnabled = false
    }
    
    // line chart data point creation + styling
    func getLineChartDataSet() -> LineChartDataSet {
        let set = LineChartDataSet(entries: coordinates)
        
        // edit set styling
        set.lineWidth = 4
        set.drawCirclesEnabled = false
        set.setColor(UIColor.highlightColor)
        set.mode = .horizontalBezier
        //set.fill = Fill.fillWithLinearGradient(getGradient(), angle: 90.0)
        //set.drawFilledEnabled = true
        
        return set
    }
}
