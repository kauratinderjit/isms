//
//  PerformanceGraphVC.swift
//  ISMS
//
//  Created by Navalpreet Kaur on 11/27/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit
import Charts

class PerformanceGraphVC: UIViewController {

    //MARK :- Outlat
    @IBOutlet weak var viewPieChart: PieChartView!
    @IBOutlet weak var viewBarChart: BarChartView!
    @IBOutlet weak var lblBarYAxisTitle: UILabel!
    //MARK:- Variables
     var years:[String] = []
    
    //MARK:- lifeCycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        SetView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    //MARK:- other functions
    func SetView()
    {
        lblBarYAxisTitle.transform = CGAffineTransform( rotationAngle: CGFloat(( M_PI ) / 2) );
        viewBarChart.noDataText = "No Data Found"
        years = ["2018-19", "2002-03", "2004-05", "2006-07", "2008-09"]
        let result = ["Pass","Fail"]
        let markPercentage = [20,60]
       let yearPercentage = [20.0,50.0,6.0,30.0,12.0]
        setBarChart(months: years,yearPercentage:yearPercentage)
        setPieChart(result:result,markPercentage: markPercentage)
    }
    
    //SetPieChart
    func setPieChart(result:[String],markPercentage:[Int])  {
        var dataEntries: [PieChartDataEntry] = []
        
        for i in 0..<result.count {
            let dataEntry = PieChartDataEntry(value: Double(markPercentage[i]), label: result[i])
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: "")
        let pieChartData =  PieChartData(dataSet: pieChartDataSet)
        let colors: [UIColor] = [UIColor(red: 88/255, green: 159/255, blue: 80/255, alpha: 1),UIColor(red: 160/255, green: 10/255, blue: 32/255, alpha: 1)]
        viewPieChart.drawEntryLabelsEnabled = true
        viewPieChart.legend.horizontalAlignment = .center
        pieChartDataSet.colors = colors
        viewPieChart.drawHoleEnabled = false
        viewPieChart.data = pieChartData
    }
    
    //SetBarChart
    func setBarChart(months:[String],yearPercentage:[Double]){
        var dataEntries :[BarChartDataEntry] = []
        
        for i in 0..<yearPercentage.count
        {
            let dataEntery = BarChartDataEntry(x: Double(i), y: Double(yearPercentage[i]) )
    
            dataEntries.append(dataEntery)
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries,label:"YEAR")
        chartDataSet.colors = [UIColor(red: 160/255, green: 10/255, blue: 32/255, alpha: 1)]

        let dataSets: [BarChartDataSet] = [chartDataSet]
        viewBarChart.xAxis.labelPosition = .bottom
        viewBarChart.xAxis.drawGridLinesEnabled = false
        viewBarChart.rightAxis.enabled = false
        viewBarChart.legend.enabled = true
        viewBarChart.leftAxis.drawGridLinesEnabled = false
        viewBarChart.leftAxis.drawLabelsEnabled = false
        viewBarChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: years)
        viewBarChart.xAxis.granularity = 1
        viewBarChart.legend.horizontalAlignment = .center
        viewBarChart.xAxis.axisMinimum = -0.5
        viewBarChart.xAxis.axisMaximum = Double(years.count) - 0.5
        viewBarChart.backgroundColor = UIColor.white
        viewBarChart.xAxis.granularityEnabled = true
        
        let chartData = BarChartData(dataSets: dataSets)
        chartData.barWidth = 0.2
        viewBarChart.data = chartData
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 1
        formatter.multiplier = 1.0
        
  
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
