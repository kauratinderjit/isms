//
//  StudentRatingVC.swift
//  ISMS
//
//  Created by Kuldeep Singh on 11/27/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class StudentRatingVC: BaseUIViewController {
    
    @IBOutlet weak var addRatingBtn: UIButton!
    @IBOutlet var txtfieldClass: UITextField!
    @IBOutlet var txtfieldSubject: UITextField!
    @IBOutlet var tableView: UITableView!
    var viewModel : StudentRatingViewModel?
    
    var isUnauthorizedUser = false
    var isFetching:Bool?
    var arrClassList = [GetClassListResultData]()
    var arrSubjectlist=[GetSubjectResultData]()
    var selectedClassId : Int?
    var selectedSubjectId : Int?
    var selectedStudentId : Int?
    var selectedClassArrIndex : Int?
    var pageSize = KIntegerConstants.kInt10
    var isClassSelected = false
    var isSubjectSelected = false
    var isMonthSelected = false
    var arrStudent = [StudentRatingResultData]()
    var arrSkillList = [AddStudentRatingResultData]()
    var arrSubjectList1 = [AddStudentRatingResultData]()
    let userRoleParticularId = UserDefaultExtensionModel.shared.userRoleParticularId
    var isFromHod :Bool!
    var currentMonth = ""
    var arrMonthlist = ["Jan","Feb","March","April","May","June","July","Augest","September","October","Novemeber","Decemeber"]
    @IBOutlet var textfieldMonth: UITextField!
    //MARK:- CLASS OVERRIDE FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = StudentRatingViewModel.init(delegate : self)
        self.viewModel?.attachView(viewDelegate: self)
        DispatchQueue.main.async {
            self.setUI()
        }
        let month = viewModel?.getCurrentDate()
        print("your printed month : \(month!)")
        currentMonth = month!
        textfieldMonth.text = month!
        tableView.separatorStyle = .none
        tableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if isFromHod == true{
            addRatingBtn.isHidden = true
        }else{
            addRatingBtn.isHidden = false
        }
        if checkInternetConnection(){
//            self.viewModel?.classList(searchText: "", pageSize: KIntegerConstants.kInt1000, filterBy: 0, skip: KIntegerConstants.kInt0)
            self.viewModel?.GetSkillList(id : 44 , enumType : 6)
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
    }
    //MARK:- BUTTON HIDDEN OR FLASE
    func showEnableButtons() {
        
        
    }
    
    @IBAction func btnAddRating(_ sender: Any) {
        
        let vc = UIStoryboard.init(name: KStoryBoards.kStudent, bundle: Bundle.main).instantiateViewController(withIdentifier: "AddStudentRatingVC") as! AddStudentRatingVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK:- SELECT CLASS PICKER
    @IBAction func ActionSelectClass(_ sender: Any) {
        isClassSelected = true
        isSubjectSelected = false
        isMonthSelected = false
        
        if checkInternetConnection(){
            if arrSkillList.count > 0{
                UpdatePickerModel2(count: arrSkillList.count, sharedPickerDelegate: self, View:  self.view, index: 0)
                
                selectedClassId = arrSkillList[0].studentID
                let text = txtfieldClass.text!
                if let index = arrSkillList.index(where: { (dict) -> Bool in
                    return dict.studentName ?? "" == text // Will found index of matched id
                })
                {
                    print("Index found :\(index)")
                    UpdatePickerModel2(count: arrSkillList.count, sharedPickerDelegate: self, View:  self.view, index: index)
                }
                
                
            }
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
    }
    //MARK:- SELECT SUBJECT PICKER
    @IBAction func ActionSelectSubject(_ sender: Any) {
        isClassSelected = false
        isSubjectSelected = true
        isMonthSelected = false
        
        if checkInternetConnection(){
            if arrSubjectList1.count > 0{
                UpdatePickerModel2(count: arrSubjectList1.count, sharedPickerDelegate: self, View:  self.view, index: 0)
                
                selectedSubjectId = arrSubjectList1[0].studentID
                let text = txtfieldSubject.text!
                if let index = arrSubjectList1.index(where: { (dict) -> Bool in
                    return dict.studentName ?? "" == text // Will found index of matched id
                })
                {
                    print("Index found :\(index)")
                    UpdatePickerModel2(count: arrSubjectList1.count, sharedPickerDelegate: self, View:  self.view, index: index)
                }
                
                
            }
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
      
    }
    
    
    @IBAction func ActionSelectMonth(_ sender: Any) {
        isClassSelected = false
        isSubjectSelected = false
        isMonthSelected =  true
        if checkInternetConnection(){
            if arrMonthlist.count > 0{
                UpdatePickerModel(count: arrMonthlist.count, sharedPickerDelegate: self as! SharedUIPickerDelegate, View:  self.view)
                //  selectedSubjectId = arrSubjectlist[0].subjectId
                
                let text = textfieldMonth.text!
                if let index = arrMonthlist.index(where: { (dict) -> Bool in
                    
                    
                    return dict ?? "" == text // Will found index of matched id
                }) {
                    print("Index found :\(index)")
                    UpdatePickerModel4(count: arrClassList.count, sharedPickerDelegate: self as! SharedUIPickerDelegate, View:  self.view, index: index)
                }
            }
            //           self.viewModel?.classList(searchText: "", pageSize: KIntegerConstants.kInt1000, filterBy: 0, skip: KIntegerConstants.kInt0)
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
    }
    
    
    
}

//MARK:- Student Rating Delegate
extension StudentRatingVC : StudentRatingDelegate {
    func GetSkillListDidSucceed(data: [AddStudentRatingResultData]?) {
        print("our data : ",data)
        
        self.isFetching = true
        
        if let data1 = data {
            if data1.count>0
            {
                self.arrSkillList = data1
                if let className = arrSkillList[0].studentName{
                    txtfieldClass.text = className
                    var newclassid = arrSkillList[0].studentID!
                     RegisterClassDataModel.sharedInstance?.subjectID = newclassid
                    //                    RegisterClassDataModel.sharedInstance?.classID = arrSkillList[0].studentID
                    self.viewModel?.GetSubjectList(classid: newclassid,teacherId: userRoleParticularId)
                    
                }
                
                
            }
            
            
            tableView.reloadData()
        }
    }
    
    func GetSubjectListDidSucceed(data: [AddStudentRatingResultData]?) {
        print("our data : ",data)
        
        self.isFetching = true
        
        if let data1 = data {
            if data1.count>0
            {
                self.arrSubjectList1 = data1
                if let subjectName = arrSubjectList1[0].studentName{
                    txtfieldSubject.text = subjectName
                    self.viewModel?.studentList(search: "", skip: 0, pageSize: KIntegerConstants.kInt0, sortColumnDir: "", sortColumn: "", classSubjectID: 96, classID: RegisterClassDataModel.sharedInstance?.subjectID ?? 0 )
//                    self.viewModel?.studentList(search: "", skip: 0, pageSize: KIntegerConstants.kInt0, sortColumnDir: "", sortColumn: "", classSubjectID: arrSubjectList1[0].studentID ?? 0, classID: RegisterClassDataModel.sharedInstance?.subjectID ?? 0 )
                    //                    RegisterClassDataModel.sharedInstance?.classID = arrSkillList[0].studentID
                    
                }
                
                
            }
            
            
            tableView.reloadData()
        }
    }
    
    
    func StudentRatingListDidSucceed(data: [StudentRatingResultData]) {
        //   print(good)
        arrStudent = data
        self.tableView.reloadData()
    }
    
    
    func classListDidSuccess(data: [GetClassListResultData]?) {
        
        
        self.isFetching = true
        if data != nil{
            if data?.count ?? 0 > 0{
                for value in data!{
                    let containsSameValue = arrClassList.contains(where: {$0.classId == value.classId})
                    if containsSameValue == false{
                        arrClassList.append(value)
                        if let className = arrClassList[0].name{
                            txtfieldClass.text = className
                        }
                    }
                    // self.tblViewCenterLabel(tblView: tableView, lblText: "", hide: true)
                }
                if let id = arrClassList[0].classId {
                    self.viewModel?.subjectList(search : "",skip : KIntegerConstants.kInt0,pageSize: pageSize,sortColumnDir: "",sortColumn: "", particularId: id)
                }
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Zero")
            }
        }else{
            CommonFunctions.sharedmanagerCommon.println(object: "Nil")
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    func SubjectListDidSuccess(data: [GetSubjectResultData]?) {
        isFetching = true
        if data != nil{
            if data?.count ?? 0 > 0{
                for value in data!{
                    let containsSameValue = arrSubjectlist.contains(where: {$0.subjectId == value.subjectId})
                    if containsSameValue == false{
                        arrSubjectlist.append(value)
                        if let subjectName = arrSubjectlist[0].subjectName {
                            txtfieldSubject.text = subjectName
                            
                            //                            if let id = arrSubjectlist[0].subjectId {
                            //                                if let classid = selectedClassId {
                            
                            //                                }
                            //                            }
                        }
                    }
                    //  self.tblViewCenterLabel(tblView: tableView, lblText: "", hide: true)
                }
                
                self.viewModel?.studentList(search: "", skip: 0, pageSize: KIntegerConstants.kInt0, sortColumnDir: "", sortColumn: "", classSubjectID:1, classID: 1 )
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Zero")
            }
        }else{
            CommonFunctions.sharedmanagerCommon.println(object: "Nil")
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    func StudentRatingDidSucceed() {
        
    }
    
    func StudentRatingDidFailour() {
        
    }
    
    
    
}
//MARK:- PICKER DELEGATE FUNCTIONS
extension StudentRatingVC : SharedUIPickerDelegate{
    func DoneBtnClicked() {
        if checkInternetConnection(){
            //            arrAllAssignedSubjects.removeAll()
            if isClassSelected == true {
                if let index = selectedClassArrIndex {
                    if let id = arrSkillList[index].studentID {
                         RegisterClassDataModel.sharedInstance?.subjectID = id
                        self.viewModel?.GetSubjectList(classid: id,teacherId: userRoleParticularId)
                        //                        self.viewModel?.subjectList(search : "",skip : KIntegerConstants.kInt0,pageSize: pageSize,sortColumnDir: "",sortColumn: "", particularId: id)
                    }
                }
            }else if isSubjectSelected == true{
                if let index = selectedClassArrIndex {
                    self.viewModel?.studentList(search: "", skip: 0, pageSize: KIntegerConstants.kInt0, sortColumnDir: "", sortColumn: "", classSubjectID:96, classID:  RegisterClassDataModel.sharedInstance?.subjectID ?? 0 )
//                    self.viewModel?.studentList(search: "", skip: 0, pageSize: KIntegerConstants.kInt0, sortColumnDir: "", sortColumn: "", classSubjectID:arrSubjectList1[index].studentID ?? 0, classID:  RegisterClassDataModel.sharedInstance?.subjectID ?? 0 )
                }
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
            if arrSubjectList1.count > 0 {
                txtfieldSubject.text = arrSubjectList1[0].studentName
                return arrSubjectList1[index].studentName ?? ""
            }
        }
        else if isMonthSelected == true {
            if arrMonthlist.count > 0 {
                //                textfieldMonth.text = arrMonthlist[0]
                //                return arrMonthlist[index] ?? ""
            }
        }
        return ""
    }
    
    func SelectedRow(index: Int) {
        
        if isClassSelected == true {
            if arrSkillList.count > 0{
                selectedClassId = arrSkillList[index].studentID
                txtfieldClass.text = arrSkillList[index].studentName
                selectedClassArrIndex = index
            }
        }
        else if isSubjectSelected == true {
            if arrSubjectList1.count > 0 {
                selectedSubjectId = arrSubjectList1[index].studentID
                txtfieldSubject.text = arrSubjectList1[index].studentName
            }
            
        }
        else if isMonthSelected == true {
            if arrMonthlist.count > 0 {
                textfieldMonth.text = arrMonthlist[index]
            }
        }
        
    }
}


//MARK:- View Delegate
extension StudentRatingVC : ViewDelegate{
    func registerTableViewCell(){
        self.tableView.register(UINib(nibName: "SelectionTblViewCell", bundle: nil), forCellReuseIdentifier: KTableViewCellIdentifier.kSelectionTableViewCell)
    }
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
    func setUI(){
        
        self.setSearchBarInNavigationController(placeholderText: KSearchBarPlaceHolder.kUserSearchBarPlaceHolder, navigationTitle: KStoryBoards.KClassListIdentifiers.kClassListTitle, navigationController: self.navigationController, navigationSearchBarDelegates: self)
        
        //Set Back Button
        self.setBackButton()
        
        //Set picker view
        self.SetpickerView(self.view)
        
        // cornerButton(btn: btnSubmit, radius: 8)
        
        //Title
        self.title = KStoryBoards.KClassListIdentifiers.kStudentRating
        
        self.tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.separatorColor = .white
        
        self.viewModel?.isSearching = false
        txtfieldClass.txtfieldPadding(leftpadding: 10, rightPadding: 0)
        txtfieldSubject.txtfieldPadding(leftpadding: 10, rightPadding: 0)
        textfieldMonth.txtfieldPadding(leftpadding: 10, rightPadding: 0)
        
    }
}
extension StudentRatingVC : UITableViewDelegate {
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isFromHod == true{
            let storyboard = UIStoryboard.init(name: "Student", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SubjectSkillRatingVC") as! SubjectSkillRatingVC
//            if arrSubjectlist.count > 0{
                vc.subjectName = txtfieldSubject.text
//            }
            
            //        if let id = arrSubjectList[indexPath.row].ClassSubjectId {
            //            print("your value printed : \(id)")
            //            vc.classId = id
            //        }
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let storyboard = UIStoryboard.init(name: "Student", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "AddStudentRatingVC") as! AddStudentRatingVC
            if currentMonth == textfieldMonth.text! {
                //User can edit or not
                vc.type = "Edit"
            }
            else {
                vc.type = "Show"
            }
            if let name = arrStudent[indexPath.row].studentName {
                vc.studentName = name
            }
            if let className = txtfieldClass.text {
                vc.className = className
            }
            if let subjectName = txtfieldSubject.text {
                vc.subjectName = subjectName
            }
            
            if let classid = selectedClassId {
                vc.selectedClassId = classid
            }
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
}
extension StudentRatingVC : UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.separatorStyle = .singleLine
        return arrStudent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StudentRating.kStudentRatingCell, for: indexPath) as! StudentRatingTableViewCell
        
        cell.setCellUI(data: arrStudent, indexPath: indexPath)
        //        if let name = arrStudent[indexPath.row].studentName {
        //            cell.lblStudentName.text = name
        //        }
        //
        //        if let rating = arrStudent[indexPath.row].studentRating {
        //            cell.lblPercentage.text = rating
        //        }
        return cell
        
    }
    
}


//MARK:- UISearchController Bar Delegates
extension StudentRatingVC : NavigationSearchBarDelegate{
    
    func textDidChange(searchBar: UISearchBar, searchText: String) {
        viewModel?.isSearching = true
        //  arrAllAssignedSubjects.removeAll()
        //        self.viewModel?.getAllAssignSubjectList(classId: self.selectedClassId ?? 0, searchText: searchText, pageSize: KIntegerConstants.kInt1000, filterBy: 0, skip: KIntegerConstants.kInt0)
    }
    
    func cancelButtonPress(uiSearchBar: UISearchBar) {
        viewModel?.isSearching = true
        DispatchQueue.main.async {
            //            self.viewModel?.getAllAssignSubjectList(classId: self.selectedClassId ?? 0, searchText: "", pageSize: KIntegerConstants.kInt1000, filterBy: 0, skip: KIntegerConstants.kInt0)
        }
    }
}

extension StudentRatingVC : OKAlertViewDelegate{
    
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

extension Date {
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self)
    }
}
