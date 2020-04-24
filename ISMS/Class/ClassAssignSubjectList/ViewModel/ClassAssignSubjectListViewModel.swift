//
//  ClassAssignSubjectListPresenter.swift
//  ISMS
//
//  Created by Taranjeet Singh on 7/5/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation



protocol ClassAssignSubjectListDelegate: class {
    func unauthorizedUser()
    func classListDidSuccess(data : [GetClassListResultData]?)
    func classListDidFailed()
    func classSubjectDidSuccess(data : [GetAllAssignSubjectResultData]?)
    func classSubjectDidfailed()
    func assignSubjectsToClassDidSuccess(data: AssignSubjectsToClassResponseModel)
    func assignSubjectsToClassFailed()
}


class ClassAssignSubjectListViewModel{
    var isSearching : Bool?
    
    //Global ViewDelegate weak object
    private weak var classAssignSubjectListView : ViewDelegate?
    
    //ClassListDelegate weak object
    private weak var classAssignSubjectListDelegate : ClassAssignSubjectListDelegate?
    
    //Initiallize the presenter class using delegates
    init(delegate: ClassAssignSubjectListDelegate) {
        classAssignSubjectListDelegate = delegate
    }
    
    //Attach GlobalViewDelegate
    func attachView(viewDelegate : ViewDelegate){
        classAssignSubjectListView = viewDelegate
    }
    
    //Deattach View for free the memory from instances
    func deattachView(){
        classAssignSubjectListView = nil
        classAssignSubjectListDelegate = nil
    }
    
    //MARK:- Class list
    func classList(searchText: String,pageSize : Int,filterBy: Int,skip: Int){
        
        
        var postDict = [String:Any]()
        
        postDict[KApiParameters.KCommonParametersForList.kSearch] = searchText
        postDict[KApiParameters.KCommonParametersForList.kPageSize] = pageSize
        postDict[KApiParameters.KCommonParametersForList.kSortColumn] = ""
        postDict[KApiParameters.KCommonParametersForList.kSkip] = skip
        postDict[KApiParameters.KCommonParametersForList.kSortColumnDir] = ""
        
        self.classAssignSubjectListView?.showLoader()
        
        ClassApi.sharedManager.getClassList(url: ApiEndpoints.kGetClassList, parameters: postDict, completionResponse: { (classModel) in
            
            switch classModel.statusCode{
            case KStatusCode.kStatusCode200:
                self.classAssignSubjectListView?.hideLoader()
                self.classAssignSubjectListDelegate?.classListDidSuccess(data: classModel.resultData)
            case KStatusCode.kStatusCode401:
                self.classAssignSubjectListView?.hideLoader()
                if let msg = classModel.message{
                    self.classAssignSubjectListView?.showAlert(alert: msg)
                }
                self.classAssignSubjectListDelegate?.unauthorizedUser()
            default :
                self.classAssignSubjectListView?.hideLoader()
            }
         
        }, completionnilResponse: { (nilResponseError) in
            
            self.classAssignSubjectListView?.hideLoader()
            self.classAssignSubjectListDelegate?.classListDidFailed()
            
            if let error = nilResponseError{
                self.classAssignSubjectListView?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Class APi Nil response")
            }
            
        }) { (error) in
            self.classAssignSubjectListView?.hideLoader()
            self.classAssignSubjectListDelegate?.classListDidFailed()
            if let err = error?.localizedDescription{
                self.classAssignSubjectListView?.showAlert(alert: err)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Class APi error response")
            }
        }
    }

    //Get Subject List
    func getAllAssignSubjectList(classId: Int,searchText: String,pageSize : Int,filterBy: Int,skip: Int){
        
        
        var postDict = [String:Any]()
        
        postDict[KApiParameters.KCommonParametersForList.kSearch] = searchText
        postDict[KApiParameters.KCommonParametersForList.kPageSize] = pageSize
        postDict[KApiParameters.KCommonParametersForList.kSortColumn] = ""
        postDict[KApiParameters.KCommonParametersForList.kSkip] = skip
        postDict[KApiParameters.KCommonParametersForList.kSortColumnDir] = ""
        postDict[KApiParameters.KAddClassApiPerameters.kClassId] = classId
        
        if isSearching == false{
            self.classAssignSubjectListView?.showLoader()
        }
        
        ClassAssignSubjectApi.sharedInstance.getAllAssignSubjectList(url: ApiEndpoints.kGetAllAssignSubjectApi, parameters: postDict, completionResponse: { (response) in
            
            self.classAssignSubjectListView?.hideLoader()
            print("assign subjects: ",response.resultData)
            switch response.statusCode{
            case KStatusCode.kStatusCode200:
                self.classAssignSubjectListDelegate?.classSubjectDidSuccess(data: response.resultData)
            case KStatusCode.kStatusCode401:
                if let msg = response.message{
                    self.classAssignSubjectListView?.showAlert(alert: msg)
                }
                self.classAssignSubjectListDelegate?.unauthorizedUser()
            default:
                if let msg = response.message{
                    self.classAssignSubjectListView?.showAlert(alert: msg)
                }
                CommonFunctions.sharedmanagerCommon.println(object: "Get All Assign Subject APi status change")
            }
            
        }, completionnilResponse: { (nilResponseError) in
            
            self.classAssignSubjectListView?.hideLoader()
            self.classAssignSubjectListDelegate?.classListDidFailed()
            
            if let error = nilResponseError{
                self.classAssignSubjectListView?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Get All Assign Subject APi Nil response")
            }
            
        }) { (error) in
            self.classAssignSubjectListView?.hideLoader()
            self.classAssignSubjectListDelegate?.classListDidFailed()
            if let err = error{
                self.classAssignSubjectListView?.showAlert(alert: err)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Get All Assign Subject APi error response")
            }
        }
    }
    
    //MARK:- Assign Subjects to Class
    func assignSubjectsClass(classId: Int, classSubjectList: [AssignSubjectsToClassModel]){
        var postDict = [String:Any]()
        
        let classSubjectMapList = classSubjectList.map { (model) -> Dictionary<String, Any> in
            var selectedClassSubjectsDict = Dictionary<String, Any>()
            selectedClassSubjectsDict[KApiParameters.AssignSubjectToClassApi.kSubjectId] = model.subjectId
            selectedClassSubjectsDict[KApiParameters.AssignSubjectToClassApi.kClassSubjectId] = model.classSubjectId
            return selectedClassSubjectsDict
        }
        postDict[KApiParameters.AssignSubjectToClassApi.kClassId] = classId
        postDict[KApiParameters.AssignSubjectToClassApi.kClassSubjectModels] = classSubjectMapList

        CommonFunctions.sharedmanagerCommon.println(object: "\(classSubjectList) || Array:- \(classSubjectMapList)")
        print("submit data: ",postDict)
        self.classAssignSubjectListView?.showLoader()
        ClassAssignSubjectApi.sharedInstance.assignSubjectToClass(url: ApiEndpoints.kAssignSubjectsToClass, parameters: postDict, completionResponse: { (response) in
            self.classAssignSubjectListView?.hideLoader()
            switch response.statusCode{
            case KStatusCode.kStatusCode200:
                self.classAssignSubjectListDelegate?.assignSubjectsToClassDidSuccess(data: response)
            case KStatusCode.kStatusCode401:
                if let msg = response.message{
                    self.classAssignSubjectListView?.showAlert(alert: msg)
                }
                self.classAssignSubjectListDelegate?.unauthorizedUser()
            case KStatusCode.kStatusCode400:
                if let msg = response.message{
                    self.classAssignSubjectListView?.showAlert(alert: msg)
                }
                self.classAssignSubjectListDelegate?.assignSubjectsToClassFailed()
            default:
                if let msg = response.message{
                    self.classAssignSubjectListView?.showAlert(alert: msg)
                }
                CommonFunctions.sharedmanagerCommon.println(object: "Assign Subject to class APi status change")
            }
        }, completionnilResponse: { (nilResponseError) in
            self.classAssignSubjectListView?.hideLoader()
            self.classAssignSubjectListDelegate?.assignSubjectsToClassFailed()
            if let error = nilResponseError{
                self.classAssignSubjectListView?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Assign Subject to class APi Nil response")
            }
        }) { (error) in
            self.classAssignSubjectListView?.hideLoader()
            self.classAssignSubjectListDelegate?.assignSubjectsToClassFailed()
            if let err = error{
                self.classAssignSubjectListView?.showAlert(alert: err)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Assign Subject to class APi error response")
            }
        }
    }
}
//MARK:- UISearchController Bar Delegates
extension ClassAssignSubjectListVC : NavigationSearchBarDelegate{
    
    func textDidChange(searchBar: UISearchBar, searchText: String) {
        viewModel?.isSearching = true
        arrAllAssignedSubjects.removeAll()
        self.viewModel?.getAllAssignSubjectList(classId: self.selectedClassId ?? 0, searchText: searchText, pageSize: KIntegerConstants.kInt1000, filterBy: 0, skip: KIntegerConstants.kInt0)
    }
    
    func cancelButtonPress(uiSearchBar: UISearchBar) {
        viewModel?.isSearching = true
        DispatchQueue.main.async {
            self.viewModel?.getAllAssignSubjectList(classId: self.selectedClassId ?? 0, searchText: "", pageSize: KIntegerConstants.kInt1000, filterBy: 0, skip: KIntegerConstants.kInt0)
        }
    }
}
