//
//  TeacherSkillRatingVC.swift
//  ISMS
//
//  Created by Kuldeep Singh on 12/5/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit


class TeacherSubjectSkillRatingVC: BaseUIViewController {
    
    var viewModel : TeacherSubjectSkillRatingViewModel?
    var arrSkillList = [TeacherSubjectSkillRatingResultData]()
    var arrSubjectlist = [AddStudentRatingResultData]()
    var isSubjectSelected = false
    var selectedSubjectId : Int?
    var indexCount : Int?
    var classId : Int?
    @IBOutlet var textfieldSubject: UITextField!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        self.viewModel = TeacherSubjectSkillRatingViewModel.init(delegate: self)
        self.viewModel?.attachView(viewDelegate: self)
        // Do any additional setup after loading the view.
        self.setUI()
        self.viewModel?.GetSkillList(id: 33, enumType: 10, type: "Skill")
        if let id = classId {
            
        self.viewModel?.getSubjectWiseRating(enrollmentsId: 46, classSubjectId: id)
        }
    }
    
    @IBAction func ActionSubjectPicker(_ sender: Any) {
        isSubjectSelected = true
        if checkInternetConnection(){
            if arrSubjectlist.count > 0{
                UpdatePickerModel(count: arrSubjectlist.count, sharedPickerDelegate: self as! SharedUIPickerDelegate, View:  self.view)
                selectedSubjectId = arrSubjectlist[0].studentID
                let text = textfieldSubject.text!
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


