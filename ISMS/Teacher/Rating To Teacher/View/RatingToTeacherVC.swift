//
//  RatingToTeacherVC.swift
//  ISMS
//
//  Created by Kuldeep Singh on 12/2/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class RatingToTeacherVC: BaseUIViewController {

    //MARK:- ALL CLASS OUTLETS
    @IBOutlet var txtfieldClass: UITextField!
    @IBOutlet var txtfieldStudent: UITextField!
    @IBOutlet var txtfieldSubject: UITextField!
    @IBOutlet var tableView: UITableView!
    //MARK:- ALL VARIABLES
    var isUnauthorizedUser = false
    var isFetching:Bool?
    var arrClassList = [GetClassListResultData]()
    var arrSubjectlist=[AddStudentRatingResultData]()
    var arrTeacherlist = [TeacherResultData]()
    var selectedClassId : Int?
    var selectedSubjectId : Int?
    var selectTeacherId : Int?
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
    var viewModel : RatingToTeacherViewModel?
    var array = [1,2,3,4,5,6,7,8,9,10]
    var clickedCount : Int?
    var arrSelect = [[String:Any]]()
    
    //MARK:- CLASS OVERRIDE FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = RatingToTeacherViewModel.init(delegate: self)
        self.viewModel?.attachView(viewDelegate: self)
        // Do any additional setup after loading the view.
        DispatchQueue.main.async {
            self.setUI()
        }
        self.viewModel?.GetSkillList(id : 0 , enumType : 15 ,type : "Skill")
        tableView.reloadData()
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
            if arrTeacherlist.count > 0{
                UpdatePickerModel(count: arrTeacherlist.count, sharedPickerDelegate: self as! SharedUIPickerDelegate, View:  self.view)
                self.selectTeacherId = arrTeacherlist[0].teacherID
                
                let text = txtfieldClass.text!
                if let index = arrTeacherlist.index(where: { (dict) -> Bool in
                    return dict.teacherFirstName ?? "" == text // Will found index of matched id
                }) {
                    print("Index found :\(index)")
                    UpdatePickerModel4(count: arrTeacherlist.count, sharedPickerDelegate: self as! SharedUIPickerDelegate, View:  self.view,index: index)
                }
            }
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
    }
    
    //MARK:- ACTION SUBMIT
    @IBAction func ActionSubmit(_ sender: Any) {
        if let id = selectedSubjectId {
            if let getID = selectTeacherId {
                self.viewModel?.SubmitTotalRating(teacherID: getID, enrollmentsId : 0,classSubjectId: id,comment: "good",StudentSkillRatings: arrSelect)
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
                selectedSubjectId = arrSubjectlist[0].studentID
                let text = txtfieldClass.text!
                if let index = arrSubjectlist.index(where: { (dict) -> Bool in
                    return dict.studentName ?? "" == text // Will found index of matched id
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
