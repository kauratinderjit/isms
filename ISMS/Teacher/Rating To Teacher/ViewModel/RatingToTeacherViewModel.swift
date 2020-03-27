//
//  RatingToTeacherViewModel.swift
//  ISMS
//
//  Created by Kuldeep Singh on 12/2/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation


protocol RatingToTeacherDelegate : class {
    func StudentRatingDidSucceed()
    func StudentRatingDidFailour()
    func classListDidSuccess(data : [GetClassListResultData]?)
    func SubjectListDidSuccess(data: [AddStudentRatingResultData]?)
    func GetSkillListDidSucceed(data : [AddStudentRatingResultData]?)
//    func studentListDidSucceed(data : [AddStudentRatingResultData]?)
    func AddStudentRatingDidSucceed(data: String)
    //func StudentRatingListDidSucceed(data : [AddStudentRatingResultData])
    func TeacherListDidSucceed(data : [TeacherResultData])
}

class RatingToTeacherViewModel {
    var isSearching : Bool?
    private weak var ratingToTeacherView : ViewDelegate?
    private  weak var ratingToTeacherDelegate: RatingToTeacherDelegate?
    
    
    init(delegate : RatingToTeacherDelegate) {
        ratingToTeacherDelegate = delegate
    }
    
    func attachView(viewDelegate : ViewDelegate){
        ratingToTeacherView = viewDelegate
    }
    
    //MARK:- Class list
    func classList(searchText: String,pageSize : Int,filterBy: Int,skip: Int){
        
        if self.isSearching == false {
            self.ratingToTeacherView?.showLoader()
        }
        
        var postDict = [String:Any]()
        
        postDict[KApiParameters.KCommonParametersForList.kSearch] = searchText
        postDict[KApiParameters.KCommonParametersForList.kPageSize] = pageSize
        postDict[KApiParameters.KCommonParametersForList.kSortColumn] = ""
        postDict[KApiParameters.KCommonParametersForList.kSkip] = skip
        postDict[KApiParameters.KCommonParametersForList.kSortColumnDir] = ""
   ClassApi.sharedManager.getClassList(url: ApiEndpoints.kGetClassList, parameters: postDict, completionResponse: { (classModel) in
            
            self.ratingToTeacherView?.hideLoader()
            
            switch classModel.statusCode{
            case KStatusCode.kStatusCode200:
                self.ratingToTeacherDelegate?.classListDidSuccess(data: classModel.resultData)
            case KStatusCode.kStatusCode401:
                if let msg = classModel.message{
                    self.ratingToTeacherView?.showAlert(alert: msg)
                }
               default:
                if let msg = classModel.message{
                    self.ratingToTeacherView?.showAlert(alert: msg)
                }
            }
        }, completionnilResponse: { (nilResponseError) in
            
            self.ratingToTeacherView?.hideLoader()
            self.ratingToTeacherDelegate?.StudentRatingDidFailour()
            
            if let error = nilResponseError{
                self.ratingToTeacherView?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Class APi Nil response")
            }
            
        }) { (error) in
            self.ratingToTeacherView?.hideLoader()
            //  self.studentRatingDelegate?.StudentRatingDidFailour()
            if let err = error?.localizedDescription{
                self.ratingToTeacherView?.showAlert(alert: err)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Class APi error response")
            }
        }
    }
    
    //MARK:- SUBJECT LIST
    func TeacherList(search : String?,skip : Int?,pageSize: Int?,sortColumnDir: String?,sortColumn: String?, classSubjectID : Int , classID : Int){
        self.ratingToTeacherView?.showLoader()
        
        let paramDict = [ "Search": "",
                          "Skip": 0,
                          "PageSize": 0,
                          "SortColumnDir": "",
                          "SortColumn": "",
                          "ParticularId": 0] as [String : Any]
        
        RatingToTeacherApi.sharedInstance.GetTeacherList(url: ApiEndpoints.kTeacherListApi, parameters: paramDict as [String : Any], completionResponse: { (TeacherListModel) in
        
            if TeacherListModel.statusCode == KStatusCode.kStatusCode200{
                self.ratingToTeacherView?.hideLoader()
            //    self.ratingToTeacherDelegate?.StudentRatingListDidSucceed(data : StudentRatingListModel.resultData!)
                 self.ratingToTeacherDelegate?.TeacherListDidSucceed(data : TeacherListModel.resultData!)
                
            }else if TeacherListModel.statusCode == KStatusCode.kStatusCode401{
                self.ratingToTeacherView?.hideLoader()
                self.ratingToTeacherView?.showAlert(alert: TeacherListModel.message ?? "")
                //  self.SubjectListDelegate?.unauthorizedUser()
            }else{
                self.ratingToTeacherView?.hideLoader()
                CommonFunctions.sharedmanagerCommon.println(object: "student APi status change")
            }
            
        }, completionnilResponse: { (nilResponseError) in
            
            self.ratingToTeacherView?.hideLoader()
            //   self.SubjectListDelegate?.SubjectListDidFailed()
            
            if let error = nilResponseError{
                self.ratingToTeacherView?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "student APi Nil response")
            }
            
        }) { (error) in
            self.ratingToTeacherView?.hideLoader()
    
        }
        
    }
  //MARK:- SUBJECT LIST
    func GetSubjectList(id : Int , enumType : Int , type : String) {
        self.ratingToTeacherView?.showLoader()
        
        let paramDict = [ AddStudentRating.kId:id,
                          AddStudentRating.kEnumType: enumType] as [String : Any]
        let url = ApiEndpoints.kSkillList + "?id=" + "\(id)" + "&enumType=" + "\(enumType)"
        AddStudentRatingApi.sharedInstance.GetSkillList(url: url , parameters: paramDict as [String : Any], completionResponse: { (AddStudentRatingListModel) in
            
            if AddStudentRatingListModel.statusCode == KStatusCode.kStatusCode200 {
                self.ratingToTeacherView?.hideLoader()
                if type == "SubjectList" {
                    
                    self.ratingToTeacherDelegate?.SubjectListDidSuccess(data: AddStudentRatingListModel.resultData)
                }
                
            }else if AddStudentRatingListModel.statusCode == KStatusCode.kStatusCode401 {
                self.ratingToTeacherView?.hideLoader()
                self.ratingToTeacherView?.showAlert(alert: AddStudentRatingListModel.message ?? "")
                //  self.SubjectListDelegate?.unauthorizedUser()
            }else{
                self.ratingToTeacherView?.hideLoader()
                CommonFunctions.sharedmanagerCommon.println(object: "student APi status change")
            }
            
        }, completionnilResponse: { (nilResponseError) in
            
            self.ratingToTeacherView?.hideLoader()
            //   self.SubjectListDelegate?.SubjectListDidFailed()
            
            if let error = nilResponseError{
                self.ratingToTeacherView?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "student APi Nil response")
            }
            
        }) { (error) in
            self.ratingToTeacherView?.hideLoader()
            //   self.SubjectListDelegate?.SubjectListDidFailed()
            //            if let err = error?.localizedDescription{
            //                self.studentRatingView?.showAlert(alert: err)
            //            }else{
            //                CommonFunctions.sharedmanagerCommon.println(object: "student APi error response")
            //            }
        }
        
    }

    
    //MARK:- SUBJECT LIST
    func GetSkillList(id : Int , enumType : Int , type : String) {
        self.ratingToTeacherView?.showLoader()
        
        let paramDict = [ AddStudentRating.kId:id,
                          AddStudentRating.kEnumType: enumType] as [String : Any]
        let url = ApiEndpoints.kSkillList + "?id=" + "\(id)" + "&enumType=" + "\(enumType)"
        AddStudentRatingApi.sharedInstance.GetSkillList(url: url , parameters: paramDict as [String : Any], completionResponse: { (AddStudentRatingListModel) in
            
            if AddStudentRatingListModel.statusCode == KStatusCode.kStatusCode200 {
                self.ratingToTeacherView?.hideLoader()
                if type == "Skill" {
                    self.ratingToTeacherDelegate?.GetSkillListDidSucceed(data:AddStudentRatingListModel.resultData!)
                }
                
            }else if AddStudentRatingListModel.statusCode == KStatusCode.kStatusCode401 {
                self.ratingToTeacherView?.hideLoader()
                self.ratingToTeacherView?.showAlert(alert: AddStudentRatingListModel.message ?? "")
                //  self.SubjectListDelegate?.unauthorizedUser()
            }else{
                self.ratingToTeacherView?.hideLoader()
                CommonFunctions.sharedmanagerCommon.println(object: "student APi status change")
            }
            
        }, completionnilResponse: { (nilResponseError) in
            
            self.ratingToTeacherView?.hideLoader()
            //   self.SubjectListDelegate?.SubjectListDidFailed()
            
            if let error = nilResponseError{
                self.ratingToTeacherView?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "student APi Nil response")
            }
            
        }) { (error) in
            self.ratingToTeacherView?.hideLoader()
        }
    }
    
    //MARK:- SUBJECT LIST
    func SubmitTotalRating(teacherID: Int?, enrollmentsId : Int?,classSubjectId: Int?,comment: String?,StudentSkillRatings: [[String : Any]]){
        self.ratingToTeacherView?.showLoader()
   
        let param = ["TeacherRatingId": 0,
                     "TeacherId": teacherID!,
                     "StudentId": 32,
                     "ClassSubjectId": classSubjectId!,
                     "Comment": "string",
                     "TeacherSkillRating": StudentSkillRatings] as [String : Any]
       AddStudentRatingApi.sharedInstance.SubmitApiList(url: ApiEndpoints.kAddTeacherRating, parameters: param, completionResponse: { (SubjectListModel) in
            
            if SubjectListModel.statusCode == KStatusCode.kStatusCode200{
                self.ratingToTeacherView?.hideLoader()
                self.ratingToTeacherDelegate?.AddStudentRatingDidSucceed(data : "Teacher Rating Added Successfully")
            }else if SubjectListModel.statusCode == KStatusCode.kStatusCode401{
                self.ratingToTeacherView?.hideLoader()
                self.ratingToTeacherView?.showAlert(alert: SubjectListModel.message ?? "")
                //  self.SubjectListDelegate?.unauthorizedUser()
            }else{
                self.ratingToTeacherView?.hideLoader()
                CommonFunctions.sharedmanagerCommon.println(object: "student APi status change")
            }
            
        }, completionnilResponse: { (nilResponseError) in
            
            self.ratingToTeacherView?.hideLoader()
            //   self.SubjectListDelegate?.SubjectListDidFailed()
            
            if let error = nilResponseError{
                self.ratingToTeacherView?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "student APi Nil response")
            }
            
        }) { (error) in
            self.ratingToTeacherView?.hideLoader()
          
        }
        
    }
    
    
}

//MARK:- ADD STUDENT RATING DELEGATE
extension RatingToTeacherVC : RatingToTeacherDelegate {
  func TeacherListDidSucceed(data: [TeacherResultData]) {
        isFetching = true
        if data != nil{
            if data.count ?? 0 > 0{
                for value in data{
                    
                    let containsSameValue = arrTeacherlist.contains(where: {$0.teacherID == value.teacherID})
                    
                    if containsSameValue == false{
                        arrTeacherlist.append(value)
                        if let teacherName = arrTeacherlist[0].teacherFirstName {
                           
                            txtfieldStudent.text = teacherName
                        }
                        if let id = arrTeacherlist[0].teacherID {
                             selectTeacherId  = id
                        }
                    }
                  }
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Zero")
            }
        }else{
            CommonFunctions.sharedmanagerCommon.println(object: "Nil")
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
   

    func AddStudentRatingDidSucceed(data: String) {
        self.showAlert(alert: data)
    }

    func GetSkillListDidSucceed(data: [AddStudentRatingResultData]?) {
        
        if let data1 = data {
            self.arrSkillList = data1
            
            tableView.reloadData()
        }
    }
    
    func classListDidSuccess(data: [GetClassListResultData]?) {
        self.isFetching = true
        if data != nil{
            if data?.count ?? 0 > 0 {
                for value in data! {
                    let containsSameValue = arrClassList.contains(where: {$0.classId == value.classId})
                    if containsSameValue == false{
                        arrClassList.append(value)
                        if let className = arrClassList[0].name{
                            txtfieldClass.text = className
                        }
                    }
        
                }
                if let id = arrClassList[0].classId {
                    selectedClassId = id
                    self.viewModel?.GetSubjectList(id: id, enumType: 10, type: "SubjectList")
                     }
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Zero")
            }
        }else{
            CommonFunctions.sharedmanagerCommon.println(object: "Nil")
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func SubjectListDidSuccess(data: [AddStudentRatingResultData]?) {
        isFetching = true
        if data != nil{
            if data?.count ?? 0 > 0{
                for value in data!{
                    
                    let containsSameValue = arrSubjectlist.contains(where: {$0.studentID == value.studentID})
                    
                    if containsSameValue == false{
                        arrSubjectlist.append(value)
                        if let studentName = arrSubjectlist[0].studentName {
                            txtfieldSubject.text = studentName
                        }
                    }
                          }
                if let classId = selectedClassId {
                self.viewModel?.TeacherList(search: "", skip: 0, pageSize: 0, sortColumnDir: "", sortColumn: "", classSubjectID: 0, classID: 0)
                }
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Zero")
            }
        }else{
            CommonFunctions.sharedmanagerCommon.println(object: "Nil")
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    func StudentRatingDidSucceed() {
        
    }
    
    func StudentRatingDidFailour() {
        
    }
    
    
    
    
}
//MARK:- PICKER DELEGATE FUNCTIONS
extension RatingToTeacherVC : SharedUIPickerDelegate{
    func DoneBtnClicked() {
        if checkInternetConnection(){
            //            arrAllAssignedSubjects.removeAll()
            if isClassSelected == true {
                if let index = selectedClassArrIndex {
                    if let id = arrClassList[index].classId {
                        selectedClassId = id
                         self.viewModel?.GetSubjectList(id: id, enumType: 10, type: "SubjectList")
                          }
                }
            }
            else if isSelectedRating == true {
                if let count1 = countSelected {
                        if let tag = clickedCount {
                        arrSkillList[tag].isSelected = 1
                        arrSkillList[tag].ratingValue = count1 + 1
                        let studentSkillId = arrSkillList[tag].studentID
                        let rating = count1 + 1
                        var dict = [String:Any]()
                        dict["TeacherSkillId"] = studentSkillId
                        dict["Rating"] = rating
                        arrSelect.append(dict)
                    }
                    tableView.reloadData()
                }
            }else{
                self.showAlert(alert: Alerts.kNoInternetConnection)
            }
        }
    }
    func GetTitleForRow(index: Int) -> String {
         if isClassSelected == true {
            if arrClassList.count > 0{
                txtfieldClass.text = arrClassList[0].name
                print("starting index :\(index)")
                return arrClassList[index].name ?? ""
            }
        }
        else if isSubjectSelected == true {
            if arrSubjectlist.count > 0 {
                txtfieldSubject.text = arrSubjectlist[0].studentName
                return arrSubjectlist[index].studentName ?? ""
            }
        }
        else if isStudentSelected == true {
            if arrTeacherlist.count > 0 {
                txtfieldStudent.text = arrTeacherlist[0].teacherFirstName
                   print("starting teacher index :\(index)")
                return arrTeacherlist[index].teacherFirstName ?? ""
            }
        }
        else if  isSelectedRating == true {
            if  array.count > 0 {
                return "\(array[index])"
            }
        }
        return ""
    }
    
    func SelectedRow(index: Int) {
        if isClassSelected == true {
            if arrClassList.count > 0{
                selectedClassId = arrClassList[index].classId
                txtfieldClass.text = arrClassList[index].name
                selectedClassArrIndex = index
            }
        }
        else if isSubjectSelected == true {
            if arrSubjectlist.count > 0 {
                selectedSubjectId = arrSubjectlist[index].studentID 
                txtfieldSubject.text = arrSubjectlist[index].studentName
            }
            
        }
        else if isStudentSelected == true {
            if arrTeacherlist.count > 0 {
                selectTeacherId = arrTeacherlist[index].teacherID
                txtfieldStudent.text = arrTeacherlist[index].teacherFirstName
            }
        }
        else if isSelectedRating == true {
            if array.count > 0 {
               countSelected = index
            }
        }
    }
}
//MARK:- VIEW DELEGATE
extension RatingToTeacherVC : ViewDelegate {
    
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
        //Title
        self.title = RatingToTeacher.kAddTeacherRating
        self.tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        self.viewModel?.isSearching = false
      }
}


extension RatingToTeacherVC : UITableViewDataSource , RatingToTeacherTableViewCellDelegate {
    func didPressButton(_ tag: Int) {
        print("your pressed button :\(tag)")
        clickedCount = tag
        print("your skill count : \(arrSkillList.count)")
        if let id = arrSkillList[tag].studentName {
            isSelectedRating = true
            isClassSelected = false
            isSubjectSelected = false
            isStudentSelected = false
            countSelected = tag
            UpdatePickerModel4(count: array.count, sharedPickerDelegate: self as! SharedUIPickerDelegate, View:  self.view,index: 0)
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //    return arrSkillList.count
        return arrSkillList.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RatingToTeacher.kRatingToTeacherCell, for: indexPath) as! RatingToTeacherTableViewCell
        cell.cellDelegate = self
        cell.btnPicker.tag = indexPath.row
        if let name = arrSkillList[indexPath.row].studentName {
            // cell.lblStudentName.text = name
            cell.lblSkill.text = name
        }
        if isSelectedRating == true {
            if arrSkillList[indexPath.row].isSelected == 1 {
                cell.lblRating.text = "\(arrSkillList[indexPath.row].ratingValue)"
             }
        }
       return cell
    }
}


extension RatingToTeacherVC : OKAlertViewDelegate{
    //Ok Button Clicked
    func okBtnAction() {
         okAlertView.removeFromSuperview()
    }
}
