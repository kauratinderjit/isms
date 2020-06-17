//
//  AssignSubjectTeacherViewModel.swift
//  ISMS
//
//  Created by Gagan on 09/06/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//


import Foundation

protocol AssignSubjectTeacherDelegate: class {
    func unauthorizedUser()
    func AssignSubjectTeacherDidSuccess(data : [GetSubjectListResultData])
    func GetAssignSubjectSucceed(data: [GetAssignSubjectListResultData])
    func AssignSubjectTeacherDidFailed()
    func getClassdropdownDidSucceed(data : GetCommonDropdownModel)
    
}
class AssignSubjectTeacherViewModel{
    
    //Global ViewDelegate weak object
    private weak var AssignSubjectToTeacherVC : ViewDelegate?
    
    //StudentListDelegate weak object
    private weak var AssignSubjectTeacherDelegate : AssignSubjectTeacherDelegate?
    
    //Initiallize the presenter StudentList using delegates
    init(delegate:AssignSubjectTeacherDelegate) {
        AssignSubjectTeacherDelegate = delegate
    }
    
    //Attach GlobalViewDelegate
    func attachView(viewDelegate : ViewDelegate){
        AssignSubjectToTeacherVC = viewDelegate
    }
    
    //Deattach View for free the memory from instances
    func deattachView(){
        AssignSubjectToTeacherVC = nil
        AssignSubjectTeacherDelegate = nil
    }
    
//    func studentList(classId: Int?,Search: String?,Skip: Int?,PageSize: Int){
//        self.AssignSubjectToTeacherVC?.showLoader()
//
//        let paramDict = [KApiParameters.StudentListApi.StudentClassId: classId ?? 0,KApiParameters.StudentListApi.StudentSearch:Search ?? "",KApiParameters.StudentListApi.PageSkip: Skip ?? 10,KApiParameters.StudentListApi.PageSize: PageSize] as [String : Any]
//
//
//        print("param: ",paramDict)
//        AdStudentApi.sharedInstance.getStudentList(url: ApiEndpoints.KStudentListApi, parameters: paramDict as [String : Any], completionResponse: { (StudentListModel) in
//            print("student list: ",StudentListModel.resultData)
//            if StudentListModel.statusCode == KStatusCode.kStatusCode200{
//                self.StudentListVC?.hideLoader()
//                self.StudentListDelegate?.StudentListDidSuccess(data: StudentListModel.resultData)
//            }else if StudentListModel.statusCode == KStatusCode.kStatusCode401{
//                self.StudentListVC?.hideLoader()
//                self.StudentListVC?.showAlert(alert: StudentListModel.message ?? "")
//                self.StudentListDelegate?.unauthorizedUser()
//            }else{
//                self.StudentListVC?.hideLoader()
//                CommonFunctions.sharedmanagerCommon.println(object: "student APi status change")
//            }
//
//        }, completionnilResponse: { (nilResponseError) in
//
//            self.StudentListVC?.hideLoader()
//            self.StudentListDelegate?.StudentListDidFailed()
//
//            if let error = nilResponseError{
//                self.StudentListVC?.showAlert(alert: error)
//
//            }else{
//                CommonFunctions.sharedmanagerCommon.println(object: "student APi Nil response")
//            }
//
//        }) { (error) in
//            self.StudentListVC?.hideLoader()
//            self.StudentListDelegate?.StudentListDidFailed()
//            if let err = error?.localizedDescription{
//                self.StudentListVC?.showAlert(alert: err)
//            }else{
//                CommonFunctions.sharedmanagerCommon.println(object: "student APi error response")
//            }
//        }
//        
//    }
    
    func GetSubjectList(classid: Int,teacherId: Int, hodid: Int){
        self.AssignSubjectToTeacherVC?.showLoader()
        let paramDict = ["classid":classid,"teacherId" : teacherId] as [String : Any]
        let url = ApiEndpoints.kGetClassSubjectsByteacherId + "?classid=" + "\(classid)" + "&teacherId=" + "\(teacherId)" + "&hodid=" + "\(hodid)"
        TeacherApi.sharedManager.GetSubjectList(url: url , parameters: paramDict as [String : Any], completionResponse: { (GetSubjectResultData) in
            
            print("your respomnse subjectdata : ",GetSubjectResultData.resultData)
            
            if GetSubjectResultData.statusCode == KStatusCode.kStatusCode200 {
                self.AssignSubjectToTeacherVC?.hideLoader()
                
                self.AssignSubjectTeacherDelegate?.AssignSubjectTeacherDidSuccess(data:GetSubjectResultData.resultData!)
                
            }else if GetSubjectResultData.statusCode == KStatusCode.kStatusCode401 {
                self.AssignSubjectToTeacherVC?.hideLoader()
                self.AssignSubjectToTeacherVC?.showAlert(alert: GetSubjectResultData.message ?? "")
                //  self.SubjectListDelegate?.unauthorizedUser()
            }else{
                self.AssignSubjectToTeacherVC?.hideLoader()
                CommonFunctions.sharedmanagerCommon.println(object: "student APi status change")
            }
            
        }, completionnilResponse: { (nilResponseError) in
            
            self.AssignSubjectToTeacherVC?.hideLoader()
            //   self.SubjectListDelegate?.SubjectListDidFailed()
            
            if let error = nilResponseError{
                self.AssignSubjectToTeacherVC?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "student APi Nil response")
            }
            
        }) { (error) in
            self.AssignSubjectToTeacherVC?.hideLoader()
            //   self.SubjectListDelegate?.SubjectListDidFailed()
            //            if let err = error?.localizedDescription{
            //                self.studentRatingView?.showAlert(alert: err)
            //            }else{
            //                CommonFunctions.sharedmanagerCommon.println(object: "student APi error response")
            //            }
        }
        
    }
    
    func getClassId(id: Int?, enumtype: Int?){
        guard let selectId = id else{ return }
        guard let enumType = enumtype else { return }
        
        self.AssignSubjectToTeacherVC?.showLoader()
        
        TeacherApi.sharedManager.getClassDropdownData(id: selectId, enumType: enumType, completionResponse: { (responseModel) in
            
            print("clas id : ",responseModel.resultData)
            self.AssignSubjectToTeacherVC?.hideLoader()
            self.AssignSubjectTeacherDelegate?.getClassdropdownDidSucceed(data: responseModel)
            
        }, completionnilResponse: { (nilResponse) in
            self.AssignSubjectToTeacherVC?.hideLoader()
            if let nilRes = nilResponse{
                self.AssignSubjectToTeacherVC?.showAlert(alert: nilRes)
            }
        }) { (error) in
            self.AssignSubjectToTeacherVC?.hideLoader()
            if let err = error{
                self.AssignSubjectToTeacherVC?.showAlert(alert: err.localizedDescription)
            }
        }
    }
    
    func submitAssignSubject(ClassId: Int,TeacherId: Int,subjectLists: [[String:Any]]){
        let parameters = ["ClassId":ClassId,"TeacherId":TeacherId,"subjectLists": subjectLists] as [String : Any]
        print("params: ",parameters)
        self.AssignSubjectToTeacherVC?.showLoader()
        SubjectApi.sharedInstance.AddSubject(url: "api/Institute/AssignedSubjectToTeacher", parameters: parameters, completionResponse: { (responseModel) in
            print(responseModel)
            
            self.AssignSubjectToTeacherVC?.hideLoader()
            if responseModel.statusCode == KStatusCode.kStatusCode200{
                
                if responseModel.resultData != nil{
                    self.AssignSubjectToTeacherVC?.showAlert(alert: responseModel.message ?? "")
                }else{
                    self.AssignSubjectToTeacherVC?.showAlert(alert: responseModel.message ?? "")
                }
                
            }else if responseModel.statusCode == KStatusCode.kStatusCode401{
                self.AssignSubjectToTeacherVC?.showAlert(alert: responseModel.message ?? "")
            }
            
            if responseModel.statusCode == KStatusCode.kStatusCode400{
                self.AssignSubjectToTeacherVC?.showAlert(alert: responseModel.message ?? "")
            }
            
        }, completionnilResponse: { (nilResponse) in
            self.AssignSubjectToTeacherVC?.hideLoader()
            self.AssignSubjectToTeacherVC?.showAlert(alert: nilResponse ?? Alerts.kMapperModelError)
        }) { (error) in
            self.AssignSubjectToTeacherVC?.hideLoader()
            self.AssignSubjectToTeacherVC?.showAlert(alert: error.debugDescription)
            
            
        }
        }
    
    func GetAssignedSubjectToTeacherById(ClassId: Int,TeacherId: Int){
        let url = KApiParameters.kUpdateSyllabusApiParameter.kChapterAndTopicApi
        
          let param = ["ClassId" : ClassId ,"TeacherId": TeacherId] as [String : Any]
         
          UpdateSyllabusApi.sharedManager.AssignSubjectData(url:url , parameters: param, completionResponse: { (UpdateSyllabusModel) in
               self.AssignSubjectToTeacherVC?.hideLoader()
                  if let result = UpdateSyllabusModel.resultData {
                    self.AssignSubjectTeacherDelegate?.GetAssignSubjectSucceed(data: result)
                  }
          }, completionnilResponse: { (nilResponseError) in
              self.AssignSubjectToTeacherVC?.hideLoader()
              // self.syllabusCoverageDelegate?.SyllabusCoverageFailour(msg :
              if let error = nilResponseError{
                  self.AssignSubjectToTeacherVC?.showAlert(alert: error.description)
                  
              }else{
                  CommonFunctions.sharedmanagerCommon.println(object: SyllabusCoverage.kSyllabusResponseNotGet)
              }
          }) { (error) in
              self.AssignSubjectToTeacherVC?.hideLoader()
              if let err = error?.localizedDescription{
                  self.AssignSubjectToTeacherVC?.showAlert(alert: err)
              }else{
                  CommonFunctions.sharedmanagerCommon.println(object: SyllabusCoverage.kSyllabusResponseError)
              }
          }
        }
    }
    
 
