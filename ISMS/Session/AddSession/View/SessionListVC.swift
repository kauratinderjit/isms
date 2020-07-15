//
//  SessionListVC.swift
//  ISMS
//
//  Created by Poonam  on 07/07/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import UIKit

class SessionListVC: BaseUIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblEndDate: UILabel!
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var lblStudentName: UILabel!
    
    var isSelectStartDate = false
    var isSeclectEndDate = false
    var startDate = Date()
    var endDate = Date()
    var selectedSessionId = 0
     let userRoleParticularId = UserDefaultExtensionModel.shared.userRoleParticularId
    let studentClassId = UserDefaultExtensionModel.shared.StudentClassId
      var classId,timeTableId,teacherId,classSubjectId,periodId :Int?
     var arrAttendanceList = [GetStudentAttendanceResultData]()
     var arrSessionList = [GetSessionResultData]()
     var viewModel : StudentGetAttendanceViewModel?
    var updateSessionId = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        setBackButton()
      
        self.viewModel = StudentGetAttendanceViewModel.init(delegate: self)
        self.viewModel?.attachView(viewDelegate: self)
        setDatePickerView(self.view, type: .date)
         self.viewModel?.getSessionList()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnGetAttendance(_ sender: Any) {
        if lblStartDate.text == "Start Date"{
             self.showAlert(alert:"Please Enter Start Date")
        }else if lblEndDate.text == "End Date"{
            self.showAlert(alert:"Please Enter End Date")
        }else{
            if startDate <= endDate{
                let m = "\(startDate)"
                let parsedStartDate = m.replacingOccurrences(of: "+0000", with: "")
                
                let m2 = "\(endDate)"
                let parsedEndDate = m2.replacingOccurrences(of: "+0000", with: "")
                self.viewModel?.sessionCheck(SessionStartDate: lblStartDate.text ?? "",SessionEndDate: lblEndDate.text ?? "")

            }else{
                 self.showAlert(alert:"Please Enter correct start and end Date")
            }
            
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
    
    @IBAction func actionCheckBtn(_ sender: Any) {
        selectedSessionId = arrSessionList[(sender as AnyObject).tag].id ?? 0
        
         
        self.viewModel?.updateSessionCheck(SessionId: selectedSessionId ?? 0,SessionStatus: true)
    }
    
    @IBAction func actionEditBtn(_ sender: Any) {
        self.lblStartDate.text = arrSessionList[(sender as AnyObject).tag].strSessionStartDate
        self.lblEndDate.text = arrSessionList[(sender as AnyObject).tag].strSessionEndDate
        updateSessionId = arrSessionList[(sender as AnyObject).tag].id ?? 0
    }
    
}
extension SessionListVC : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 60//Choose your custom row height
    }
    
}
extension SessionListVC : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.arrSessionList.count > 0{
            tableView.separatorStyle = .singleLine
            tblViewCenterLabel(tblView: tableView, lblText: KConstants.kNoDataFound, hide: true)
            return (self.arrSessionList.count)
        }else{
            tblViewCenterLabel(tblView: tableView, lblText: KConstants.kNoDataFound, hide: false)
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SessionTableCell
        cell.btnCheck.tag = indexPath.row
        cell.lblDate.text = arrSessionList[indexPath.row].sessionName
        if selectedSessionId == arrSessionList[indexPath.row].id{
            cell.btnCheck.setImage(UIImage(named: "check"), for: .normal)
        }else{
             cell.btnCheck.setImage(UIImage(named: "uncheck"), for: .normal)
        }
        return cell
    }
}
extension SessionListVC:SharedUIDatePickerDelegate{
    
    func doneButtonClicked(datePicker: UIDatePicker) {
        //yearofestablishment
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.timeZone = TimeZone.autoupdatingCurrent
        formatter.locale = Locale.current
        let convertedDate = formatter.string(from: datePicker.date)
        let strDate = formatter.date(from: convertedDate)
        
        if isSelectStartDate == true{
             lblStartDate.text = convertedDate
            startDate = strDate ?? Date()
        }else{
            endDate = strDate ?? Date()
            lblEndDate.text = convertedDate
        }
       
    }
}

extension SessionListVC : StudentGetAttendanceDelegate{

    func attendanceListDidSuccess(data: [GetStudentAttendanceResultData]?){
        if let data1 = data {
            if data1.count>0
            {
                self.arrAttendanceList = data1
                tableView.reloadData()
            }
        }
    }
    func checkSession(data: Bool?){
        if data == false{
            if updateSessionId == 0{
                self.viewModel?.AddSession(SessionId: 0,strSessionStartDate: lblStartDate.text ?? "",strSessionEndDate: lblEndDate.text ?? "",SessionStartDate:"\(startDate)" ,SessionEndDate: "\(endDate)")
            }else{
                self.viewModel?.AddSession(SessionId: updateSessionId,strSessionStartDate: lblStartDate.text ?? "",strSessionEndDate: lblEndDate.text ?? "",SessionStartDate:"" ,SessionEndDate: "")
            }
          
        }else{
            self.showAlert(alert: "Session already exists")
        }
    }
    func updateSessionStatus(data: String?){
        tableView.reloadData()
    }
    
    func addSession(){
        
    }
    func sessionListDidSuccess(data:  [GetSessionResultData]?){
       if let data1 = data {
            if data1.count>0
            {
                self.arrSessionList = data1
                tableView.reloadData()
            }
        }
    }
}
extension SessionListVC : ViewDelegate{
    
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
extension SessionListVC : OKAlertViewDelegate{
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
