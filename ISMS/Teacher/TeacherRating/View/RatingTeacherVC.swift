//
//  RatingToTeacherVC.swift
//  ISMS
//
//  Created by Poonam Sharma on 13/4/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import UIKit

class RatingTeacherVC: BaseUIViewController {

    
//    Outlets
    @IBOutlet weak var txtFieldSubject: UITextField!
    @IBOutlet weak var txtFieldTeacher: UITextField!
    @IBOutlet weak var imgCheck: UIImageView!
    @IBOutlet weak var lblFeedback: UILabel!
    @IBOutlet weak var txtViewFeedback: UITextView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var arrTeacherList = [TeacherRatingList]()
    var arrSubjectList = [SubjectListResult]()
      var viewModel : TeacherRatingAddViewModel?
    var  isTeacherSelected = false
    var isSubjectSelected = false
    var selectedTeacherId : Int?
    var selectedSubjectId : Int?
    var selectedTeacherArrIndex : Int?
    var check = false
      let studentClassId = UserDefaultExtensionModel.shared.StudentClassId
     let userRoleParticularId = UserDefaultExtensionModel.shared.userRoleParticularId
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = TeacherRatingAddViewModel.init(delegate : self)
        self.viewModel?.attachView(viewDelegate: self as! ViewDelegate)
        setUI()
        self.viewModel?.TeacherList(studentID : userRoleParticularId)
        
        // Do any additional setup after loading the view.
    }
    
    
//   Button Action
    @IBAction func btnDropDownTeacher(_ sender: Any) {
        isTeacherSelected = true
        isSubjectSelected = false
        
        if checkInternetConnection(){
            if arrTeacherList.count > 0{
                UpdatePickerModel2(count: arrTeacherList.count, sharedPickerDelegate: self, View:  self.view, index: 0)
                
                selectedTeacherId = arrTeacherList[0].teacherId
                let text = txtFieldTeacher.text!
                if let index = arrTeacherList.index(where: { (dict) -> Bool in
                    return dict.teacherName ?? "" == text // Will found index of matched id
                })
                {
                    print("Index found :\(index)")
                    UpdatePickerModel2(count: arrTeacherList.count, sharedPickerDelegate: self, View:  self.view, index: index)
                }
            }
        }else{
            self.showAlert(Message: Alerts.kNoInternetConnection)
        }
    }
    
    
    @IBAction func btnDropDownSubject(_ sender: Any) {
        isTeacherSelected = false
        isSubjectSelected = true
        
        if checkInternetConnection(){
            if arrSubjectList.count > 0{
                UpdatePickerModel2(count: arrSubjectList.count, sharedPickerDelegate: self, View:  self.view, index: 0)
                
                selectedSubjectId = arrSubjectList[0].id
                let text = txtFieldSubject.text!
                if let index = arrSubjectList.index(where: { (dict) -> Bool in
                    return dict.name ?? "" == text // Will found index of matched id
                })
                {
                    print("Index found :\(index)")
                    UpdatePickerModel2(count: arrSubjectList.count, sharedPickerDelegate: self, View:  self.view, index: index)
                }
            }
        }else{
            self.showAlert(Message: Alerts.kNoInternetConnection)
        }
        
    }
    
    @IBAction func btnSubmit(_ sender: Any) {
        self.viewModel?.submit(teacherId : RegisterClassDataModel.sharedInstance?.enrolmentID ?? 0, StudentId: userRoleParticularId, classSubjectId: RegisterClassDataModel.sharedInstance?.tagID ?? 0 ,feedback: self.txtViewFeedback.text,anonymous: check)
    }
    
    @IBAction func btnImgCheck(_ sender: Any) {
        if check == true{
            check = false
          self.imgCheck.image = UIImage(named: "uncheck")
        }else{
            check = true
            self.imgCheck.image = UIImage(named: "check")
        }
    }
}

//MARK:- PICKER DELEGATE FUNCTIONS
extension RatingTeacherVC : SharedUIPickerDelegate{
    func DoneBtnClicked() {
        if checkInternetConnection(){
            // arrAllAssignedSubjects.removeAll()
            if isTeacherSelected == true {
                if let index = selectedTeacherArrIndex {
                    if let teacherId = arrTeacherList[index].teacherId {
                        if let classId = arrTeacherList[index].classId{
                               self.viewModel?.GetSubjectList(teacherId: teacherId,classId: classId)
                        }
                    }
                }else{
                    selectedTeacherArrIndex = 0
                    if let teacherId = arrTeacherList[0].teacherId {
                        if let classId = arrTeacherList[0].classId{
                            self.viewModel?.GetSubjectList(teacherId: teacherId,classId: classId)
                        }
                    }
                }
            }
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
    }
    
    func GetTitleForRow(index: Int) -> String {
        
        if isTeacherSelected == true {
            if arrTeacherList.count > 0{
                txtFieldTeacher.text = arrTeacherList[0].teacherName
                return arrTeacherList[index].teacherName ?? ""
            }
        }
        else if isSubjectSelected == true {
            if arrSubjectList.count > 0 {
                txtFieldSubject.text = arrSubjectList[0].name
                return arrSubjectList[index].name ?? ""
            }
        }
        return ""
    }
    
    func SelectedRow(index: Int) {
        
        if isTeacherSelected == true {
            if arrTeacherList.count > 0{
                selectedTeacherId = arrTeacherList[index].teacherId
                txtFieldTeacher.text = arrTeacherList[index].teacherName
                selectedTeacherArrIndex = index
                  RegisterClassDataModel.sharedInstance?.enrolmentID = arrTeacherList[index].teacherId
                 RegisterClassDataModel.sharedInstance?.subjectID = arrTeacherList[index].studentId
            }
        }
        else if isSubjectSelected == true {
            if arrSubjectList.count > 0 {
                selectedSubjectId = arrSubjectList[index].id
                txtFieldSubject.text = arrSubjectList[index].name
                RegisterClassDataModel.sharedInstance?.subjectID = arrSubjectList[index].id
                RegisterClassDataModel.sharedInstance?.tagID = arrSubjectList[index].classSubjectId
            }
        }
    }
}

extension RatingTeacherVC : TeacherRatingAddDelegate{
    func GetSubjectListDidSucceed(data: [SubjectListResult]?) {
        if let data1 = data {
            arrSubjectList.removeAll()
            if data1.count>0
            {
                self.arrSubjectList = data1
                if let subjectId = arrSubjectList[0].id{
                    txtFieldSubject.text = arrSubjectList[0].name
                    
                    RegisterClassDataModel.sharedInstance?.tagID = arrSubjectList[0].classSubjectId
                }
            }
        }
    }
    
    func GetTeacherListDidSucceed(data: [TeacherRatingList]?) {
        if let data1 = data {
            if data1.count>0
            {
                self.arrTeacherList = data1
                if let teacherId = arrTeacherList[0].teacherId{
                    if let classId = arrTeacherList[0].classId{
                      RegisterClassDataModel.sharedInstance?.enrolmentID = arrTeacherList[0].teacherId
                        RegisterClassDataModel.sharedInstance?.subjectID = arrTeacherList[0].studentId
//                        txtFieldTeacher.text = arrTeacherList[0].teacherName
//                        self.viewModel?.GetSubjectList(teacherId: teacherId,classId: classId)
                        }
                    }
                }
            }
    }
}

//MARK:- View Delegate
extension RatingTeacherVC : ViewDelegate{
   
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
    func setUI(){
        
//        self.setSearchBarInNavigationController(placeholderText: KSearchBarPlaceHolder.kUserSearchBarPlaceHolder, navigationTitle: KStoryBoards.KClassListIdentifiers.kClassListTitle, navigationController: self.navigationController, navigationSearchBarDelegates: self)
        
        //Set Back Button
        self.setBackButton()
        
        //Set picker view
        self.SetpickerView(self.view)
        
        // cornerButton(btn: btnSubmit, radius: 8)
        
        //Title
        self.title = "Teacher Rating"
        txtFieldSubject.txtfieldPadding(leftpadding: 10, rightPadding: 0)
        txtFieldTeacher.txtfieldPadding(leftpadding: 10, rightPadding: 0)
    }
}
extension RatingTeacherVC : OKAlertViewDelegate{
    
    //Ok Button Clicked
    func okBtnAction() {
        okAlertView.removeFromSuperview()
         navigationController?.popViewController(animated: false)
    }
}


extension RatingTeacherVC:UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n"
        {
            textView.resignFirstResponder()
        }
        return true
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        lblFeedback.isHidden = true
        self.animateTextView(textView: textView, up: true, movementDistance: 100, scrollView:self.scrollView)
        
        
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        let str = textView.text.trimmingCharacters(in: .whitespaces)
        
        if str == ""
        {
            self.txtViewFeedback.text = ""
            lblFeedback.isHidden = false
            
        }
        else{
            txtViewFeedback.text = textView.text
        }
        
        DispatchQueue.main.async {
            
            self.animateTextView(textView: textView, up: false, movementDistance: 250, scrollView:self.scrollView)
        }
        
    }
    
}
