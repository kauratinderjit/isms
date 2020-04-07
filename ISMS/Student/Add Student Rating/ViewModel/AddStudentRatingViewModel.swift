//
//  AddStudentRatingViewModel.swift
//  ISMS
//
//  Created by Kuldeep Singh on 11/28/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation

protocol AddStudentRatingDelegate : class {
    func StudentRatingDidSucceed()
    func StudentRatingDidFailour()
    func classListDidSuccess(data : [GetClassListResultData]?)
    func SubjectListDidSuccess(data: [GetSubjectResultData]?)
      func SubjectWiseRatingDidSucceed(data : [SubjectWiseRatingResultData])
    func GetSkillListDidSucceed(data : [AddStudentRatingResultData]?)
    func GetSubjectListDidSucceed(data:[AddStudentRatingResultData]?)
    func studentListDidSucceed(data : [AddStudentRatingResultData]?)
    func AddStudentRatingDidSucceed(data: String)
}

class AddStudentRatingViewModel {
   var isSearching : Bool?
   private weak var addStudentRatingView : ViewDelegate?
  private  weak var addStudentRatingDelegate: AddStudentRatingDelegate?
    
    
    init(delegate : AddStudentRatingDelegate) {
        addStudentRatingDelegate = delegate
    }
    
    func attachView(viewDelegate : ViewDelegate){
        addStudentRatingView = viewDelegate
    }
   
    //MARK:- Class list
    func classList(searchText: String,pageSize : Int,filterBy: Int,skip: Int){
        
        if self.isSearching == false {
            self.addStudentRatingView?.showLoader()
        }
        
        var postDict = [String:Any]()
        
        postDict[KApiParameters.KCommonParametersForList.kSearch] = searchText
        postDict[KApiParameters.KCommonParametersForList.kPageSize] = pageSize
        postDict[KApiParameters.KCommonParametersForList.kSortColumn] = ""
        postDict[KApiParameters.KCommonParametersForList.kSkip] = skip
        postDict[KApiParameters.KCommonParametersForList.kSortColumnDir] = ""
        
        
        
        ClassApi.sharedManager.getClassList(url: ApiEndpoints.kGetClassList, parameters: postDict, completionResponse: { (classModel) in
            
            self.addStudentRatingView?.hideLoader()
            
            switch classModel.statusCode{
            case KStatusCode.kStatusCode200:
                self.addStudentRatingDelegate?.classListDidSuccess(data: classModel.resultData)
            case KStatusCode.kStatusCode401:
                if let msg = classModel.message{
                    self.addStudentRatingView?.showAlert(alert: msg)
                }
            //  self.classListDelegate?.unauthorizedUser()
            default:
                if let msg = classModel.message{
                    self.addStudentRatingView?.showAlert(alert: msg)
                }
            }
        }, completionnilResponse: { (nilResponseError) in
            
            self.addStudentRatingView?.hideLoader()
            self.addStudentRatingDelegate?.StudentRatingDidFailour()
            
            if let error = nilResponseError{
                self.addStudentRatingView?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Class APi Nil response")
            }
            
        }) { (error) in
            self.addStudentRatingView?.hideLoader()
            //  self.studentRatingDelegate?.StudentRatingDidFailour()
            if let err = error?.localizedDescription{
                self.addStudentRatingView?.showAlert(alert: err)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Class APi error response")
            }
        }
    }
    
    //MARK:- SUBJECT LIST
    func subjectList(search : String?,skip : Int?,pageSize: Int?,sortColumnDir: String?,sortColumn: String?, particularId : Int){
        self.addStudentRatingView?.showLoader()
        
        let paramDict = [KApiParameters.SubjectListApi.subjectSearch: search ?? "",KApiParameters.SubjectListApi.PageSkip:skip ?? 0,KApiParameters.SubjectListApi.PageSize: pageSize ?? 0,KApiParameters.SubjectListApi.sortColumnDir: sortColumnDir ?? "", KApiParameters.SubjectListApi.sortColumn: sortColumn ?? "",
                         KApiParameters.kUpdateSyllabusApiParameter.kParticularId : particularId] as [String : Any]
        
        SubjectApi.sharedInstance.getSubjectList(url: ApiEndpoints.KSubjectListApi, parameters: paramDict as [String : Any], completionResponse: { (SubjectListModel) in
            
            if SubjectListModel.statusCode == KStatusCode.kStatusCode200{
                self.addStudentRatingView?.hideLoader()
                self.addStudentRatingDelegate?.SubjectListDidSuccess(data: SubjectListModel.resultData)
            }else if SubjectListModel.statusCode == KStatusCode.kStatusCode401{
                self.addStudentRatingView?.hideLoader()
                self.addStudentRatingView?.showAlert(alert: SubjectListModel.message ?? "")
                //  self.SubjectListDelegate?.unauthorizedUser()
            }else{
                self.addStudentRatingView?.hideLoader()
                CommonFunctions.sharedmanagerCommon.println(object: "student APi status change")
            }
            
        }, completionnilResponse: { (nilResponseError) in
            
            self.addStudentRatingView?.hideLoader()
            //   self.SubjectListDelegate?.SubjectListDidFailed()
            
            if let error = nilResponseError{
                self.addStudentRatingView?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "student APi Nil response")
            }
            
        }) { (error) in
            self.addStudentRatingView?.hideLoader()
            //   self.SubjectListDelegate?.SubjectListDidFailed()
            if let err = error?.localizedDescription{
                self.addStudentRatingView?.showAlert(alert: err)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "student APi error response")
            }
        }
        
    }

    
    //MARK:- SUBJECT LIST
    func GetSkillList(id : Int , enumType : Int , type : String) {
        self.addStudentRatingView?.showLoader()
        
        let paramDict = [ AddStudentRating.kId:id,
                          AddStudentRating.kEnumType: enumType] as [String : Any]
        let url = ApiEndpoints.kSkillList + "?id=" + "\(id)" + "&enumType=" + "\(enumType)"
        AddStudentRatingApi.sharedInstance.GetSkillList(url: url , parameters: paramDict as [String : Any], completionResponse: { (AddStudentRatingListModel) in
            
            print("your respomnse data : ",AddStudentRatingListModel.resultData)
            
            if AddStudentRatingListModel.statusCode == KStatusCode.kStatusCode200 {
                self.addStudentRatingView?.hideLoader()
                if type == "Skill" {
        self.addStudentRatingDelegate?.GetSkillListDidSucceed(data:AddStudentRatingListModel.resultData!)
                }
                else {
              self.addStudentRatingDelegate?.studentListDidSucceed(data: AddStudentRatingListModel.resultData!)
                    
                }
                
            }else if AddStudentRatingListModel.statusCode == KStatusCode.kStatusCode401 {
                self.addStudentRatingView?.hideLoader()
                self.addStudentRatingView?.showAlert(alert: AddStudentRatingListModel.message ?? "")
                //  self.SubjectListDelegate?.unauthorizedUser()
            }else{
                self.addStudentRatingView?.hideLoader()
                CommonFunctions.sharedmanagerCommon.println(object: "student APi status change")
            }
            
        }, completionnilResponse: { (nilResponseError) in
            
            self.addStudentRatingView?.hideLoader()
            //   self.SubjectListDelegate?.SubjectListDidFailed()
            
            if let error = nilResponseError{
                self.addStudentRatingView?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "student APi Nil response")
            }
            
        }) { (error) in
            self.addStudentRatingView?.hideLoader()
            //   self.SubjectListDelegate?.SubjectListDidFailed()
            //            if let err = error?.localizedDescription{
            //                self.studentRatingView?.showAlert(alert: err)
            //            }else{
            //                CommonFunctions.sharedmanagerCommon.println(object: "student APi error response")
            //            }
        }
        
    }
    
    func GetClassSubjectsByteacherId(classid: Int,teacherId: Int){
        self.addStudentRatingView?.showLoader()
        
        let paramDict = ["classid":classid,
                          "teacherId" : teacherId] as [String : Any]
        let url = ApiEndpoints.kGetClassSubjectsByteacherId + "?classid=" + "\(classid)" + "&teacherId=" + "\(teacherId)"
        AddStudentRatingApi.sharedInstance.GetSkillList(url: url , parameters: paramDict as [String : Any], completionResponse: { (AddStudentRatingListModel) in
            
            print("your respomnse data : ",AddStudentRatingListModel.resultData)
            
            if AddStudentRatingListModel.statusCode == KStatusCode.kStatusCode200 {
                self.addStudentRatingView?.hideLoader()
                self.addStudentRatingDelegate?.GetSubjectListDidSucceed(data:AddStudentRatingListModel.resultData!)
//                if type == "Skill" {
//                    self.addStudentRatingDelegate?.GetSkillListDidSucceed(data:AddStudentRatingListModel.resultData!)
//                }
//                else {
//                    self.addStudentRatingDelegate?.studentListDidSucceed(data: AddStudentRatingListModel.resultData!)
//
//                }
                
            }else if AddStudentRatingListModel.statusCode == KStatusCode.kStatusCode401 {
                self.addStudentRatingView?.hideLoader()
                self.addStudentRatingView?.showAlert(alert: AddStudentRatingListModel.message ?? "")
                //  self.SubjectListDelegate?.unauthorizedUser()
            }else{
                self.addStudentRatingView?.hideLoader()
                CommonFunctions.sharedmanagerCommon.println(object: "student APi status change")
            }
            
        }, completionnilResponse: { (nilResponseError) in
            
            self.addStudentRatingView?.hideLoader()
            //   self.SubjectListDelegate?.SubjectListDidFailed()
            
            if let error = nilResponseError{
                self.addStudentRatingView?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "student APi Nil response")
            }
            
        }) { (error) in
            self.addStudentRatingView?.hideLoader()
            //   self.SubjectListDelegate?.SubjectListDidFailed()
            //            if let err = error?.localizedDescription{
            //                self.studentRatingView?.showAlert(alert: err)
            //            }else{
            //                CommonFunctions.sharedmanagerCommon.println(object: "student APi error response")
            //            }
        }
    }
    
    
    //MARK:- SUBJECT LIST
    func getSubjectWiseRating(enrollmentsId : Int?,classId: Int?){
        self.addStudentRatingView?.showLoader()
        print("your data ")
        let paramDict = [ "EnrollmentId": enrollmentsId!,
                          "ClassSubjectId" : classId!
            ] as [String : Any]
        
        AddStudentRatingApi.sharedInstance.SubmitApiList(url: ApiEndpoints.kGetSubjectEnrollement, parameters: paramDict, completionResponse: { (SubjectListModel) in
            
            if SubjectListModel.statusCode == KStatusCode.kStatusCode200{
                self.addStudentRatingView?.hideLoader()
                self.addStudentRatingDelegate?.SubjectWiseRatingDidSucceed(data: SubjectListModel.resultData!)
            }else if SubjectListModel.statusCode == KStatusCode.kStatusCode401{
                self.addStudentRatingView?.hideLoader()
                self.addStudentRatingView?.showAlert(alert: SubjectListModel.message ?? "")
                //  self.SubjectListDelegate?.unauthorizedUser()
            }else{
                self.addStudentRatingView?.hideLoader()
                CommonFunctions.sharedmanagerCommon.println(object: "student APi status change")
            }
            
        }, completionnilResponse: { (nilResponseError) in
            
            self.addStudentRatingView?.hideLoader()
            //   self.SubjectListDelegate?.SubjectListDidFailed()
            
            if let error = nilResponseError{
                self.addStudentRatingView?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "student APi Nil response")
            }
            
        }) { (error) in
            self.addStudentRatingView?.hideLoader()
            //   self.SubjectListDelegate?.SubjectListDidFailed()
            //            if let err = error?.localizedDescription{
            //                self.addStudentRatingView?.showAlert(alert: err)
            //            }else{
            //                CommonFunctions.sharedmanagerCommon.println(object: "student APi error response")
            //            }
        }
        
    }
    
    
    //MARK:- SUBJECT LIST
    func SubmitTotalRating(teacherID: Int?, enrollmentsId : Int?,classSubjectId: Int?,comment: String?,StudentSkillRatings: [[String : Any]]){
        self.addStudentRatingView?.showLoader()
        
//        var postDict = [String:Any]()
//
//        let classSubjectMapList = classSubjectList.map { (model) -> Dictionary<String, Any> in
//            var selectedClassSubjectsDict = Dictionary<String, Any>()
//            selectedClassSubjectsDict[KApiParameters.AssignSubjectToClassApi.kSubjectId] = model.subjectId
//            selectedClassSubjectsDict[KApiParameters.AssignSubjectToClassApi.kClassSubjectId] = model.classSubjectId
//            return selectedClassSubjectsDict
//        }
//        postDict[KApiParameters.AssignSubjectToClassApi.kClassId] = classId
//        postDict[KApiParameters.AssignSubjectToClassApi.kClassSubjectModels] = classSubjectMapList
        
            //[
//            {
//                "StudentSkillId": 0,
//                "Rating": 0
//        }
//        ]
        let paramDict = [ "Id": 0,
                          "TeacherId": 10,
                          "EnrollmentsId": enrollmentsId!,
                          "ClassSubjectId":classSubjectId!,
                          "Comment": "good",
                          "StudentSkillRatings":StudentSkillRatings] as [String : Any]
        
        AddStudentRatingApi.sharedInstance.SubmitApiList(url: ApiEndpoints.kAddStudentRating, parameters: paramDict, completionResponse: { (SubjectListModel) in
            
            if SubjectListModel.statusCode == KStatusCode.kStatusCode200{
                self.addStudentRatingView?.hideLoader()
                self.addStudentRatingDelegate?.AddStudentRatingDidSucceed(data : "Student Rating Added Successfully")
            }else if SubjectListModel.statusCode == KStatusCode.kStatusCode401{
                self.addStudentRatingView?.hideLoader()
                self.addStudentRatingView?.showAlert(alert: SubjectListModel.message ?? "")
                //  self.SubjectListDelegate?.unauthorizedUser()
            }else{
                self.addStudentRatingView?.hideLoader()
                CommonFunctions.sharedmanagerCommon.println(object: "student APi status change")
            }
            
        }, completionnilResponse: { (nilResponseError) in
            
            self.addStudentRatingView?.hideLoader()
            //   self.SubjectListDelegate?.SubjectListDidFailed()
            
            if let error = nilResponseError{
                self.addStudentRatingView?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "student APi Nil response")
            }
            
        }) { (error) in
            self.addStudentRatingView?.hideLoader()
            //   self.SubjectListDelegate?.SubjectListDidFailed()
//            if let err = error?.localizedDescription{
//                self.addStudentRatingView?.showAlert(alert: err)
//            }else{
//                CommonFunctions.sharedmanagerCommon.println(object: "student APi error response")
//            }
        }
        
    }
    
    
}

//MARK:- ADD STUDENT RATING DELEGATE
extension AddStudentRatingVC : AddStudentRatingDelegate {
   
    func SubjectListDidSuccess(data: [GetSubjectResultData]?) {
        
    }
    
    
    func GetSubjectListDidSucceed(data:[AddStudentRatingResultData]?){
        if let data1 = data {
            self.arrSubjectlist = data1
            if let studentName = arrSubjectlist[0].studentName{
                txtfieldClass.text = studentName
//                self.viewModel?.GetSkillList(id : 1, enumType : 14 ,type : "Student")
//                self.viewModel?.GetClassSubjectsByteacherId(classid: 1,teacherId: 2 )
                
            }
            
            
            tableView.reloadData()
        }
    }
    
    func SubjectWiseRatingDidSucceed(data: [SubjectWiseRatingResultData]) {
      //  arrSubjectList = data
        tableView.reloadData()
    }
    
    func AddStudentRatingDidSucceed(data: String) {
        self.showAlert(alert: data)
    }
    
    func studentListDidSucceed(data: [AddStudentRatingResultData]?) {
         isFetching = true
        if data != nil{
            if data?.count ?? 0 > 0{
                for value in data!{
                    
                    let containsSameValue = arrStudentlist.contains(where: {$0.studentID == value.studentID})
                    
                    if containsSameValue == false{
                        arrStudentlist.append(value)
                        if let studentName = arrStudentlist[0].studentName {
                            txtfieldStudent.text = studentName
                        }
                    }
                    //  self.tblViewCenterLabel(tblView: tableView, lblText: "", hide: true)
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
    
    func GetSkillListDidSucceed(data: [AddStudentRatingResultData]?) {
        print("our data : ",data)
        
        self.isFetching = true
//        if data != nil{
//            if data?.count ?? 0 > 0{
//                for value in data!{
//                    let containsSameValue = arrClassList.contains(where: {$0.classId == value.classId})
//                    if containsSameValue == false{
//                        arrClassList.append(value)
//                        if let className = arrClassList[0].name{
//                            txtfieldClass.text = className
//                        }
//                    }
//                    // self.tblViewCenterLabel(tblView: tableView, lblText: "", hide: true)
//
//
//                }
//                if let id = arrClassList[0].classId {
//                    selectedClassId = id
//
//                    self.viewModel?.GetClassSubjectsByteacherId(classid: selectedClassId ?? 0,teacherId: 2 )
//                    self.viewModel?.subjectList(search : "",skip : KIntegerConstants.kInt0,pageSize: pageSize,sortColumnDir: "",sortColumn: "", particularId: id)
//                }
//
//            }else{
//                CommonFunctions.sharedmanagerCommon.println(object: "Zero")
//            }
//        }else{
//            CommonFunctions.sharedmanagerCommon.println(object: "Nil")
//        }
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//        }
        
        
                if let data1 = data {
                self.arrSkillList = data1
                    if let className = arrSkillList[0].studentName{
                            txtfieldClass.text = className
                           self.viewModel?.GetSkillList(id : 1, enumType : 14 ,type : "Student")
                         self.viewModel?.GetClassSubjectsByteacherId(classid: 1,teacherId: 2 )
                        
                    }
        
       
                    tableView.reloadData()
                }
    }
    
    
    
    func classListDidSuccess(data: [GetClassListResultData]?) {
       self.isFetching = true
        if data != nil{
            if data?.count ?? 0 > 0{
                for value in data!{
                    let containsSameValue = arrClassList.contains(where: {$0.classId == value.classId})
                    if containsSameValue == false{
                        arrClassList.append(value)
                        if let className = arrClassList[0].name{
                            txtfieldClass.text = className
                        }
                    }
                    // self.tblViewCenterLabel(tblView: tableView, lblText: "", hide: true)
                 
                    
                }
                if let id = arrClassList[0].classId {
                    selectedClassId = id
                    
                    self.viewModel?.GetClassSubjectsByteacherId(classid: selectedClassId ?? 0,teacherId: 2 )
//                    self.viewModel?.subjectList(search : "",skip : KIntegerConstants.kInt0,pageSize: pageSize,sortColumnDir: "",sortColumn: "", particularId: id)
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
    
//    func SubjectListDidSuccess(data: [GetSubjectResultData]?) {
//        isFetching = true
//        if data != nil{
//            if data?.count ?? 0 > 0{
//                for value in data!{
//
//                    let containsSameValue = arrSubjectlist.contains(where: {$0.subjectId == value.subjectId})
//
//                    if containsSameValue == false{
//                        arrSubjectlist.append(value)
//                        if let subjectName = arrSubjectlist[0].subjectName {
//                            txtfieldSubject.text = subjectName
//                        }
////                            self.viewModel?.GetSkillList(id : 10, enumType : 14 ,type : "Student")
//                    }
//                    //  self.tblViewCenterLabel(tblView: tableView, lblText: "", hide: true)
//                }
////                if let classId = selectedClassId {
////                    self.viewModel?.GetSkillList(id : 1, enumType : 14 ,type : "Student")
////                }
//
//            }else{
//                CommonFunctions.sharedmanagerCommon.println(object: "Zero")
//            }
//        }else{
//            CommonFunctions.sharedmanagerCommon.println(object: "Nil")
//        }
//
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//        }
//    }
    
    
    func StudentRatingDidSucceed() {
        
    }
    
    func StudentRatingDidFailour() {
        
    }
    
}
    

//MARK:- PICKER DELEGATE FUNCTIONS
extension AddStudentRatingVC : SharedUIPickerDelegate{
    func DoneBtnClicked() {
        if checkInternetConnection(){
            //            arrAllAssignedSubjects.removeAll()
            if isClassSelected == true {
                if let index = selectedClassArrIndex {
                    if let id = arrSkillList[index].studentID {
                           self.viewModel?.GetSkillList(id : 1, enumType : 14 ,type : "Student")
                         self.viewModel?.GetClassSubjectsByteacherId(classid: 1,teacherId: 2 )
//                       self.viewModel?.GetSkillList(id : 10, enumType : 14 ,type : "Student")
//                        self.viewModel?.subjectList(search : "",skip : KIntegerConstants.kInt0,pageSize: pageSize,sortColumnDir: "",sortColumn: "", particularId: id)
                    }
                }
            }
            else if isSelectedRating == true {
                if let count1 = countSelected {
               //  let count = selectRatingCount[count1]
                    if let tag = clickedCount {
                        arrSkillList[tag].isSelected = 1

           arrSkillList[tag].ratingValue = count1 + 1
                   
                 //   arrClickedArray[count1].ratingValue = array[count1]
                    
                    
                    let studentSkillId = arrSkillList[tag].studentID
                    let rating = count1 + 1

                    var dict = [String:Any]()
                    dict["StudentSkillId"] = studentSkillId
                    dict["Rating"] = rating
                    arrSelect.append(dict)
                    }
                    tableView.reloadData()
                
                
            }
                
            }
            else if isStudentSelected == true{
                
            }
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
    }
    func GetTitleForRow(index: Int) -> String {
        
        if isClassSelected == true {
            if arrSkillList.count > 0{
                txtfieldClass.text = arrSkillList[0].studentName
                return arrSkillList[index].studentName ?? ""
            }
        }
        else if isSubjectSelected == true {
            if arrSubjectlist.count > 0 {
                txtfieldSubject.text = arrSubjectlist[0].studentName
                return arrSubjectlist[index].studentName ?? ""
            }
        }
        else if isStudentSelected == true {
            if arrStudentlist.count > 0 {
                txtfieldStudent.text = arrStudentlist[0].studentName
                return arrStudentlist[index].studentName ?? ""
            }
        }
        else if  isSelectedRating == true {
            if  array.count > 0 {
              //  let indexPath = IndexPath(row: index, section: 0)
//               let cell =  self.tableView.dequeueReusableCell(withIdentifier: "cell", for:indexPath.row) as! AddStudentRatingTableViewCell
//                cell.lblRating.text = array[0]
               return "\(array[index])"
            }
            
        }
        return ""
    }
    
    func SelectedRow(index: Int) {
        
        if isClassSelected == true {
            if arrSkillList.count > 0{
                selectedClassId = arrSkillList[index].studentID
                txtfieldClass.text = arrSkillList[index].studentName
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
            if arrStudentlist.count > 0 {
                selectStudentId = arrStudentlist[index].studentID
                txtfieldStudent.text = arrStudentlist[index].studentName
            }
        }
        else if isSelectedRating == true {
            if array.count > 0 {
              //  selectRatingCount.remove(at: array[index])
//                selectRatingCount.insert(array[index], at: array[index])
//                print("your array count : \(array[index]) and rating count \(selectRatingCount[array[index]])")
                countSelected = index
            }
            
        }
        
    }
}
//MARK:- VIEW DELEGATE
extension AddStudentRatingVC : ViewDelegate {
    
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
        
//        self.setSearchBarInNavigationController(placeholderText: KSearchBarPlaceHolder.kUserSearchBarPlaceHolder, navigationTitle: KStoryBoards.KClassListIdentifiers.kClassListTitle, navigationController: self.navigationController, navigationSearchBarDelegates: self)
        
        //Set Back Button
        self.setBackButton()
        
        //Set picker view
        self.SetpickerView(self.view)
        
        // cornerButton(btn: btnSubmit, radius: 8)
        
        //Title
        self.title = KStoryBoards.KClassListIdentifiers.kClassListTitle
        
        self.tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        
        self.viewModel?.isSearching = false
        
        
    }
    


}


extension AddStudentRatingVC : UITableViewDataSource , AddStudentRatingTableViewCellDelegate {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: AddStudentRating.kAddStudentRatingCell, for: indexPath) as! AddStudentRatingTableViewCell
        cell.cellDelegate = self
        cell.btnPicker.tag = indexPath.row
        if type == "Edit" {
             cell.btnPicker.isEnabled = true
        }
        else {
            cell.btnPicker.isEnabled = false
        }
        
        if let name = arrSkillList[indexPath.row].studentName {
           // cell.lblStudentName.text = name
            cell.lblSkill.text = name
        }
        if isSelectedRating == true {
            if arrSkillList[indexPath.row].isSelected == 1 {
            cell.lblRating.text = "\(arrSkillList[indexPath.row].ratingValue)"
            
              //  "\(arrClickedArray[indexPath.row].ratingValue)"
                
                //"\(arrSkillList[indexPath.row].ratingValue)"
              //  arrSkillList[indexPath.row].isSelected = 0
                //"\(array[selectRatingCount[indexPath.row]])"
            }
        }
        
   //     cell.lblRating.text = "\(array[indexPath.row])"
//        if let rating = arrSkillList[indexPath.row].studentRating {
//            cell.lblPercentage.text = rating + "%"
//        }
        return cell
        
    }
    
    
    
    
    
    
    
    
    
}


extension AddStudentRatingVC : OKAlertViewDelegate{
    
    //Ok Button Clicked
    func okBtnAction() {
        //        if isUnauthorizedUser == true{
        //            isUnauthorizedUser = false
        //            CommonFunctions.sharedmanagerCommon.setRootLogin()
        //        }else if isStudentAdd == true{
        //            isStudentAdd = false
        //            okAlertView.removeFromSuperview()
        //            self.navigationController?.popViewController(animated: true)
        //        }
        okAlertView.removeFromSuperview()
    }
}
