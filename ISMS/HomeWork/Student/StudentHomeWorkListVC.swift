//
//  StudentHomeWorkListVC.swift
//  ISMS
//
//  Created by Atinder Kaur on 4/16/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import UIKit

class StudentHomeWorkListVC: BaseUIViewController {
    
    @IBOutlet weak var tblViewListing: UITableView!
    @IBOutlet weak var LblNoDataFound: UILabel!
    var viewModel : HomeworkViewModel?
    var homeWorkList : [lstASTopic]?
    var homworkId: Int? = 0
    var assignHomeWorkId : Int? = 0
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = HomeworkViewModel.init(delegate: self)
        self.viewModel?.attachView(viewDelegate: self)
        setView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //  assignHomeWorkId = homeWorkList.AssignHomeWorkId
        //  self.viewModel?.getHomeworkDataForStudent(studentId: UserDefaultExtensionModel.shared.enrollmentIdStudent, assignHomeWorkId: assignHomeWorkId ?? 0)
    }
    
    func setView()
    {
        tblViewListing.tableFooterView = UIView()
        self.title = "Assign Homework"
        self.setBackButton()
        
        
    }
    
}

extension StudentHomeWorkListVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeWorkList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeWorkCell
        cell.lblTitle.text = homeWorkList?[indexPath.row].Topic
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        if let dateFinal =  dateFormatter.date(from: homeWorkList?[indexPath.row].SubmssionDate ?? "") {
            let dd = formatter.string(from: dateFinal)
            cell.lblClassName.text = "Submission Date: \(dd)"
        }
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 91
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // objGetStudentHomeDetail
        tableView.deselectRow(at: indexPath, animated: false)
        if homeWorkList?.count ?? 0 > 0 {
            let vc = UIStoryboard.init(name:"Homework", bundle: Bundle.main).instantiateViewController(withIdentifier: "StudentDetailHomeworkVC") as! StudentDetailHomeworkVC
            vc.objGetStudentHomeDetail = homeWorkList?[indexPath.row].AssignHomeWorkId
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
}
extension StudentHomeWorkListVC : ViewDelegate {
    
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

extension StudentHomeWorkListVC : AddHomeWorkDelegate {
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

