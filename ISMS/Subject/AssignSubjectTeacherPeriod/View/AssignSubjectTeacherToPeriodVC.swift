//
//  AssignSubjectTeacherToPeriodVC.swift
//  ISMS
//
//  Created by Taranjeet Singh on 7/17/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class AssignSubjectTeacherToPeriodVC: BaseUIViewController {

    //MARK:- Properties
    @IBOutlet weak var btnMonday: UIButton!
    @IBOutlet weak var btnTuesday: UIButton!
    @IBOutlet weak var btnWednesday: UIButton!
    @IBOutlet weak var btnThrusday: UIButton!
    @IBOutlet weak var btnFriday: UIButton!
    @IBOutlet weak var btnSaturday: UIButton!
    @IBOutlet weak var btnSunday: UIButton!
    @IBOutlet weak var btnSubject: UIButton!
    @IBOutlet weak var btnTeacher: UIButton!
    @IBOutlet weak var txtFieldSelectSubject: UITextField!
    @IBOutlet weak var txtFieldSelectTeacher: UITextField!
    @IBOutlet weak var lblPeriod: UILabel!
    @IBOutlet var popUpView: UIView!
    @IBOutlet weak var popUpTableView: UITableView!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var lblPopUpViewTitle: UILabel!
    @IBOutlet weak var btnPopUpViewAlertOk: UIButton!

    
    //MARK:- Variables
    var isUnauthorizedUser = false
    var isAssignTeacherSubjectSuccessfully : Bool?
    var viewModel : AssignSubjectTeacherToPeriodViewModel?
    var asignSubjectTeacherPeriodArr = [AddUpdateTimeTableResponseModel.ResultData]()
    var teacherSubjectData : GetCommonDropdownModel!
    var isSubjectButtonSelected : Bool?
    var selectedDays = Int()
    var selectedDaysArray = [Int]()
    var classId:Int?
    var periodId:Int?
    var timeTableId:Int?
    var selectedSubjectIndex  = 0
    var selectedTeacherIndex = 0
    var selectedTeacherID : Int?
    var selectedSubjectID : Int?
    var selectedPeriodName:String?
    var selectedSubjectName : String?
    var selectedTeacherName : String?
    let userRoleParticularId = UserDefaultExtensionModel.shared.userRoleParticularId
    var HODdepartmentId = UserDefaultExtensionModel.shared.HODDepartmentId
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUI()
        
    }
    //MARK:- Subject Drop down
    @IBAction func btnSubjectDropDown(_ sender: UIButton) {
        if checkInternetConnection(){
            isSubjectButtonSelected = true
            //Hit Subject Api Dropdown
            self.viewModel?.getSubjectsTeacherListDropdown(selectId: classId ?? 0, enumType: 21)
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
    }
    //MARK:- Subject Drop down
    @IBAction func btnTeacherDropDown(_ sender: UIButton) {
        if checkInternetConnection(){
            isSubjectButtonSelected = false
            self.viewModel?.getSubjectsTeacherListDropdown(selectId: userRoleParticularId ??  0, enumType: 18)
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
    }
     
    @IBAction func btnOkAction(_ sender: UIButton) {
        popUpView.removeFromSuperview()
        removeBlurEffect()
    }
    

    @IBAction func btnActionSubmit(_ sender: UIButton) {
        debugPrint("Selected Days Array:- \(selectedDaysArray)")
        teacherSubjectApi()
    }
   
    @IBAction func btnDaysTapAction(_ sender: UIButton) {
        debugPrint("Sender Tag :- \(sender.tag)")
        sender.tintColor = .clear
        if timeTableId == 0{
        
            switch sender.tag{
            case 1:
                if sender.isSelected == false{
                    btnMonday.isSelected = true
                    btnMonday.layer.borderColor = UIColor.green.cgColor
                    btnMonday.layer.borderWidth = 2
                    selectedDaysArray.append(sender.tag)
                }else{
                    btnMonday.isSelected = false
                    btnMonday.layer.borderColor = UIColor.white.cgColor
                    btnMonday.layer.borderWidth = 0
                    removeValueFromDaysArray(day : sender.tag)
                }
                break
            case 2:
                if sender.isSelected == false{
                    btnTuesday.isSelected = true
                    btnTuesday.layer.borderColor = UIColor.green.cgColor
                    btnTuesday.layer.borderWidth = 2
                    selectedDaysArray.append(sender.tag)
                }else{
                    btnTuesday.isSelected = false
                    btnTuesday.layer.borderColor = UIColor.white.cgColor
                    btnTuesday.layer.borderWidth = 0
                    removeValueFromDaysArray(day : sender.tag)
                }
                break
            case 3:
                if sender.isSelected == false{
                    btnWednesday.isSelected = true
                    btnWednesday.layer.borderColor = UIColor.green.cgColor
                    btnWednesday.layer.borderWidth = 2
                    selectedDaysArray.append(sender.tag)
                }else{
                    btnWednesday.isSelected = false
                    btnWednesday.layer.borderColor = UIColor.white.cgColor
                    btnWednesday.layer.borderWidth = 0
                    removeValueFromDaysArray(day : sender.tag)
                }
                break
            case 4:
                if sender.isSelected == false{
                    btnThrusday.isSelected = true
                    btnThrusday.layer.borderColor = UIColor.green.cgColor
                    btnThrusday.layer.borderWidth = 2
                    selectedDaysArray.append(sender.tag)
                }else{
                    btnThrusday.isSelected = false
                    btnThrusday.layer.borderColor = UIColor.white.cgColor
                    btnThrusday.layer.borderWidth = 0
                    removeValueFromDaysArray(day : sender.tag)
                }
                break
            case 5:
                if sender.isSelected == false{
                    btnFriday.isSelected = true
                    btnFriday.layer.borderColor = UIColor.green.cgColor
                    btnFriday.layer.borderWidth = 2
                    selectedDaysArray.append(sender.tag)
                }else{
                    btnFriday.isSelected = false
                    btnFriday.layer.borderColor = UIColor.white.cgColor
                    btnFriday.layer.borderWidth = 0
                    removeValueFromDaysArray(day : sender.tag)
                }
                break
            case 6:
                if sender.isSelected == false{
                    btnSaturday.isSelected = true
                    btnSaturday.layer.borderColor = UIColor.green.cgColor
                    btnSaturday.layer.borderWidth = 2
                    selectedDaysArray.append(sender.tag)
                }else{
                    btnSaturday.isSelected = false
                    btnSaturday.layer.borderColor = UIColor.white.cgColor
                    btnSaturday.layer.borderWidth = 0
                    removeValueFromDaysArray(day : sender.tag)
                }
                break
            case 7:
                if sender.isSelected == false{
                    btnSunday.isSelected = true
                    btnSunday.layer.borderColor = UIColor.green.cgColor
                    btnSunday.layer.borderWidth = 2
                    selectedDaysArray.append(sender.tag)
                }else{
                    btnSunday.isSelected = false
                    btnSunday.layer.borderColor = UIColor.white.cgColor
                    btnSunday.layer.borderWidth = 0
                    removeValueFromDaysArray(day : sender.tag)
                }
            default:
                break
            }
        }else{
            debugPrint("Time table :- \(String(describing: timeTableId))")
        }
        
    }
    
    func removeValueFromDaysArray(day: Int){
        _ = selectedDaysArray.enumerated().map { index,value in
            if day == value{
                selectedDaysArray.remove(at: index)
            }
        }
        debugPrint("Selected Days array:- \(selectedDaysArray)")
    }
    
    //MARK:- Hit teacher/subject Api
    func teacherSubjectApi(){
        let selectedDays = selectedDaysArray.map { String($0) }.joined(separator: ", ")
        if checkInternetConnection() {
            self.viewModel?.addUpdateSubjectsTeacherToPeriod(timeTabelId: timeTableId ?? 0, classId: classId, classSubjectId: selectedSubjectID, teacherId: selectedTeacherID, periodId: periodId, days: selectedDays)
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
    }
    
    //MARK:- Set UI
    func setUI(){
        //Initiallize memory for view model
        self.viewModel = AssignSubjectTeacherToPeriodViewModel.init(delegate: self)
        self.viewModel?.attachView(viewDelegate: self)
        //Set UIPicker View
        SetpickerView(self.view)
        //Back button
        setBackButton()
        //Navigation title
        self.title = "Assign Subject/Teacher to Period"
        //gurleen
        self.lblPeriod.text = selectedPeriodName
        
        if let theme = ThemeManager.shared.currentTheme{
        CommonFunctions.sharedmanagerCommon.setColorsForMultipleViews([btnMonday,btnTuesday,btnWednesday,btnThrusday,btnFriday,btnSaturday,btnSunday], theme.uiButtonBackgroundColor)
            btnSubmit.backgroundColor = theme.uiButtonBackgroundColor
        }
        
        //For disable the multiselection of days and set the selected values
        if timeTableId != 0{
            CommonFunctions.sharedmanagerCommon.disableEnableUserIntractionOfViews([btnMonday,btnTuesday,btnWednesday,btnThrusday,btnFriday,btnSaturday,btnSunday], false)
            txtFieldSelectSubject.text = selectedSubjectName
            txtFieldSelectTeacher.text = selectedTeacherName
            
            let timeTableSelectedTeacherId = selectedTeacherID
            selectedTeacherID = timeTableSelectedTeacherId
            let timeTableSelectedSubjectId = selectedSubjectID
            selectedSubjectID = timeTableSelectedSubjectId
        }
        
        
        switch selectedDays {
        case 1:
            btnMonday.layer.borderColor = UIColor.green.cgColor
            btnMonday.layer.borderWidth = 2
            btnMonday.frame = CGRect(x: 0, y: 0, width: btnMonday.frame.width/2 + 2, height: btnMonday.frame.height/2 + 2)
            btnMonday.isSelected = true
            btnMonday.tintColor = .clear
            selectedDaysArray.append(selectedDays)
        case 2:
            btnTuesday.layer.borderColor = UIColor.green.cgColor
            btnTuesday.layer.borderWidth = 2
            btnTuesday.isSelected = true
            btnTuesday.tintColor = .clear
            selectedDaysArray.append(selectedDays)
        case 3:
            btnWednesday.layer.borderColor = UIColor.green.cgColor
            btnWednesday.layer.borderWidth = 2
            btnWednesday.isSelected = true
            btnWednesday.tintColor = .clear
            selectedDaysArray.append(selectedDays)
        case 4:
            btnThrusday.layer.borderColor = UIColor.green.cgColor
            btnThrusday.layer.borderWidth = 2
            btnThrusday.isSelected = true
            btnThrusday.tintColor = .clear
            selectedDaysArray.append(selectedDays)
        case 5:
            btnFriday.layer.borderColor = UIColor.green.cgColor
            btnFriday.layer.borderWidth = 2
            btnFriday.isSelected = true
            btnFriday.tintColor = .clear
            selectedDaysArray.append(selectedDays)
        case 6:
            btnSaturday.layer.borderColor = UIColor.green.cgColor
            btnSaturday.layer.borderWidth = 2
            btnSaturday.isSelected = true
            btnSaturday.tintColor = .clear
            selectedDaysArray.append(selectedDays)
        case 7:
            btnSunday.layer.borderColor = UIColor.green.cgColor
            btnSunday.layer.borderWidth = 2
            btnSunday.isSelected = true
            btnSunday.tintColor = .clear
            selectedDaysArray.append(selectedDays)
        default:
            CommonFunctions.sharedmanagerCommon.println(object: "Border of button.")
        }
    }
}
//MARK:- Assign Subject,Teacher to Class
extension AssignSubjectTeacherToPeriodVC : AssignSubjectTeacherToPeriodDelegate{
    func addSubjectTeacherToPeriodsDidfailed() {
        
    }
    
   func getTeacherSubjectDropdownDidSuccess(data: GetCommonDropdownModel?) {
        if data != nil{
            if data?.resultData != nil{
                if let count = data?.resultData?.count{
                    if count > 0{
                        teacherSubjectData = data
                        UpdatePickerModel(count: teacherSubjectData?.resultData?.count ?? 0, sharedPickerDelegate: self, View: self.view)
                    }else{
                        if isSubjectButtonSelected == true{
                            self.showAlert(alert: "Please assign subjects to this class first.")
                        }
                        CommonFunctions.sharedmanagerCommon.println(object: "Count is zero")
                    }
                }
            }
        }
    }
    func unauthorizedUser() {
        isUnauthorizedUser = true
    }
    func addSubjectTeacherToPeriodsDidSuccess() {
        isAssignTeacherSubjectSuccessfully = true
    }
    func addSubjectTeacherToPeriodsDidfailed(data: AddUpdateTimeTableResponseModel?) {
        self.createBlurEffectView()
        if let response = data?.resultData{
            asignSubjectTeacherPeriodArr.removeAll()
            asignSubjectTeacherPeriodArr = response
        }
        self.popUpView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 60, height: self.popUpView.frame.height)
        self.popUpView.center = CGPoint(x: UIScreen.main.bounds.width / 2,
                                                        y: UIScreen.main.bounds.height / 2 - self.popUpView.frame.height/2)
        if let theme = ThemeManager.shared.currentTheme {
            lblPopUpViewTitle.backgroundColor = theme.labelBackgroundColor
            btnPopUpViewAlertOk.backgroundColor = theme.uiButtonBackgroundColor
        }
        self.view.addSubview(popUpView)
        popUpTableView.delegate = self
        popUpTableView.dataSource = self
        DispatchQueue.main.async {
            self.popUpTableView.reloadData()
        }
        
    }
    
}
//MARK:- Class Periods TimeTable View Delegate
extension AssignSubjectTeacherToPeriodVC : ViewDelegate{
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
extension AssignSubjectTeacherToPeriodVC : OKAlertViewDelegate{
    func okBtnAction() {
        okAlertView.removeFromSuperview()
        if isUnauthorizedUser == true{
            isUnauthorizedUser = false
            CommonFunctions.sharedmanagerCommon.setRootLogin()
        }else if isAssignTeacherSubjectSuccessfully == true{
            isAssignTeacherSubjectSuccessfully = false
            self.navigationController?.popViewController(animated: true)
        }
    }
}

//MARK:- Picker View Delegates
extension AssignSubjectTeacherToPeriodVC:SharedUIPickerDelegate{
    func DoneBtnClicked() {
        if teacherSubjectData.resultData?.count ?? 0 > 0{
                switch isSubjectButtonSelected{
                case true:
                    self.txtFieldSelectSubject.text = self.teacherSubjectData.resultData?[selectedSubjectIndex].name
                    self.selectedSubjectID = self.teacherSubjectData.resultData?[selectedSubjectIndex].id
                case false:
                    self.txtFieldSelectTeacher.text = self.teacherSubjectData.resultData?[selectedTeacherIndex].name
                    self.selectedTeacherID = self.teacherSubjectData.resultData?[selectedTeacherIndex].id
                default:
                 CommonFunctions.sharedmanagerCommon.println(object: "Switch Default case.")
                }
            }
    }
    func GetTitleForRow(index: Int) -> String {
        if teacherSubjectData.resultData?.count ?? 0 > 0{
                switch isSubjectButtonSelected{
                case true:
//                    txtFieldSelectSubject.text = self.teacherSubjectData.resultData?[0].name
                    return teacherSubjectData.resultData?[index].name ?? ""
                case false:
//                    txtFieldSelectTeacher.text = self.teacherSubjectData.resultData?[0].name
                    return teacherSubjectData.resultData?[index].name ?? ""
                default:
                    CommonFunctions.sharedmanagerCommon.println(object: "Switch GetTitleForRow Default case.")
                }
            }
        return ""
    }
    
    func SelectedRow(index: Int) {
            if teacherSubjectData.resultData?.count ?? 0 > 0{
                switch isSubjectButtonSelected{
                case true:
//                    txtFieldSelectSubject.text = self.teacherSubjectData.resultData?[index].name
//                    selectedSubjectID = self.teacherSubjectData.resultData?[index].id ?? 0
                    selectedSubjectIndex = index
                case false:
//                    txtFieldSelectTeacher.text = teacherSubjectData.resultData?[index].name
//                    selectedTeacherID = teacherSubjectData.resultData?[index].id ?? 0
                    selectedTeacherIndex = index
                default:
                    CommonFunctions.sharedmanagerCommon.println(object: "Selected Row Index Default Case.")
                }
            }
    }
}

//MARK:- TableViewExtension
extension AssignSubjectTeacherToPeriodVC : UITableViewDelegate{
    
}

extension AssignSubjectTeacherToPeriodVC : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return asignSubjectTeacherPeriodArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PopUpTableViewCell
        let data = asignSubjectTeacherPeriodArr[indexPath.row]
        cell.setCellData(data, indexPath)
        return cell
    }

}
