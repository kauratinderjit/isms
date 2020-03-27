//
//  StudentRatingViewModel.swift
//  ISMS
//
//  Created by Kuldeep Singh on 11/27/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation


protocol StudentRatingDelegate : class {
    func StudentRatingDidSucceed()
    func StudentRatingDidFailour()
     func classListDidSuccess(data : [GetClassListResultData]?)
     func SubjectListDidSuccess(data: [GetSubjectResultData]?)
    func StudentRatingListDidSucceed(data : [StudentRatingResultData])
}


class StudentRatingViewModel {
        var isSearching : Bool?
  private  weak var studentRatingView : ViewDelegate?
  private  weak var studentRatingDelegate : StudentRatingDelegate?
    
    //Initiallize the presenter class using delegates
    init(delegate: StudentRatingDelegate) {
        studentRatingDelegate = delegate
    }
    
    //Attach GlobalViewDelegate
    func attachView(viewDelegate : ViewDelegate){
        studentRatingView = viewDelegate
    }
    
    //Deattach View for free the memory from instances
    func deattachView(){
        studentRatingView = nil
        studentRatingDelegate = nil
    }
    
    
    
    


    
    
    //MARK:- Class list
    func classList(searchText: String,pageSize : Int,filterBy: Int,skip: Int){
        
        if self.isSearching == false {
            self.studentRatingView?.showLoader()
        }
        
        var postDict = [String:Any]()
        
        postDict[KApiParameters.KCommonParametersForList.kSearch] = searchText
        postDict[KApiParameters.KCommonParametersForList.kPageSize] = pageSize
        postDict[KApiParameters.KCommonParametersForList.kSortColumn] = ""
        postDict[KApiParameters.KCommonParametersForList.kSkip] = skip
        postDict[KApiParameters.KCommonParametersForList.kSortColumnDir] = ""
        
        
        
        ClassApi.sharedManager.getClassList(url: ApiEndpoints.kGetClassList, parameters: postDict, completionResponse: { (classModel) in
            
            self.studentRatingView?.hideLoader()
            
            switch classModel.statusCode{
            case KStatusCode.kStatusCode200:
          self.studentRatingDelegate?.classListDidSuccess(data: classModel.resultData)
            case KStatusCode.kStatusCode401:
                if let msg = classModel.message{
                    self.studentRatingView?.showAlert(alert: msg)
                }
              //  self.classListDelegate?.unauthorizedUser()
            default:
                if let msg = classModel.message{
                    self.studentRatingView?.showAlert(alert: msg)
                }
            }
        }, completionnilResponse: { (nilResponseError) in
            
            self.studentRatingView?.hideLoader()
          self.studentRatingDelegate?.StudentRatingDidFailour()
            
            if let error = nilResponseError{
                self.studentRatingView?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Class APi Nil response")
            }
            
        }) { (error) in
            self.studentRatingView?.hideLoader()
            //  self.studentRatingDelegate?.StudentRatingDidFailour()
            if let err = error?.localizedDescription{
                self.studentRatingView?.showAlert(alert: err)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Class APi error response")
            }
        }
    }
    
    //MARK:- SUBJECT LIST
    func subjectList(search : String?,skip : Int?,pageSize: Int?,sortColumnDir: String?,sortColumn: String?, particularId : Int){
        self.studentRatingView?.showLoader()
        
        let paramDict = [KApiParameters.SubjectListApi.subjectSearch: search ?? "",KApiParameters.SubjectListApi.PageSkip:skip ?? 0,KApiParameters.SubjectListApi.PageSize: pageSize ?? 0,KApiParameters.SubjectListApi.sortColumnDir: sortColumnDir ?? "", KApiParameters.SubjectListApi.sortColumn: sortColumn ?? "",
                         KApiParameters.kUpdateSyllabusApiParameter.kParticularId : particularId] as [String : Any]
        
        SubjectApi.sharedInstance.getSubjectList(url: ApiEndpoints.KSubjectListApi, parameters: paramDict as [String : Any], completionResponse: { (SubjectListModel) in
            
            if SubjectListModel.statusCode == KStatusCode.kStatusCode200{
                self.studentRatingView?.hideLoader()
                self.studentRatingDelegate?.SubjectListDidSuccess(data: SubjectListModel.resultData)
            }else if SubjectListModel.statusCode == KStatusCode.kStatusCode401{
                self.studentRatingView?.hideLoader()
                self.studentRatingView?.showAlert(alert: SubjectListModel.message ?? "")
              //  self.SubjectListDelegate?.unauthorizedUser()
            }else{
                self.studentRatingView?.hideLoader()
                CommonFunctions.sharedmanagerCommon.println(object: "student APi status change")
            }
            
        }, completionnilResponse: { (nilResponseError) in
            
            self.studentRatingView?.hideLoader()
         //   self.SubjectListDelegate?.SubjectListDidFailed()
            
            if let error = nilResponseError{
                self.studentRatingView?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "student APi Nil response")
            }
            
        }) { (error) in
            self.studentRatingView?.hideLoader()
         //   self.SubjectListDelegate?.SubjectListDidFailed()
            if let err = error?.localizedDescription{
                self.studentRatingView?.showAlert(alert: err)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "student APi error response")
            }
        }
        
    }
    func getCurrentDate() -> String {
        
        let date = Date()
        let monthString = date.month
        print("your printed month is :\(monthString)")
    
        return monthString
    }
    
    
    
    //MARK:- SUBJECT LIST
    func studentList(search : String?,skip : Int?,pageSize: Int?,sortColumnDir: String?,sortColumn: String?, classSubjectID : Int , classID : Int){
        self.studentRatingView?.showLoader()
        
        let paramDict = [ "ClassId":classID,
                          "ClassSubjectId": classSubjectID] as [String : Any]
        
        StudentRatingApi.sharedInstance.GetStudentList(url: ApiEndpoints.kStudentRating, parameters: paramDict as [String : Any], completionResponse: { (StudentRatingListModel) in
            
            if StudentRatingListModel.statusCode == KStatusCode.kStatusCode200{
                self.studentRatingView?.hideLoader()
                self.studentRatingDelegate?.StudentRatingListDidSucceed(data : StudentRatingListModel.resultData!)
            }else if StudentRatingListModel.statusCode == KStatusCode.kStatusCode401{
                self.studentRatingView?.hideLoader()
                self.studentRatingView?.showAlert(alert: StudentRatingListModel.message ?? "")
                //  self.SubjectListDelegate?.unauthorizedUser()
            }else{
                self.studentRatingView?.hideLoader()
                CommonFunctions.sharedmanagerCommon.println(object: "student APi status change")
            }
            
        }, completionnilResponse: { (nilResponseError) in
            
            self.studentRatingView?.hideLoader()
            //   self.SubjectListDelegate?.SubjectListDidFailed()
            
            if let error = nilResponseError{
                self.studentRatingView?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "student APi Nil response")
            }
            
        }) { (error) in
            self.studentRatingView?.hideLoader()
            //   self.SubjectListDelegate?.SubjectListDidFailed()
//            if let err = error?.localizedDescription{
//                self.studentRatingView?.showAlert(alert: err)
//            }else{
//                CommonFunctions.sharedmanagerCommon.println(object: "student APi error response")
//            }
        }
        
    }
    
}

//MARK:- Student Rating Delegate
extension StudentRatingVC : StudentRatingDelegate {
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
                       // self.tblViewCenterLabel(tblView: tableView, lblText: "", hide: true)
                    }
                    if let id = arrClassList[0].classId {
                        self.viewModel?.subjectList(search : "",skip : KIntegerConstants.kInt0,pageSize: pageSize,sortColumnDir: "",sortColumn: "", particularId: id)
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
    
    func SubjectListDidSuccess(data: [GetSubjectResultData]?) {
        isFetching = true
        if data != nil{
            if data?.count ?? 0 > 0{
                for value in data!{
                    let containsSameValue = arrSubjectlist.contains(where: {$0.subjectId == value.subjectId})
                    if containsSameValue == false{
                        arrSubjectlist.append(value)
                        if let subjectName = arrSubjectlist[0].subjectName {
                        txtfieldSubject.text = subjectName
//                            if let id = arrSubjectlist[0].subjectId {
//                                if let classid = selectedClassId {
                            
//                                }
//                            }
                        }
                    }
                  //  self.tblViewCenterLabel(tblView: tableView, lblText: "", hide: true)
                }
                 self.viewModel?.studentList(search: "", skip: 0, pageSize: KIntegerConstants.kInt0, sortColumnDir: "", sortColumn: "", classSubjectID:33, classID: 14 )
                
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
extension StudentRatingVC : SharedUIPickerDelegate{
    func DoneBtnClicked() {
        if checkInternetConnection(){
//            arrAllAssignedSubjects.removeAll()
            if isClassSelected == true {
                if let index = selectedClassArrIndex {
            if let id = arrClassList[index].classId {
                self.viewModel?.subjectList(search : "",skip : KIntegerConstants.kInt0,pageSize: pageSize,sortColumnDir: "",sortColumn: "", particularId: id)
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
                txtfieldSubject.text = arrSubjectlist[0].subjectName
                return arrSubjectlist[index].subjectName ?? ""
            }
        }
        else if isMonthSelected == true {
            if arrMonthlist.count > 0 {
                textfieldMonth.text = arrMonthlist[0]
                return arrMonthlist[index] ?? ""
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
                selectedSubjectId = arrSubjectlist[index].subjectId
                txtfieldSubject.text = arrSubjectlist[index].subjectName
            }
            
        }
        else if isMonthSelected == true {
            if arrMonthlist.count > 0 {
                textfieldMonth.text = arrMonthlist[index]
            }
        }
        
    }
}


//MARK:- View Delegate
extension StudentRatingVC : ViewDelegate{
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
        self.title = KStoryBoards.KClassListIdentifiers.kStudentRating
        
        self.tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        
        self.viewModel?.isSearching = false
        
       
    }
}
extension StudentRatingVC : UITableViewDelegate {

    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let storyboard = UIStoryboard.init(name: "Student", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddStudentRatingVC") as! AddStudentRatingVC
        if currentMonth == textfieldMonth.text! {
            //User can edit or not
            vc.type = "Edit"
        }
        else {
            vc.type = "Show"
        }
        if let name = arrStudent[indexPath.row].studentName {
        vc.studentName = name
        }
        if let className = txtfieldClass.text {
            vc.className = className
        }
        if let subjectName = txtfieldSubject.text {
            vc.subjectName = subjectName
        }
        
        if let classid = selectedClassId {
            vc.selectedClassId = classid
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
extension StudentRatingVC : UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return arrStudent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StudentRating.kStudentRatingCell, for: indexPath) as! StudentRatingTableViewCell
        if let name = arrStudent[indexPath.row].studentName {
        cell.lblStudentName.text = name
        }
        
        if let rating = arrStudent[indexPath.row].studentRating {
            cell.lblPercentage.text = rating
        }
        return cell
       
    }
    
}


//MARK:- UISearchController Bar Delegates
extension StudentRatingVC : NavigationSearchBarDelegate{
    
    func textDidChange(searchBar: UISearchBar, searchText: String) {
        viewModel?.isSearching = true
      //  arrAllAssignedSubjects.removeAll()
//        self.viewModel?.getAllAssignSubjectList(classId: self.selectedClassId ?? 0, searchText: searchText, pageSize: KIntegerConstants.kInt1000, filterBy: 0, skip: KIntegerConstants.kInt0)
    }
    
    func cancelButtonPress(uiSearchBar: UISearchBar) {
        viewModel?.isSearching = true
        DispatchQueue.main.async {
//            self.viewModel?.getAllAssignSubjectList(classId: self.selectedClassId ?? 0, searchText: "", pageSize: KIntegerConstants.kInt1000, filterBy: 0, skip: KIntegerConstants.kInt0)
        }
    }
}

extension StudentRatingVC : OKAlertViewDelegate{
    
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

extension Date {
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self)
    }
}
