//
//  AddStudentRatingVC.swift
//  ISMS
//
//  Created by Kuldeep Singh on 11/28/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class AddStudentRatingVC: BaseUIViewController {
    
    @IBOutlet var txtfieldClass: UITextField!
    @IBOutlet var txtfieldStudent: UITextField!
    @IBOutlet var txtfieldSubject: UITextField!
    @IBOutlet var tableView: UITableView!
    var isUnauthorizedUser = false
    var isFetching:Bool?
    
    var arrStudent = [StudentRatingResultData]()
    var arrClassList = [GetClassListResultData]()
    var arrSubjectlist=[AddStudentRatingResultData]()
    var arrStudentByClassId = [StudentsByClassId]()
    var arrStudentlist = [AddStudentRatingResultData]()
    var selectedClassId : Int?
    var selectedSubjectId : Int?
    var selectStudentId : Int?
    var selectRatingCount = [0,1,2,3,4,5,6,7,8,9]
    var selectedClassArrIndex : Int?
    var pageSize = KIntegerConstants.kInt10
    var isClassSelected = false
    var isSubjectSelected = false
    var isStudentSelected = false
    var isSelectedRating = false
    var countSelected : Int?
    var arrSkillList = [AddStudentRatingResultData]()
    var arrSkillListNew = [AddStudentRatingResultData]()
    var arrClickedArray = [AddStudentRatingResultData]()
    var viewModel : AddStudentRatingViewModel?
    var array = [0,1,2,3,4,5,6,7,8,9]
    var clickedCount : Int?
    var arrSelect = [[String:Any]]()
    var type : String?
    var studentName : String?
    var className : String?
    var subjectName : String?
    var selectClassRating = Int()
    var selectstudentRating = Int()
    let userRoleParticularId = UserDefaultExtensionModel.shared.userRoleParticularId
    @IBOutlet var btnClass: UIButton!
    @IBOutlet var btnStudent: UIButton!
    @IBOutlet var btnSubject: UIButton!
    var isEditStudentRating:Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = AddStudentRatingViewModel.init(delegate: self)
        self.viewModel?.attachView(viewDelegate: self)
        SetpickerView(self.view)
        self.title = "Skill Wise Ratings"
        // Do any additional setup after loading the view.
        
        DispatchQueue.main.async {
            self.setUI()
        }
        if let name = className {
            txtfieldClass.text = name
        }
        if let name = studentName {
            txtfieldStudent.text = name
        }
        if let name = subjectName {
            txtfieldSubject.text = name
        }
        
        //        self.viewModel?.GetSkillList(id : userRoleParticularId , enumType : 17 ,type : "Skill")
        self.viewModel?.GetSkillList(id : 0 , enumType : 13 ,type : "skillList")
        if let classID = selectedClassId {
            
        }
        
        //        self.viewModel?.getSubjectWiseRating(enrollmentsId: 6, classId: 33)
        tableView.reloadData()
        //        if type == "Edit" {
        //
        //            btnClass.isEnabled = true
        //            btnStudent.isEnabled = true
        //            btnSubject.isEnabled = true
        //        }
        //        else {
        //            btnClass.isEnabled = false
        //            btnStudent.isEnabled = false
        //            btnSubject.isEnabled = false
        //             }
        //
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if checkInternetConnection(){
            self.viewModel?.GetSkillList(id : userRoleParticularId , enumType : 17 ,type : "Skill")
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
    }
    
    
    
    
    
    //MARK:- Action Class Picker
    @IBAction func ActionClassPicker(_ sender: UIButton) {
        isClassSelected = true
        isSubjectSelected = false
        isStudentSelected = false
        isSelectedRating = false
        
        if checkInternetConnection(){
            if arrSkillList.count > 0{
                UpdatePickerModel2(count: arrSkillList.count, sharedPickerDelegate: self, View:  self.view, index: 0)
                
                selectedClassId = arrSkillList[0].studentID
                let text = txtfieldClass.text!
                if let index = arrSkillList.index(where: { (dict) -> Bool in
                    return dict.studentName ?? "" == text // Will found index of matched id
                }) {
                    print("Index found :\(index)")
                    UpdatePickerModel2(count: arrSkillList.count, sharedPickerDelegate: self, View:  self.view, index: index)
                }
                
                
            }
            //           self.viewModel?.classList(searchText: "", pageSize: KIntegerConstants.kInt1000, filterBy: 0, skip: KIntegerConstants.kInt0)
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
        
    }
    //MARK:- ACTION STUDENT PICKER
    @IBAction func ActionStudentPicker(_ sender: UIButton) {
        isClassSelected = false
        isSubjectSelected = false
        isStudentSelected = true
        isSelectedRating = false
        if checkInternetConnection(){
            if arrStudentByClassId.count > 0{
                UpdatePickerModel2(count: arrStudentByClassId.count, sharedPickerDelegate: self, View:  self.view, index: 0)
                self.selectStudentId = arrStudentByClassId[0].studentId
                
                let text = txtfieldStudent.text!
                if let index = arrStudentByClassId.index(where: { (dict) -> Bool in
                    return dict.studentName ?? "" == text // Will found index of matched id
                }) {
                    print("Index found :\(index)")
                    UpdatePickerModel2(count: arrStudentByClassId.count, sharedPickerDelegate: self, View:  self.view,index: index)
                }
            }
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
    }
    
    //MARK:- ACTION SUBMIT
    @IBAction func ActionSubmit(_ sender: Any) {
        if  RegisterClassDataModel.sharedInstance?.enrolmentID  != 0{
            if RegisterClassDataModel.sharedInstance?.subjectID  != 0 {
                self.viewModel?.SubmitTotalRating(teacherID: userRoleParticularId, enrollmentId :  RegisterClassDataModel.sharedInstance?.enrolmentID ,classSubjectId: RegisterClassDataModel.sharedInstance?.subjectID,comment: "good",StudentSkillRatings: arrSelect)
            }
        }
    }
    
    
    //MARK:- ACTION SUBJECT PICKER
    @IBAction func ActionSubjectPicker(_ sender: Any) {
        isClassSelected = false
        isSubjectSelected = true
        isStudentSelected = false
        isSelectedRating = false
        if checkInternetConnection(){
            if arrSubjectlist.count > 0{
                UpdatePickerModel2(count: arrSubjectlist.count, sharedPickerDelegate: self, View:  self.view,index: 0)
                selectedSubjectId = arrSubjectlist[0].studentID
                let text = txtfieldSubject.text!
                if let index = arrSubjectlist.index(where: { (dict) -> Bool in
                    return dict.studentName ?? "" == text // Will found index of matched id
                }) {
                    print("Index found :\(index)")
                    UpdatePickerModel2(count: arrSubjectlist.count, sharedPickerDelegate: self as! SharedUIPickerDelegate, View:  self.view,index: index)
                }
            }
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
    }
}

//MARK:- ADD STUDENT RATING DELEGATE
extension AddStudentRatingVC : AddStudentRatingDelegate {
    //    get student list success
    func  GetStudentByClassDidSucceed(data:[StudentsByClassId]?){
        if let data1 = data {
            self.arrStudentByClassId = data1
            if  arrStudentByClassId.count > 0{
                if let studentName = arrStudentByClassId[0].studentName{
                    txtfieldStudent.text = studentName
                    var idClass = arrStudentByClassId[0].classId
                    RegisterClassDataModel.sharedInstance?.enrolmentID = arrStudentByClassId[0].enrollmentId
                    //                RegisterClassDataModel.sharedInstance?.subjectID = arrSubjectlist[0].studentID
                    //                self.viewModel?.GetSkillList(id : 1, enumType : 14 ,type : "Student")
                    self.viewModel?.GetClassSubjectsByteacherId(classid: idClass ?? 0,teacherId: userRoleParticularId )
                    
                }
                
            }else{
                txtfieldStudent.text = ""
            }
            tableView.reloadData()
        }
    }
    
    func SubjectListDidSuccess(data: [GetSubjectResultData]?) {
        
    }
    
    //    get subject success
    func GetSubjectListDidSucceed(data:[AddStudentRatingResultData]?){
        self.arrSubjectlist.removeAll()
        print("our subject : ",data)
        if let data1 = data {
            self.arrSubjectlist = data1
            if data1.count > 0 {
                if let studentName = arrSubjectlist[0].studentName{
                    txtfieldSubject.text = studentName
                    RegisterClassDataModel.sharedInstance?.subjectID = arrSubjectlist[0].classSubjectId
                }
            }else {
                txtfieldSubject.text = ""
            }
            tableView.reloadData()
        }
    }
    
    func SubjectWiseRatingDidSucceed(data: [SubjectWiseRatingResultData]) {
        //  arrSubjectList = data
        tableView.reloadData()
    }
    
    func AddStudentRatingDidSucceed(data: String) {
       // self.showAlert(alert: data)
        self.AlertMessageWithOkAction(titleStr: KAPPContentRelatedConstants.kAppTitle, messageStr: data, Target: self) {
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    func studentListDidSucceed(data: [AddStudentRatingResultData]?) {
        
    }
    
    //    get skill list sucess
    func GetSkillListaddDidSucceed(data:[AddStudentRatingResultData]?){
        self.isFetching = true
        
        if let data1 = data {
            if data1.count>0
            {
                self.arrSkillListNew = data1
                if let className = arrSkillListNew[0].studentName{
                }
            }
            
            
            tableView.reloadData()
        }
    }
    
    //    get class sucess
    func GetSkillListDidSucceed(data: [AddStudentRatingResultData]?) {
        print("our data : ",data)
        
        self.isFetching = true
        
        if let data1 = data {
            if data1.count>0
            {
                self.arrSkillList = data1
                if self.arrSkillList.count > 0 {
                    if let className = arrSkillList[0].studentName{
                        txtfieldClass.text = className
                        //                      RegisterClassDataModel.sharedInstance?.enrolmentID = arrStudentByClassId[index].enrollmentId
                        var newClassid = arrSkillList[0].studentID!
                        self.viewModel?.GetStudentsByClassId(classid : newClassid)
                    }
                }
            }else{
                txtfieldClass.text = ""
            }
            
            
            tableView.reloadData()
        }
    }
    
    
    
    func classListDidSuccess(data: [GetClassListResultData]?) {
        self.isFetching = true
        
    }
    
    
    func StudentRatingDidSucceed() {
        
    }
    
    func StudentRatingDidFailour() {
        
    }
    
}


//MARK:- PICKER DELEGATE FUNCTIONS
extension AddStudentRatingVC : SharedUIPickerDelegate{
    func DoneBtnClicked() {
        if checkInternetConnection(){
            //            arrAllAssignedSubjects.removeAll()
            if isClassSelected == true {
                if let index = selectedClassArrIndex {
                    if let id = arrSkillList[index].studentID {
                        txtfieldClass.text = arrSkillList[index].studentName
                        var addClassId =  arrSkillList[index].studentID
                        arrStudentlist.removeAll()
                        //                        self.viewModel?.GetSkillList(id : id, enumType : 14 ,type : "Student")
                        self.viewModel?.GetStudentsByClassId(classid : addClassId ?? 0)
                        self.viewModel?.GetClassSubjectsByteacherId(classid: addClassId ?? 0,teacherId: 2 )
                        //                       self.viewModel?.GetSkillList(id : 10, enumType : 14 ,type : "Student")
                        //                        self.viewModel?.subjectList(search : "",skip : KIntegerConstants.kInt0,pageSize: pageSize,sortColumnDir: "",sortColumn: "", particularId: id)
                    }
                }
            }
            else if isSelectedRating == true {
                if let count1 = RegisterClassDataModel.sharedInstance?.tagID {
                    //  let count = selectRatingCount[count1]
                    if let tag = RegisterClassDataModel.sharedInstance?.tagID {
                        
                        let indexPath = IndexPath(row: RegisterClassDataModel.sharedInstance?.tagID ?? 0, section: 0)
                        let cell =  self.tableView.dequeueReusableCell(withIdentifier: "AddStudentRatingCell", for:indexPath) as! AddStudentRatingTableViewCell
                        //                        var data = arrSkillListNew[tag]
                        //                        data.isSelected = 1
                        cell.lblRating.text = "\(array[selectClassRating])"
                        //                        selectClassRating = index
                        
                        arrSkillListNew[tag].isSelected = 1
                        
                        arrSkillListNew[tag].ratingValue = array[selectClassRating]
                        
                        //   arrClickedArray[count1].ratingValue = array[count1]
                        
                        
                        let studentSkillId = arrSkillListNew[tag].studentID
                        let rating = count1 + 1
                        var isPresent = 0
                        if arrSelect.count > 0{
                            for i in 0..<arrSelect.count{
                                if (arrSelect[i] as NSDictionary).value(forKey: "StudentSkillId") as? Int == studentSkillId{
                                    isPresent = 1
                                    arrSelect[i]["Rating"] = array[selectClassRating]
                                }
                            }
                        }
                        if isPresent == 0 {
                            var dict = [String:Any]()
                            dict["StudentSkillId"] = studentSkillId
                            dict["Rating"] = array[selectClassRating]
                            arrSelect.append(dict)
                        }
                      
                    }
                    tableView.reloadData()
                }
            }
            else if isStudentSelected == true{
                
            }
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
    }
    func GetTitleForRow(index: Int) -> String {
        
        if isClassSelected == true {
            if arrSkillList.count > 0{
                txtfieldClass.text = arrSkillList[0].studentName
                return arrSkillList[index].studentName ?? ""
            }
        }
        else if isSubjectSelected == true {
            if arrSubjectlist.count > 0 {
                txtfieldSubject.text = arrSubjectlist[0].studentName
                return arrSubjectlist[index].studentName ?? ""
            }
        }
        else if isStudentSelected == true {
            if arrStudentByClassId.count > 0 {
                txtfieldStudent.text = arrStudentByClassId[0].studentName
                return arrStudentByClassId[index].studentName ?? ""
            }
        }
        else if  isSelectedRating == true {
            if  array.count > 0 {
                //                  let indexPath = IndexPath(row: index, section: 0)
                //                               let cell =  self.tableView.dequeueReusableCell(withIdentifier: "AddStudentRatingCell", for:indexPath) as! AddStudentRatingTableViewCell
                //                                cell.lblRating.text = array[0]
                return "\(array[index])"
            }
            
        }
        return ""
    }
    
    func SelectedRow(index: Int) {
        
        if isClassSelected == true {
            if arrSkillList.count > 0{
                selectedClassId = arrSkillList[index].studentID
                //                selectClassRating = arrSkillList[index].studentID ?? 0
                //                RegisterClassDataModel.sharedInstance?.classID = arrSkillList[index].studentID
                print(selectClassRating)
                txtfieldClass.text = arrSkillList[index].studentName
                selectedClassArrIndex = index
            }
        }
        else if isSubjectSelected == true {
            if arrSubjectlist.count > 0 {
                selectedSubjectId = arrSubjectlist[index].studentID
                RegisterClassDataModel.sharedInstance?.subjectID = arrSubjectlist[index].classSubjectId
                //                selectstudentRating = arrSubjectlist[index].studentID ?? 0
                txtfieldSubject.text = arrSubjectlist[index].studentName
            }
            
        }
        else if isStudentSelected == true {
            if arrStudentByClassId.count > 0 {
                RegisterClassDataModel.sharedInstance?.enrolmentID = arrStudentByClassId[index].enrollmentId
                selectStudentId = arrStudentByClassId[index].studentId
                txtfieldStudent.text = arrStudentByClassId[index].studentName
            }
        }
        else if isSelectedRating == true {
            if array.count > 0 {
                let indexPath = IndexPath(row: RegisterClassDataModel.sharedInstance?.tagID ?? 0, section: 0)
                let cell =  self.tableView.dequeueReusableCell(withIdentifier: "AddStudentRatingCell", for:indexPath) as! AddStudentRatingTableViewCell
                cell.lblRating.text = "\(array[index])"
                selectClassRating = index
                //                countSelected = index
            }
            
        }
        
    }
}
//MARK:- VIEW DELEGATE
extension AddStudentRatingVC : ViewDelegate {
    
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
    //MARK:- SET UI
    func setUI(){
        
        //        self.setSearchBarInNavigationController(placeholderText: KSearchBarPlaceHolder.kUserSearchBarPlaceHolder, navigationTitle: KStoryBoards.KClassListIdentifiers.kClassListTitle, navigationController: self.navigationController, navigationSearchBarDelegates: self)
        
        //Set Back Button
        self.setBackButton()
        
        //Set picker view
        self.SetpickerView(self.view)
        
        // cornerButton(btn: btnSubmit, radius: 8)
        
        //Title
        //        self.title = KStoryBoards.KClassListIdentifiers.kClassListTitle
        
        txtfieldClass.txtfieldPadding(leftpadding: 10, rightPadding: 0)
        txtfieldStudent.txtfieldPadding(leftpadding: 10, rightPadding: 0)
        txtfieldSubject.txtfieldPadding(leftpadding: 10, rightPadding: 0)
        
        self.tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        
        self.viewModel?.isSearching = false
        
        
    }
}


extension AddStudentRatingVC : UITableViewDataSource , AddStudentRatingTableViewCellDelegate {
    func didPressButton(_ tag: Int) {
        print("your pressed button :\(tag)")
        clickedCount = tag
        RegisterClassDataModel.sharedInstance?.tagID = tag
        print("your skill count : \(arrSkillListNew.count)")
        if let id = arrSkillListNew[tag].studentID {
            isSelectedRating = true
            isClassSelected = false
            isSubjectSelected = false
            isStudentSelected = false
            countSelected = RegisterClassDataModel.sharedInstance?.tagID
            UpdatePickerModel2(count: array.count, sharedPickerDelegate: self, View:  self.view,index: 0)
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //    return arrSkillList.count
        return arrSkillListNew.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AddStudentRating.kAddStudentRatingCell, for: indexPath) as! AddStudentRatingTableViewCell
        cell.cellDelegate = self
        cell.btnPicker.tag = indexPath.row
        //        if type == "Edit" {
        //             cell.btnPicker.isEnabled = true
        //        }
        //        else {
        //            cell.btnPicker.isEnabled = false
        //        }
        
        if let name = arrSkillListNew[indexPath.row].studentName {
            // cell.lblStudentName.text = name
            cell.lblSkill.text = name
        }
        if isSelectedRating == true {
            if arrSkillListNew[indexPath.row].isSelected == 1 {
                cell.lblRating.text = "\(arrSkillListNew[indexPath.row].ratingValue)"
                
                //  "\(arrClickedArray[indexPath.row].ratingValue)"
                
                //"\(arrSkillList[indexPath.row].ratingValue)"
                //  arrSkillList[indexPath.row].isSelected = 0
                //"\(array[selectRatingCount[indexPath.row]])"
            }
        }
        
        //     cell.lblRating.text = "\(array[indexPath.row])"
        //        if let rating = arrSkillList[indexPath.row].studentRating {
        //            cell.lblPercentage.text = rating + "%"
        //        }
        return cell
        
    }
}


extension AddStudentRatingVC : OKAlertViewDelegate{
    
    //Ok Button Clicked
    func okBtnAction() {
        //        if isUnauthorizedUser == true{
        //            isUnauthorizedUser = false
        //            CommonFunctions.sharedmanagerCommon.setRootLogin()
        //        }else if isStudentAdd == true{
        //            isStudentAdd = false
        //            okAlertView.removeFromSuperview()
        //            self.navigationController?.popViewController(animated: true)
        //        }
        
        
        okAlertView.removeFromSuperview()
    }
}






