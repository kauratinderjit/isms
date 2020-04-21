//
//  StudentDetailHomeworkVC.swift
//  ISMS
//
//  Created by Atinder Kaur on 4/16/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import UIKit

class StudentDetailHomeworkVC: BaseUIViewController {
    
    
    @IBOutlet weak var txtfieldClass: UITextField!
    @IBOutlet weak var txtfieldSubject: UITextField!
    @IBOutlet weak var txtfieldTitle: UITextField!
    @IBOutlet weak var txtViewDescription: UITextView!
    @IBOutlet weak var txtfieldSubmissionDate: UITextField!
    @IBOutlet weak var tblViewListing: UITableView!
    @IBOutlet weak var heightTblView: NSLayoutConstraint!
      var viewModel : HomeworkViewModel?
    var objGetStudentHomeDetail : Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Homework Details"
        heightTblView.constant = 0
        self.viewModel = HomeworkViewModel.init(delegate: self)
               self.viewModel?.attachView(viewDelegate: self)
        tblViewListing.tableFooterView = UIView()
        self.viewModel?.getHomeworkDataForStudent(studentId: UserDefaultExtensionModel.shared.userRoleParticularId, assignHomeWorkId: objGetStudentHomeDetail ?? 0)
        
    }

    
    @IBAction func actionbtnSubmit(_ sender: UIButton) {
        
    }
    
    @IBAction func actionBtnDownload(_ sender: UIButton) {
    }
    
}
extension StudentDetailHomeworkVC : ViewDelegate {
    
    func showAlert(alert: String) {
        self.showAlert(Message: alert)
    }
    
    func showLoader() {
          self.ShowLoader()
    }
    
    func hideLoader() {
        self.HideLoader()
    }
    
}

extension StudentDetailHomeworkVC : AddHomeWorkDelegate {
    func subjectList(data: [HomeworkResultHWData]) {
        
    }
    
    func attachmentDeletedSuccessfully() {
        
    }
    
    func addedSuccessfully() {
        
    }
    
    func getSubjectList(arr: [GetSubjectHWResultData]) {
        
    }
    
    
    func classListDidSuccess(data: GetCommonDropdownModel) {
        
    }
    
    
    func AddHomeworkSucceed(array: [HomeworkResultData]) {
        
//        homeWorkList = array
//
//        if homeWorkList?.count ?? 0 > 0 {
//            LblNoDataFound.isHidden = true
//        }
//        else {
//            LblNoDataFound.isHidden = false
//        }
//        tblViewListing.reloadData()
    }
    
    func AddHomeworkFailour(msg: String) {
         self.showAlert(Message: msg)
    }
}
