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
    var homeWorkList : [HomeworkResultData]?
    var homworkId: Int? = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

       self.viewModel = HomeworkViewModel.init(delegate: self)
        self.viewModel?.attachView(viewDelegate: self)
        setView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
         self.viewModel?.getHomeworkData(teacherId:2)
     }

   func setView() {
       tblViewListing.tableFooterView = UIView()
   }

}

extension StudentHomeWorkListVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeWorkList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeWorkCell
        cell.lblTitle.text = homeWorkList?[indexPath.row].Topic
        cell.lblSubjectName.text = homeWorkList?[indexPath.row].SubjectName
        cell.lblClassName.text = homeWorkList?[indexPath.row].ClassName
        return cell
    }
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 91
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
            LblNoDataFound.isHidden = true
        }
        else {
            LblNoDataFound.isHidden = false
        }
        tblViewListing.reloadData()
    }
    
    func AddHomeworkFailour(msg: String) {
         self.showAlert(Message: msg)
    }
}

