//
//  AddOccuranceVC.swift
//  ISMS
//
//  Created by Poonam  on 09/06/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import UIKit

class AddOccuranceVC: BaseUIViewController {

    @IBOutlet weak var txtFieldOccurance: UITextField!
    @IBOutlet weak var txtFieldSubject: UITextField!
    @IBOutlet weak var txtFieldClass: UITextField!
    
      var ViewModel : OccuranceViewModel?
     var isUnauthorizedUser = false
    var selectedSubjectArrIndex : Int?
    var classData : GetCommonDropdownModel!
    var selectedClassIndex = 0
    var selectedClassSubjectId : Int?
    var selectedClassID : Int?
    var arrSubjectList1 = [AddStudentRatingResultData]()
    var isClassSelected = false
    var isSubjectSelected = false
    var isOccuranceSelected = false
    var selectedSubjectId : Int?
      var arrOccurancelist = [1,2,3,4,5,6,7,8]
    let departmentId = UserDefaultExtensionModel.shared.HODDepartmentId
    let userRoleParticularId = UserDefaultExtensionModel.shared.userRoleParticularId
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackButton()
        setupUI()
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
     func setupUI(){
        self.title = "Add Occurance"
        self.ViewModel = OccuranceViewModel.init(delegate: self)
        self.ViewModel?.attachView(viewDelegate: self)
        SetpickerView(self.view)
        }

    @IBAction func actionClassDropDown(_ sender: Any) {
        isClassSelected = true
        isSubjectSelected = false
        isOccuranceSelected = false
        if classData.resultData?.count ?? 0 > 0{
            UpdatePickerModel2(count: classData?.resultData?.count ?? 0, sharedPickerDelegate: self, View:  self.view, index: 0)
        }
    }
    
    @IBAction func actionSubjectDropDown(_ sender: Any) {
        isClassSelected = false
        isSubjectSelected = true
        isOccuranceSelected = false
        
        if checkInternetConnection(){
            if arrSubjectList1.count > 0{
                UpdatePickerModel2(count: arrSubjectList1.count, sharedPickerDelegate: self, View:  self.view, index: 0)
                
                selectedSubjectId = arrSubjectList1[0].studentID
                let text = txtFieldSubject.text!
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
    
    @IBAction func actionOccuranceDropDown(_ sender: Any) {
        isClassSelected = false
        isSubjectSelected = false
        isOccuranceSelected = true
        if checkInternetConnection(){
            if arrOccurancelist.count > 0{
                UpdatePickerModel2(count: arrOccurancelist.count, sharedPickerDelegate: self, View:  self.view, index: 0)
                
            }
        }else{
            self.showAlert(Message: Alerts.kNoInternetConnection)
        }
    }
    
    @IBAction func actionSubmit(_ sender: Any) {
        
    }
    
}



extension AddOccuranceVC : OccuranceDelegate{
     func unauthorizedUser() {
            isUnauthorizedUser = true
        }
        func getClassdropdownDidSucceed(data : GetCommonDropdownModel){
            classData = data
            if let count = data.resultData?.count{
                if count > 0 {
                    var resultData = classData.resultData
                }else{
                    print("Department Count is zero.")
                }
            }
        }
    
     func GetSubjectListDidSucceed(data: [AddStudentRatingResultData]?) {
            print("our data : ",data)
            arrSubjectList1.removeAll()
            if let data1 = data {
                if data1.count>0
                {
                    self.arrSubjectList1 = data1
                    if let subjectName = arrSubjectList1[0].studentName{
                         selectedClassSubjectId = arrSubjectList1[0].classSubjectId
                        txtFieldSubject.text = subjectName
                    }
                }else{
                    txtFieldSubject.text = ""
                    txtFieldSubject.placeholder = "No Subject assign"
                }
            }
        }
}

extension AddOccuranceVC: SharedUIPickerDelegate{
    func DoneBtnClicked() {
        if isClassSelected == true {
            isClassSelected = false
        if let count = classData.resultData?.count{
            if count > 0{
                //Bool for set the array in the list of students for selected class
                txtFieldClass.text = classData?.resultData?[selectedClassIndex].name
                if selectedClassIndex == 0{
                    self.txtFieldClass.text = self.classData?.resultData?[selectedClassIndex].name
                    self.selectedClassID = self.classData?.resultData?[selectedClassIndex].id ?? 0
                    self.ViewModel?.GetSubjectList(classid: selectedClassID ?? 0,teacherId: 0,hodid:userRoleParticularId )
                }else{
                    self.txtFieldClass.text = self.classData?.resultData?[selectedClassIndex].name
                    self.selectedClassID = self.classData?.resultData?[selectedClassIndex].id ?? 0
                    self.ViewModel?.GetSubjectList(classid: selectedClassID ?? 0,teacherId: 0,hodid:userRoleParticularId )
                        }
                    }
                }
            }else if isSubjectSelected == true{
                isSubjectSelected = false
                if let index = selectedSubjectArrIndex {
                    if arrSubjectList1.count>index{
                        selectedClassSubjectId = arrSubjectList1[index].classSubjectId
                        }
                    }
                }
            }
    func GetTitleForRow(index: Int) -> String {
        if isClassSelected == true{
            if let count = classData.resultData?.count{
                      if count > 0{
                          //dropDownTextField.text = classData?.resultData?[0].name
                          selectedClassID = classData?.resultData?[0].id ?? 0
                          selectedClassIndex = 0
                          return classData?.resultData?[index].name ?? ""
                      }
                  }
        }else if isSubjectSelected == true {
            if arrSubjectList1.count > 0 {
                txtFieldSubject.text = arrSubjectList1[0].studentName
                return arrSubjectList1[index].studentName ?? ""
            }
        }else if isOccuranceSelected == true {
            if arrOccurancelist.count > 0 {
                txtFieldOccurance.text =  String(arrOccurancelist[index])
                return txtFieldOccurance.text ?? ""
            }
        }
        return ""
    }
    
    
    func SelectedRow(index: Int) {
        
        //Using Exist Method of collection prevent from indexoutof range error
        if isClassSelected == true{
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
        else if isSubjectSelected == true {
                   if arrSubjectList1.count > 0 {
                       selectedSubjectId = arrSubjectList1[index].studentID
                       txtFieldSubject.text = arrSubjectList1[index].studentName
                       selectedSubjectArrIndex = index
                   }
                   
               }else if isOccuranceSelected == true {
            if arrOccurancelist.count > 0 {
                           txtFieldOccurance.text = String(arrOccurancelist[index])
                       }
        }
    }
    
    func cancelButtonClicked() {
        
    }
    
}

extension AddOccuranceVC : ViewDelegate{
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
extension AddOccuranceVC : OKAlertViewDelegate{
    
    //Ok Button Clicked
    func okBtnAction() {
        if isUnauthorizedUser == true{
            isUnauthorizedUser = false

        }
//        else if isStudentDelete == true{
//            isStudentDelete = false
//            if let selectedIndex = self.selectedStudentArrIndex{
//                self.arrStudentlist.remove(at: selectedIndex)
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//            }
//            
//        }
        okAlertView.removeFromSuperview()
    }
}
