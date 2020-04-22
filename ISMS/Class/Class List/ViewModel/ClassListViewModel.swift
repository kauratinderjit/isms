//
//  ClassListViewModel.swift
//  ISMS
//
//  Created by Taranjeet Singh on 6/18/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation


protocol ClassListDelegate: class {
    func unauthorizedUser()
    func classListDidSuccess(data : [GetClassListByDeptResultData]?)
    func classListDidFailed()
    func classDeleteDidSuccess(data : DeleteClassModel)
    func classDeleteDidfailed()
}

class ClassListViewModel{
    var isSearching : Bool?
    //Global ViewDelegate weak object
    private weak var classListView : ViewDelegate?
    
    //ClassListDelegate weak object
    private weak var classListDelegate : ClassListDelegate?
    
    //Initiallize the presenter class using delegates
    init(delegate: ClassListDelegate) {
        classListDelegate = delegate
    }
    
    //Attach GlobalViewDelegate
    func attachView(viewDelegate : ViewDelegate){
        classListView = viewDelegate
    }
    
    //Deattach View for free the memory from instances
    func deattachView(){
        classListView = nil
        classListDelegate = nil
    }
    
    //MARK:- Class list
    func classList(departmentId: Int){
        
        if isSearching == false{
            self.classListView?.showLoader()
        }
        
        var postDict = [String:Any]()
        
        postDict["departmentId"] = departmentId
       
       let url = "api/Institute/GetClassListByDepartmentId" + "?departmentId=" + "\(departmentId)"
        
        
        ClassApi.sharedManager.getClassListAccnToDepartment(url: url, parameters: postDict, completionResponse: { (GetClassListByDepartmentModel) in
            
            self.classListView?.hideLoader()

            switch GetClassListByDepartmentModel.statusCode{
            case KStatusCode.kStatusCode200:
                self.classListDelegate?.classListDidSuccess(data: GetClassListByDepartmentModel.resultData)
            case KStatusCode.kStatusCode401:
                if let msg = GetClassListByDepartmentModel.message{
                    self.classListView?.showAlert(alert: msg)
                }
                self.classListDelegate?.unauthorizedUser()
            default:
                if let msg = GetClassListByDepartmentModel.message{
                    self.classListView?.showAlert(alert: msg)
                }
            }
        }, completionnilResponse: { (nilResponseError) in
            
            self.classListView?.hideLoader()
            self.classListDelegate?.classListDidFailed()
            
            if let error = nilResponseError{
                self.classListView?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Class APi Nil response")
            }
            
        }) { (error) in
            self.classListView?.hideLoader()
            self.classListDelegate?.classListDidFailed()
            if let err = error?.localizedDescription{
                self.classListView?.showAlert(alert: err)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Class APi error response")
            }
        }
    }
    
    //MARK:- delete Class
    func deleteClass(classId: Int){
        
        self.classListView?.showLoader()
        ClassApi.sharedManager.deleteClassApi(url: ApiEndpoints.kDeleteClass+"?classId=\(classId)", completionResponse: {deleteModel in
            
            self.classListView?.hideLoader()
            
            switch deleteModel.statusCode{
            case KStatusCode.kStatusCode200:
                if let msg = deleteModel.message{
                    self.classListView?.showAlert(alert: msg)
                }
                self.classListDelegate?.classDeleteDidSuccess(data: deleteModel)
            case KStatusCode.kStatusCode401:
                    if let res = deleteModel.message{
                        self.classListView?.showAlert(alert: res)
                    }
                    self.classListDelegate?.unauthorizedUser()
            default:
                if let msg = deleteModel.message{
                    self.classListView?.showAlert(alert: msg)
                }
            }
        }, completionnilResponse: { (nilResponse) in
            
            self.classListView?.hideLoader()
            if let res = nilResponse{
                self.classListView?.showAlert(alert: res)
            }
            
        }) { (error) in
            self.classListView?.hideLoader()
            if let err = error{
                self.classListView?.showAlert(alert: err.localizedDescription)
            }
        }
    }
}
