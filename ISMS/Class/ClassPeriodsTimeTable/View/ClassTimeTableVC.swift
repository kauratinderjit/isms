//
//  ClassPeriodsTimeTableVC.swift
//  ISMS
//
//  Created by Taranjeet Singh on 7/17/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class ClassTimeTableVC: BaseUIViewController {
    
    //MARK:- Properties
    @IBOutlet weak var txtFieldClass: UITextField!
    @IBOutlet weak var btnSelectClassDropDown: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnMoveOnAddPeriod: UIButton!
    
    @IBOutlet weak var viewDropDown: UIView!
    //MARK:- Variables
    var viewModel : ClassPeriodsTimetableViewModel?
    var isUnauthorizedUser = false
    var selectedClassId : Int?
    var classDropdownData : GetCommonDropdownModel!
    var selectedClassIndex = 0
    var selectedPeriod:String?
    var arrGetTimeTableDaysModel : [GetTimeTableModel.DaysModel]?
    var arrGetTimeTablePeriodModel = [GetTimeTableModel.PeriodDetailModel]()
    var isCameFromOtherScreen : String?
    var currentDay:String!
    let userRoleParticularId = UserDefaultExtensionModel.shared.userRoleParticularId
      var HODdepartmentId = UserDefaultExtensionModel.shared.HODDepartmentId
    public var isFromTimeTable:Bool!
    public var isFromViewAttendence:Bool!
    public var isFromTeacher:Int!
    public var teacherViewTimeTble:Bool!
    public var isFromStudentViewAttendance : Bool!
    //MARK:- ViewLifeCycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUI()
        classListDropdownApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isFromTeacher == 0{
            self.title = "Attendance"
        }else if isFromTeacher == 1{
            self.title = "Mark Student Attendance"
        }else if isFromTeacher == 2{
            self.title = KStoryBoards.KClassPeriodIdIdentifiers.kClassPeriodTimeTableTitle
        }
        if teacherViewTimeTble == true {
              self.title = "TimeTable"
        }
        
        if isFromStudentViewAttendance == true{
            viewDropDown.isHidden = true
            btnMoveOnAddPeriod.isHidden = false
        }else{
            viewDropDown.isHidden = false
              btnMoveOnAddPeriod.isHidden = true
        }
        checkCameFromWhichScreen()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    //MARK:- Actions
    @IBAction func btnActionClassList(_ sender: Any) {
        updatePickerModel()
    }
    
    //Mark:- Move to Add Period
    @IBAction func btnActionMoveAddPeriod(_ sender: UIButton) {
        isCameFromOtherScreen = "AddPeriod"
        moveToAddPeriodVC()
    }
    
    //Mark:- Check came from which screen
    func checkCameFromWhichScreen(){
        switch isCameFromOtherScreen{
        case "AddPeriod":
            self.viewModel?.getTimeTableAccordingClass(classId: selectedClassId, teacherId: userRoleParticularId)
            break
        case "AssignSubjectTeacherToPeriod":
            self.viewModel?.getTimeTableAccordingClass(classId: selectedClassId, teacherId: userRoleParticularId)
            break
        default:
            break
        }
        
    }
    //MARK:- Add Right Navigation Button
    func addRightNavButton(){
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.imageView?.contentMode = .center
        button.setImage(UIImage(named: "edit"), for: .normal)
        button.addTarget(self, action:#selector(moveToAddPeriodVC), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    //MARK:- Update Picker Model
    func updatePickerModel(){
        guard let classDropDownArray = classDropdownData else {
            return
        }
        if checkInternetConnection(){
            if classDropDownArray.resultData?.count ?? 0 > 0{
                let index = CommonFunctions.sharedmanagerCommon.getIndexOfPickerModelObject(data: classDropDownArray, pickerTextfieldString: txtFieldClass.text)
                
                UpdatePickerModel2(count: classDropDownArray.resultData?.count ?? 0, sharedPickerDelegate: self, View: self.view, index: index)
                
            }
        }
    }
    //MARK:- Class List Dropdown
    func classListDropdownApi(){
        if checkInternetConnection(){
            self.viewModel?.getClassListDropdown(selectId: HODdepartmentId, enumType: 6)
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
    }
    
    //MARK:- Set UI
    func setUI(){
        //Initiallize memory for view model
        self.viewModel = ClassPeriodsTimetableViewModel.init(delegate: self)
        self.viewModel?.attachView(viewDelegate: self)
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEE")
        print(dateFormatter.string(from: Date()))
        currentDay = dateFormatter.string(from: Date())
        txtFieldClass.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        //Set title
        //        self.title = KStoryBoards.KClassPeriodIdIdentifiers.kClassPeriodTimeTableTitle
        //Set back button
        setBackButton()
        //Set picker view
        SetpickerView(self.view)
        //Adding edit add period
        
        if isFromTeacher == 1{
            
        }else{
            addRightNavButton()
        }
        
    }
    
    func setupCollectionView(){
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
        } else {
            // Fallback on earlier versions
        }
        
        //        let epgNib = UINib(nibName: "EPGCollectionViewCell", bundle: Bundle.main)
        //        collectionView.register(epgNib, forCellWithReuseIdentifier: "epgCell")
        
        let timeNib = UINib(nibName: "TimeCollectionViewCell", bundle: Bundle.main)
        collectionView.register(timeNib, forCellWithReuseIdentifier: "timeCell")
        
        let channelNib = UINib(nibName: "DayCollectionViewCell", bundle: Bundle.main)
        collectionView.register(channelNib, forCellWithReuseIdentifier: "dayCell")
        
        let programNib = UINib(nibName: "PeriodCollectionViewCell", bundle: Bundle.main)
        collectionView.register(programNib, forCellWithReuseIdentifier: "periodCell")
        
        collectionView.isHidden = false
        collectionView.backgroundColor = UIColor.lightGray
        let layout = ClassTimeTableCollectionViewLayout()
        layout.days = self.arrGetTimeTableDaysModel
        collectionView.setCollectionViewLayout(layout, animated: false)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    //Navigate To AddPeriod Screen
    @objc func moveToAddPeriodVC(){
        if let vc = UIStoryboard.init(name: "Period", bundle: nil).instantiateViewController(withIdentifier: "TimePeriodVC") as? TimePeriodVC{
            vc.timetableSelectedClassId = selectedClassId
            vc.selectedClassName = txtFieldClass.text
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension ClassTimeTableVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let count = arrGetTimeTableDaysModel?.count {
            return count + 1// Number of channels + Time headers
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            if let count = arrGetTimeTableDaysModel?[0].periodDetailListModel?.count{
                return count + 1
            }
        } else {
            if let count = self.arrGetTimeTableDaysModel?[section - 1].periodDetailListModel?.count {
                debugPrint("Items in section in else part :- \(count + 1)")
                return count + 1
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let theme = ThemeManager.shared.currentTheme
        
        //Time
        if indexPath.section == 0 {
            let timeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "timeCell", for: indexPath) as! TimeCollectionViewCell
            if indexPath.row == 0{
                timeCell.backgroundColor = theme?.uiButtonBackgroundColor
                timeCell.timeLabel.textColor = UIColor.white
                timeCell.timeLabel.text = ""
            }else{
                if let time = self.arrGetTimeTableDaysModel?[indexPath.section].periodDetailListModel?[indexPath.row - 1] {
                    timeCell.backgroundColor = theme?.uiButtonBackgroundColor
                    timeCell.timeLabel.textColor = UIColor.white
                    timeCell.timeLabel.text = time.strTime
                }
            }
            return timeCell
        } else if indexPath.row == 0 { // Days
            let dayCell = collectionView.dequeueReusableCell(withReuseIdentifier: "dayCell", for: indexPath) as! DayCollectionViewCell
            if let day = self.arrGetTimeTableDaysModel?[indexPath.section - 1]{
                
                if currentDay == day.dayName
                {
                    dayCell.backgroundColor = theme?.uiButtonBackgroundColor//UIColor(red: 134/255, green: 11/255, blue: 27/255, alpha: 1)
                    dayCell.lbl_Day.textColor = UIColor.white
                }
                else
                {
                    dayCell.backgroundColor = UIColor.white//theme?.uiButtonBackgroundColor
                    dayCell.lbl_Day.textColor = UIColor.gray
                }
                dayCell.configureWith(day: day)
            }
            return dayCell
        } else {
            let periodCell = collectionView.dequeueReusableCell(withReuseIdentifier: "periodCell", for: indexPath) as! PeriodCollectionViewCell
            if let day = self.arrGetTimeTableDaysModel?[indexPath.section - 1]{
                //There is duplicacy issue
                if let period = day.periodDetailListModel?[indexPath.row - 1]{
                    if currentDay == day.dayName
                    {
                        if period.isTeacher == true
                        {
                            periodCell.backgroundColor = UIColor.white
                        }
                        else
                        {
                            periodCell.backgroundColor = UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 1)
                        }
                    }
                    else
                    {
                         periodCell.backgroundColor = UIColor.white
//                        periodCell.backgroundColor = UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 1)
                    }
                    //                        //When User is Teacher
                    //                        if period.isTeacher == true{
                    //                            //For Disabling the another cells
                    //                            if currentDay == day.dayName{
                    //                                //Provide White Color For Current day
                    //                                periodCell.backgroundColor = UIColor.white
                    //                            }else{
                    //                                //Provide gray color which is other day
                    //                                periodCell.isUserInteractionEnabled = false
                    //                                periodCell.backgroundColor = UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 1)
                    //                            }
                    //                        }else{//When user is admin
                    //                            periodCell.backgroundColor = UIColor.white
                    //                        }
                    periodCell.configureWith(period: period, isFromAttendence : self.isFromViewAttendence)
                    periodCell.btnAssignTeacherSubject.tag = indexPath.section - 1
                }
            }
            return periodCell
        }
    }
}

// MARK: - UICollectionViewDelegate
extension ClassTimeTableVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            // Do nothing.
        }
        else if indexPath.row == 0 { // Days
            //            if let day = self.days?[indexPath.section - 1] {
        } else { // Periods
            
            if let day = self.arrGetTimeTableDaysModel?[indexPath.section - 1]{
                if isFromTimeTable == true
                {
                    if let daysModel = self.arrGetTimeTableDaysModel?[indexPath.section - 1] {
                        if let period = daysModel.periodDetailListModel?[indexPath.row - 1] {
                            print(period)
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AssignSubjectTeacherToPeriodVC") as! AssignSubjectTeacherToPeriodVC
                            if period.timeTableId ?? 0 == 0{
                                vc.timeTableId = 0
                            }else{
                                vc.timeTableId = period.timeTableId
                                vc.selectedSubjectName = period.subjectName
                                vc.selectedTeacherName = period.teacherName
                                vc.selectedTeacherID = period.teacherId
                                vc.selectedSubjectID = period.subjectId
                            }
                            vc.selectedDays = daysModel.dayId ?? 0
                            vc.classId = selectedClassId
                            vc.periodId = period.periodId
                            vc.selectedPeriodName = period.periodName
                            isCameFromOtherScreen = "AssignSubjectTeacherToPeriod"
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
                else
                {
                    
                    if isFromStudentViewAttendance == true{
                        if let daysModel = self.arrGetTimeTableDaysModel?[indexPath.section - 1] {
                            if let period = daysModel.periodDetailListModel?[indexPath.row - 1] {
                                print(period)
                                if period.teacherId != 0{
                                    let storyboard = UIStoryboard.init(name: "StudentAttendence", bundle: nil)
                                    let vc = storyboard.instantiateViewController(withIdentifier: "StudentViewAttendanceVC") as! StudentViewAttendanceVC
                                    vc.timeTableId = period.timeTableId
                                    vc.classId = selectedClassId
                                    vc.teacherId = period.teacherId
                                    vc.classSubjectId = period.subjectId
                                    self.navigationController?.pushViewController(vc, animated: false)
                                }
                            }
                        }
                        
                    }else{
                    if day.periodDetailListModel?[indexPath.row - 1].isTeacher == true
                    {
                        print("isTeacherTrue")
                        
                        if teacherViewTimeTble == true {
                            
                        }else{
                        if currentDay == day.dayName
                        {
                            if let daysModel = self.arrGetTimeTableDaysModel?[indexPath.section - 1] {
                                if let period = daysModel.periodDetailListModel?[indexPath.row - 1] {
                                    print(period)
                                    if period.teacherId != 0{
                                        let storyboard = UIStoryboard.init(name: "StudentAttendence", bundle: nil)
                                        let vc = storyboard.instantiateViewController(withIdentifier: "StudentListToMarkAttendence") as! StudentListToMarkAttendence
                                        vc.timeTableId = period.timeTableId
                                        vc.classId = selectedClassId
                                        vc.teacherId = period.teacherId
                                        vc.classSubjectId = period.subjectId
                                        vc.isFromHOD = false
                                        self.navigationController?.pushViewController(vc, animated: false)
                                    }
                                }
                            }
                        }else{
                            if let daysModel = self.arrGetTimeTableDaysModel?[indexPath.section - 1] {
                                if let period = daysModel.periodDetailListModel?[indexPath.row - 1] {
                                    print(period)
                                    if period.teacherId != 0{
                                        let storyboard = UIStoryboard.init(name: "StudentAttendence", bundle: nil)
                                        let vc = storyboard.instantiateViewController(withIdentifier: "StudentListToMarkAttendence") as! StudentListToMarkAttendence
                                        vc.timeTableId = period.timeTableId
                                        vc.classId = selectedClassId
                                        vc.teacherId = period.teacherId
                                        vc.classSubjectId = period.subjectId
                                        vc.isFromHOD = true
                                        self.navigationController?.pushViewController(vc, animated: false)
                                        }
                                    }
                                }
                            
                            }
                        }
                    }else{
                        //                        debugPrint("Teacher is false.")
                        if teacherViewTimeTble == true {
                            
                        }else{
                        if isFromViewAttendence == true{
                            if let daysModel = self.arrGetTimeTableDaysModel?[indexPath.section - 1] {
                                if let period = daysModel.periodDetailListModel?[indexPath.row - 1] {
                                    print(period)
                                    if period.teacherId != 0{
                                        let storyboard = UIStoryboard.init(name: "StudentAttendence", bundle: nil)
                                        let vc = storyboard.instantiateViewController(withIdentifier: "StudentListToMarkAttendence") as! StudentListToMarkAttendence
                                        vc.timeTableId = period.timeTableId
                                        vc.classId = selectedClassId
                                        vc.teacherId = period.teacherId
                                        vc.classSubjectId = period.subjectId
                                        vc.isFromHOD = true
                                        self.navigationController?.pushViewController(vc, animated: false)
                                    }
                                }
                            }
                        }else{
                            if let daysModel = self.arrGetTimeTableDaysModel?[indexPath.section - 1] {
                                if let period = daysModel.periodDetailListModel?[indexPath.row - 1] {
                                    print(period)
                                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "AssignSubjectTeacherToPeriodVC") as! AssignSubjectTeacherToPeriodVC
                                    if period.timeTableId ?? 0 == 0{
                                        vc.timeTableId = 0
                                    }else{
                                        vc.timeTableId = period.timeTableId
                                        vc.selectedSubjectName = period.subjectName
                                        vc.selectedTeacherName = period.teacherName
                                        vc.selectedTeacherID = period.teacherId
                                        vc.selectedSubjectID = period.subjectId
                                    }
                                    vc.selectedDays = daysModel.dayId ?? 0
                                    vc.classId = selectedClassId
                                    vc.periodId = period.periodId
                                    vc.selectedPeriodName = period.periodName
                                    isCameFromOtherScreen = "AssignSubjectTeacherToPeriod"
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                            }
                        }
                        }
                    }
                    }
                }
            }else{
                print("not a current day")
            }
        }
    }
}

//MARK:- Class Periods Time Table Delegate
extension ClassTimeTableVC : ClassPeriodsTimeTableDelegate{
    func getTimeTableSuccess(data: GetTimeTableModel) {
        if let daysData = data.resultData?.dayModel{
            if daysData.count > 0 {
                arrGetTimeTableDaysModel = daysData
                //For check the period is present or not
                if arrGetTimeTableDaysModel?[0].periodDetailListModel?.count ?? 0 == 0{
                    collectionView.isHidden = true
                    btnMoveOnAddPeriod.isHidden = false
                }else{
                    setupCollectionView()
                    self.collectionView.reloadData()
                    self.collectionView.collectionViewLayout.invalidateLayout()
                    self.collectionView.layoutSubviews()
                }
            }
        }else{
            debugPrint("Nil days data")
        }
    }
    
    
    func classListDidSuccess(data: GetCommonDropdownModel) {
        if data.resultData != nil{
            if data.resultData?.count ?? 0 > 0{
                //Set data when user first time come
                classDropdownData = data
                selectedClassId = classDropdownData.resultData?[0].id
                txtFieldClass.text = classDropdownData.resultData?[0].name
                self.viewModel?.getTimeTableAccordingClass(classId: 21, teacherId: userRoleParticularId)
            }else{
                self.showAlert(alert: "There is no classes")
                CommonFunctions.sharedmanagerCommon.println(object: "Count is zero.")
            }
        }
    }
    
    func classListDidFailed() {
        
    }
    
    func getTimeTableFailed() {
        
    }
    
    func unauthorizedUser() {
        isUnauthorizedUser = true
    }
    
    
}
//MARK:- Class Periods TimeTable View Delegate
extension ClassTimeTableVC : ViewDelegate{
    func showAlert(alert: String){
        initializeCustomOkAlert(self.view, isHideBlurView: true)
        okAlertView.delegate = self
        okAlertView.lblResponseDetailMessage.text = alert
    }
    func showLoader() {
        ShowLoader()
    }
    func hideLoader() {
        HideLoader()
    }
}

//MARK:- OK Alert Delegate
extension ClassTimeTableVC : OKAlertViewDelegate{
    func okBtnAction() {
        okAlertView.removeFromSuperview()
        if isUnauthorizedUser == true{
            isUnauthorizedUser = false
            CommonFunctions.sharedmanagerCommon.setRootLogin()
        }
    }
}
//MARK:- UiPicker Delegate
extension ClassTimeTableVC:SharedUIPickerDelegate{
    func DoneBtnClicked() {
        if classDropdownData.resultData?.count ?? 0 > 0{
            self.txtFieldClass.text = self.classDropdownData.resultData?[selectedClassIndex].name
            self.selectedClassId = self.classDropdownData.resultData?[selectedClassIndex].id
            self.viewModel?.getTimeTableAccordingClass(classId : selectedClassId, teacherId: userRoleParticularId)
        }
    }
    func GetTitleForRow(index: Int) -> String {
        if classDropdownData.resultData?.count ?? 0 > 0{
            return classDropdownData.resultData?[index].name ?? ""
        }
        return ""
    }
    
    func SelectedRow(index: Int) {
        if classDropdownData.resultData?.count ?? 0 > 0{
            selectedClassIndex = index
        }
    }
    
    func cancelButtonClicked() {
        
    }
}
extension ClassTimeTableVC : PeriodCollectionViewDelegate{
    func assignTeacherSubjectToPeriod(selectedIndex: Int) {
        debugPrint("Index:- \(selectedIndex)")
    }
    
}
//                    _ = arrGetTimeTableDaysModel?.enumerated().map({ (index,value) in
//                        let periodDetailListModel = value.periodDetailListModel
//                        arrGetTimeTablePeriodModel.removeAll()
//                        _ = periodDetailListModel?.enumerated().map({ (index,periodValue) in
//                            if index == 0{
//                                let periodDict = ["TimeTableId":0,"TeacherName":"","SubjectName":"","ClassName":"","StartTime":"","EndTime":"","PeriodName":"","PeriodId":"","StrTime":""] as [String : Any]
//                                let periodMdl = GetTimeTableModel.PeriodDetailModel(JSON: periodDict)
//                                arrGetTimeTablePeriodModel.append(periodMdl!)
//                            }else{
//                                arrGetTimeTablePeriodModel.append(periodValue)
//                            }
//
//                        })
//                        arrGetTimeTableDaysModel?[index].periodDetailListModel = arrGetTimeTablePeriodModel
//                    })
