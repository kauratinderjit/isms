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
                //  self.SubjectListDelegate?.unauthorizedUser()
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
}
