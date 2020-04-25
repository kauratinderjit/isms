//
//  HomeworkListVC.swift
//  ISMS
//
//  Created by Atinder Kaur on 4/7/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import UIKit

class HomeworkListVC: BaseUIViewController {
    
    @IBOutlet weak var tblViewListing: UITableView!
    public var lstActionAccess : GetMenuFromRoleIdModel.ResultData?
    var viewModel : HomeworkViewModel?
    var homeWorkList : [HomeworkResultData]?
    var homworkId: Int? = 0
    
    @IBOutlet weak var lblNoDataFound: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = HomeworkViewModel.init(delegate: self)
        self.viewModel?.attachView(viewDelegate: self)
        setView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewModel?.getHomeworkData(teacherId:UserDefaultExtensionModel.shared.userRoleParticularId)
    }
    
    func setView() {
        tblViewListing.tableFooterView = UIView()
        setBackButton()
    }
    
    @IBAction func editAction(_ sender: UIButton) {
        if homeWorkList?.count ?? 0 > 0 {
        let data = homeWorkList?[(sender as AnyObject).tag]
            let vc = UIStoryboard.init(name:"Homework", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddHomeWorkVC") as! AddHomeWorkVC
            vc.editableHomeWorkData = data
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    
    @IBAction func deleteAction(_ sender: UIButton) {
        
        if homeWorkList?.count ?? 0>0 {
           let data = homeWorkList?[(sender as AnyObject).tag]
            homworkId = data?.AssignHomeWorkId
                         initializeCustomYesNoAlert(self.view, isHideBlurView: true)
                         yesNoAlertView.delegate = self
                         yesNoAlertView.lblResponseDetailMessage.text = "Do you really want to delete this homework?"
                         
                     }
    }
    

}

extension HomeworkListVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeWorkList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeWorkCell
        cell.btnDel.tag = indexPath.row
        cell.btnEdit.tag = indexPath.row
        cell.lblTitle.text = homeWorkList?[indexPath.row].Topic
        cell.lblSubjectName.text = homeWorkList?[indexPath.row].SubjectName
        cell.lblClassName.text = homeWorkList?[indexPath.row].ClassName
        return cell
    }
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 91
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
extension HomeworkListVC : ViewDelegate {
    
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

extension HomeworkListVC : AddHomeWorkDelegate {
    func studentHomeworkDetail(data: [HomeworkListStudentData]) {
        
    }
    
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
        
        homeWorkList = array
        
        if homeWorkList?.count ?? 0 > 0 {
            lblNoDataFound.isHidden = true
        }
        else {
            lblNoDataFound.isHidden = false
        }
        tblViewListing.reloadData()
    }
    
    func AddHomeworkFailour(msg: String) {
         self.showAlert(Message: msg)
    }
}



extension HomeworkListVC : YesNoAlertViewDelegate{
    
    func yesBtnAction() {
        if self.checkInternetConnection(){
            if let SubjectId1 = self.homworkId{
                self.viewModel?.deleteHW(homeworkId: homworkId ?? 0)
                yesNoAlertView.removeFromSuperview()
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Delete event id is nil")
                yesNoAlertView.removeFromSuperview()
            }
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
            yesNoAlertView.removeFromSuperview()
        }
        yesNoAlertView.removeFromSuperview()
    }
    
    func noBtnAction() {
        yesNoAlertView.removeFromSuperview()
    }
}
