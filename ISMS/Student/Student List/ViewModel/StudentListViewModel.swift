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
    func StudentSessionListDidSuccess(data : GetStudentSessionResultData?)
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
        
        
        print("param: ",paramDict)
        AdStudentApi.sharedInstance.getStudentList(url: ApiEndpoints.KStudentListApi, parameters: paramDict as [String : Any], completionResponse: { (StudentListModel) in
            print("student list: ",StudentListModel.resultData)
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
            print("delete data: ",deleteModel)
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
            
            print("clas id : ",responseModel.resultData)
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
    
    func studenSessiontList(classId : Int){
        self.StudentListVC?.showLoader()
               
        let paramDict = ["classId": classId ?? 0,"sessionId":2] as [String : Any]
        
        
        print("param: ",paramDict)
        AdStudentApi.sharedInstance.getStudentSessionList(url: "api/User/GetStudentListByClassId", parameters: paramDict as [String : Any], completionResponse: { (StudentSessionModel) in
            print("student list: ",StudentSessionModel.resultData)
            if StudentSessionModel.statusCode == KStatusCode.kStatusCode200{
                self.StudentListVC?.hideLoader()
                self.StudentListDelegate?.StudentSessionListDidSuccess(data: StudentSessionModel.resultData)
            }else if StudentSessionModel.statusCode == KStatusCode.kStatusCode401{
                self.StudentListVC?.hideLoader()
                self.StudentListVC?.showAlert(alert: StudentSessionModel.message ?? "")
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
}

