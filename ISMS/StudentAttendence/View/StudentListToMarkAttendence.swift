//
//  StudentListToMarkAttendence.swift
//  ISMS
//
//  Created by Poonam Sharma on 12/3/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class StudentListToMarkAttendence: BaseUIViewController {
    
    //Outlets
    @IBOutlet weak var tableViewStudent: UITableView!
    @IBOutlet weak var viewDate: UIView!
    @IBOutlet weak var btnSubmitAttandance: UIButton!
    @IBOutlet weak var kbtnSubmitHeight: NSLayoutConstraint!
    
    @IBOutlet weak var constraintsTableViewTop: NSLayoutConstraint!
    
    @IBOutlet weak var lblSelectDate: UILabel!
    
    //Variables
    var arrStudentlist = [GetStudentListForAttResultData]()
    var viewModel : StudentListForAttViewModel?
    var isUnauthorizedUser = false
    var isStudentAttendanceSuccess = false
    var classId,timeTableId,teacherId,classSubjectId :Int?
    var studentAttendenceArray = [[String:Any]]()
    var isFromHOD:Bool?
    var startDate = Date()
    var isCurrentDay = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = StudentListForAttViewModel.init(delegate: self)
        self.viewModel?.attachView(viewDelegate: self)
        self.title = "Student Attendance"
        tableViewStudent.separatorStyle = .none
        tableViewStudent.tableFooterView = UIView()
        tableViewStudent.delegate = self
        tableViewStudent.dataSource = self
        tableViewStudent.separatorColor = KAPPContentRelatedConstants.kLightBlueColour
        setBackButton()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
             
        
        if isFromHOD == true{
            btnSubmitAttandance.isHidden = false
            kbtnSubmitHeight.constant = 58
        }else{
            btnSubmitAttandance.isHidden = true
            kbtnSubmitHeight.constant = 0
             
        }
        if isCurrentDay == true{
            btnSubmitAttandance.isHidden = false
            kbtnSubmitHeight.constant = 58
        }else{
            btnSubmitAttandance.isHidden = true
            kbtnSubmitHeight.constant = 0
        }

//          btnSubmitAttandance.isHidden = false
        arrStudentlist.removeAll()
        StudentListApi()
        
    }
    
    func StudentListApi(){
        if checkInternetConnection(){
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            formatter.timeZone = TimeZone.autoupdatingCurrent
            formatter.locale = Locale.current
             let convertedDate = formatter.string(from: Date())
            self.lblSelectDate.text = convertedDate
            //            self.viewModel?.isSearching = false
            self.viewModel?.StudentList(TimeTableId: timeTableId ?? 0,ClassId: classId ?? 0,Date:  self.lblSelectDate.text ?? "")
            
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
    }
    
    @IBAction func btnSelectDate(_ sender: Any) {
        setDatePickerView(self.view, type: .date)
        showDatePicker(datePickerDelegate: self)
    }
    
    @IBAction func actionSubmitStudentAttendence(_ sender: Any) {
        isStudentAttendanceSuccess = true
        submitStudentAtt()
    }
    
    func  submitStudentAtt(){
        if checkInternetConnection(){
            //            self.viewModel?.isSearching = false
            self.viewModel?.submitStudentListAttendence(TimeTableId: timeTableId ?? 0,
                                                        TeacherId: teacherId ?? 0, ClassSubjectId : classSubjectId ?? 0 ,ListAttendences : studentAttendenceArray )
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
    }
    
    
}



extension StudentListToMarkAttendence:SharedUIDatePickerDelegate{
    
    func doneButtonClicked(datePicker: UIDatePicker) {
        //yearofestablishment
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        let convertedDate = formatter.string(from: datePicker.date)
        let strDate = formatter.date(from: convertedDate)
             lblSelectDate.text = convertedDate
            startDate = strDate ?? Date()
        
        let currentDate = formatter.string(from: Date())
             
       
        if isFromHOD == false && currentDate == convertedDate{
            if isCurrentDay == true{
                btnSubmitAttandance.isHidden = false
                kbtnSubmitHeight.constant = 58
            }else{
                btnSubmitAttandance.isHidden = true
                kbtnSubmitHeight.constant = 0
            }
           
        }else{
            btnSubmitAttandance.isHidden = true
            kbtnSubmitHeight.constant = 0
        }
        self.viewModel?.StudentList(TimeTableId: timeTableId ?? 0,ClassId: classId ?? 0,Date:lblSelectDate.text ?? "")
       
    }
}

extension StudentListToMarkAttendence : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80;//Choose your custom row height
    }
    
}
extension StudentListToMarkAttendence : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrStudentlist.count > 0{
            tableViewStudent.separatorStyle = .singleLine
            return (arrStudentlist.count)
        }else{
            tblViewCenterLabel(tblView: tableView, lblText: KConstants.kNoDataFound, hide: false)
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentListAtt", for: indexPath) as! StudentListMarkAttCell
        
        cell.setCellUI(data: arrStudentlist, indexPath: indexPath, isFromHODVal : self.isFromHOD)
        cell.cellDelegate = self
        return cell
    }
}
extension StudentListToMarkAttendence :  StudentListMarkAttCellDelegate{
    func didPressBtnPresent(_ tag: Int) {
        print("tag present: ",tag)
        if self.isFromHOD == false{
            
            if isCurrentDay == true{
                let indexPath = IndexPath(row: tag, section: 0)
                if let newcell = tableViewStudent.cellForRow(at: indexPath) as? StudentListMarkAttCell{
                    var data = arrStudentlist[tag]
                    data.isSelected = 1
                    arrStudentlist[tag] = data
                    studentAttendenceArray.remove(at: tag)
                    let arr = ["EnrollmentId" : data.enrollmentId ?? 0, "Status" : "P"] as [String : Any]
                    studentAttendenceArray.insert(arr, at: tag)
                    newcell.StudentPresent.backgroundColor = UIColor.green
                    newcell.studentAbsent.backgroundColor = .clear
                    print(arrStudentlist[tag])
                    self.tableViewStudent.reloadData()
                }
            }
            
        }else{
//            let indexPath = IndexPath(row: tag, section: 0)
//            if let newcell = tableViewStudent.cellForRow(at: indexPath) as? StudentListMarkAttCell{
//                var data = arrStudentlist[tag]
//                data.isSelected = 1
//                arrStudentlist[tag] = data
//                studentAttendenceArray.remove(at: tag)
//                let arr = ["EnrollmentId" : data.enrollmentId ?? 0, "Status" : "P"] as [String : Any]
//                studentAttendenceArray.insert(arr, at: tag)
//                newcell.StudentPresent.backgroundColor = UIColor.green
//                newcell.studentAbsent.backgroundColor = .clear
//                print(arrStudentlist[tag])
//                self.tableViewStudent.reloadData()
//            }
        }
    }
    
    func didPressBtnAbsent(_ tag: Int) {
        print("tag absent: ",tag)
        if self.isFromHOD == false{
            if isCurrentDay == true{
                let indexPath = IndexPath(row: tag, section: 0)
                if let newcell = tableViewStudent.cellForRow(at: indexPath) as? StudentListMarkAttCell{
                    var data = arrStudentlist[tag]
                    data.isSelected = 2
                    arrStudentlist[tag] = data
                    studentAttendenceArray.remove(at: tag)
                    let arr = ["EnrollmentId" : data.enrollmentId ?? 0, "Status" : "A"] as [String : Any]
                    studentAttendenceArray.insert(arr, at: tag)
                    newcell.StudentPresent.backgroundColor = .clear
                    newcell.studentAbsent.backgroundColor = UIColor.red
                    print(arrStudentlist[tag])
                    self.tableViewStudent.reloadData()
                }
            }
        }else{
//            let indexPath = IndexPath(row: tag, section: 0)
//            if let newcell = tableViewStudent.cellForRow(at: indexPath) as? StudentListMarkAttCell{
//                var data = arrStudentlist[tag]
//                data.isSelected = 2
//                arrStudentlist[tag] = data
//                studentAttendenceArray.remove(at: tag)
//                let arr = ["EnrollmentId" : data.enrollmentId ?? 0, "Status" : "A"] as [String : Any]
//                studentAttendenceArray.insert(arr, at: tag)
//                newcell.StudentPresent.backgroundColor = .clear
//                newcell.studentAbsent.backgroundColor = UIColor.red
//                print(arrStudentlist[tag])
//                self.tableViewStudent.reloadData()
//            }
        }
    }
}

extension StudentListToMarkAttendence :  StudentListForAttDelegate{
    func addStudentAttendenceSuccess() {
        isStudentAttendanceSuccess = true
    }
    
    func addStudentAttendenceFailed() {
        
    }
    
    func unauthorizedUser() {
        isUnauthorizedUser = true
    }
    func studentListDidSuccess(data: [GetStudentListForAttResultData]?) {
        if data != nil{
            if data?.count ?? 0 > 0{
                guard let rsltData = data else{
                    return
                }
                
                tableViewStudent.delegate = self
                tableViewStudent.dataSource = self
                
                //When user select the class for change the data in list selected
                
                arrStudentlist.removeAll()
                _ = rsltData.map({ (data) in
                    if data.status == nil {
                        let arr = ["EnrollmentId" :data.enrollmentId, "Status" : ""] as [String : Any]
                         studentAttendenceArray.append(arr)
                    }else{
                          let arr = ["EnrollmentId" :data.enrollmentId, "Status" : data.status] as [String : Any]
                         studentAttendenceArray.append(arr)
                    }
                    
                   
                    arrStudentlist.append(data)
                })
                
                self.tblViewCenterLabel(tblView: tableViewStudent, lblText: "", hide: true)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Zero")
            }
        }else{
            CommonFunctions.sharedmanagerCommon.println(object: "Nil")
        }
        DispatchQueue.main.async {
            self.tableViewStudent.reloadData()
        }
    }
    func studentListDidFailed() {
        
    }
}

//MARK:- Viewdelegates
extension StudentListToMarkAttendence : ViewDelegate{
    
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
extension StudentListToMarkAttendence : OKAlertViewDelegate{
    func okBtnAction() {
        okAlertView.removeFromSuperview()
        if isUnauthorizedUser == true{
            isUnauthorizedUser = false
            CommonFunctions.sharedmanagerCommon.setRootLogin()
        }else if isStudentAttendanceSuccess == true{
            isStudentAttendanceSuccess = false
            self.navigationController?.popViewController(animated: true)
        }
    }
}
