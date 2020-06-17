//
//  AssignSubjectToTeacherVC.swift
//  ISMS
//
//  Created by Poonam on 09/06/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import UIKit

class AssignSubjectToTeacherVC: BaseUIViewController {
    var ViewModel : AssignSubjectTeacherViewModel?
    var arrSubjectList = [GetSubjectListResultData]()
    var isSelectedArr = [Int]()
    var selectedSubjectArrIndex : Int?
    var selectedClassIndex = 0
    var selectedClassID : Int?
    var classData : GetCommonDropdownModel!
   
   
    var skip = Int()
    var isScrolling : Bool?
    var pageSize = KIntegerConstants.kInt10
    var pointNow:CGPoint!
    var isFetching:Bool?
    var isUnauthorizedUser = false
    var selectedSubjectViewModels = [[String:Any]]()
    var teacherId : Int?
    var isUpdate : Int?
    let userRoleParticularId = UserDefaultExtensionModel.shared.userRoleParticularId
    let departmentId = UserDefaultExtensionModel.shared.HODDepartmentId
    
    @IBOutlet weak var btnSubmitStudent: UIButton!
    
    @IBOutlet weak var dropDownTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("teacherid : ",teacherId)
        setBackButton()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
    if checkInternetConnection()
        {
            self.ViewModel?.getClassId(id:departmentId, enumtype: 6)
        }
        else
        {
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
             
    }
     
    
    @IBAction func btnCheckAction(_ sender: UIButton) {

    var data = [String:Any]()
        let extractedData = arrSubjectList[sender.tag]
       
        
        if sender.isSelected{
            sender.isSelected = false
            if let index = isSelectedArr.firstIndex(of: sender.tag) {
                    isSelectedArr.remove(at: index)
            }
            let index = getIndex(of: "ClassSubjectId", for: extractedData.classSubjectId ?? 0, in: selectedSubjectViewModels)
            self.selectedSubjectViewModels.remove(at: index)
        }else{
            sender.isSelected = true
            isSelectedArr.append(sender.tag)
           
            data = ["ClassSubjectId":extractedData.classSubjectId , "SubjectName": extractedData.subjectName,"Occurrence":0]
            selectedSubjectViewModels.append(data)
        }
    
    print("data: ",data)
    
//    selectedSubjectViewModels.append(data)
    }
    
    
    func getIndex(of key: String, for value: Int, in dictionary : [[String: Any]]) -> Int{
        var count = 0
        for dictElement in dictionary{
            if dictElement.keys.contains(key) && dictElement[key] as! Int == value{
                return count
            }
            else{
                count = count + 1
            }
        }
        return -1

    }
    
    
  @IBAction func SubmitAction(_ sender: Any) {
    self.ViewModel?.submitAssignSubject(ClassId: selectedClassID ?? 0,TeacherId: 1088,subjectLists: selectedSubjectViewModels)
    }

    @IBAction func btnOpenDropDown(_ sender: Any) {
           if classData.resultData?.count ?? 0 > 0{
               UpdatePickerModel2(count: classData?.resultData?.count ?? 0, sharedPickerDelegate: self, View:  self.view, index: 0)
           }
    }
    
        //Setup UI
        func setupUI(){
            self.title = "Assign Subject To Teacher"
            self.ViewModel = AssignSubjectTeacherViewModel.init(delegate: self)
            self.ViewModel?.attachView(viewDelegate: self)
            tableView.separatorStyle = .none
            tableView.tableFooterView = UIView()
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorColor = KAPPContentRelatedConstants.kLightBlueColour
            self.tblViewCenterLabel(tblView: tableView, lblText: "Select student class", hide: false)
            dropDownTextField.txtfieldPadding(leftpadding: 10, rightPadding: 0)
            SetpickerView(self.view)
            
    }

}
extension AssignSubjectToTeacherVC : OKAlertViewDelegate{
    
    //Ok Button Clicked
    func okBtnAction() {
        if isUnauthorizedUser == true{
            isUnauthorizedUser = false
            CommonFunctions.sharedmanagerCommon.setRootLogin()
        }
        okAlertView.removeFromSuperview()
    }
}

extension AssignSubjectToTeacherVC : YesNoAlertViewDelegate{
    
    func yesBtnAction() {

    }
    
    func noBtnAction() {
        yesNoAlertView.removeFromSuperview()
    }
}


extension AssignSubjectToTeacherVC : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100;//Choose your custom row height
    }
    
}
extension AssignSubjectToTeacherVC : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrSubjectList.count > 0{
            tableView.separatorStyle = .singleLine
            return (arrSubjectList.count)
        }else{
          //  tblViewCenterLabel(tblView: tableView, lblText: KConstants.kNoDataFound, hide: false)
           return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AssignSubjectTeacherCell", for: indexPath) as! AssignSubjectTeacherCell
        
        if isSelectedArr.contains(indexPath.row){
            cell.checkBtn.isSelected = true
        }else{
            cell.checkBtn.isSelected = false
        }
        
        cell.setCellUI(data: arrSubjectList, indexPath: indexPath)
        return cell
    }
}

extension AssignSubjectToTeacherVC : AssignSubjectTeacherDelegate{
    
    
    func unauthorizedUser() {
        isUnauthorizedUser = true
    }
    func getClassdropdownDidSucceed(data : GetCommonDropdownModel){
        classData = data
        if let count = data.resultData?.count{
            if count > 0 {
//                UpdatePickerModel2(count: classData?.resultData?.count ?? 0, sharedPickerDelegate: self, View:  self.view, index: 0)
                var resultData = classData.resultData
               // self.dropDownTextField.text = resultData?[0].name
              //  var newClassId = resultData?[0].id
               //  self.ViewModel?.studentList(classId : newClassId, Search: "", Skip: KIntegerConstants.kInt0, PageSize: pageSize)
            }else{
                print("Department Count is zero.")
            }
        }
    }
    
    
    func AssignSubjectTeacherDidSuccess(data : [GetSubjectListResultData])
    {
        isFetching = true
        
        arrSubjectList.removeAll()
        arrSubjectList = data
        self.tableView.reloadData()
        if isUpdate == 1{
            ViewModel?.GetAssignedSubjectToTeacherById(ClassId: selectedClassID ?? 0,TeacherId: teacherId ?? 0)
        }
        

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    func GetAssignSubjectSucceed(data: [GetAssignSubjectListResultData]){
        
    }
    
    func AssignSubjectTeacherDidFailed() {
        
    }
    
}

extension AssignSubjectToTeacherVC : ViewDelegate{
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


extension AssignSubjectToTeacherVC: SharedUIPickerDelegate{
    func DoneBtnClicked() {
        if let count = classData.resultData?.count{
            if count > 0{
                //Bool for set the array in the list of students for selected class
              
                dropDownTextField.text = classData?.resultData?[selectedClassIndex].name
                if selectedClassIndex == 0{
                    self.dropDownTextField.text = self.classData?.resultData?[selectedClassIndex].name
                    self.selectedClassID = self.classData?.resultData?[selectedClassIndex].id ?? 0
                    //self.ViewModel?.studentList(classId : selectedClassID, Search: "", Skip: 0, PageSize: 1000)
                    self.ViewModel?.GetSubjectList(classid: selectedClassID ?? 0,teacherId: 0,hodid:userRoleParticularId)
                }else{
                    self.dropDownTextField.text = self.classData?.resultData?[selectedClassIndex].name
                    self.selectedClassID = self.classData?.resultData?[selectedClassIndex].id ?? 0
                    //self.ViewModel?.studentList(classId : selectedClassID, Search: "", Skip: 0, PageSize: 1000)
                    self.ViewModel?.GetSubjectList(classid: selectedClassID ?? 0,teacherId: 0,hodid:userRoleParticularId)
                }
            }
        }
    }
    
    func GetTitleForRow(index: Int) -> String {
        if let count = classData.resultData?.count{
            if count > 0{
                //dropDownTextField.text = classData?.resultData?[0].name
                selectedClassID = classData?.resultData?[0].id ?? 0
                selectedClassIndex = 0
                return classData?.resultData?[index].name ?? ""
            }
        }
        return ""
    }
    
    
    func SelectedRow(index: Int) {
        
        //Using Exist Method of collection prevent from indexoutof range error
        if let count = classData.resultData?.count{
            if count > 0{
                if (self.classData.resultData?[exist: index]?.name) != nil{
                   // self.dropDownTextField.text = self.classData?.resultData?[index].name
                    self.selectedClassID = self.classData?.resultData?[index].id ?? 0
                    self.selectedClassIndex = index
                    print("Selected Department:- \(String(describing: self.classData?.resultData?[index].name))")
                }
            }
        }
    }
    
    func cancelButtonClicked() {
        
    }
    
}
