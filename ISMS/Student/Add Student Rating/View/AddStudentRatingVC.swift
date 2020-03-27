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
    var arrClassList = [GetClassListResultData]()
    var arrSubjectlist=[GetSubjectResultData]()
    var arrStudentlist = [AddStudentRatingResultData]()
    var selectedClassId : Int?
    var selectedSubjectId : Int?
    var selectStudentId : Int?
    var selectRatingCount = [1,2,3,4,5,6,7,8,9,10]
    var selectedClassArrIndex : Int?
    var pageSize = KIntegerConstants.kInt10
    var isClassSelected = false
    var isSubjectSelected = false
    var isStudentSelected = false
    var isSelectedRating = false
    var countSelected : Int?
    var arrSkillList = [AddStudentRatingResultData]()
    var arrClickedArray = [AddStudentRatingResultData]()
    var viewModel : AddStudentRatingViewModel?
    var array = [1,2,3,4,5,6,7,8,9,10]
    var clickedCount : Int?
    var arrSelect = [[String:Any]]()
    var type : String?
    var studentName : String?
    var className : String?
    var subjectName : String?
    
    @IBOutlet var btnClass: UIButton!
    @IBOutlet var btnStudent: UIButton!
    @IBOutlet var btnSubject: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewModel = AddStudentRatingViewModel.init(delegate: self)
        self.viewModel?.attachView(viewDelegate: self)
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
       
        self.viewModel?.GetSkillList(id : 0 , enumType : 13 ,type : "Skill")
     
        if let classID = selectedClassId {
        
        }
        
        self.viewModel?.getSubjectWiseRating(enrollmentsId: 6, classId: 33)
        tableView.reloadData()
        if type == "Edit" {
            
            btnClass.isEnabled = true
            btnStudent.isEnabled = true
            btnSubject.isEnabled = true
        }
        else {
            btnClass.isEnabled = false
            btnStudent.isEnabled = false
            btnSubject.isEnabled = false
             }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if checkInternetConnection(){
            self.viewModel?.classList(searchText: "", pageSize: KIntegerConstants.kInt1000, filterBy: 0, skip: KIntegerConstants.kInt0)
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
            if arrClassList.count > 0{
                UpdatePickerModel(count: arrClassList.count, sharedPickerDelegate: self as! SharedUIPickerDelegate, View:  self.view)
                
                selectedClassId = arrClassList[0].classId
                let text = txtfieldClass.text!
                if let index = arrClassList.index(where: { (dict) -> Bool in
                    return dict.name ?? "" == text // Will found index of matched id
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
    //MARK:- ACTION STUDENT PICKER
    @IBAction func ActionStudentPicker(_ sender: UIButton) {
        isClassSelected = false
        isSubjectSelected = false
        isStudentSelected = true
        isSelectedRating = false
        if checkInternetConnection(){
            if arrStudentlist.count > 0{
                UpdatePickerModel(count: arrSubjectlist.count, sharedPickerDelegate: self as! SharedUIPickerDelegate, View:  self.view)
                self.selectStudentId = arrStudentlist[0].studentID
                
                let text = txtfieldClass.text!
                if let index = arrStudentlist.index(where: { (dict) -> Bool in
                    return dict.studentName ?? "" == text // Will found index of matched id
                }) {
                    print("Index found :\(index)")
                    UpdatePickerModel4(count: arrStudentlist.count, sharedPickerDelegate: self as! SharedUIPickerDelegate, View:  self.view,index: index)
                }
            }
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
}
    
    //MARK:- ACTION SUBMIT
    @IBAction func ActionSubmit(_ sender: Any) {
        if let id = selectedClassId {
            if let getStudentID = selectStudentId {
            self.viewModel?.SubmitTotalRating(teacherID: 10, enrollmentsId : getStudentID,classSubjectId: id,comment: "good",StudentSkillRatings: arrSelect)
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
                UpdatePickerModel(count: arrSubjectlist.count, sharedPickerDelegate: self as! SharedUIPickerDelegate, View:  self.view)
                selectedSubjectId = arrSubjectlist[0].subjectId
                                let text = txtfieldClass.text!
                                if let index = arrSubjectlist.index(where: { (dict) -> Bool in
                                    return dict.subjectName ?? "" == text // Will found index of matched id
                                }) {
                                    print("Index found :\(index)")
                                    UpdatePickerModel4(count: arrSubjectlist.count, sharedPickerDelegate: self as! SharedUIPickerDelegate, View:  self.view,index: index)
                                }
            }
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
    }
}
    
    
    
    
    

