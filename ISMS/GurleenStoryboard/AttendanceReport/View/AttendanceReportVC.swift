//
//  AttendanceReportVC.swift
//  ISMS
//
//  Created by Gurleen Osahan on 11/28/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit
import Charts

let colorSelected = UIColor.init(red: 134/255, green: 11/255, blue: 27/255, alpha: 0.9)
let colorUnSelected = UIColor.init(red: 142/255, green: 10/255, blue: 28/255, alpha: 1.0)

class AttendanceReportVC: BaseUIViewController {
    
    //MARK:- Variables
     var classDropdownData : GetCommonDropdownModel!
    var studentDropdownData : [GetStudentResultData]!
    var selectedClassIndex = 0
    var selectedstudentIndex = 0
    var viewModel                   : AttendanceReportViewModel?
    var monthsSession = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    var months:[String] = []
    var selectedClassId:Int?
    var selectedStudentId:Int?
    let group = DispatchGroup()
     let dispatchGroup = DispatchGroup()
    var unitsSoldSession:[Double] = []
    var isStudentSelected,isClassSelected,isTabClassSelected,isTabStudentSelected: Bool!
    let unitsBought         = [0.0, 14.0, 60.0, 0.0, 2.0,20.0, 41.0, 68.0, 30.0, 16.0,10.0, 15.0]
//    let months              = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    @IBOutlet weak var ktxtStudentheight: NSLayoutConstraint!
    
    @IBOutlet weak var imgDropDownSelecetStudent: UIImageView!
    @IBOutlet weak var txtSelectSession: UITextField!
    @IBOutlet weak var btnSelectStudent: UIButton!
    @IBOutlet weak var txtClass: UITextField!
    @IBOutlet weak var barChart: BarChartView!
    @IBOutlet weak var mySegmentControl: UISegmentedControl!
    
    @IBOutlet weak var txtSelectStudent: UITextField!
    @IBOutlet weak var kLblSelectStudHeight: NSLayoutConstraint!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        mySegmentControl.removeBorders()
        
        let subViewOfSegment1: UIView = mySegmentControl.subviews[0] as UIView
        subViewOfSegment1.tintColor = UIColor.darkGray
        let subViewOfSegment2: UIView = mySegmentControl.subviews[1] as UIView
        subViewOfSegment2.tintColor = UIColor.darkGray
        setUI()
       
      //  let check: AttendanceReportViewModel = AttendanceReportViewModel(delegate: <#AttendanceReportDelegate#>)
        
        dispatchGroup.enter()
       // check.checkSpeed()
        self.classListDropdownApi()
        dispatchGroup.leave()
        dispatchGroup.wait()
        
        dispatchGroup.enter()
         self.getStudentList()
        dispatchGroup.leave()
        dispatchGroup.wait()
       
        dispatchGroup.notify(queue: DispatchQueue.main, execute:
        {
            print("Finished all requests.")
          //  print("speed = \(check.nMbps)")
        })
       
     //   getStudentList()
     
   
        
    }
    //MARK:- HitApi
    //getStudentList Api
    func getStudentList()
    {
        if checkInternetConnection(){
            
            self.viewModel?.studentList(classId : 0, Search: "", Skip: KIntegerConstants.kInt0, PageSize: KIntegerConstants.kInt10)
            
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
    }
  // Class List Dropdown
    func classListDropdownApi(){
        if checkInternetConnection(){
            self.viewModel?.getClassListDropdown(selectId: 0, enumType: CountryStateCity.classes.rawValue)
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
    }
    
    func getAttendanceReportApi(enrollment_Id:Int)
    {
        if checkInternetConnection(){
            self.viewModel?.GetAttendanceReport(classId: selectedClassId ?? 0, enrollmentId: enrollment_Id, sessionId: 0)
        }else{
            self.showAlert(Message: Alerts.kNoInternetConnection)
        }
    }
    //MARK:- other function
    
    @IBAction func SegmentAction(_ sender: Any) {
        
        switch (sender as AnyObject).selectedSegmentIndex
        {
        case 0:
            isTabClassSelected = true
            isTabStudentSelected = false
            ktxtStudentheight.constant = 0
            kLblSelectStudHeight.constant = 0
            btnSelectStudent.isUserInteractionEnabled = false
            imgDropDownSelecetStudent.isHidden = true
            getAttendanceReportApi(enrollment_Id:0)
            break
        case 1:
            isTabClassSelected = false
            isTabStudentSelected = true
            ktxtStudentheight.constant = 30
            kLblSelectStudHeight.constant = 21
            btnSelectStudent.isUserInteractionEnabled = true
            imgDropDownSelecetStudent.isHidden = false
            getAttendanceReportApi(enrollment_Id:selectedStudentId ?? 0)
            break
          
        default:
            break
        }
    }
    @IBAction func BtnSelectClassAction(_ sender: Any)
    {
        isStudentSelected = false
        isClassSelected = true
        let index = CommonFunctions.sharedmanagerCommon.getIndexOfPickerModelObject(data: classDropdownData, pickerTextfieldString: txtClass.text)
            UpdatePickerModel2(count: classDropdownData.resultData?.count ?? 0, sharedPickerDelegate: self, View: self.view, index: index)
    }
    @IBAction func BtnSelectSessionAction(_ sender: Any)
    {
    }
    @IBAction func selectStudentAction(_ sender: Any)
    {
        isStudentSelected = true
        isClassSelected = false
        UpdatePickerModel(count: studentDropdownData?.count ?? 0, sharedPickerDelegate: self, View: self.view)
    }
    func setUI()
    {
        self.viewModel = AttendanceReportViewModel.init(delegate : self )
        self.viewModel?.attachView(viewDelegate: self)
         SetpickerView(self.view)
        txtClass.txtfieldPadding(leftpadding: 8, rightPadding: 8)
        txtSelectSession.txtfieldPadding(leftpadding: 8, rightPadding: 8)
        txtSelectStudent.txtfieldPadding(leftpadding: 8, rightPadding: 8)
        ktxtStudentheight.constant = 0
        kLblSelectStudHeight.constant = 0
        btnSelectStudent.isUserInteractionEnabled = false
        imgDropDownSelecetStudent.isHidden = true
      //  getAttendanceReportApi()
    }
    //SetBarChart
     func barChartsEvent(data:AttendanceReportModel) {
        months.removeAll()
        unitsSoldSession.removeAll()
        
        for month in data.resultData!
        {
            self.months.append(month.months!)
            //          guard let amount = month.attendance as? String else { return }
            //            let am = Double(amount)
            self.unitsSoldSession.append(month.attendance!)
        }
        barChart.noDataText = "You need to provide data for the chart."
        var dataEntries :[BarChartDataEntry] = []
        
        for i in 0..<self.months.count
        {
            let dataEntery = BarChartDataEntry(x: Double(i), y: Double(unitsSoldSession[i]) )
            
            dataEntries.append(dataEntery)
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries,label:"MONTHS")
        chartDataSet.colors = [UIColor(red: 160/255, green: 10/255, blue: 32/255, alpha: 1)]
        
        let dataSets: [BarChartDataSet] = [chartDataSet]
        barChart.xAxis.labelPosition = .bottom
        barChart.xAxis.drawGridLinesEnabled = false
        barChart.rightAxis.enabled = false
        barChart.legend.enabled = true
        barChart.leftAxis.drawGridLinesEnabled = false
        barChart.leftAxis.drawLabelsEnabled = false
        barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: months)
        barChart.xAxis.granularity = 1
        barChart.legend.horizontalAlignment = .center
        barChart.xAxis.axisMinimum = -0.5
        barChart.xAxis.axisMaximum = Double(months.count) - 0.5
        barChart.backgroundColor = UIColor.white
        barChart.xAxis.granularityEnabled = true
        
        let chartData = BarChartData(dataSets: dataSets)
        chartData.barWidth = 0.2
        barChart.data = chartData
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 1
        formatter.multiplier = 1.0
        barChart.data?.setValueFormatter(DefaultValueFormatter(formatter:formatter))
        barChart.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)
        
    }
    //MARK:- api result
    
    func bar_ChartsEvent(data:AttendanceReportModel) {
       
        for month in data.resultData!
        {
            self.months.append(month.months!)
  //          guard let amount = month.attendance as? String else { return }
//            let am = Double(amount)
            self.unitsSoldSession.append(month.attendance!)
        }

        
        //legend
        let legend = barChart.legend
        legend.enabled = true
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .top
        legend.orientation = .vertical
        legend.drawInside = true
        legend.yOffset = 10.0;
        legend.xOffset = 10.0;
        legend.yEntrySpace = 0.0;
        
        
        let xaxis = barChart.xAxis
        //  xaxis.valueFormatter = axisFormatDelegate
        xaxis.drawGridLinesEnabled = false
        xaxis.labelPosition = .bottom
        xaxis.centerAxisLabelsEnabled = true
        xaxis.valueFormatter = IndexAxisValueFormatter(values:self.months)
        xaxis.granularity = 1
       
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.maximumFractionDigits = 1
        
        let yaxis = barChart.leftAxis
        yaxis.spaceTop = 0.35
        yaxis.axisMinimum = 0
        yaxis.drawGridLinesEnabled = false
    
        barChart.rightAxis.enabled = false
        //axisFormatDelegate = self
        
        setChartEvent()
    }
    
    
    
    func setChartEvent() {
        barChart.noDataText = "You need to provide data for the chart."
        var dataEntries: [BarChartDataEntry] = []

        for i in 0..<self.months.count {

            let dataEntry = BarChartDataEntry(x: Double(i) , y: self.unitsSoldSession[i] as! Double)
            dataEntries.append(dataEntry)

        }
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Tickets sold per Event")
        let dataSets: [BarChartDataSet] = [chartDataSet]
        chartDataSet.setColor(colorSelected)
        let chartData = BarChartData(dataSets: dataSets)
        barChart.notifyDataSetChanged()
        barChart.data = chartData
        barChart.fitBars = true
        barChart.leftAxis.labelTextColor = .clear
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .percent
//        formatter.maximumFractionDigits = 1
//        formatter.multiplier = 1.0
//        // barChart.data?.setValueFormatter = formatter
//        barChart.data?.setValueFormatter((formatter as! IValueFormatter))
//
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 1
        formatter.multiplier = 1.0
        barChart.data?.setValueFormatter(DefaultValueFormatter(formatter:formatter))
        
        DispatchQueue.main.async {
           // self.barChart.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        }

        barChart.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)
        
    }

}

extension UISegmentedControl {
    func removeBorders(andBackground:Bool=false) {
        setBackgroundImage(imageWithColor(color: backgroundColor ?? colorSelected), for: .normal, barMetrics: .default)
        setBackgroundImage(imageWithColor(color: tintColor!), for: .selected, barMetrics: .default)
        setDividerImage(imageWithColor(color: UIColor.clear), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        
        _ = self.subviews.compactMap {
            if ($0.frame.width>0) {
                $0.layer.cornerRadius = 8
                $0.layer.borderColor = UIColor.clear.cgColor
                $0.clipsToBounds = true
                $0.layer.borderWidth = andBackground ? 1.0 : 0.0
                $0.layer.borderColor = andBackground ? tintColor?.cgColor : UIColor.clear.cgColor
                andBackground ? $0.layer.backgroundColor = UIColor.clear.cgColor : nil
            }
        }
    }
    
    // create a 1x1 image with this color
    private func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width:  1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor);
        context!.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!
    }
}

