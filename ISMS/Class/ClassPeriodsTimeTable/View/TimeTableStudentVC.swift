//
//  TimeTableStudentVC.swift
//  ISMS
//
//  Created by Poonam Sharma on 17/4/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import UIKit

class TimeTableStudentVC: BaseUIViewController {
    
    //MARK:- Properties
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnMoveOnAddPeriod: UIButton!

    //MARK:- Variables
    var viewModel : TimeTableStudentViewModel?
    var isUnauthorizedUser = false
    var selectedClassId : Int?
    var classDropdownData : GetCommonDropdownModel!
    var selectedClassIndex = 0
    var selectedPeriod:String?
    var arrGetTimeTableDaysModel : [GetTimeTableModel.DaysModel]?
    var arrGetTimeTablePeriodModel = [GetTimeTableModel.PeriodDetailModel]()
    var isCameFromOtherScreen : String?
    var currentDay:String!
    let studentClassId = UserDefaultExtensionModel.shared.StudentClassId
    public var isFromTimeTableParent:Bool!
    
    //MARK:- ViewLifeCycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUI()
         self.viewModel?.getTimeTableAccordingClass(classId : studentClassId, teacherId: 0)
//        classListDropdownApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isFromTimeTableParent == false{
                self.title = "Time Table"
        }else{
                self.title = "Time Table"
        }
    
//        checkCameFromWhichScreen()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    
    //Mark:- Move to Add Period
    @IBAction func btnActionMoveAddPeriod(_ sender: UIButton) {
        isCameFromOtherScreen = "AddPeriod"
        moveToAddPeriodVC()
    }
    
    //Mark:- Check came from which screen
    func checkCameFromWhichScreen(){
//        switch isCameFromOtherScreen{
//        case "AddPeriod":
//            self.viewModel?.getTimeTableAccordingClass(classId: selectedClassId, teacherId: userRoleParticularId)
//            break
//        case "AssignSubjectTeacherToPeriod":
//            self.viewModel?.getTimeTableAccordingClass(classId: selectedClassId, teacherId: userRoleParticularId)
//            break
//        default:
//            break
//        }
        
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

    //MARK:- Class List Dropdown
  
    
    //MARK:- Set UI
    func setUI(){
        //Initiallize memory for view model
        self.viewModel = TimeTableStudentViewModel.init(delegate: self)
        self.viewModel?.attachView(viewDelegate: self)
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEE")
        print(dateFormatter.string(from: Date()))
        currentDay = dateFormatter.string(from: Date())
        setBackButton()
        //Set picker view
        SetpickerView(self.view)
        //Adding edit add period
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
        collectionView.backgroundColor = UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 0.6)
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
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension TimeTableStudentVC: UICollectionViewDataSource {
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
                    dayCell.backgroundColor = theme?.mainColor//UIColor(red: 134/255, green: 11/255, blue: 27/255, alpha: 1)
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
                       // periodCell.backgroundColor = UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 1)
                        periodCell.backgroundColor = UIColor.white
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
                    periodCell.configureWith(period: period, isFromAttendence : true)
                    periodCell.btnAssignTeacherSubject.tag = indexPath.section - 1
                }
            }
            return periodCell
        }
    }
}

// MARK: - UICollectionViewDelegate
extension TimeTableStudentVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if let daysModel = self.arrGetTimeTableDaysModel?[indexPath.section - 1] {
                if let period = daysModel.periodDetailListModel?[indexPath.row - 1] {
                    print(period)
                    if period.teacherId != 0{
                        let storyboard = UIStoryboard.init(name: "StudentAttendence", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "StudentViewAttendanceVC") as! StudentViewAttendanceVC
                        vc.periodId = period.periodId
                        vc.timeTableId = period.timeTableId
                        vc.classId = selectedClassId
                        vc.teacherId = period.teacherId
                        vc.classSubjectId = period.subjectId
                        self.navigationController?.pushViewController(vc, animated: false)
                    }
                }
            }
    }
}

//MARK:- Class Periods Time Table Delegate
extension TimeTableStudentVC : TimeTableStudentDelegate{
    
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
    func unauthorizedUser() {
        isUnauthorizedUser = true
    }
    
    
}
//MARK:- Class Periods TimeTable View Delegate
extension TimeTableStudentVC : ViewDelegate{
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
extension TimeTableStudentVC : OKAlertViewDelegate{
    func okBtnAction() {
        okAlertView.removeFromSuperview()
        if isUnauthorizedUser == true{
            isUnauthorizedUser = false
            CommonFunctions.sharedmanagerCommon.setRootLogin()
        }
    }
}
