//
//  TeacherRatingVC.swift
//  ISMS
//
//  Created by Kuldeep Singh on 12/3/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class TeacherRatingVC: BaseUIViewController {
    
    @IBOutlet var txtfieldClass: UITextField!
    @IBOutlet var txtfieldSubject: UITextField!
    @IBOutlet var tableView: UITableView!
    var viewModel : TeacherRatingViewModel?
    var isUnauthorizedUser = false
    var isFetching:Bool?
    var arrClassList = [GetClassListResultData]()
    var arrSubjectlist=[AddStudentRatingResultData]()
    var selectedClassId : Int?
    var selectedSubjectId : Int?
    var selectedStudentId : Int?
    var selectedClassArrIndex : Int?
    var pageSize = KIntegerConstants.kInt10
    var isClassSelected = false
    var isSubjectSelected = false
    var arrStudent = [StudentRatingResultData]()
    
    //MARK:- CLASS OVERRIDE FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = TeacherRatingViewModel.init(delegate : self)
        self.viewModel?.attachView(viewDelegate: self)
        DispatchQueue.main.async {
            self.setUI()
        }
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
    //MARK:- SELECT CLASS PICKER
    @IBAction func ActionSelectClass(_ sender: Any) {
        isClassSelected = true
        isSubjectSelected = false
        
        if checkInternetConnection(){
            if arrClassList.count > 0{
                UpdatePickerModel(count: arrClassList.count, sharedPickerDelegate: self as! SharedUIPickerDelegate, View:  self.view)
                
                selectedClassId = arrClassList[0].classId
                let text = txtfieldClass.text!
                if let index = arrClassList.index(where: { (dict) -> Bool in
                    return dict.name ?? "" == text // Will found index of matched id
                })
                {
                    print("Index found :\(index)")
                    UpdatePickerModel4(count: arrClassList.count, sharedPickerDelegate: self as! SharedUIPickerDelegate, View:  self.view, index: index)
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
        if checkInternetConnection(){
            if arrSubjectlist.count > 0 {
                UpdatePickerModel(count: arrSubjectlist.count, sharedPickerDelegate: self as! SharedUIPickerDelegate, View:  self.view)
                selectedSubjectId = arrSubjectlist[0].studentID
                
                let text = txtfieldSubject.text!
                if let index = arrSubjectlist.index(where: { (dict) -> Bool in
                    return dict.studentName ?? "" == text // Will found index of matched id
                })
                {
                    print("Index found :\(index)")
                    UpdatePickerModel4(count: arrSubjectlist.count, sharedPickerDelegate: self as! SharedUIPickerDelegate, View:  self.view, index: index)
                }
                
            }
            //           self.viewModel?.classList(searchText: "", pageSize: KIntegerConstants.kInt1000, filterBy: 0, skip: KIntegerConstants.kInt0)
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
        
        
    }
    
    
}
