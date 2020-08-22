//
//  HomeVC.swift
//  ISMS
//
//  Created by Taranjeet Singh on 6/19/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit
import SWRevealViewController
import SDWebImage
import Charts

var selectedIndexParent =  0
class HomeVC: BaseUIViewController {
    
    
    @IBOutlet weak var viewName: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var viewDept: UIView!
    @IBOutlet weak var lblDept: UILabel!
    
    @IBOutlet weak var lblCount1: UILabel!
    @IBOutlet weak var lblCount2: UILabel!
    @IBOutlet weak var lblCount3: UILabel!
    @IBOutlet weak var lblName1: UILabel!
    @IBOutlet weak var lblName2: UILabel!
    @IBOutlet weak var lblName3: UILabel!
    @IBOutlet weak var viewEvents: UIView!
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet var iv1: UIImageView!
    @IBOutlet var iv2: UIImageView!
    @IBOutlet var iv3: UIImageView!
    
    @IBOutlet weak var collectionViewBottomTable: NSLayoutConstraint!
    
    @IBOutlet weak var viewEventTopConstraints: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var lv1TopConstrtraints: NSLayoutConstraint!
    
    @IBOutlet weak var lblNameTopConstraints: NSLayoutConstraint!
    
    @IBOutlet weak var lv2TopConstraints: NSLayoutConstraint!
    
    
    @IBOutlet weak var lblName2TopConstraints: NSLayoutConstraint!
    
    
    @IBOutlet weak var lv3TopConstraints: NSLayoutConstraint!
    
    @IBOutlet weak var lblName3TopComnstraints: NSLayoutConstraint!
    
    
    @IBOutlet weak var lineChartView: LineChartView!
    
    @IBOutlet weak var viewStatsAdmin: UIView!
    
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var viewMaleFemalePieChart: PieChartView!
    
    @IBOutlet weak var BarChartViewResultData: BarChartView!
    
    var studentArr = [StudentResultData]()
    private let sectionInsets = UIEdgeInsets(top: 5.0,left: 5.0,bottom: 5.0,right: 5.0)
    private var itemsPerRow: CGFloat = 3
    
    var arrEventlist : [ListData]?
    var eventArr = [EventResultData]()
    var deptArr = [departmentList]()
    
    var roleUserName:String?
    var homeViewModel : HomeViewModel?
    var isUnauthorizedUser = false
    var firstTime = 1
    //For check the user is came on home screen from login or not when user have only one role
    static var isCameDirectFromLoginScreen : Bool?
    //For set the role id when user came from login id and selectRole
    static var roleIdFromUserRoleId : Int?
    
    let players = ["Classes","HODs","Sudents","Teachers"]
//    let noOfTeacherStudentData = [12,4,12,24]
    let maleArr = ["Male","Female"]
//    let valesMale = [10,2]
    
    fileprivate var userRoleDelegate = MultiRoleTableViewDataSource()
    
    @IBOutlet var multiRoleView: UIView!
    @IBOutlet weak var barBtnMenu: UIBarButtonItem!
    @IBOutlet weak var multiRoleTableView: UITableView!
    @IBOutlet weak var selectRoleLabel: UILabel!
    @IBOutlet weak var heightofMultiRoleTableView: NSLayoutConstraint!
    var menuArray = [KMenuRowsTitles.kHomeTitle,KMenuRowsTitles.kManageInstituteTitle,KMenuRowsTitles.kManageRolesTitle,KMenuRowsTitles.kManageDepartmentsTitle,KMenuRowsTitles.kManageHODTitle,KMenuRowsTitles.kManageClassesTitle,KMenuRowsTitles.kManageTeachersTitle,KMenuRowsTitles.kManageStudentTitle,KMenuRowsTitles.kManageSubjectTitle,KMenuRowsTitles.kManageClassSubjectTitle,KMenuRowsTitles.kClassPeriodTimeTableTitle,KMenuRowsTitles.kAssignSubjectTeacherToPeriodTitle,KMenuRowsTitles.kAddPeriod,KMenuRowsTitles.kLogOutTitle]
    
    var menuHOD = [KMenuRowsTitles.kHomeTitle,KMenuRowsTitles.kManageTeachersTitle,KMenuRowsTitles.kManageStudentTitle,KMenuRowsTitles.kManageSubjectTitle,KMenuRowsTitles.kManageClassSubjectTitle,KMenuRowsTitles.kClassPeriodTimeTableTitle,KMenuRowsTitles.kAssignSubjectTeacherToPeriodTitle,KMenuRowsTitles.kAddPeriod,KMenuRowsTitles.kLogOutTitle]
    
    var menuVC = MenuVC()
    @IBOutlet weak var tblViewListing: UITableView!
    
    @IBOutlet weak var topEventView: NSLayoutConstraint!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
       
//      if checkInternetConnection(){
//      }else{
//          self.showAlert(Message: Alerts.kNoInternetConnection)
//      }

        // Do any additional setup after loading the view.
        
        //        self.homeViewModel = HomeViewModel.init(delegate: self)
        //        self.homeViewModel?.attachView(view: self)
        //        setLeftMenuButton()
        //
        //        //If it is came from direct login screen and have only one role then it is executed zero index role id of user
        //        if HomeVC.isCameDirectFromLoginScreen == true{
        //            HomeVC.isCameDirectFromLoginScreen = false
        //            if let userRoleId = UserDefaults.standard.value(forKey: UserDefaultKeys.userRoleId.rawValue) as? Int,let userId = UserDefaults.standard.value(forKey: UserDefaultKeys.userId.rawValue) as? Int{
        //                self.homeViewModel?.getMenuFromUserRoleId(userId: userId, roleId: userRoleId)
        //            }
        //        }else{
        //            //For Multi Roles Of User
        //            if let userRoleId = UserDefaults.standard.value(forKey: UserDefaultKeys.userRoleId.rawValue) as? Int
        //            {
        //                self.homeViewModel?.getMenuFromUserRoleId(userId: UserDefaultExtensionModel.shared.currentUserId, roleId: userRoleId)
        //            }
        //            else{
        //
        //            }
        //         //   menuVC.getMenuArraySuccess(data: )
        //        }
        //
        //        self.title = KAPPContentRelatedConstants.kAppTitle
        
    }
    func customizeChartMaleFemale(dataPoints: [String], values: [Double]) {
      
      // 1. Set ChartDataEntry
      var dataEntries: [ChartDataEntry] = []
      for i in 0..<dataPoints.count {
        let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i], data:  dataPoints[i] as AnyObject)
        dataEntries.append(dataEntry)
      }
      
      // 2. Set ChartDataSet
       let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: nil)
      pieChartDataSet.colors = colorsOfCharts(numbersOfColor: dataPoints.count)
       
      
      // 3. Set ChartData
      let pieChartData = PieChartData(dataSet: pieChartDataSet)
      let format = NumberFormatter()
      format.numberStyle = .none
      let formatter = DefaultValueFormatter(formatter: format)
      pieChartData.setValueFormatter(formatter)
      
      // 4. Assign it to the chart's data
      viewMaleFemalePieChart.data = pieChartData
       viewMaleFemalePieChart.legend.font = UIFont(name: "Verdana", size: 10.0)!
       
    }
    func customizeChart(dataPoints: [String], values: [Double]) {
       
       // 1. Set ChartDataEntry
       var dataEntries: [ChartDataEntry] = []
       for i in 0..<dataPoints.count {
         let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i], data:  dataPoints[i] as AnyObject)
         dataEntries.append(dataEntry)
       }
       
       // 2. Set ChartDataSet
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: nil)
       pieChartDataSet.colors = colorsOfCharts(numbersOfColor: dataPoints.count)
        
       
       // 3. Set ChartData
       let pieChartData = PieChartData(dataSet: pieChartDataSet)
       let format = NumberFormatter()
       format.numberStyle = .none
       let formatter = DefaultValueFormatter(formatter: format)
       pieChartData.setValueFormatter(formatter)
       
       // 4. Assign it to the chart's data
       pieChartView.data = pieChartData
//        pieChartView.animate(xAxisDuration: 5.0, yAxisDuration: 5.0, easingOption: .easeInCubic)
        pieChartView.legend.font = UIFont(name: "Verdana", size: 10.0)!
        
     }
     
     private func colorsOfCharts(numbersOfColor: Int) -> [UIColor] {
       var colors: [UIColor] = []
       for _ in 0..<numbersOfColor {
         let red = Double(arc4random_uniform(256))
         let green = Double(arc4random_uniform(256))
         let blue = Double(arc4random_uniform(256))
         let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
         colors.append(color)
       }
       return colors
     }
    
    func setChart(dataPoints: [String], values: [Double]) {
//      BarChartViewResultData.noDataText = "You need to provide data for the chart."
//
      var dataEntries: [BarChartDataEntry] = []

      for i in 0..<dataPoints.count {
        let dataEntry = BarChartDataEntry(x: Double(i), y: Double(values[i]))
        dataEntries.append(dataEntry)
      }

        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Bar Chart View")
//      let chartData = BarChartData(dataSet: chartDataSet)
        chartDataSet.colors = ChartColorTemplates.joyful()
     
        
        
        let chartData = BarChartData(dataSets: [chartDataSet])
      BarChartViewResultData.data = chartData
        BarChartViewResultData.xAxis.labelPosition = .bottom
        BarChartViewResultData.xAxis.drawGridLinesEnabled = false
        BarChartViewResultData.rightAxis.enabled = false
        BarChartViewResultData.scaleYEnabled = false
        BarChartViewResultData.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInBounce)
        BarChartViewResultData.xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
    }
    
    func setLineChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
          let dataEntry = ChartDataEntry(x: values[i], y: Double(i))
          dataEntries.append(dataEntry)
        }
         lineChartView.xAxis.labelPosition = .bottom
        let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: nil)
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        lineChartView.data = lineChartData
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
        
        // Do any additional setup after loading the view.
        self.homeViewModel = HomeViewModel.init(delegate: self)
        self.homeViewModel?.attachView(view: self)
        setLeftMenuButton()
        tblViewListing.tableFooterView = UIView()

        
        //If it is came from direct login screen and have only one role then it is executed zero index role id of user
        if HomeVC.isCameDirectFromLoginScreen == true
        {
            HomeVC.isCameDirectFromLoginScreen = false
            if let userRoleId = UserDefaults.standard.value(forKey: UserDefaultKeys.userRoleId.rawValue) as? Int,let userId = UserDefaults.standard.value(forKey: UserDefaultKeys.userId.rawValue) as? Int
            {
                self.homeViewModel?.getMenuFromUserRoleId(userId: userId, roleId: userRoleId)
            }
        }
        else
        {
            //For Multi Roles Of User
            if let userRoleId = UserDefaults.standard.value(forKey: UserDefaultKeys.userRoleId.rawValue) as? Int
            {
                self.homeViewModel?.getMenuFromUserRoleId(userId: UserDefaultExtensionModel.shared.currentUserId, roleId: userRoleId)
            }
            else
            {
                
            }
            //   menuVC.getMenuArraySuccess(data: )
        }
        
        self.title = KAPPContentRelatedConstants.kAppTitle
        self.homeViewModel?.getRoleId(userID: UserDefaultExtensionModel.shared.currentUserId)
        
        if UserDefaultExtensionModel.shared.currentHODRoleName == "HOD"
        {
            self.title = "HOD's Dashboard"
            collectionView.isHidden = true
            viewStatsAdmin.isHidden = false
            self.homeViewModel?.getDataForHOD(userId: UserDefaultExtensionModel.shared.currentUserId)
        }
        else if UserDefaultExtensionModel.shared.currentHODRoleName.contains("Teacher")
        {
          
            self.title = "Teacher's Dashboard"
              collectionView.isHidden = false
            self.homeViewModel?.getDataTeacher(userId: UserDefaultExtensionModel.shared.currentUserId)
            //mohit tblViewListing.isHidden = true
        }
        else if UserDefaultExtensionModel.shared.currentHODRoleName.contains("Admin")
        {
            self.homeViewModel?.getDataForAdmin(userId: UserDefaultExtensionModel.shared.currentUserId)
            self.title = "Admin's Dashboard"
              collectionView.isHidden = true
            tblViewListing.isHidden = true
            viewStatsAdmin.isHidden = false
        }
        else if UserDefaultExtensionModel.shared.currentHODRoleName.contains("Student")
        {
            self.title = "Student's Dashboard"
              collectionView.isHidden = true
            // tblViewListing.isHidden = true
            self.homeViewModel?.getDataStudent(userId: UserDefaultExtensionModel.shared.currentUserId)
          
        }
        else if UserDefaultExtensionModel.shared.currentHODRoleName.contains("Parent")
        {
            self.title = "Parent's Dashboard"
            self.iv1.isHidden = true
            self.iv2.isHidden = true
            self.iv3.isHidden = true
            
            self.lblName1.isHidden = true
            self.lblName2.isHidden = true
            self.lblName3.isHidden = true
            
            viewEventTopConstraints.constant = 10
            // tblViewListing.isHidden = true
            self.homeViewModel?.getDataParentDashboardApi(userId: UserDefaultExtensionModel.shared.currentUserId)
            
        }
    }
    
    
    
    @IBAction func TESTING_ACTION(_ sender: Any)
    {
        let vc = UIStoryboard.init(name:"CalendarAndEvents", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddEventVC") as! AddEventVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    @IBAction func btnMenuAction(_ sender: UIBarButtonItem) {
        self.revealViewController()?.revealToggle(animated: true)
    }
    
    func centerItemsInCollectionView(cellWidth: Double, numberOfItems: Double, spaceBetweenCell: Double, collectionView: UICollectionView) -> UIEdgeInsets {
        let totalWidth = cellWidth * numberOfItems
        let totalSpacingWidth = spaceBetweenCell * (numberOfItems - 1)
        let leftInset = (collectionView.frame.width - CGFloat(totalWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset
        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
    }
    
}
//
//extension HomeVC : UserRoleTableViewDelegate{
//    func selectRoleButton(_ selectedData: UserRoleIdModel.ResultData?) {
//        let selectedRoleId = selectedData?.roleId
//        homeViewModel?.getMenuFromUserRoleId(userRoleId: selectedRoleId)
//    }
//}

extension HomeVC : HomeViewModelDelegate
{
    func parentData(data: ParentResultData) {
        lblName.text = data.parentName
        lblDept.text = (data.email ?? "")
        self.studentArr = data.students!
        
        if UserDefaultExtensionModel.shared.imageUrl != nil{
            var  imgProfileUrl = UserDefaultExtensionModel.shared.imageUrl
            imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
            //mohit studentImgUrl = URL(string: imgProfileUrl)
            imgProfile.contentMode = .scaleAspectFill
            imgProfile.sd_setImage(with: URL(string: imgProfileUrl), placeholderImage: UIImage(named: kImages.kProfileImage))
        }else{
            //            studentImgUrl = URL(string: "")
            imgProfile.image = UIImage.init(named: kImages.kProfileImage)
        }
        
        print("count",studentArr.count)
        collectionView.reloadData()
        if self.studentArr.count == 1{
            self.iv1.isHidden = true
            self.iv2.isHidden = true
            self.iv3.isHidden = true
            
            self.lblName1.isHidden = true
            self.lblName2.isHidden = true
            self.lblName3.isHidden = true
            collectionView.isHidden = true
           viewEventTopConstraints.constant = -100
            
        }else{
            self.iv1.isHidden = true
            self.iv2.isHidden = true
            self.iv3.isHidden = true
            
            self.lblName1.isHidden = true
            self.lblName2.isHidden = true
            self.lblName3.isHidden = true
            
            viewEventTopConstraints.constant = 10
        }
            UserDefaultExtensionModel.shared.StudentClassId = studentArr[selectedIndexParent].classId ?? 0
            UserDefaultExtensionModel.shared.enrollmentIdStudent = studentArr[selectedIndexParent].enrollmentId ?? 0
            UserDefaultExtensionModel.shared.classNameStudent = studentArr[selectedIndexParent].className ?? ""
            UserDefaultExtensionModel.shared.UserName = studentArr[selectedIndexParent].studentName ?? ""
        UserDefaultExtensionModel.shared.HODDepartmentId = studentArr[selectedIndexParent].departmentId ?? 0
       
        self.homeViewModel?.GetEvents(enumTypeId:1, Search:"", Skip: 10,PageSize: 0,SortColumnDir: "", SortColumn: "",ParticularId: UserDefaultExtensionModel.shared.HODDepartmentId)
    }
    
    func EventModelSucced(data: [EventResultData]?){
        self.eventArr = data!
        tblViewListing.reloadData()
//        tableView.reloadData()
    }
    func HODData(data: homeHODData){
        var  noOfTeacherStudentData = [Double]()
        noOfTeacherStudentData.append(Double(data.numberofClasses ?? Int(0.0)))
        noOfTeacherStudentData.append(Double(data.numberofStudent ?? Int(0.0)))
        noOfTeacherStudentData.append(Double(data.numberofTeacher ?? Int(0.0)))
//        noOfTeacherStudentData = [3,5,5]
        
        let players = ["Classes","Sudents","Teachers"]
        customizeChart(dataPoints: players, values: noOfTeacherStudentData.map{ Double($0) })
        BarChartViewResultData.animate(yAxisDuration: 2.0)
        BarChartViewResultData.pinchZoomEnabled = false
        BarChartViewResultData.drawBarShadowEnabled = false
        BarChartViewResultData.drawBordersEnabled = false
        BarChartViewResultData.doubleTapToZoomEnabled = false
        BarChartViewResultData.drawGridBackgroundEnabled = true
        BarChartViewResultData.chartDescription?.text = "Result Data Bar Chart View"
//        BarChartViewResultData.
        
        let months = ["2010", "2011", "2012", "2013", "2015", "2016", "2017", "2018", "2019"]
        let unitsSold = [88.0, 77.0, 81.0, 93.0, 94.0, 95.0, 96.0, 97, 99.0]
        //        setChart(dataPoints: months, values: unitsSold)
    
        setChart(dataPoints: months, values: unitsSold)
        setLineChart(dataPoints: months, values: unitsSold)
        
        var  valesMale = [Double]()
//        valesMale = [4,1]
        valesMale.append(Double(data.countOfStudentMales ?? Int(0.0)))
        valesMale.append(Double(data.countOfStudentFemales ?? Int(0.0)))
        
        customizeChartMaleFemale(dataPoints: maleArr, values: valesMale.map{ Double($0) })
        
        //        self.iv1.isHidden = false
        //        self.iv2.isHidden = false
        //        self.iv3.isHidden = false
        //
        //        self.lblName1.isHidden = false
        //        self.lblName2.isHidden = false
        //        self.lblName3.isHidden = false
        //
        //        print(data)
        //        lblName.text = data.HodName
        //        lblDept.text = (data.DepartmentName ?? "")
        //
        //
        //
        //        if UserDefaultExtensionModel.shared.imageUrl != nil{
        //          var  imgProfileUrl = UserDefaultExtensionModel.shared.imageUrl
        //            imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
        //            //mohit studentImgUrl = URL(string: imgProfileUrl)
        //            imgProfile.contentMode = .scaleAspectFill
        //            imgProfile.sd_setImage(with: URL(string: imgProfileUrl), placeholderImage: UIImage(named: kImages.kProfileImage))
        //        }else{
        ////            studentImgUrl = URL(string: "")
        //            imgProfile.image = UIImage.init(named: kImages.kProfileImage)
        //        }
        //
        //        var strClass : String = "Class"
        //        var strTeacher : String = "Teacher"
        //        var strStudent : String = "Student"
        //
        //        if data.NumberofClasses! > 1
        //        {
        //            strClass = "Classes"
        //        }
        //        if data.NumberofTeacher! > 1
        //        {
        //            strTeacher = "Teachers"
        //        }
        //        if data.NumberofStudent! > 1
        //        {
        //            strStudent = "Students"
        //        }
        //
        //        lblName1.text = "\(String(describing: data.NumberofClasses!))" + " " + strClass
        //        lblName2.text =  "\(String(describing: data.NumberofTeacher!))" + " " + strTeacher
        //        lblName3.text =  "\(String(describing: data.NumberofStudent!))" + " " + strStudent
        //
        //        if data.lstEvent?.count ?? 0 > 0
        //        {
        //            arrEventlist = data.lstEvent
        //            tblViewListing.reloadData()
        //        }
        //        else
        //        {
        //            tblViewListing.isHidden = true
        //        }
        //        self.homeViewModel?.GetEvents(enumTypeId:1, Search:"", Skip: 10,PageSize: 0,SortColumnDir: "", SortColumn: "",ParticularId: UserDefaultExtensionModel.shared.HODDepartmentId)
    }
    
    func AdminData(data: homeAdminResultData)
    {
        
        var  noOfTeacherStudentData = [Double]()
        noOfTeacherStudentData.append(Double(data.NoOfClasses ?? Int(0.0)))
//        noOfTeacherStudentData.append(Double(data.NoOfHODs ?? Int(0.0)))
        noOfTeacherStudentData.append(Double(data.noOfSudents ?? Int(0.0)))
        noOfTeacherStudentData.append(Double(data.NoOfTeachers ?? Int(0.0)))
//        noOfTeacherStudentData = [12,5,6,7]
        
        
          var  valesMale = [Double]()
//        valesMale = [10,2]
         valesMale.append(Double(data.countOfStudentMales ?? Int(0.0)))
         valesMale.append(Double(data.countOfStudentFemales ?? Int(0.0)))
        
         customizeChart(dataPoints: players, values: noOfTeacherStudentData.map{ Double($0) })
          customizeChartMaleFemale(dataPoints: maleArr, values: valesMale.map{ Double($0) })
        
        
        
        BarChartViewResultData.animate(yAxisDuration: 2.0)
        BarChartViewResultData.pinchZoomEnabled = false
        BarChartViewResultData.drawBarShadowEnabled = false
        BarChartViewResultData.drawBordersEnabled = false
        BarChartViewResultData.doubleTapToZoomEnabled = false
        BarChartViewResultData.drawGridBackgroundEnabled = true
        BarChartViewResultData.chartDescription?.text = "Result Data Bar Chart View"
        
        let months = ["2010-2011", "2011-2012", "2012-2013", "2013-2014", "2015-2016", "2016-2017", "2017-2018", "2018-2019", "2019-2020"]
        let unitsSold = [88.0, 77.0, 81.0, 93.0, 94.0, 95.0, 96.0, 97, 99.0]
//        setChart(dataPoints: months, values: unitsSold)
        
        setChart(dataPoints: months, values: unitsSold)
        setLineChart(dataPoints: months, values: unitsSold)
//        lblName.text = data.AdminName
//        lblDept.text = (data.EmailId ?? "")
//        var strClass : String = "Class"
//        var strTeacher : String = "Teacher"
//        var strHOD : String = "HOD"
//
//        if data.NoOfClasses! > 1 {
//            strClass = "Classes"
//        }
//        if data.NoOfTeachers! > 1 {
//            strTeacher = "Teachers"
//        }
//        if data.NoOfHODs! > 1 {
//            strHOD = "HODs"
//        }
//
//
//
//        lblName1.text = "\(String(describing: data.NoOfClasses!))" + " " + strClass
//        lblName2.text =  "\(String(describing: data.NoOfTeachers!))" + " " + strTeacher
//        lblName3.text =  "\(String(describing: data.NoOfHODs!))" + " " + strHOD
//
//        if data.lstEvent?.count ?? 0 > 0 {
//            arrEventlist = data.lstEvent
//            tblViewListing.reloadData()
//        }
//        else{
//            tblViewListing.isHidden = true
//        }
//          self.homeViewModel?.GetEvents(enumTypeId:1, Search:"", Skip: 10,PageSize: 0,SortColumnDir: "", SortColumn: "",ParticularId: 0)
    }
    
    func hodData(data: homeResultData)
    {
         var  noOfTeacherStudentData = [Double]()
//                noOfTeacherStudentData.append(Double(data.NoOfClasses ?? Int(0.0)))
//                noOfTeacherStudentData.append(Double(data.noOfSudents ?? Int(0.0)))
//                noOfTeacherStudentData.append(Double(data.NoOfTeachers ?? Int(0.0)))
                noOfTeacherStudentData = [12,5,6]
                
                let players = ["Classes","Sudents","Teachers"]
                 customizeChart(dataPoints: players, values: noOfTeacherStudentData.map{ Double($0) })
         BarChartViewResultData.animate(yAxisDuration: 2.0)
                BarChartViewResultData.pinchZoomEnabled = false
                BarChartViewResultData.drawBarShadowEnabled = false
                BarChartViewResultData.drawBordersEnabled = false
                BarChartViewResultData.doubleTapToZoomEnabled = false
                BarChartViewResultData.drawGridBackgroundEnabled = true
                BarChartViewResultData.chartDescription?.text = "Result Data Bar Chart View"
                
                let months = ["2010-2011", "2011-2012", "2012-2013", "2013-2014", "2015-2016", "2016-2017", "2017-2018", "2018-2019", "2019-2020"]
                let unitsSold = [88.0, 77.0, 81.0, 93.0, 94.0, 95.0, 96.0, 97, 99.0]
        //        setChart(dataPoints: months, values: unitsSold)
                
                setChart(dataPoints: months, values: unitsSold)
                setLineChart(dataPoints: months, values: unitsSold)
        
           var  valesMale = [Double]()
                valesMale = [10,2]
//                 valesMale.append(Double(data.countOfStudentMales ?? Int(0.0)))
//                 valesMale.append(Double(data.countOfStudentFemales ?? Int(0.0)))
                
                  customizeChartMaleFemale(dataPoints: maleArr, values: valesMale.map{ Double($0) })
        
//        self.iv1.isHidden = false
//        self.iv2.isHidden = false
//        self.iv3.isHidden = false
//
//        self.lblName1.isHidden = false
//        self.lblName2.isHidden = false
//        self.lblName3.isHidden = false
//
//        print(data)
//        lblName.text = data.HodName
//        lblDept.text = (data.DepartmentName ?? "")
//
//
//
//        if UserDefaultExtensionModel.shared.imageUrl != nil{
//          var  imgProfileUrl = UserDefaultExtensionModel.shared.imageUrl
//            imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
//            //mohit studentImgUrl = URL(string: imgProfileUrl)
//            imgProfile.contentMode = .scaleAspectFill
//            imgProfile.sd_setImage(with: URL(string: imgProfileUrl), placeholderImage: UIImage(named: kImages.kProfileImage))
//        }else{
////            studentImgUrl = URL(string: "")
//            imgProfile.image = UIImage.init(named: kImages.kProfileImage)
//        }
//
//        var strClass : String = "Class"
//        var strTeacher : String = "Teacher"
//        var strStudent : String = "Student"
//
//        if data.NumberofClasses! > 1
//        {
//            strClass = "Classes"
//        }
//        if data.NumberofTeacher! > 1
//        {
//            strTeacher = "Teachers"
//        }
//        if data.NumberofStudent! > 1
//        {
//            strStudent = "Students"
//        }
//
//        lblName1.text = "\(String(describing: data.NumberofClasses!))" + " " + strClass
//        lblName2.text =  "\(String(describing: data.NumberofTeacher!))" + " " + strTeacher
//        lblName3.text =  "\(String(describing: data.NumberofStudent!))" + " " + strStudent
//
//        if data.lstEvent?.count ?? 0 > 0
//        {
//            arrEventlist = data.lstEvent
//            tblViewListing.reloadData()
//        }
//        else
//        {
//            tblViewListing.isHidden = true
//        }
//        self.homeViewModel?.GetEvents(enumTypeId:1, Search:"", Skip: 10,PageSize: 0,SortColumnDir: "", SortColumn: "",ParticularId: UserDefaultExtensionModel.shared.HODDepartmentId)
    }
    
    func teacherData(data: teacherData)
    {
        
        self.iv1.isHidden = false
        self.iv2.isHidden = false
        self.iv3.isHidden = false
        
        self.lblName1.isHidden = false
        self.lblName2.isHidden = false
        self.lblName3.isHidden = false
        
        print(data)
        lblName.text = data.dashBoardTeacherViewModel?[0].teacherName
        lblDept.text = ""
        
        self.deptArr = data.departmentList!
        
        if UserDefaultExtensionModel.shared.imageUrl != nil{
            var  imgProfileUrl = UserDefaultExtensionModel.shared.imageUrl
            imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
            //mohit studentImgUrl = URL(string: imgProfileUrl)
            imgProfile.contentMode = .scaleAspectFill
            imgProfile.sd_setImage(with: URL(string: imgProfileUrl), placeholderImage: UIImage(named: kImages.kProfileImage))
        }else{
            //            studentImgUrl = URL(string: "")
            imgProfile.image = UIImage.init(named: kImages.kProfileImage)
        }
        
        if deptArr.count != 1{
            collectionView.reloadData()
            
            lv1TopConstrtraints.constant = 120
            lblNameTopConstraints.constant = 10
            viewEventTopConstraints.constant = 100
            
            
            lv2TopConstraints.constant = 120
            lblName2TopConstraints.constant = 10
            
            lv3TopConstraints.constant = 120
            lblName3TopComnstraints.constant = 10
        }else{
            collectionView.isHidden = true
        }
       
//        collectionViewBottomTable.constant = 250
        
        var strClass : String = "Class"
        var strTeacher : String = "Subjects"
        var strStudent : String = "Student"
        if deptArr.count>0{
            self.lblDept.text = deptArr[selectedIndexParent].departmentName
            self.lblName1.text = "\(deptArr[selectedIndexParent].noOfClasses!)" + " " + "Classes"
            self.lblName2.text = "\(deptArr[selectedIndexParent].noOfStudents!)" + " " + "Students"
            self.lblName3.text = "\(deptArr[selectedIndexParent].noOfSubjects!)" + " " + "Subjects"
        }

        if let department = deptArr[selectedIndexParent].departmentId {
            UserDefaultExtensionModel.shared.HODDepartmentId = department ?? 0
        }
        
//        if data.das ?? 0 > 1
//        {
//            strClass = "Classes"
//        }
//        if data.NoOfSubjects ?? 0 > 1
//        {
//            strTeacher = "Subjects"
//        }
//        if data.NoOfStudents ?? 0 > 1
//        {
//            strStudent = "Students"
//        }
//
//        lblName1.text = "\(String(describing: data.NoOfClasses!))" + " " + strClass
//        lblName2.text =  "\(String(describing: data.NoOfSubjects!))" + " " + strTeacher
//        lblName3.text =  "\(String(describing: data.NoOfStudents!))" + " " + strStudent
//
//        if data.lstEvent?.count ?? 0 > 0
//        {
//            arrEventlist = data.lstEvent
//            tblViewListing.reloadData()
//        }
//        else
//        {
//            tblViewListing.isHidden = true
//        }
        self.homeViewModel?.GetEvents(enumTypeId:1, Search:"", Skip: 10,PageSize: 0,SortColumnDir: "", SortColumn: "",ParticularId: UserDefaultExtensionModel.shared.HODDepartmentId)
    }
    
    
    
    func studentData(data: StudentData)
    {
        print(data)
        lblName.text = data.StudentName
        lblDept.text = ""
        
        self.iv1.isHidden = true
        self.iv2.isHidden = true
        self.iv3.isHidden = true
        
        self.lblName1.isHidden = true
        self.lblName2.isHidden = true
        self.lblName3.isHidden = true
        
        if UserDefaultExtensionModel.shared.imageUrl != nil{
            var  imgProfileUrl = UserDefaultExtensionModel.shared.imageUrl
            imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
            //mohit studentImgUrl = URL(string: imgProfileUrl)
            imgProfile.contentMode = .scaleAspectFill
            imgProfile.sd_setImage(with: URL(string: imgProfileUrl), placeholderImage: UIImage(named: kImages.kProfileImage))
        }else{
            //            studentImgUrl = URL(string: "")
            imgProfile.image = UIImage.init(named: kImages.kProfileImage)
        }
        
          viewEventTopConstraints.constant = -100
//        viewEventTopConstraints
//        var strClass : String = "Class"
        var strTeacher = "Teacher"
//        var strStudent : String = "Student"
        
//        if data.NoOfClasses ?? 0 > 1
//        {
//            strClass = "Classes"
//        }
        if data.subjectNameLists?.count ?? 0 > 1
        {
            strTeacher = "Subjects"
        }
//        if data.NoOfStudents ?? 0 > 1
//        {
//            strStudent = "Students"
//        }
        
        lblName1.text = "\(String(describing: data.subjectNameLists?.count ?? 0))" + " " + "Subjects"
      //  lblName2.text =  "\(String(describing: data.NoOfSubjects!))" + " " + strTeacher
     //   lblName3.text =  "\(String(describing: data.NoOfStudents!))" + " " + strStudent
        
                if data.lstEvent?.count ?? 0 > 0
                {
                    arrEventlist = data.lstEvent
                    tblViewListing.reloadData()
                }
                else
                {
                    tblViewListing.isHidden = true
                }
         self.homeViewModel?.GetEvents(enumTypeId:1, Search:"", Skip: 10,PageSize: 0,SortColumnDir: "", SortColumn: "",ParticularId:UserDefaultExtensionModel.shared.HODDepartmentId)
    }
    
    func userUnauthorize()
    {
        isUnauthorizedUser = true
        
    }
    
    func didSuccessUserRole(data: UserRoleIdModel) {
        // UserDefaults.standard.set(data.resultData?.count ?? 0, forKey: UserDefaultKeys.userRolesCount.rawValue)
        //        UserDefaults.standard.synchronize()
        UserDefaultExtensionModel.shared.userName = data.resultData?[0].UserName ?? ""
        UserDefaultExtensionModel.shared.userProfile = data.resultData?[0].ImageUrl ?? ""
        
        if data.resultData?.count ?? 0 == 0{
            debugPrint("Count is zero")
        }else if data.resultData?.count ?? 0 == 1{
            debugPrint("Count is one")
        }else if data.resultData?.count ?? 0 > 1{
            debugPrint("Count is greater then one")
        }
    }
    
    func didSuccessMenuAccordingRole(data: GetMenuFromRoleIdModel)
    {
        menuVC.getMenuArraySuccess(data: data)
        CommonFunctions.sharedmanagerCommon.println(object: "Role menu:- \(data.resultData)")
        _ = data.resultData?.enumerated().map({ (index,valueNew) in
            let sideMenuName = valueNew.pageName
            MenuVC.menuArray.insert(sideMenuName ?? "No", at: index)
        })
    }
    
}

extension HomeVC : ViewDelegate{
    func showLoader() {
        self.ShowLoader()
    }
    
    func hideLoader() {
        self.HideLoader()
    }
    
    func showAlert(alert: String)
    {
        
       
        initializeCustomOkAlert(self.view, isHideBlurView: true)
        okAlertView.delegate = self
          if alert == "The Internet connection appears to be offline."{
                     okAlertView.lblResponseDetailMessage.text = "No internet connection."
                 }else{
                     okAlertView.lblResponseDetailMessage.text = alert
                 }
    }
}

extension HomeVC : OKAlertViewDelegate{
    func okBtnAction() {
        okAlertView.removeFromSuperview()
        if isUnauthorizedUser == true{
            isUnauthorizedUser = false
            CommonFunctions.sharedmanagerCommon.setRootLogin()
        }
    }
}
extension HomeVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if eventArr.count>0{
            tblViewCenterLabel(tblView: tableView, lblText: KConstants.kNoDataFound, hide: true)
            return eventArr.count ?? 0
        }else{
            tblViewCenterLabel(tblView: tableView, lblText: KConstants.kNoDataFound, hide: false)
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ExamScheduleTableViewCell
        
        cell?.lblTitle.text = eventArr[indexPath.row].title
        cell?.lblDate.text = "Start Date : \(String(describing: eventArr[indexPath.row].strStartDate!))"
        cell?.lblTime.text = "Start Time : \(String(describing: eventArr[indexPath.row].strStartTime!))"
        cell?.imgView.addInitials(first: "E", second: "")
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
extension HomeVC : UICollectionViewDelegateFlowLayout {
    //1
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        if UserDefaultExtensionModel.shared.currentHODRoleName.contains("Teacher"){
            itemsPerRow = CGFloat(self.deptArr.count)
            let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
            let availableWidth = view.frame.width - paddingSpace
            let widthPerItem = availableWidth / itemsPerRow
            return CGSize(width: widthPerItem, height: widthPerItem)
        }
        itemsPerRow = CGFloat(self.studentArr.count)
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if itemsPerRow > 4{
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            let cellWidth: CGFloat = flowLayout.itemSize.width
            let cellHieght: CGFloat = flowLayout.itemSize.height
            let cellSpacing: CGFloat = flowLayout.minimumInteritemSpacing
            let cellCount = CGFloat(collectionView.numberOfItems(inSection: section))
            var collectionWidth = collectionView.frame.size.width
            var collectionHeight = collectionView.frame.size.height
            if #available(iOS 11.0, *) {
                collectionWidth -= collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right
                collectionHeight -= collectionView.safeAreaInsets.top + collectionView.safeAreaInsets.bottom
            }
            let totalWidth = cellWidth * cellCount + cellSpacing * (cellCount - 1)
            let totalHieght = cellHieght * cellCount + cellSpacing * (cellCount - 1)
            if totalWidth <= collectionWidth {
                let edgeInsetWidth = (collectionWidth - totalWidth - 45) / 2
                
                print(edgeInsetWidth, edgeInsetWidth)
                return UIEdgeInsets(top: 5, left: edgeInsetWidth, bottom: flowLayout.sectionInset.top, right: edgeInsetWidth)
            } else {
                let edgeInsetHieght = (collectionHeight - totalHieght) / 2
                print(edgeInsetHieght, edgeInsetHieght)
                return UIEdgeInsets(top: edgeInsetHieght, left: flowLayout.sectionInset.top, bottom: edgeInsetHieght, right: flowLayout.sectionInset.top)
                
            }
        }else{
            return sectionInsets
      
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
    }

extension HomeVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if UserDefaultExtensionModel.shared.currentHODRoleName.contains("Teacher"){
            return deptArr.count
        }
        return studentArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellCollection", for: indexPath as IndexPath) as! StudentCollectionViewCell
           if UserDefaultExtensionModel.shared.currentHODRoleName.contains("Teacher"){
              cell.setCellUIDept(data :deptArr,indexPath: indexPath)
           }else{
            cell.setCellUI(data :studentArr,indexPath: indexPath)
        }
        
        if selectedIndexParent == indexPath.row{
            UIView.animate(withDuration: 0.3, animations: {
                cell.contentView.backgroundColor = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1)
            })
        }else{
           
                cell.contentView.backgroundColor = UIColor.clear
          
        }
      
//        cell.imageCell.image = UIImage(named: self.bookImages![indexPath.row])
        return cell
    }
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellCollection", for: indexPath as IndexPath) as! StudentCollectionViewCell
        
        collectionView.allowsMultipleSelection = false
        selectedIndexParent = indexPath.row
         if UserDefaultExtensionModel.shared.currentHODRoleName.contains("Teacher"){
            self.lblDept.text = deptArr[selectedIndexParent].departmentName
            self.lblName1.text = "\(deptArr[selectedIndexParent].noOfClasses!)" + " " + "Classes"
            self.lblName2.text = "\(deptArr[selectedIndexParent].noOfStudents!)" + " " + "Students"
            self.lblName3.text = "\(deptArr[selectedIndexParent].noOfSubjects!)" + " " + "Subjects"
            UserDefaultExtensionModel.shared.HODDepartmentId = deptArr[selectedIndexParent].departmentId ?? 0
            self.homeViewModel?.GetEvents(enumTypeId:1, Search:"", Skip: 10,PageSize: 0,SortColumnDir: "", SortColumn: "",ParticularId: UserDefaultExtensionModel.shared.HODDepartmentId)
         }else{
            if let classId = studentArr[indexPath.row].classId{
                 UserDefaultExtensionModel.shared.StudentClassId = classId
            }
            if let enrollmentId = studentArr[indexPath.row].enrollmentId{
                UserDefaultExtensionModel.shared.enrollmentIdStudent = enrollmentId
            }
            if let className = studentArr[indexPath.row].className{
                 UserDefaultExtensionModel.shared.classNameStudent = className
            }
           
           
           
            UserDefaultExtensionModel.shared.UserName = studentArr[indexPath.row].studentName ?? ""
            UserDefaultExtensionModel.shared.HODDepartmentId = studentArr[selectedIndexParent].departmentId ?? 0
            
             self.homeViewModel?.GetEvents(enumTypeId:1, Search:"", Skip: 10,PageSize: 0,SortColumnDir: "", SortColumn: "",ParticularId: UserDefaultExtensionModel.shared.HODDepartmentId)
        }
    
        collectionView.reloadData()
    }
}
