//
//  AddStudentRatingViewModel.swift
//  ISMS
//
//  Created by Kuldeep Singh on 11/28/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation

protocol AddStudentRatingDelegate : class {
    func StudentRatingDidSucceed()
    func StudentRatingDidFailour()
    func classListDidSuccess(data : [GetClassListResultData]?)
    func SubjectListDidSuccess(data: [GetSubjectResultData]?)
      func SubjectWiseRatingDidSucceed(data : [SubjectWiseRatingResultData])
    func GetSkillListDidSucceed(data : [AddStudentRatingResultData]?)
    func GetSubjectListDidSucceed(data:[AddStudentRatingResultData]?)
    func studentListDidSucceed(data : [AddStudentRatingResultData]?)
    func GetSkillListaddDidSucceed(data:[AddStudentRatingResultData]?)
    func classListDidSuccesss(data: GetCommonDropdownModel)
   func  GetStudentByClassDidSucceed(data:[StudentsByClassId]?)
    func AddStudentRatingDidSucceed(data: String)
}

class AddStudentRatingViewModel {
   var isSearching : Bool?
   private weak var addStudentRatingView : ViewDelegate?
  private  weak var addStudentRatingDelegate: AddStudentRatingDelegate?
    
    
    init(delegate : AddStudentRatingDelegate) {
        addStudentRatingDelegate = delegate
    }
    
    func attachView(viewDelegate : ViewDelegate){
        addStudentRatingView = viewDelegate
    }
   
    //MARK:- Get Class List Dropdown Api for teacher
       func getClassListTeacherDropdown(teacherId: Int, departmentId: Int,type : String){
           
           addStudentRatingView?.showLoader()
           
           ClassApi.sharedManager.getClassDropdownDataTeacher(teacherId: teacherId, departmentId: departmentId, completionResponse: { (responseClassDropdown) in
               
               self.addStudentRatingView?.hideLoader()
               switch responseClassDropdown.statusCode{
               case KStatusCode.kStatusCode200:
                   self.addStudentRatingDelegate?.classListDidSuccesss(data: responseClassDropdown)
               case KStatusCode.kStatusCode401:
                   self.addStudentRatingView?.showAlert(alert: responseClassDropdown.message ?? "")
               default:
                   self.addStudentRatingView?.showAlert(alert: responseClassDropdown.message ?? "")
               }
           }, completionnilResponse: { (nilResponse) in
               self.addStudentRatingView?.hideLoader()
               self.addStudentRatingView?.showAlert(alert: nilResponse ?? "Server Error")
           }) { (error) in
               self.addStudentRatingView?.hideLoader()
               self.addStudentRatingView?.showAlert(alert: error?.localizedDescription ?? "Error")
           }
       }
    
    //MARK:- Class list
    func classList(searchText: String,pageSize : Int,filterBy: Int,skip: Int){
        
        if self.isSearching == false {
            self.addStudentRatingView?.showLoader()
        }
        
        var postDict = [String:Any]()
        
        postDict[KApiParameters.KCommonParametersForList.kSearch] = searchText
        postDict[KApiParameters.KCommonParametersForList.kPageSize] = pageSize
        postDict[KApiParameters.KCommonParametersForList.kSortColumn] = ""
        postDict[KApiParameters.KCommonParametersForList.kSkip] = skip
        postDict[KApiParameters.KCommonParametersForList.kSortColumnDir] = ""
        
        ClassApi.sharedManager.getClassList(url: ApiEndpoints.kGetClassList, parameters: postDict, completionResponse: { (classModel) in
            
            self.addStudentRatingView?.hideLoader()
            
            switch classModel.statusCode{
            case KStatusCode.kStatusCode200:
                self.addStudentRatingDelegate?.classListDidSuccess(data: classModel.resultData)
            case KStatusCode.kStatusCode401:
                if let msg = classModel.message{
                    self.addStudentRatingView?.showAlert(alert: msg)
                }
            //  self.classListDelegate?.unauthorizedUser()
            default:
                if let msg = classModel.message{
                    self.addStudentRatingView?.showAlert(alert: msg)
                }
            }
        }, completionnilResponse: { (nilResponseError) in
            
            self.addStudentRatingView?.hideLoader()
            self.addStudentRatingDelegate?.StudentRatingDidFailour()
            
            if let error = nilResponseError{
                self.addStudentRatingView?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Class APi Nil response")
            }
            
        }) { (error) in
            self.addStudentRatingView?.hideLoader()
            //  self.studentRatingDelegate?.StudentRatingDidFailour()
            if let err = error?.localizedDescription{
                self.addStudentRatingView?.showAlert(alert: err)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Class APi error response")
            }
        }
    }
    
    //MARK:- SUBJECT LIST
    func subjectList(search : String?,skip : Int?,pageSize: Int?,sortColumnDir: String?,sortColumn: String?, particularId : Int){
        self.addStudentRatingView?.showLoader()
        
        let paramDict = [KApiParameters.SubjectListApi.subjectSearch: search ?? "",KApiParameters.SubjectListApi.PageSkip:skip ?? 0,KApiParameters.SubjectListApi.PageSize: pageSize ?? 0,KApiParameters.SubjectListApi.sortColumnDir: sortColumnDir ?? "", KApiParameters.SubjectListApi.sortColumn: sortColumn ?? "",
                         KApiParameters.kUpdateSyllabusApiParameter.kParticularId : particularId] as [String : Any]
        
        SubjectApi.sharedInstance.getSubjectList(url: ApiEndpoints.KSubjectListApi, parameters: paramDict as [String : Any], completionResponse: { (SubjectListModel) in
            
            if SubjectListModel.statusCode == KStatusCode.kStatusCode200{
                self.addStudentRatingView?.hideLoader()
                self.addStudentRatingDelegate?.SubjectListDidSuccess(data: SubjectListModel.resultData)
            }else if SubjectListModel.statusCode == KStatusCode.kStatusCode401{
                self.addStudentRatingView?.hideLoader()
                self.addStudentRatingView?.showAlert(alert: SubjectListModel.message ?? "")
                //  self.SubjectListDelegate?.unauthorizedUser()
            }else{
                self.addStudentRatingView?.hideLoader()
                CommonFunctions.sharedmanagerCommon.println(object: "student APi status change")
            }
            
        }, completionnilResponse: { (nilResponseError) in
            
            self.addStudentRatingView?.hideLoader()
            //   self.SubjectListDelegate?.SubjectListDidFailed()
            
            if let error = nilResponseError{
                self.addStudentRatingView?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "student APi Nil response")
            }
            
        }) { (error) in
            self.addStudentRatingView?.hideLoader()
            //   self.SubjectListDelegate?.SubjectListDidFailed()
            if let err = error?.localizedDescription{
                self.addStudentRatingView?.showAlert(alert: err)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "student APi error response")
            }
        }
        
    }

    
    //MARK:- SUBJECT LIST
    func GetSkillList(id : Int , enumType : Int , type : String) {
        self.addStudentRatingView?.showLoader()
        
        let paramDict = [ AddStudentRating.kId:id,
                          AddStudentRating.kEnumType: enumType] as [String : Any]
        let url = ApiEndpoints.kSkillList + "?id=" + "\(id)" + "&enumType=" + "\(enumType)"
        AddStudentRatingApi.sharedInstance.GetSkillList(url: url , parameters: paramDict as [String : Any], completionResponse: { (AddStudentRatingListModel) in
            
            print("your respomnse data : ",AddStudentRatingListModel.resultData)
            
            if AddStudentRatingListModel.statusCode == KStatusCode.kStatusCode200 {
                self.addStudentRatingView?.hideLoader()
                if type == "Skill" {
        self.addStudentRatingDelegate?.GetSkillListDidSucceed(data:AddStudentRatingListModel.resultData!)
                } else if type == "skillList"{
                    self.addStudentRatingDelegate?.GetSkillListaddDidSucceed(data:AddStudentRatingListModel.resultData!)
                }else {
              self.addStudentRatingDelegate?.studentListDidSucceed(data: AddStudentRatingListModel.resultData!)
                    
                }
                
            }else if AddStudentRatingListModel.statusCode == KStatusCode.kStatusCode401 {
                self.addStudentRatingView?.hideLoader()
                self.addStudentRatingView?.showAlert(alert: AddStudentRatingListModel.message ?? "")
                //  self.SubjectListDelegate?.unauthorizedUser()
            }else{
                self.addStudentRatingView?.hideLoader()
                CommonFunctions.sharedmanagerCommon.println(object: "student APi status change")
            }
            
        }, completionnilResponse: { (nilResponseError) in
            
            self.addStudentRatingView?.hideLoader()
            //   self.SubjectListDelegate?.SubjectListDidFailed()
            
            if let error = nilResponseError{
                self.addStudentRatingView?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "student APi Nil response")
            }
            
        }) { (error) in
            self.addStudentRatingView?.hideLoader()
            //   self.SubjectListDelegate?.SubjectListDidFailed()
            //            if let err = error?.localizedDescription{
            //                self.studentRatingView?.showAlert(alert: err)
            //            }else{
            //                CommonFunctions.sharedmanagerCommon.println(object: "student APi error response")
            //            }
        }
        
    }
    
    
    func GetStudentsByClassId(classid : Int){
        self.addStudentRatingView?.showLoader()
        
        let paramDict = ["classid":classid] as [String : Any]
        let url = ApiEndpoints.kGetStudentsByClassId + "?classid=" + "\(classid)"
        AddStudentRatingApi.sharedInstance.StudentsByClassIdApi(url: url , parameters: paramDict as [String : Any], completionResponse: { (GetStudentsByClassIdModel) in
            
            print("your respomnse data : ",GetStudentsByClassIdModel.resultData)
            
            if GetStudentsByClassIdModel.statusCode == KStatusCode.kStatusCode200 {
                self.addStudentRatingView?.hideLoader()
                self.addStudentRatingDelegate?.GetStudentByClassDidSucceed(data:GetStudentsByClassIdModel.resultData)
                //                if type == "Skill" {
                //                    self.addStudentRatingDelegate?.GetSkillListDidSucceed(data:AddStudentRatingListModel.resultData!)
                //                }
                //                else {
                //                    self.addStudentRatingDelegate?.studentListDidSucceed(data: AddStudentRatingListModel.resultData!)
                //
                //                }
                
            }else if GetStudentsByClassIdModel.statusCode == KStatusCode.kStatusCode401 {
                self.addStudentRatingView?.hideLoader()
                self.addStudentRatingView?.showAlert(alert: GetStudentsByClassIdModel.message ?? "")
                //  self.SubjectListDelegate?.unauthorizedUser()
            }else{
                self.addStudentRatingView?.hideLoader()
                CommonFunctions.sharedmanagerCommon.println(object: "student APi status change")
            }
            
        }, completionnilResponse: { (nilResponseError) in
            
            self.addStudentRatingView?.hideLoader()
            //   self.SubjectListDelegate?.SubjectListDidFailed()
            
            if let error = nilResponseError{
                self.addStudentRatingView?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "student APi Nil response")
            }
            
        }) { (error) in
            self.addStudentRatingView?.hideLoader()
            //   self.SubjectListDelegate?.SubjectListDidFailed()
            //            if let err = error?.localizedDescription{
            //                self.studentRatingView?.showAlert(alert: err)
            //            }else{
            //                CommonFunctions.sharedmanagerCommon.println(object: "student APi error response")
            //            }
        }
    }
    
    func GetClassSubjectsByteacherId(classid: Int,teacherId: Int){
        self.addStudentRatingView?.showLoader()
        
        let paramDict = ["classid":classid,
                          "teacherId" : teacherId] as [String : Any]
        let url = ApiEndpoints.kGetClassSubjectsByteacherId + "?classid=" + "\(classid)" + "&teacherId=" + "\(teacherId)"
        AddStudentRatingApi.sharedInstance.GetAddSkillList(url: url , parameters: paramDict as [String : Any], completionResponse: { (AddStudentRatingListModel) in
            
            print("your respomnse data : ",AddStudentRatingListModel.resultData)
            
            if AddStudentRatingListModel.statusCode == KStatusCode.kStatusCode200 {
                self.addStudentRatingView?.hideLoader()
                self.addStudentRatingDelegate?.GetSubjectListDidSucceed(data:AddStudentRatingListModel.resultData!)
//                if type == "Skill" {
//                    self.addStudentRatingDelegate?.GetSkillListDidSucceed(data:AddStudentRatingListModel.resultData!)
//                }
//                else {
//                    self.addStudentRatingDelegate?.studentListDidSucceed(data: AddStudentRatingListModel.resultData!)
//
//                }
                
            }else if AddStudentRatingListModel.statusCode == KStatusCode.kStatusCode401 {
                self.addStudentRatingView?.hideLoader()
                self.addStudentRatingView?.showAlert(alert: AddStudentRatingListModel.message ?? "")
                //  self.SubjectListDelegate?.unauthorizedUser()
            }else{
                self.addStudentRatingView?.hideLoader()
                CommonFunctions.sharedmanagerCommon.println(object: "student APi status change")
            }
            
        }, completionnilResponse: { (nilResponseError) in
            
            self.addStudentRatingView?.hideLoader()
            //   self.SubjectListDelegate?.SubjectListDidFailed()
            
            if let error = nilResponseError{
                self.addStudentRatingView?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "student APi Nil response")
            }
            
        }) { (error) in
            self.addStudentRatingView?.hideLoader()
            //   self.SubjectListDelegate?.SubjectListDidFailed()
            //            if let err = error?.localizedDescription{
            //                self.studentRatingView?.showAlert(alert: err)
            //            }else{
            //                CommonFunctions.sharedmanagerCommon.println(object: "student APi error response")
            //            }
        }
    }
    
    
    //MARK:- SUBJECT LIST
    func getSubjectWiseRating(enrollmentsId : Int?,classId: Int?){
        self.addStudentRatingView?.showLoader()
        print("your data ")
        let paramDict = ["EnrollmentId": enrollmentsId!,
                          "ClassSubjectId" : classId!
            ] as [String : Any]
        
        AddStudentRatingApi.sharedInstance.SubmitApiList(url: ApiEndpoints.kGetSubjectEnrollement, parameters: paramDict, completionResponse: { (SubjectListModel) in
            
            if SubjectListModel.statusCode == KStatusCode.kStatusCode200{
                self.addStudentRatingView?.hideLoader()
                self.addStudentRatingDelegate?.SubjectWiseRatingDidSucceed(data: SubjectListModel.resultData!)
            }else if SubjectListModel.statusCode == KStatusCode.kStatusCode401{
                self.addStudentRatingView?.hideLoader()
                self.addStudentRatingView?.showAlert(alert: SubjectListModel.message ?? "")
                //  self.SubjectListDelegate?.unauthorizedUser()
            }else{
                self.addStudentRatingView?.hideLoader()
                CommonFunctions.sharedmanagerCommon.println(object: "student APi status change")
            }
            
        }, completionnilResponse: { (nilResponseError) in
            
            self.addStudentRatingView?.hideLoader()
            //   self.SubjectListDelegate?.SubjectListDidFailed()
            
            if let error = nilResponseError{
                self.addStudentRatingView?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "student APi Nil response")
            }
            
        }) { (error) in
            self.addStudentRatingView?.hideLoader()
            //   self.SubjectListDelegate?.SubjectListDidFailed()
            //            if let err = error?.localizedDescription{
            //                self.addStudentRatingView?.showAlert(alert: err)
            //            }else{
            //                CommonFunctions.sharedmanagerCommon.println(object: "student APi error response")
            //            }
        }
        
    }
    
    
    //MARK:- SUBJECT LIST
    func SubmitTotalRating(teacherID: Int?, enrollmentId : Int?,classSubjectId: Int?,comment: String?,StudentSkillRatings: [[String : Any]]){
        self.addStudentRatingView?.showLoader()
        
//        var postDict = [String:Any]()
//
//        let classSubjectMapList = classSubjectList.map { (model) -> Dictionary<String, Any> in
//            var selectedClassSubjectsDict = Dictionary<String, Any>()
//            selectedClassSubjectsDict[KApiParameters.AssignSubjectToClassApi.kSubjectId] = model.subjectId
//            selectedClassSubjectsDict[KApiParameters.AssignSubjectToClassApi.kClassSubjectId] = model.classSubjectId
//            return selectedClassSubjectsDict
//        }
//        postDict[KApiParameters.AssignSubjectToClassApi.kClassId] = classId
//        postDict[KApiParameters.AssignSubjectToClassApi.kClassSubjectModels] = classSubjectMapList
        
            //[
//            {
//                "StudentSkillId": 0,
//                "Rating": 0
//        }
//        ]
        let paramDict = [ "Id": 0,
                          "TeacherId": teacherID ?? "",
                          "EnrollmentId": enrollmentId ?? "",
                          "ClassSubjectId":classSubjectId ?? "",
                          "Comment": "good",
                          "StudentSkillRatings":StudentSkillRatings] as [String : Any]
        
        AddStudentRatingApi.sharedInstance.SubmitApiList(url: ApiEndpoints.kAddStudentRating, parameters: paramDict, completionResponse: { (SubjectListModel) in
            
            if SubjectListModel.statusCode == KStatusCode.kStatusCode200{
                self.addStudentRatingView?.hideLoader()
                self.addStudentRatingDelegate?.AddStudentRatingDidSucceed(data : SubjectListModel.message ?? "")
            }else if SubjectListModel.statusCode == KStatusCode.kStatusCode401{
                self.addStudentRatingView?.hideLoader()
                self.addStudentRatingView?.showAlert(alert: SubjectListModel.message ?? "")
                //  self.SubjectListDelegate?.unauthorizedUser()
            }else{
                self.addStudentRatingView?.hideLoader()
                CommonFunctions.sharedmanagerCommon.println(object: "student APi status change")
            }
            
        }, completionnilResponse: { (nilResponseError) in
            
            self.addStudentRatingView?.hideLoader()
            //   self.SubjectListDelegate?.SubjectListDidFailed()
            
            if let error = nilResponseError{
                self.addStudentRatingView?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "student APi Nil response")
            }
            
        }) { (error) in
            self.addStudentRatingView?.hideLoader()
            //   self.SubjectListDelegate?.SubjectListDidFailed()
//            if let err = error?.localizedDescription{
//                self.addStudentRatingView?.showAlert(alert: err)
//            }else{
//                CommonFunctions.sharedmanagerCommon.println(object: "student APi error response")
//            }
        }
        
    }
    
    
}

