////
////  SubjectSkillRatingViewModel.swift
////  ISMS
////
////  Created by Kuldeep Singh on 12/5/19.
////  Copyright © 2019 Atinder Kaur. All rights reserved.
////
//
import Foundation



protocol SubjectSkillRatingDelegate : class {
    func SubjectSkillRatingDidSucceed(data : [SubjectSkillRatingResultData])
    func SubjectSkillRatingDidFailour()
    func GetSkillListDidSucceed(data: [AddStudentRatingResultData])
    
}

class SubjectSkillRatingViewModel {
    
    var isSearching : Bool?
    private weak var subjectSkillRatingView : ViewDelegate?
    private  weak var subjectSkillRatingDelegate: SubjectSkillRatingDelegate?
    
    
    init(delegate : SubjectSkillRatingDelegate) {
        self.subjectSkillRatingDelegate = delegate
    }
    
    func attachView(viewDelegate : ViewDelegate){
        subjectSkillRatingView = viewDelegate
    }

    //MARK:- SUBJECT LIST
    func getSubjectWiseRating(enrollmentsId : Int?,classSubjectId: Int?){
        self.subjectSkillRatingView?.showLoader()
        
        let paramDict = [ "EnrollmentId": enrollmentsId!,
                          "ClassSubjectId": classSubjectId!
            ] as [String : Any]
        
        SubjectSkillRatingApi.sharedInstance.SubmitApiList(url: ApiEndpoints.kGetSubjectSkillRating, parameters: paramDict, completionResponse: { (SubjectListModel) in
            
            print("our skill array : ",SubjectListModel.resultData)
            
            if SubjectListModel.statusCode == KStatusCode.kStatusCode200{
                self.subjectSkillRatingView?.hideLoader()
                self.subjectSkillRatingDelegate?.SubjectSkillRatingDidSucceed(data: SubjectListModel.resultData!)
            }else if SubjectListModel.statusCode == KStatusCode.kStatusCode401{
                self.subjectSkillRatingView?.hideLoader()
                self.subjectSkillRatingView?.showAlert(alert: SubjectListModel.message ?? "")
                //  self.SubjectListDelegate?.unauthorizedUser()
            }else{
                self.subjectSkillRatingView?.hideLoader()
                CommonFunctions.sharedmanagerCommon.println(object: "student APi status change")
            }
            
        }, completionnilResponse: { (nilResponseError) in
            
            self.subjectSkillRatingView?.hideLoader()
            //   self.SubjectListDelegate?.SubjectListDidFailed()
            
            if let error = nilResponseError{
                self.subjectSkillRatingView?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "student APi Nil response")
            }
            
        }) { (error) in
            self.subjectSkillRatingView?.hideLoader()
         
        }
        
    }
    
    
    //MARK:- SUBJECT LIST
    func GetSkillList(id : Int , enumType : Int , type : String) {
        self.subjectSkillRatingView?.showLoader()
        
        let paramDict = [ AddStudentRating.kId:id,
                          AddStudentRating.kEnumType: enumType] as [String : Any]
        let url = ApiEndpoints.kSkillList + "?id=" + "\(id)" + "&enumType=" + "\(enumType)"
        AddStudentRatingApi.sharedInstance.GetSkillList(url: url , parameters: paramDict as [String : Any], completionResponse: { (AddStudentRatingListModel) in
            
            if AddStudentRatingListModel.statusCode == KStatusCode.kStatusCode200 {
                self.subjectSkillRatingView?.hideLoader()
                
                self.subjectSkillRatingDelegate?.GetSkillListDidSucceed(data: AddStudentRatingListModel.resultData!)
          
                
            }else if AddStudentRatingListModel.statusCode == KStatusCode.kStatusCode401 {
                self.subjectSkillRatingView?.hideLoader()
                self.subjectSkillRatingView?.showAlert(alert: AddStudentRatingListModel.message ?? "")
                //  self.SubjectListDelegate?.unauthorizedUser()
            }else{
                self.subjectSkillRatingView?.hideLoader()
                CommonFunctions.sharedmanagerCommon.println(object: "student APi status change")
            }
            
        }, completionnilResponse: { (nilResponseError) in
            
            self.subjectSkillRatingView?.hideLoader()
            //   self.SubjectListDelegate?.SubjectListDidFailed()
            
            if let error = nilResponseError{
                self.subjectSkillRatingView?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "student APi Nil response")
            }
            
        }) { (error) in
            self.subjectSkillRatingView?.hideLoader()
           }
     }
    
    
    
}


