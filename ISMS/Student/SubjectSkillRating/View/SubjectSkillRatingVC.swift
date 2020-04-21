//
//  SubjectSkillRatingVC.swift
//  ISMS
//
//  Created by Kuldeep Singh on 12/5/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class SubjectSkillRatingVC: BaseUIViewController {

    var viewModel : SubjectSkillRatingViewModel?
    var arrSkillList = [SubjectSkillRatingResultData]()
    var arrSubjectlist = [AddStudentRatingResultData]()
    var isSubjectSelected = false
    var selectedSubjectId : Int?
    var indexCount : Int?
    var subjectName : String?
    @IBOutlet var textfieldSubject: UITextField!
    @IBOutlet var tableView: UITableView!
    var classId : Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = SubjectSkillRatingViewModel.init(delegate: self)
        self.viewModel?.attachView(viewDelegate: self)
        // Do any additional setup after loading the view.
        self.setUI()
          self.textfieldSubject.text = subjectName
       self.viewModel?.GetSkillList(id: 33, enumType: 10, type: "Skill")
           self.viewModel?.getSubjectWiseRating(enrollmentsId: 14, classSubjectId: 6)
        if let classSubectID = classId {
        self.viewModel?.getSubjectWiseRating(enrollmentsId: 7, classSubjectId: 1)
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
    
extension SubjectSkillRatingVC : UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 105
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //    return arrSkillList.count
        return arrSkillList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SubjectWiseRating.kSubjectSkillRatingCell, for: indexPath) as! SubjectSkillRatingTableViewCell
        
        print("our skill new array : ",arrSkillList[indexPath.row].rating)
        if let skillName = arrSkillList[indexPath.row].Name {
            // cell.lblSubjectName.text = subjectName
            cell.lblSkillName.text = skillName
            
        }
        if let rating = arrSkillList[indexPath.row].rating{
            cell.lblRating.text = "\(rating)"
        }
        //        cell.lblPercentage.text = "97 %"
        return cell
    }
    
}
extension SubjectSkillRatingVC : SubjectSkillRatingDelegate {
    func GetSkillListDidSucceed(data: [AddStudentRatingResultData]) {
        //   isFetching = true
        if data != nil{
            if data.count ?? 0 > 0{
                for value in data{
                    let containsSameValue = arrSubjectlist.contains(where: {$0.studentID == value.studentID})
                    if containsSameValue == false{
                        arrSubjectlist.append(value)
                        if let studentName = arrSubjectlist[0].studentName {
                            textfieldSubject.text = studentName
                        }
                    }
                }
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Zero")
            }
        }else{
            CommonFunctions.sharedmanagerCommon.println(object: "Nil")
        }
    }
    
    
    func SubjectSkillRatingDidSucceed(data: [SubjectSkillRatingResultData]) {
        arrSkillList = data
        tableView.reloadData()
    }
    
    func SubjectSkillRatingDidFailour() {
        
    }
    
    
}

extension SubjectSkillRatingVC : ViewDelegate {
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
    //MARK:- SET UI
    func setUI(){
        //Set Back Button
        self.setBackButton()
        //Set picker view
        self.SetpickerView(self.view)
        // cornerButton(btn: btnSubmit, radius: 8)
        //Title
        self.title = SubjectSkillRating.kSubjectSkillRatingVC
        self.tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        self.viewModel?.isSearching = false
    }
}

extension SubjectSkillRatingVC : OKAlertViewDelegate{
    
    //Ok Button Clicked
    func okBtnAction() {
        okAlertView.removeFromSuperview()
    }
    
    
}



//MARK:- PICKER DELEGATE FUNCTIONS
extension SubjectSkillRatingVC : SharedUIPickerDelegate{
    func DoneBtnClicked() {
        if checkInternetConnection(){
            
            if let subjectID = arrSubjectlist[indexCount!].studentID {
                self.viewModel?.getSubjectWiseRating(enrollmentsId: 6, classSubjectId:subjectID)
            }
            //            arrAllAssignedSubjects.removeAll()
            //            if isClassSelected == true {
            //                if let index = selectedClassArrIndex {
            //                    if let id = arrClassList[index].classId {
            //                        selectedClassId = id
            //                        self.viewModel?.GetSubjectList(id: id, enumType: 10, type: "SubjectList")
            //                    }
            //                }
            //            }
            //            else if isSelectedRating == true {
            //                if let count1 = countSelected {
            //                    if let tag = clickedCount {
            //                        arrSkillList[tag].isSelected = 1
            //                        arrSkillList[tag].ratingValue = count1 + 1
            //                        let studentSkillId = arrSkillList[tag].studentID
            //                        let rating = count1 + 1
            //                        var dict = [String:Any]()
            //                        dict["TeacherSkillId"] = studentSkillId
            //                        dict["Rating"] = rating
            //                        arrSelect.append(dict)
            //                    }
            //            tableView.reloadData()
            //        }
            //    }else{
            //    self.showAlert(alert: Alerts.kNoInternetConnection)
            //
        }
    }
    func GetTitleForRow(index: Int) -> String {
        if isSubjectSelected == true {
            if arrSubjectlist.count > 0 {
                textfieldSubject.text = arrSubjectlist[0].studentName
                return arrSubjectlist[index].studentName ?? ""
            }
        }
        
        return ""
    }
    
    func SelectedRow(index: Int) {
        
        if isSubjectSelected == true {
            if arrSubjectlist.count > 0 {
                selectedSubjectId = arrSubjectlist[index].studentID
                textfieldSubject.text = arrSubjectlist[index].studentName
                indexCount = index
            }
            
        }
        
    }
}

