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
    func GetSkillListDidSucceed(data:[AddStudentRatingResultData]?)
    func GetSubjectListDidSucceed(data:[AddStudentRatingResultData]?)
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
    
    //    func GetSubjectList(classid: Int,teacherId: Int){
    //        self.addStudentRatingView?.showLoader()
    //
    //        let paramDict = ["classid":classid,
    //                         "teacherId" : teacherId] as [String : Any]
    //        let url = ApiEndpoints.kGetClassSubjectsByteacherId + "?classid=" + "\(classid)" + "&teacherId=" + "\(teacherId)"
    //        AddStudentRatingApi.sharedInstance.GetAddSkillList(url: url , parameters: paramDict as [String : Any], completionResponse: { (AddStudentRatingListModel) in
    //
    //            print("your respomnse data : ",AddStudentRatingListModel.resultData)
    //
    //            if AddStudentRatingListModel.statusCode == KStatusCode.kStatusCode200 {
    //                self.addStudentRatingView?.hideLoader()
    //                self.addStudentRatingDelegate?.GetSubjectListDidSucceed(data:AddStudentRatingListModel.resultData!)
    //                //                if type == "Skill" {
    //                //                    self.addStudentRatingDelegate?.GetSkillListDidSucceed(data:AddStudentRatingListModel.resultData!)
    //                //                }
    //                //                else {
    //                //                    self.addStudentRatingDelegate?.studentListDidSucceed(data: AddStudentRatingListModel.resultData!)
    //                //
    //                //                }
    //
    //            }else if AddStudentRatingListModel.statusCode == KStatusCode.kStatusCode401 {
    //                self.addStudentRatingView?.hideLoader()
    //                self.addStudentRatingView?.showAlert(alert: AddStudentRatingListModel.message ?? "")
    //                //  self.SubjectListDelegate?.unauthorizedUser()
    //            }else{
    //                self.addStudentRatingView?.hideLoader()
    //                CommonFunctions.sharedmanagerCommon.println(object: "student APi status change")
    //            }
    //
    //        }, completionnilResponse: { (nilResponseError) in
    //
    //            self.addStudentRatingView?.hideLoader()
    //            //   self.SubjectListDelegate?.SubjectListDidFailed()
    //
    //            if let error = nilResponseError{
    //                self.addStudentRatingView?.showAlert(alert: error)
    //
    //            }else{
    //                CommonFunctions.sharedmanagerCommon.println(object: "student APi Nil response")
    //            }
    //
    //        }) { (error) in
    //            self.addStudentRatingView?.hideLoader()
    //            //   self.SubjectListDelegate?.SubjectListDidFailed()
    //            //            if let err = error?.localizedDescription{
    //            //                self.studentRatingView?.showAlert(alert: err)
    //            //            }else{
    //            //                CommonFunctions.sharedmanagerCommon.println(object: "student APi error response")
    //            //            }
    //        }
    //    }
    //
    
    func GetSubjectList(classid: Int,teacherId: Int, hodid: Int){
        self.studentRatingView?.showLoader()
        let paramDict = ["classid":classid,"teacherId" : teacherId] as [String : Any]
        let url = ApiEndpoints.kGetClassSubjectsByteacherId + "?classid=" + "\(classid)" + "&teacherId=" + "\(teacherId)" + "&hodid=" + "\(hodid)"
        AddStudentRatingApi.sharedInstance.GetAddSkillList(url: url , parameters: paramDict as [String : Any], completionResponse: { (AddStudentRatingListModel) in
            
            print("your respomnse subjectdata : ",AddStudentRatingListModel.resultData)
            
            if AddStudentRatingListModel.statusCode == KStatusCode.kStatusCode200 {
                self.studentRatingView?.hideLoader()
                
                self.studentRatingDelegate?.GetSubjectListDidSucceed(data:AddStudentRatingListModel.resultData!)
                
            }else if AddStudentRatingListModel.statusCode == KStatusCode.kStatusCode401 {
                self.studentRatingView?.hideLoader()
                self.studentRatingView?.showAlert(alert: AddStudentRatingListModel.message ?? "")
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
    
    func GetSkillList(id : Int , enumType : Int) {
        self.studentRatingView?.showLoader()
        
        let paramDict = [ AddStudentRating.kId:id,
                          AddStudentRating.kEnumType: enumType] as [String : Any]
        let url = ApiEndpoints.kSkillList + "?id=" + "\(id)" + "&enumType=" + "\(enumType)" 
        AddStudentRatingApi.sharedInstance.GetSkillList(url: url , parameters: paramDict as [String : Any], completionResponse: { (AddStudentRatingListModel) in
            
            print("your respomnse class data : ",AddStudentRatingListModel.resultData)
            
            if AddStudentRatingListModel.statusCode == KStatusCode.kStatusCode200 {
                self.studentRatingView?.hideLoader()
                
                self.studentRatingDelegate?.GetSkillListDidSucceed(data:AddStudentRatingListModel.resultData!)
                
            }else if AddStudentRatingListModel.statusCode == KStatusCode.kStatusCode401 {
                self.studentRatingView?.hideLoader()
                self.studentRatingView?.showAlert(alert: AddStudentRatingListModel.message ?? "")
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
    func studentList(search : String,skip : Int,pageSize: Int,sortColumnDir: String,sortColumn: String, classSubjectID : Int , classID : Int){
        self.studentRatingView?.showLoader()
        
        let paramDict = [ "ClassId":classID,
                          "ClassSubjectId": classSubjectID] as [String : Any]
//        let paramDict = ["Search" : search,"Skip" : skip,"PageSize": pageSize,"SortColumnDir": sortColumnDir,"SortColumn": sortColumn, "ClassSubjectId" : classSubjectID, "ClassId" : classID] as [String : Any]
        
        print("param: ",paramDict)
        
        StudentRatingApi.sharedInstance.GetStudentList(url: ApiEndpoints.kStudentRating, parameters: paramDict as [String : Any], completionResponse: { (StudentRatingListModel) in
             print("response: ",StudentRatingListModel.resultData)
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

