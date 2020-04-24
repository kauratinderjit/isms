//
//  ViewTeacherRatingVC.swift
//  ISMS
//
//  Created by Poonam Sharma on 14/4/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import UIKit

class ViewTeacherRatingVC: BaseUIViewController {

    @IBOutlet weak var txtFieldTeacher: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
      var ViewModel : ViewTeacherRatingViewModel?
    var arrTeacher = [ViewTeacherRatingResult]()
    var arrGetTeacherRating = [GetViewTeacherRatingResult]()
    var idHOD = UserDefaultExtensionModel.shared.userRoleParticularId
    
    var isSelectedTeacher = false
    var selectedTeacherIndex : Int?
    var selectedId : Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.setUI()
            self.ViewModel?.TeacherList(HodId: self.idHOD,enumType: 18)
            
        }
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        tableView.separatorColor = KAPPContentRelatedConstants.kLightBlueColour
        // Do any additional setup after loading the view.
    }
    
    func setUI(){
        setBackButton()
        self.ViewModel = ViewTeacherRatingViewModel.init(delegate: self)
        self.ViewModel?.attachView(viewDelegate: self)
        //Title
        self.title = "View Teacher Feedback"
        txtFieldTeacher.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        //Table View Settings
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        SetpickerView(self.view)
        
    }

    @IBAction func btnDropDownTeacher(_ sender: Any) {
        isSelectedTeacher = true
      
        
        if checkInternetConnection(){
            if arrTeacher.count > 0{
                UpdatePickerModel2(count: arrTeacher.count, sharedPickerDelegate: self, View:  self.view, index: 0)
                
                selectedId = arrTeacher[0].teacherId
                let text = txtFieldTeacher.text!
                if let index = arrTeacher.index(where: { (dict) -> Bool in
                    return dict.teacherName ?? "" == text // Will found index of matched id
                })
                {
                    print("Index found :\(index)")
                    UpdatePickerModel2(count: arrTeacher.count, sharedPickerDelegate: self, View:  self.view, index: index)
                }
                
                
            }
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
        
    }
}
extension ViewTeacherRatingVC : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 70;
//    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
//        return UITableView.automaticDimension;//Choose your custom row height
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 150;//Choose your custom row height
    }
    
}
extension ViewTeacherRatingVC : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrGetTeacherRating.count > 0{
            tableView.separatorStyle = .singleLine
            return (arrGetTeacherRating.count)
        }else{
            tblViewCenterLabel(tblView: tableView, lblText: KConstants.kNoDataFound, hide: false)
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
        let cell = tableView.dequeueReusableCell(withIdentifier: "RatingCell", for: indexPath) as! ViewRatingCell
//
        cell.setCellUI(data: arrGetTeacherRating, indexPath: indexPath)
        return cell
    }
}

extension ViewTeacherRatingVC : SharedUIPickerDelegate{
   
    func DoneBtnClicked() {
        if checkInternetConnection(){
            //            arrAllAssignedSubjects.removeAll()
            if isSelectedTeacher == true {
                if let index = selectedTeacherIndex {
                    if let id = arrTeacher[index].teacherId {
                        self.txtFieldTeacher.text = arrTeacher[index].teacherName
                        self.ViewModel?.GetTeacherRating(teacherId: id)
                    }
                }
            }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
        }
    }
    
    func GetTitleForRow(index: Int) -> String {
        if isSelectedTeacher == true {
            if arrTeacher.count > 0{
                txtFieldTeacher.text = arrTeacher[0].teacherName
                return arrTeacher[index].teacherName ?? ""
            }
        }
        return ""
    }
    
    func SelectedRow(index: Int) {
        
        if isSelectedTeacher == true {
            if arrTeacher.count > 0{
                txtFieldTeacher.text = arrTeacher[index].teacherName
                selectedTeacherIndex = index
                }
            }
        
        }
}
extension ViewTeacherRatingVC : ViewTeacherRatingDelegate{
    func GetTeacherRatingDidSuccess(data: [GetViewTeacherRatingResult]?) {
        
        if let data1 = data {
            if data1.count>0
            {
                self.arrGetTeacherRating = data1
                if let teacherId = arrGetTeacherRating[0].teacherId{
//                    self.txtFieldTeacher.text = arrTeacher[0].teacherName
//                    self.ViewModel?.GetTeacherRating(teacherId: teacherId)
                    
                }
            }
        }
        
        tableView.reloadData()
    }
    
    func TeacherListDidSuccess(data: [ViewTeacherRatingResult]?) {
        if let data1 = data {
            if data1.count>0
            {
                self.arrTeacher = data1
                if let teacherId = arrTeacher[0].teacherId{
                  self.txtFieldTeacher.text = arrTeacher[0].teacherName
                    self.ViewModel?.GetTeacherRating(teacherId: teacherId)
                    
                }
            }
        }
    }
}
extension ViewTeacherRatingVC : ViewDelegate{
    func showAlert(alert: String){
        initializeCustomOkAlert(self.view, isHideBlurView: true)
        okAlertView.delegate = self
        okAlertView.lblResponseDetailMessage.text = alert
        
    }
    
    func showLoader() {
        ShowLoader()
    }
    
    func hideLoader() {
        HideLoader()
    }
    
}
extension ViewTeacherRatingVC : OKAlertViewDelegate{
    
    //Ok Button Clicked
    func okBtnAction() {
//        if isUnauthorizedUser == true{
//            isUnauthorizedUser = false
//            CommonFunctions.sharedmanagerCommon.setRootLogin()
//        }else if isStudentDelete == true{
//            isStudentDelete = false
//            if let selectedIndex = self.selectedStudentArrIndex{
//                self.arrStudentlist.remove(at: selectedIndex)
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//            }
//
//        }
        okAlertView.removeFromSuperview()
    }
}
