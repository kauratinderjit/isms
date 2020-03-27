//
//  StudentRatingVC.swift
//  ISMS
//
//  Created by Kuldeep Singh on 11/27/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class StudentRatingVC: BaseUIViewController {

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
    //MARK:- BUTTON HIDDEN OR FLASE
    func showEnableButtons() {
        
        
    }
    
    //MARK:- SELECT CLASS PICKER
    @IBAction func ActionSelectClass(_ sender: Any) {
          isClassSelected = true
          isSubjectSelected = false
          isMonthSelected = false
        
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
        isMonthSelected = false
        if checkInternetConnection(){
            if arrSubjectlist.count > 0{
                UpdatePickerModel(count: arrSubjectlist.count, sharedPickerDelegate: self as! SharedUIPickerDelegate, View:  self.view)
                selectedSubjectId = arrSubjectlist[0].subjectId
                
//                let text = txtfieldClass.text!
//                if let index = arrClassList.index(where: { (dict) -> Bool in
//                    return dict.name ?? "" == text // Will found index of matched id
//                }) {
//                    print("Index found :\(index)")
//                    UpdatePickerModel(count: arrClassList.count, sharedPickerDelegate: self as! SharedUIPickerDelegate, View:  self.view, startPickerIndex: index)
//                }
            }
            //           self.viewModel?.classList(searchText: "", pageSize: KIntegerConstants.kInt1000, filterBy: 0, skip: KIntegerConstants.kInt0)
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
