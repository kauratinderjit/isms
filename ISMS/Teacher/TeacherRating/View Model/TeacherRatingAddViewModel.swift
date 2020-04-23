
//
//  TeacherRatingViewModel.swift
//  ISMS
//
//  Created by Poonam Sharma on 13/4/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//
//TeacherRatingViewModel

import Foundation


protocol TeacherRatingAddDelegate : class {
    func GetTeacherListDidSucceed(data: [TeacherRatingList]?)
    func GetSubjectListDidSucceed(data: [SubjectListResult]?)
//    func SubjectListDidSuccess(data: [TeacherRatingList]?)
   
}


class TeacherRatingAddViewModel {
    var isSearching : Bool?
    private  weak var TeacherRatingView : ViewDelegate?
    private  weak var TeacherRatingDelegate : TeacherRatingAddDelegate?
    
    //Initiallize the presenter class using delegates
    init(delegate: TeacherRatingAddDelegate) {
        TeacherRatingDelegate = delegate
    }
    
    //Attach GlobalViewDelegate
    func attachView(viewDelegate : ViewDelegate){
        TeacherRatingView = viewDelegate
    }
    
    //Deattach View for free the memory from instances
    func deattachView(){
        TeacherRatingView = nil
        TeacherRatingDelegate = nil
    }
    
    func TeacherList(studentID : Int){
        self.TeacherRatingView?.showLoader()
        
        let paramDict = ["studentId":studentID] as [String : Any]
        let url = ApiEndpoints.kTeacherRatingAdd + "?studentId=" + "\(studentID)"
        TeacherRatingListAPI.sharedInstance.GetTeacherList(url: url , parameters: paramDict as [String : Any], completionResponse: { (TeacherRatingAddModel) in
            
            print("your respomnse data : ",TeacherRatingAddModel.resultData)
            
            if TeacherRatingAddModel.statusCode == KStatusCode.kStatusCode200 {
                self.TeacherRatingView?.hideLoader()
                
                self.TeacherRatingDelegate?.GetTeacherListDidSucceed(data: TeacherRatingAddModel.resultData )
                
            }else if TeacherRatingAddModel.statusCode == KStatusCode.kStatusCode401 {
                self.TeacherRatingView?.hideLoader()
                self.TeacherRatingView?.showAlert(alert: TeacherRatingAddModel.message ?? "")
                //  self.SubjectListDelegate?.unauthorizedUser()
            }else{
                self.TeacherRatingView?.hideLoader()
                CommonFunctions.sharedmanagerCommon.println(object: "teacher APi status change")
            }
            
        }, completionnilResponse: { (nilResponseError) in
            
            self.TeacherRatingView?.hideLoader()
            //   self.SubjectListDelegate?.SubjectListDidFailed()
            
            if let error = nilResponseError{
                self.TeacherRatingView?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "teacher APi Nil response")
            }
            
        }) { (error) in
            self.TeacherRatingView?.hideLoader()
            //   self.SubjectListDelegate?.SubjectListDidFailed()
            //            if let err = error?.localizedDescription{
            //                self.studentRatingView?.showAlert(alert: err)
            //            }else{
            //                CommonFunctions.sharedmanagerCommon.println(object: "student APi error response")
            //            }
        }
    }
    
    func GetSubjectList(teacherId: Int,classId: Int){
        self.TeacherRatingView?.showLoader()
        
        let paramDict = ["teacherId":teacherId,"classId": classId] as [String : Any]
        let url = ApiEndpoints.kGetSubjectListByteacherId + "?teacherId=" + "\(teacherId)" + "&classId=" + "\(classId)"
        TeacherRatingListAPI.sharedInstance.GetSubjectList(url: url , parameters: paramDict as [String : Any], completionResponse: { (SubjectListTeacherModel) in
            
            print("your respomnse data : ",SubjectListTeacherModel.resultData)
            
            if SubjectListTeacherModel.statusCode == KStatusCode.kStatusCode200 {
                self.TeacherRatingView?.hideLoader()
                
                self.TeacherRatingDelegate?.GetSubjectListDidSucceed(data: SubjectListTeacherModel.resultData )
                
            }else if SubjectListTeacherModel.statusCode == KStatusCode.kStatusCode401 {
                self.TeacherRatingView?.hideLoader()
                self.TeacherRatingView?.showAlert(alert: SubjectListTeacherModel.message ?? "")
                //  self.SubjectListDelegate?.unauthorizedUser()
            }else{
                self.TeacherRatingView?.hideLoader()
                CommonFunctions.sharedmanagerCommon.println(object: "teacher APi status change")
            }
            
        }, completionnilResponse: { (nilResponseError) in
            
            self.TeacherRatingView?.hideLoader()
            //   self.SubjectListDelegate?.SubjectListDidFailed()
            
            if let error = nilResponseError{
                self.TeacherRatingView?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "teacher APi Nil response")
            }
            
        }) { (error) in
            self.TeacherRatingView?.hideLoader()
            //   self.SubjectListDelegate?.SubjectListDidFailed()
            //            if let err = error?.localizedDescription{
            //                self.studentRatingView?.showAlert(alert: err)
            //            }else{
            //                CommonFunctions.sharedmanagerCommon.println(object: "student APi error response")
            //            }
        }
    }
    
    func submit(teacherId : Int, StudentId:  Int, classSubjectId: Int,feedback: String,anonymous: Bool){
        self.TeacherRatingView?.showLoader()
        
       let paramDict = ["TeacherRatingId":0,"TeacherId": teacherId,"StudentId" :StudentId,"ClassSubjectId" : classSubjectId,"Comment":feedback ,"Anonymous": anonymous] as [String : Any]
        let url = ApiEndpoints.kAddTeacherFeedBack
        
        print("our param: ",paramDict)
        TeacherRatingListAPI.sharedInstance.AddTeacherFeedback(url: url , parameters: paramDict as [String : Any], completionResponse: { (AddFeedbackModel) in
            
            print("your respomnse data : ",AddFeedbackModel.resultData)
            
            if AddFeedbackModel.statusCode == KStatusCode.kStatusCode200 {
                self.TeacherRatingView?.hideLoader()
                 self.TeacherRatingView?.showAlert(alert: AddFeedbackModel.message ?? "")
//                self.TeacherRatingDelegate?.GetSubjectListDidSucceed(data: SubjectListTeacherModel.resultData )
                
            }else if AddFeedbackModel.statusCode == KStatusCode.kStatusCode401 {
                self.TeacherRatingView?.hideLoader()
                self.TeacherRatingView?.showAlert(alert: AddFeedbackModel.message ?? "")
                //  self.SubjectListDelegate?.unauthorizedUser()
            }else{
                self.TeacherRatingView?.hideLoader()
                CommonFunctions.sharedmanagerCommon.println(object: "teacher APi status change")
            }
            
        }, completionnilResponse: { (nilResponseError) in
            
            self.TeacherRatingView?.hideLoader()
            //   self.SubjectListDelegate?.SubjectListDidFailed()
            
            if let error = nilResponseError{
                self.TeacherRatingView?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "teacher APi Nil response")
            }
            
        }) { (error) in
            self.TeacherRatingView?.hideLoader()
            //   self.SubjectListDelegate?.SubjectListDidFailed()
            //            if let err = error?.localizedDescription{
            //                self.studentRatingView?.showAlert(alert: err)
            //            }else{
            //                CommonFunctions.sharedmanagerCommon.println(object: "student APi error response")
            //            }
        }
        
        
    }
    
}
