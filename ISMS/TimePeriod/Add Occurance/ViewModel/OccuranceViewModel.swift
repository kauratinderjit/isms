//
//  OccuranceViewModel.swift
//  ISMS
//
//  Created by Poonam  on 09/06/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import Foundation
protocol OccuranceDelegate: class {
    func unauthorizedUser()
    func getClassdropdownDidSucceed(data : GetCommonDropdownModel)
    func GetSubjectListDidSucceed(data:[AddStudentRatingResultData]?)
    func GetOccuranceDidSucceed(data:AddSubjectModel)
}
class OccuranceViewModel{
    
    //Global ViewDelegate weak object
    private weak var ListVC : ViewDelegate?
    
    //StudentListDelegate weak object
    private weak var OccuranceDelegate : OccuranceDelegate?
    
    //Initiallize the presenter StudentList using delegates
    init(delegate:OccuranceDelegate) {
        OccuranceDelegate = delegate
    }
    
    //Attach GlobalViewDelegate
    func attachView(viewDelegate : ViewDelegate){
        ListVC = viewDelegate
    }
    
    //Deattach View for free the memory from instances
    func deattachView(){
        ListVC = nil
        OccuranceDelegate = nil
    }
    
    func getClassId(id: Int?, enumtype: Int?){
        guard let selectId = id else{ return }
        guard let enumType = enumtype else { return }
        
        self.ListVC?.showLoader()
        
        AdStudentApi.sharedInstance.getClassDropdownData(id: selectId, enumType: enumType, completionResponse: { (responseModel) in
            print("clas id : ",responseModel.resultData)
            self.ListVC?.hideLoader()
            self.OccuranceDelegate?.getClassdropdownDidSucceed(data: responseModel)
        }, completionnilResponse: { (nilResponse) in
            self.ListVC?.hideLoader()
            if let nilRes = nilResponse{
                self.ListVC?.showAlert(alert: nilRes)
            }
        }) { (error) in
            self.ListVC?.hideLoader()
            if let err = error{
                self.ListVC?.showAlert(alert: err.localizedDescription)
            }
        }
    }
    
    func GetSubjectList(classid: Int,teacherId: Int, hodid: Int){
        self.ListVC?.showLoader()
        let paramDict = ["classid":classid,"teacherId" : teacherId] as [String : Any]
        let url = ApiEndpoints.kGetClassSubjectsByteacherId + "?classid=" + "\(classid)" + "&teacherId=" + "\(teacherId)" + "&hodid=" + "\(hodid)"
        AddStudentRatingApi.sharedInstance.GetAddSkillList(url: url , parameters: paramDict as [String : Any], completionResponse: { (AddStudentRatingListModel) in
            
            print("your respomnse subjectdata : ",AddStudentRatingListModel.resultData)
            
            if AddStudentRatingListModel.statusCode == KStatusCode.kStatusCode200 {
                self.ListVC?.hideLoader()
                
                self.OccuranceDelegate?.GetSubjectListDidSucceed(data:AddStudentRatingListModel.resultData!)
                
            }else if AddStudentRatingListModel.statusCode == KStatusCode.kStatusCode401 {
                self.ListVC?.hideLoader()
                self.ListVC?.showAlert(alert: AddStudentRatingListModel.message ?? "")
                  self.OccuranceDelegate?.unauthorizedUser()
            }else{
                self.ListVC?.hideLoader()
                CommonFunctions.sharedmanagerCommon.println(object: "student APi status change")
            }
            
        }, completionnilResponse: { (nilResponseError) in
            
            self.ListVC?.hideLoader()
            //   self.SubjectListDelegate?.SubjectListDidFailed()
            
            if let error = nilResponseError{
                self.ListVC?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "student APi Nil response")
            }
            
        }) { (error) in
            self.ListVC?.hideLoader()
            //   self.SubjectListDelegate?.SubjectListDidFailed()
            //            if let err = error?.localizedDescription{
            //                self.studentRatingView?.showAlert(alert: err)
            //            }else{
            //                CommonFunctions.sharedmanagerCommon.println(object: "student APi error response")
            //            }
        }
        
    }
    
    func GetOccurance(classid: Int,subjectId: Int){
        self.ListVC?.showLoader()
        let paramDict = ["ClassId":classid,"classSubjectId" : subjectId] as [String : Any]
        let url = "api/Institute/GetOccuranceByClassId" + "?ClassId=" + "\(classid)" + "&classSubjectId=" + "\(subjectId)"
        AddStudentRatingApi.sharedInstance.GetAddOccrance(url: url , parameters: paramDict as [String : Any], completionResponse: { (AddSubjectModel) in
            
            print("your respomnse subjectdata : ",AddSubjectModel.resultData)
            
            if AddSubjectModel.statusCode == KStatusCode.kStatusCode200 {
                self.ListVC?.hideLoader()
                
                self.OccuranceDelegate?.GetOccuranceDidSucceed(data:AddSubjectModel)
                
            }else if AddSubjectModel.statusCode == KStatusCode.kStatusCode401 {
                self.ListVC?.hideLoader()
                self.ListVC?.showAlert(alert: AddSubjectModel.message ?? "")
                  self.OccuranceDelegate?.unauthorizedUser()
            }else{
                self.ListVC?.hideLoader()
                CommonFunctions.sharedmanagerCommon.println(object: "student APi status change")
            }
            
        }, completionnilResponse: { (nilResponseError) in
            
            self.ListVC?.hideLoader()
            //   self.SubjectListDelegate?.SubjectListDidFailed()
            
            if let error = nilResponseError{
                self.ListVC?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "student APi Nil response")
            }
            
        }) { (error) in
            self.ListVC?.hideLoader()
            //   self.SubjectListDelegate?.SubjectListDidFailed()
            //            if let err = error?.localizedDescription{
            //                self.studentRatingView?.showAlert(alert: err)
            //            }else{
            //                CommonFunctions.sharedmanagerCommon.println(object: "student APi error response")
            //            }
        }
    }
    
    func submitOccurance(ClassId : Int,ClassSubjectId: Int,Occurrence: Int){
        let parameters = ["ClassId":ClassId,"ClassSubjectId":ClassSubjectId,"Occurrence":Occurrence] as [String : Any]
         print(parameters)
        self.ListVC?.showLoader()
        SubjectApi.sharedInstance.AddSubject(url: "api/Institute/UpdateOccurrenceAssignedSubjectToTeacher", parameters: parameters, completionResponse: { (responseModel) in
            print(responseModel)
            
            self.ListVC?.hideLoader()
            if responseModel.statusCode == KStatusCode.kStatusCode200{
                
                if responseModel.resultData != nil{
                    self.ListVC?.showAlert(alert: responseModel.message ?? "")
                }else{
                    self.ListVC?.showAlert(alert: responseModel.message ?? "")
                }
                
            }else if responseModel.statusCode == KStatusCode.kStatusCode401{
                self.ListVC?.showAlert(alert: responseModel.message ?? "")
                self.OccuranceDelegate?.unauthorizedUser()
            }
            
            if responseModel.statusCode == KStatusCode.kStatusCode400{
                self.ListVC?.showAlert(alert: responseModel.message ?? "")
            }
            
        }, completionnilResponse: { (nilResponse) in
            self.ListVC?.hideLoader()
            self.ListVC?.showAlert(alert: nilResponse ?? Alerts.kMapperModelError)
        }) { (error) in
            self.ListVC?.hideLoader()
            self.ListVC?.showAlert(alert: error.debugDescription)
            
            
        }
    }
    
}
