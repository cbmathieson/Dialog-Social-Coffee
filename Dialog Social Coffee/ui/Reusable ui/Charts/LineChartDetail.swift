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
        YAxis.labelTextColor = .black
        YAxis.labelFont = UIFont.boldSystemFont(ofSize: 12)
        YAxis.drawAxisLineEnabled = false
        
        //set x axis stuff
        //lineChart.xAxis.drawLabelsEnabled = false
        lineChart.xAxis.drawAxisLineEnabled = false
        lineChart.xAxis.labelPosition = .bottom
        
        //line chart stuff
        lineChart.xAxis.gridColor = .clear
        lineChart.xAxis.labelFont = UIFont.boldSystemFont(ofSize: 12)
        lineChart.xAxis.setLabelCount(5, force: false)
        lineChart.xAxis.labelTextColor = .black
        lineChart.leftAxis.gridColor = .clear
        lineChart.rightAxis.gridColor = .clear
        lineChart.setScaleEnabled(false)
        lineChart.backgroundColor = .white
        lineChart.legend.enabled = false
        lineChart.isUserInteractionEnabled = false
    }
    
    // line chart data point creation + styling
    func getLineChartDataSet() -> LineChartDataSet {
        let set = LineChartDataSet(entries: coordinates)
        
        // edit set styling
        set.lineWidth = 4
        set.drawCirclesEnabled = false
        set.setColor(.black)
        set.mode = .cubicBezier
        set.fill = Fill.fillWithLinearGradient(getGradient(), angle: 90.0)
        set.drawFilledEnabled = true
        
        return set
    }
    
    // Get Gradient for Chart
    func getGradient() -> CGGradient {
        
        let colorTop =  UIColor(red: 255.0/255.0, green: 149.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 255.0/255.0, green: 94.0/255.0, blue: 58.0/255.0, alpha: 0.0).cgColor

        let gradientColors = [colorTop, colorBottom] as CFArray
        let colorLocations:[CGFloat] = [1.0, 0.0]
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations)
        
        return gradient!
    }
}
