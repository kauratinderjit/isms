////
////  SubjectSkillRatingViewModel.swift
////  ISMS
////
////  Created by Kuldeep Singh on 12/5/19.
////  Copyright © 2019 Atinder Kaur. All rights reserved.
////
//
import Foundation



protocol SubjectSkillRatingDelegate : class {
    func SubjectSkillRatingDidSucceed(data : [SubjectSkillRatingResultData])
    func SubjectSkillRatingDidFailour()
    func GetSkillListDidSucceed(data: [AddStudentRatingResultData])
    
}

class SubjectSkillRatingViewModel {
    
    var isSearching : Bool?
    private weak var subjectSkillRatingView : ViewDelegate?
    private  weak var subjectSkillRatingDelegate: SubjectSkillRatingDelegate?
    
    
    init(delegate : SubjectSkillRatingDelegate) {
        self.subjectSkillRatingDelegate = delegate
    }
    
    func attachView(viewDelegate : ViewDelegate){
        subjectSkillRatingView = viewDelegate
    }

    //MARK:- SUBJECT LIST
    func getSubjectWiseRating(enrollmentsId : Int?,classSubjectId: Int?){
        self.subjectSkillRatingView?.showLoader()
        
        let paramDict = [ "EnrollmentId": enrollmentsId!,
                          "ClassSubjectId": classSubjectId
            ] as [String : Any]
        
        SubjectSkillRatingApi.sharedInstance.SubmitApiList(url: ApiEndpoints.kGetSubjectSkillRating, parameters: paramDict, completionResponse: { (SubjectListModel) in
            
            if SubjectListModel.statusCode == KStatusCode.kStatusCode200{
                self.subjectSkillRatingView?.hideLoader()
                self.subjectSkillRatingDelegate?.SubjectSkillRatingDidSucceed(data: SubjectListModel.resultData!)
            }else if SubjectListModel.statusCode == KStatusCode.kStatusCode401{
                self.subjectSkillRatingView?.hideLoader()
                self.subjectSkillRatingView?.showAlert(alert: SubjectListModel.message ?? "")
                //  self.SubjectListDelegate?.unauthorizedUser()
            }else{
                self.subjectSkillRatingView?.hideLoader()
                CommonFunctions.sharedmanagerCommon.println(object: "student APi status change")
            }
            
        }, completionnilResponse: { (nilResponseError) in
            
            self.subjectSkillRatingView?.hideLoader()
            //   self.SubjectListDelegate?.SubjectListDidFailed()
            
            if let error = nilResponseError{
                self.subjectSkillRatingView?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "student APi Nil response")
            }
            
        }) { (error) in
            self.subjectSkillRatingView?.hideLoader()
         
        }
        
    }
    
    
    //MARK:- SUBJECT LIST
    func GetSkillList(id : Int , enumType : Int , type : String) {
        self.subjectSkillRatingView?.showLoader()
        
        let paramDict = [ AddStudentRating.kId:id,
                          AddStudentRating.kEnumType: enumType] as [String : Any]
        let url = ApiEndpoints.kSkillList + "?id=" + "\(id)" + "&enumType=" + "\(enumType)"
        AddStudentRatingApi.sharedInstance.GetSkillList(url: url , parameters: paramDict as [String : Any], completionResponse: { (AddStudentRatingListModel) in
            
            if AddStudentRatingListModel.statusCode == KStatusCode.kStatusCode200 {
                self.subjectSkillRatingView?.hideLoader()
                
                self.subjectSkillRatingDelegate?.GetSkillListDidSucceed(data: AddStudentRatingListModel.resultData!)
          
                
            }else if AddStudentRatingListModel.statusCode == KStatusCode.kStatusCode401 {
                self.subjectSkillRatingView?.hideLoader()
                self.subjectSkillRatingView?.showAlert(alert: AddStudentRatingListModel.message ?? "")
                //  self.SubjectListDelegate?.unauthorizedUser()
            }else{
                self.subjectSkillRatingView?.hideLoader()
                CommonFunctions.sharedmanagerCommon.println(object: "student APi status change")
            }
            
        }, completionnilResponse: { (nilResponseError) in
            
            self.subjectSkillRatingView?.hideLoader()
            //   self.SubjectListDelegate?.SubjectListDidFailed()
            
            if let error = nilResponseError{
                self.subjectSkillRatingView?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "student APi Nil response")
            }
            
        }) { (error) in
            self.subjectSkillRatingView?.hideLoader()
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
        
        
        if let skillName = arrSkillList[indexPath.row].Name {
           // cell.lblSubjectName.text = subjectName
            cell.lblSkillName.text = skillName
           
        }
        if let rating = arrSkillList[indexPath.row].rating {
            cell.lblRating.text = rating
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
