//
//  TeacherRatingViewModel.swift
//  ISMS
//
//  Created by Kuldeep Singh on 12/3/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation


protocol TeacherRatingDelegate : class {
    func StudentRatingDidSucceed()
    func StudentRatingDidFailour()
    func classListDidSuccess(data : [GetClassListResultData]?)
    func SubjectListDidSuccess(data: [AddStudentRatingResultData]?)
    func StudentRatingListDidSucceed(data : [StudentRatingResultData])
}


class TeacherRatingViewModel {
    var isSearching : Bool?
    private  weak var teacherRatingView : ViewDelegate?
    private  weak var teacherRatingDelegate : TeacherRatingDelegate?
    
    //Initiallize the presenter class using delegates
    init(delegate: TeacherRatingDelegate) {
        teacherRatingDelegate = delegate
    }
    
    //Attach GlobalViewDelegate
    func attachView(viewDelegate : ViewDelegate){
        teacherRatingView = viewDelegate
    }
    
    //Deattach View for free the memory from instances
    func deattachView(){
        teacherRatingView = nil
        teacherRatingDelegate = nil
    }
   
    //MARK:- Class list
    func classList(searchText: String,pageSize : Int,filterBy: Int,skip: Int){
        
        if self.isSearching == false {
            self.teacherRatingView?.showLoader()
        }
        
        var postDict = [String:Any]()
        
        postDict[KApiParameters.KCommonParametersForList.kSearch] = searchText
        postDict[KApiParameters.KCommonParametersForList.kPageSize] = pageSize
        postDict[KApiParameters.KCommonParametersForList.kSortColumn] = ""
        postDict[KApiParameters.KCommonParametersForList.kSkip] = skip
        postDict[KApiParameters.KCommonParametersForList.kSortColumnDir] = ""
        
        
        
        ClassApi.sharedManager.getClassList(url: ApiEndpoints.kGetClassList, parameters: postDict, completionResponse: { (classModel) in
            
            self.teacherRatingView?.hideLoader()
            
            switch classModel.statusCode{
            case KStatusCode.kStatusCode200:
                self.teacherRatingDelegate?.classListDidSuccess(data: classModel.resultData)
            case KStatusCode.kStatusCode401:
                if let msg = classModel.message{
                    self.teacherRatingView?.showAlert(alert: msg)
                }
            //  self.classListDelegate?.unauthorizedUser()
            default:
                if let msg = classModel.message{
                    self.teacherRatingView?.showAlert(alert: msg)
                }
            }
        }, completionnilResponse: { (nilResponseError) in
            
            self.teacherRatingView?.hideLoader()
            self.teacherRatingDelegate?.StudentRatingDidFailour()
            
            if let error = nilResponseError{
                self.teacherRatingView?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Class APi Nil response")
            }
            
        }) { (error) in
            self.teacherRatingView?.hideLoader()
            //  self.studentRatingDelegate?.StudentRatingDidFailour()
            if let err = error?.localizedDescription{
                self.teacherRatingView?.showAlert(alert: err)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Class APi error response")
            }
        }
    }

    //MARK:- SUBJECT LIST
    func GetSubjectList(id : Int , enumType : Int , type : String) {
        self.teacherRatingView?.showLoader()
        
        let paramDict = [ AddStudentRating.kId:id,
                          AddStudentRating.kEnumType: enumType] as [String : Any]
        let url = ApiEndpoints.kSkillList + "?id=" + "\(id)" + "&enumType=" + "\(enumType)"
        AddStudentRatingApi.sharedInstance.GetSkillList(url: url , parameters: paramDict as [String : Any], completionResponse: { (AddStudentRatingListModel) in
    
            if AddStudentRatingListModel.statusCode == KStatusCode.kStatusCode200 {
                self.teacherRatingView?.hideLoader()
                if type == "SubjectList" {
                    
                  self.teacherRatingDelegate?.SubjectListDidSuccess(data: AddStudentRatingListModel.resultData)
                }
                
            }else if AddStudentRatingListModel.statusCode == KStatusCode.kStatusCode401 {
                self.teacherRatingView?.hideLoader()
                self.teacherRatingView?.showAlert(alert: AddStudentRatingListModel.message ?? "")
                //  self.SubjectListDelegate?.unauthorizedUser()
            }else{
                self.teacherRatingView?.hideLoader()
                CommonFunctions.sharedmanagerCommon.println(object: "student APi status change")
            }
            
        }, completionnilResponse: { (nilResponseError) in
            
            self.teacherRatingView?.hideLoader()
            //   self.SubjectListDelegate?.SubjectListDidFailed()
            
            if let error = nilResponseError{
                self.teacherRatingView?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "student APi Nil response")
            }
            
        }) { (error) in
            self.teacherRatingView?.hideLoader()
          
        }
        
    }

    //MARK:- SUBJECT LIST
    func studentList(search : String?,skip : Int?,pageSize: Int?,sortColumnDir: String?,sortColumn: String?, classSubjectID : Int , classID : Int){
        self.teacherRatingView?.showLoader()

          let paramDict = [ "ClassId":classID,
                   "ClassSubjectId": classSubjectID] as [String : Any]

     //   let paramDict = [ "ClassId":14,
               //           "ClassSubjectId": 33] as [String : Any]
        
        StudentRatingApi.sharedInstance.GetStudentList(url: ApiEndpoints.kTeacherRating, parameters: paramDict as [String : Any], completionResponse: { (StudentRatingListModel) in
            if StudentRatingListModel.statusCode == KStatusCode.kStatusCode200{
                self.teacherRatingView?.hideLoader()
                self.teacherRatingDelegate?.StudentRatingListDidSucceed(data : StudentRatingListModel.resultData!)
            }else if StudentRatingListModel.statusCode == KStatusCode.kStatusCode401 {
                self.teacherRatingView?.hideLoader()
                self.teacherRatingView?.showAlert(alert: StudentRatingListModel.message ?? "")
                //  self.SubjectListDelegate?.unauthorizedUser()
            }else{
                self.teacherRatingView?.hideLoader()
                CommonFunctions.sharedmanagerCommon.println(object: "student APi status change")
            }
        }, completionnilResponse: { (nilResponseError) in

            self.teacherRatingView?.hideLoader()
            //   self.SubjectListDelegate?.SubjectListDidFailed()

            if let error = nilResponseError{
                self.teacherRatingView?.showAlert(alert: error)

            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "student APi Nil response")
            }

        }) { (error) in
            self.teacherRatingView?.hideLoader()
         
        }

    }
    
}

//MARK:- Student Rating Delegate
extension TeacherRatingVC : TeacherRatingDelegate {

    
    func StudentRatingListDidSucceed(data: [StudentRatingResultData]) {
        //   print(good)
        arrStudent = data
        self.tableView.reloadData()
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
               }
                if let id = arrClassList[0].classId {
                    selectedClassId = id
                        // 10 is used for get Subject list
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
                        if let subjectName = arrSubjectlist[0].studentName {
                            txtfieldSubject.text = subjectName
                              }
                    }
                    if let id = arrSubjectlist[0].studentID {
                        selectedSubjectId = id
                    }
                 }
            
                if let classId = selectedClassId {
                    if let subjectID = selectedSubjectId {
                self.viewModel?.studentList(search: "", skip: 0, pageSize: KIntegerConstants.kInt0, sortColumnDir: "", sortColumn: "", classSubjectID:subjectID, classID: classId )
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
    
    
    func StudentRatingDidSucceed() {
        
    }
    
    func StudentRatingDidFailour() {
        
    }
    
    
    
}
//MARK:- PICKER DELEGATE FUNCTIONS
extension TeacherRatingVC : SharedUIPickerDelegate{
    func DoneBtnClicked() {
        if checkInternetConnection(){
            //            arrAllAssignedSubjects.removeAll()
            if isClassSelected == true {
                if let index = selectedClassArrIndex {
                    if let id = arrClassList[index].classId {
                        self.viewModel?.GetSubjectList(id: id, enumType: 10, type: "SubjectList")
//                        self.viewModel?.subjectList(search : "",skip : KIntegerConstants.kInt0,pageSize: pageSize,sortColumnDir: "",sortColumn: "", particularId: id)
                    }
                }
            }
            else if isSubjectSelected == true {
                if let classId = selectedClassId {
                    if let subjectID = selectedSubjectId {
                        print("your class id \(classId) and subjectID \(subjectID)")
                        self.viewModel?.studentList(search: "", skip: 0, pageSize: KIntegerConstants.kInt0, sortColumnDir: "", sortColumn: "", classSubjectID:subjectID, classID:classId  )
                    }
                }
                
                
            }
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
    }
    
    func GetTitleForRow(index: Int) -> String {
        
        if isClassSelected == true {
            if arrClassList.count > 0{
                txtfieldClass.text = arrClassList[0].name
                return arrClassList[index].name ?? ""
            }
        }
        else if isSubjectSelected == true {
            if arrSubjectlist.count > 0 {
                txtfieldSubject.text = arrSubjectlist[0].studentName
                return arrSubjectlist[index].studentName ?? ""
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
        
    }
}


//MARK:- View Delegate
extension TeacherRatingVC : ViewDelegate{
    func registerTableViewCell(){
        self.tableView.register(UINib(nibName: "SelectionTblViewCell", bundle: nil), forCellReuseIdentifier: KTableViewCellIdentifier.kSelectionTableViewCell)
    }
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
        self.setSearchBarInNavigationController(placeholderText: KSearchBarPlaceHolder.kUserSearchBarPlaceHolder, navigationTitle: KStoryBoards.KClassListIdentifiers.kClassListTitle, navigationController: self.navigationController, navigationSearchBarDelegates: self)
        //Set Back Button
        self.setBackButton()
        //Set picker view
        self.SetpickerView(self.view)
        // cornerButton(btn: btnSubmit, radius: 8)
        //Title
        self.title = TeacherRating.kTeacherRatingVC
            //KStoryBoards.KClassListIdentifiers.kClassListTitle
        self.tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        self.viewModel?.isSearching = false
    }
}

extension TeacherRatingVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrStudent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TeacherRating.kTeacherRatingCell, for: indexPath) as! TeacherRatingTableViewCell
        if let name = arrStudent[indexPath.row].teacherName {
            cell.lblStudentName.text = name
        }
        
        if let rating = arrStudent[indexPath.row].studentRating {
            cell.lblPercentage.text = rating + "%"
        }
        return cell
        
    }
    
}


//MARK:- UISearchController Bar Delegates
extension TeacherRatingVC : NavigationSearchBarDelegate{
    
    func textDidChange(searchBar: UISearchBar, searchText: String) {
        viewModel?.isSearching = true
       }
    
    func cancelButtonPress(uiSearchBar: UISearchBar) {
        viewModel?.isSearching = true
        DispatchQueue.main.async {
            //            self.viewModel?.getAllAssignSubjectList(classId: self.selectedClassId ?? 0, searchText: "", pageSize: KIntegerConstants.kInt1000, filterBy: 0, skip: KIntegerConstants.kInt0)
        }
    }
}

extension TeacherRatingVC : OKAlertViewDelegate{
    
    //Ok Button Clicked
    func okBtnAction() {
         okAlertView.removeFromSuperview()
    }
}
