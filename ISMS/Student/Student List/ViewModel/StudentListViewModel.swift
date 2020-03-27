//
//  StudentListViewModel.swift
//  ISMS
//
//  Created by Poonam Sharma on 6/27/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation

protocol StudentListDelegate: class {
    func unauthorizedUser()
    func StudentListDidSuccess(data : [GetStudentResultData]?)
    func StudentListDidFailed()
    func StudentDeleteDidSuccess()
    func StudentDeleteDidfailed()
    func StudentDeleteSuccess(Data: DeleteStudentModel)
    func getClassdropdownDidSucceed(data : GetCommonDropdownModel)
    
}
class StudentListViewModel{
    
    //Global ViewDelegate weak object
    private weak var StudentListVC : ViewDelegate?
    
    //StudentListDelegate weak object
    private weak var StudentListDelegate : StudentListDelegate?
    
    //Initiallize the presenter StudentList using delegates
    init(delegate:StudentListDelegate) {
        StudentListDelegate = delegate
    }
    
    //Attach GlobalViewDelegate
    func attachView(viewDelegate : ViewDelegate){
        StudentListVC = viewDelegate
    }
    
    //Deattach View for free the memory from instances
    func deattachView(){
        StudentListVC = nil
        StudentListDelegate = nil
    }
    
    func studentList(classId: Int?,Search: String?,Skip: Int?,PageSize: Int){
        self.StudentListVC?.showLoader()
        
        let paramDict = [KApiParameters.StudentListApi.StudentClassId: classId ?? 0,KApiParameters.StudentListApi.StudentSearch:Search ?? "",KApiParameters.StudentListApi.PageSkip: Skip ?? 10,KApiParameters.StudentListApi.PageSize: PageSize] as [String : Any]
        
        AdStudentApi.sharedInstance.getStudentList(url: ApiEndpoints.KStudentListApi, parameters: paramDict as [String : Any], completionResponse: { (StudentListModel) in
            
            if StudentListModel.statusCode == KStatusCode.kStatusCode200{
                self.StudentListVC?.hideLoader()
                self.StudentListDelegate?.StudentListDidSuccess(data: StudentListModel.resultData)
            }else if StudentListModel.statusCode == KStatusCode.kStatusCode401{
                self.StudentListVC?.hideLoader()
                self.StudentListVC?.showAlert(alert: StudentListModel.message ?? "")
                self.StudentListDelegate?.unauthorizedUser()
            }else{
                self.StudentListVC?.hideLoader()
                CommonFunctions.sharedmanagerCommon.println(object: "student APi status change")
            }
            
        }, completionnilResponse: { (nilResponseError) in
            
            self.StudentListVC?.hideLoader()
            self.StudentListDelegate?.StudentListDidFailed()
            
            if let error = nilResponseError{
                self.StudentListVC?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "student APi Nil response")
            }
            
        }) { (error) in
            self.StudentListVC?.hideLoader()
            self.StudentListDelegate?.StudentListDidFailed()
            if let err = error?.localizedDescription{
                self.StudentListVC?.showAlert(alert: err)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "student APi error response")
            }
        }
        
    }
    
    func deleteStudent(enrollmentId: Int){
        print("delete id : ",enrollmentId)
        self.StudentListVC?.showLoader()
        AdStudentApi.sharedInstance.deleteStudentApi(url: ApiEndpoints.KDeleteStudent+"\(enrollmentId)", completionResponse: {deleteModel in
            
            if deleteModel.statusCode == KStatusCode.kStatusCode200{
                
                if deleteModel.status == true{
                    CommonFunctions.sharedmanagerCommon.println(object: "delete student true")
                    self.StudentListVC?.hideLoader()
                    self.StudentListDelegate?.StudentDeleteSuccess(Data: deleteModel)
                }else{
                    CommonFunctions.sharedmanagerCommon.println(object: "delete student false")
                    self.StudentListVC?.hideLoader()
                    self.StudentListVC?.showAlert(alert: deleteModel.message ?? Alerts.kServerErrorAlert)
                }
                
            }else{
                self.StudentListVC?.hideLoader()
                if let msg = deleteModel.message{
                    self.StudentListVC?.showAlert(alert: msg)
                    
                }
                CommonFunctions.sharedmanagerCommon.println(object: "Status code is diffrent.")
            }
            
        }, completionnilResponse: { (nilResponse) in
            
            self.StudentListVC?.hideLoader()
            if let res = nilResponse{
                self.StudentListVC?.showAlert(alert: res)
            }
            
        }) { (error) in
            self.StudentListVC?.hideLoader()
            if let err = error{
                self.StudentListVC?.showAlert(alert: err.localizedDescription)
            }
        }
        
    }
    
    func getClassId(id: Int?, enumtype: Int?){
        guard let selectId = id else{ return }
        guard let enumType = enumtype else { return }
        
        self.StudentListVC?.showLoader()
        
        AdStudentApi.sharedInstance.getClassDropdownData(id: selectId, enumType: enumType, completionResponse: { (responseModel) in
            self.StudentListVC?.hideLoader()
            self.StudentListDelegate?.getClassdropdownDidSucceed(data: responseModel)
            
        }, completionnilResponse: { (nilResponse) in
            self.StudentListVC?.hideLoader()
            if let nilRes = nilResponse{
                self.StudentListVC?.showAlert(alert: nilRes)
            }
        }) { (error) in
            self.StudentListVC?.hideLoader()
            if let err = error{
                self.StudentListVC?.showAlert(alert: err.localizedDescription)
            }
        }
    }
}

extension StudentListVC : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 109;//Choose your custom row height
    }
    
}
extension StudentListVC : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrStudentlist.count > 0{
            tableView.separatorStyle = .singleLine
            return (arrStudentlist.count)
        }else{
            tblViewCenterLabel(tblView: tableView, lblText: KConstants.kNoDataFound, hide: false)
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: KTableViewCellIdentifier.kStudentTableViewCell, for: indexPath) as! StudentListTableCell
        
        cell.setCellUI(data: arrStudentlist, indexPath: indexPath)
        return cell
    }
}

extension StudentListVC : StudentListDelegate{
    func unauthorizedUser() {
        isUnauthorizedUser = true
    }
    func getClassdropdownDidSucceed(data : GetCommonDropdownModel){
        classData = data
        if let count = data.resultData?.count{
            if count > 0 {
                UpdatePickerModel(count: classData?.resultData?.count ?? 0, sharedPickerDelegate: self, View:  self.view)
            }else{
                print("Department Count is zero.")
            }
        }
    }
    
    func StudentDeleteSuccess(Data: DeleteStudentModel) {
        
        isStudentDelete = true
        initializeCustomOkAlert(self.view, isHideBlurView: true)
        okAlertView.delegate = self
        okAlertView.lblResponseDetailMessage.text = Data.message
      
    }
    
    func StudentDeleteDidSuccess() {
        
    }
    
    func StudentListDidSuccess(data : [GetStudentResultData]?) {
        isFetching = true
        if data != nil{
            if data?.count ?? 0 > 0{
                guard let rsltData = data else{
                    return
                }
                
                tableView.delegate = self
                tableView.dataSource = self
                
                //When user select the class for change the data in list selected 
                if isClassSelected == true{
                    arrStudentlist.removeAll()
                    _ = rsltData.map({ (data) in
                        arrStudentlist.append(data)
                    })
                    self.tblViewCenterLabel(tblView: tableView, lblText: "", hide: true)
                }else{
                    for value in rsltData{
                        let containsSameValue = arrStudentlist.contains(where: {$0.enrollmentId == value.enrollmentId})
                        if containsSameValue == false{
                            arrStudentlist.append(value)
                        }
                    }
                    self.tblViewCenterLabel(tblView: tableView, lblText: "", hide: true)
                }
            }else{
                //Remove the array student list
                if isClassSelected == true{
                    arrStudentlist.removeAll()
                }
//                self.tblViewCenterLabel(tblView: tableView, lblText: KConstants.kNoDataFound, hide: false)
//                CommonFunctions.sharedmanagerCommon.println(object: "Zero")
            }
        }else{
            arrStudentlist.removeAll()
            self.tblViewCenterLabel(tblView: tableView, lblText: KConstants.kNoDataFound, hide: false)
//            CommonFunctions.sharedmanagerCommon.println(object: "Nil")
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    func StudentListDidFailed() {
        
    }
    
    
    func StudentDeleteDidfailed() {
        
    }
    
}

extension StudentListVC : ViewDelegate{
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
    
    func alertForRemoveStudent(){
        let alertController = UIAlertController(title: KAPPContentRelatedConstants.kAppTitle, message: Alerts.kDeleteStudentAlert, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
            UIAlertAction in
            
            if let enrollmentId1 = self.enrollmentId{
                self.ViewModel?.deleteStudent(enrollmentId: enrollmentId1)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Delete Student id is nil")
            }
            
        }
        let cancelAction = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
    
}
extension StudentListVC: SharedUIPickerDelegate{
    func DoneBtnClicked() {
        if let count = classData.resultData?.count{
            if count > 0{
                //Bool for set the array in the list of students for selected class
                isClassSelected = true
                
                if selectedClassIndex == 0{
                    self.dropDownTextField.text = self.classData?.resultData?[0].name
                    self.selectedClassID = self.classData?.resultData?[0].id ?? 0
                    self.ViewModel?.studentList(classId : selectedClassID, Search: "", Skip: 0, PageSize: 1000)
                }else{
                    self.dropDownTextField.text = self.classData?.resultData?[selectedClassIndex].name
                    self.selectedClassID = self.classData?.resultData?[selectedClassIndex].id ?? 0
                    self.ViewModel?.studentList(classId : selectedClassID, Search: "", Skip: 0, PageSize: 1000)
                }
            }
        }
    }
    
    func GetTitleForRow(index: Int) -> String {
        if let count = classData.resultData?.count{
            if count > 0{
                dropDownTextField.text = classData?.resultData?[0].name
                selectedClassID = classData?.resultData?[0].id ?? 0
                selectedClassIndex = 0
                return classData?.resultData?[index].name ?? ""
            }
        }
        return ""
    }
    
    
    func SelectedRow(index: Int) {
        
        //Using Exist Method of collection prevent from indexoutof range error
        if let count = classData.resultData?.count{
            if count > 0{
                if (self.classData.resultData?[exist: index]?.name) != nil{
                    self.dropDownTextField.text = self.classData?.resultData?[index].name
                    self.selectedClassID = self.classData?.resultData?[index].id ?? 0
                    self.selectedClassIndex = index
                    print("Selected Department:- \(String(describing: self.classData?.resultData?[index].name))")
                }
            }
        }
    }
    
    func cancelButtonClicked() {
        isClassSelected = true
    }
    
}

extension StudentListVC : NavigationSearchBarDelegate{
    func textDidChange(searchBar: UISearchBar, searchText: String) {
        DispatchQueue.main.async {
            self.arrStudentlist.removeAll()
            self.ViewModel?.studentList(classId : 0, Search: searchText, Skip: KIntegerConstants.kInt0, PageSize: KIntegerConstants.kInt10)
        }
    }
    
    func cancelButtonPress(uiSearchBar: UISearchBar) {
        DispatchQueue.main.async {
            self.arrStudentlist.removeAll()
            self.ViewModel?.studentList(classId : 0, Search: "", Skip: KIntegerConstants.kInt0, PageSize: KIntegerConstants.kInt10)
        }
    }
}

//MARK:- Scroll View delegates
extension StudentListVC : UIScrollViewDelegate{
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if(velocity.y>0) {
            //Code will work without the animation block.I am using animation block incase if you want to set any delay to it.
            UIView.animate(withDuration: 2.5, delay: 0, options: UIView.AnimationOptions(), animations: {
                self.navigationController?.setNavigationBarHidden(true, animated: true)
            }, completion: nil)
            
        } else {
            UIView.animate(withDuration: 2.5, delay: 0, options: UIView.AnimationOptions(), animations: {
                self.navigationController?.setNavigationBarHidden(false, animated: true)
            }, completion: nil)
        }
        
        if (tableView.contentOffset.y < pointNow.y)
        {
            CommonFunctions.sharedmanagerCommon.println(object: "Down scroll view")
            isScrolling = true
        }
        else if (tableView.contentOffset.y + tableView.frame.size.height >= tableView.contentSize.height)
        {
            isScrolling = true
            if (isFetching == true)
            {
                if isClassSelected == true{
                    debugPrint("Class Selected true:- \(isClassSelected)")
                }else{
                    skip = skip + KIntegerConstants.kInt10
                    isFetching = false
                    self.ViewModel?.studentList(classId : 0, Search: "", Skip: skip, PageSize: pageSize)
                }
            }
        }else{
            CommonFunctions.sharedmanagerCommon.println(object: "Scrolling")
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        pointNow = scrollView.contentOffset
    }
    
    
}

