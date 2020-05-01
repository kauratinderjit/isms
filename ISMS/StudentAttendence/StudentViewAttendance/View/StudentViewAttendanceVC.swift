//
//  StudentViewAttendanceVC.swift
//  ISMS
//
//  Created by Poonam Sharma on 15/4/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import UIKit

class StudentViewAttendanceVC: BaseUIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblEndDate: UILabel!
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var lblStudentName: UILabel!
    
    var isSelectStartDate = false
    var isSeclectEndDate = false
     let userRoleParticularId = UserDefaultExtensionModel.shared.userRoleParticularId
    let studentClassId = UserDefaultExtensionModel.shared.StudentClassId
      var classId,timeTableId,teacherId,classSubjectId,periodId :Int?
     var arrAttendanceList = [GetStudentAttendanceResultData]()
     var viewModel : StudentGetAttendanceViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        setBackButton()
       self.lblStudentName.text =  UserDefaultExtensionModel.shared.UserName
        self.viewModel = StudentGetAttendanceViewModel.init(delegate: self)
        self.viewModel?.attachView(viewDelegate: self)
        setDatePickerView(self.view, type: .date)
        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnGetAttendance(_ sender: Any) {
        if lblStartDate.text == "Start Date"{
             self.showAlert(alert:"Please Enter Start Date")
        }else if lblEndDate.text == "End Date"{
            self.showAlert(alert:"Please Enter End Date")
        }else{
            self.viewModel?.GetAttendance(StartDate: lblStartDate.text ?? "",EndDate: lblEndDate.text ?? "",StudentId: userRoleParticularId,PeriodId: periodId ?? 0,SubjectId: classSubjectId ?? 0,EnrollmentId: UserDefaultExtensionModel.shared.enrollmentIdStudent,ClassId: studentClassId ?? 0,SessionId: 0)
        }
    }
    @IBAction func btnPickerEndDate(_ sender: Any) {
        isSelectStartDate = false
        isSeclectEndDate = true
        showDatePicker(datePickerDelegate: self)
    }
    
    @IBAction func btnPickerStartDate(_ sender: Any) {
        isSelectStartDate = true
        isSeclectEndDate = false
        showDatePicker(datePickerDelegate: self)
    }
    
}
extension StudentViewAttendanceVC : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    //    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return UITableView.automaticDimension
    //    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 60//Choose your custom row height
    }
    
}
extension StudentViewAttendanceVC : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.arrAttendanceList.count > 0{
            tableView.separatorStyle = .singleLine
            tblViewCenterLabel(tblView: tableView, lblText: KConstants.kNoDataFound, hide: true)
            return (self.arrAttendanceList.count)
        }else{
            tblViewCenterLabel(tblView: tableView, lblText: KConstants.kNoDataFound, hide: false)
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ViewStudentAttendanceCell
        //
        
        if self.arrAttendanceList[indexPath.row].attendanceStatus == "P"{
            cell.lblPresntAbsent.textColor = UIColor.green
              cell.lblPresntAbsent.text = "Present"
        }else{
            cell.lblPresntAbsent.textColor = UIColor.red
            cell.lblPresntAbsent.text = "Absent"
        }
        let finalDate = self.dateFromISOString(string: self.arrAttendanceList[indexPath.row].attendanceDate ?? "\(Date())")
        cell.lblDate.text = finalDate
//        cell.setCellUI(data: arrGetTeacherRating, indexPath: indexPath)
        return cell
    }
}
extension StudentViewAttendanceVC:SharedUIDatePickerDelegate{
    
    func doneButtonClicked(datePicker: UIDatePicker) {
        //yearofestablishment
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.autoupdatingCurrent
        formatter.locale = Locale.current
        let convertedDate = formatter.string(from: datePicker.date)
        let strDate = formatter.date(from: convertedDate)
        
        
//        let dateFormatter       = DateFormatter()
////        dateFormatter.dateStyle = DateFormatter.Style.short
//        dateFormatter.dateFormat =  "YYYY-MM-DD"
//        let strDate = dateFormatter.string(from: datePicker.date)
        if isSelectStartDate == true{
             lblStartDate.text = convertedDate
        }else{
            lblEndDate.text = convertedDate
        }
       
    }
}

extension StudentViewAttendanceVC : StudentGetAttendanceDelegate{

    func attendanceListDidSuccess(data: [GetStudentAttendanceResultData]?){
        if let data1 = data {
            if data1.count>0
            {
                self.arrAttendanceList = data1
                tableView.reloadData()
            }
        }
    }
}
extension StudentViewAttendanceVC : ViewDelegate{
    
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
extension StudentViewAttendanceVC : OKAlertViewDelegate{
    func okBtnAction() {
        okAlertView.removeFromSuperview()
//        if isUnauthorizedUser == true{
//            isUnauthorizedUser = false
//            CommonFunctions.sharedmanagerCommon.setRootLogin()
//        }else if isStudentAttendanceSuccess == true{
//            isStudentAttendanceSuccess = false
//            self.navigationController?.popViewController(animated: true)
//        }
    }
}
