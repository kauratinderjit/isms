//
//  SubjectListVC.swift
//  ISMS
//
//  Created by Atinder Kaur on 4/20/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//
import UIKit

class SubjectListHW: BaseUIViewController {
    
    var ViewModel : HomeworkViewModel?
    var arrSubjectlist=[HomeworkResultHWData]()
    var selectedSubjectArrIndex : Int?
    var subjectId:Int?
    var isUnauthorizedUser = false
    var isSubjectAddSuccessFully = false
    var isSubjectDelete = false
    var skip = Int()
    var isScrolling : Bool?
    var pageSize = KIntegerConstants.kInt10
    var pointNow:CGPoint!
    var isFetching:Bool?
    
    @IBOutlet weak var table_View: UITableView!
    @IBOutlet weak var LblNoDataFound: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackButton()
        table_View.delegate = self
        table_View.dataSource = self
        table_View.tableFooterView = UIView()
        table_View.separatorColor = KAPPContentRelatedConstants.kLightBlueColour
        self.ViewModel = HomeworkViewModel.init(delegate: self)
        self.title = KStoryBoards.KAddSubjectIdentifiers.kSubjectListTitle
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if checkInternetConnection() {
            self.ViewModel?.subjectList(studentId : UserDefaultExtensionModel.shared.userRoleParticularId)
        }else {
            self.showAlert(Message: Alerts.kNoInternetConnection)
        }
    }

}


extension SubjectListHW : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSubjectlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
     let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SubjectListCell
        cell.lblTitle.text = arrSubjectlist[indexPath.row].SubjectName
        let str = cell.lblTitle.text
        cell.lblImage.addInitials(first: str?.first?.description ?? "", second: "")

        return cell
        
    }
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if arrSubjectlist.count > 0 {
                   let assignedData = arrSubjectlist[indexPath.row].lstASTopic
                   let vc = UIStoryboard.init(name:"Homework", bundle: Bundle.main).instantiateViewController(withIdentifier: "StudentHomeWorkListVC") as! StudentHomeWorkListVC
                   vc.homeWorkList = assignedData
                   self.navigationController?.pushViewController(vc, animated: true)
                   
               }

    }
    
}

extension SubjectListHW : AddHomeWorkDelegate {
    func studentHomeworkDetail(data: [HomeworkListStudentData]) {
        
    }
    

    func subjectList(data: [HomeworkResultHWData]) {
                arrSubjectlist = data
        
        if arrSubjectlist.count > 0 {
                    LblNoDataFound.isHidden = true
                }
                else {
                    LblNoDataFound.isHidden = false
                }
                table_View.reloadData()
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
        

    }
    
    func AddHomeworkFailour(msg: String) {
         self.showAlert(Message: msg)
    }
}

