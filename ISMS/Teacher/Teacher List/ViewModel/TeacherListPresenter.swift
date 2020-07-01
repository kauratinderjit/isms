//
//  TeacherListPresenter.swift
//  ISMS
//
//  Created by Taranjeet Singh on 6/20/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation

protocol TeacherListDelegate: class {
    func unauthorizedUser()
    func teacherListDidSuccess(data : [GetTeacherListResultData]?)
    func substituteTeacherListDidSuccess(data : [GetSubstituteTeacherData]?)
    func teacherListDidFailed()
    func teacherDeleteDidSuccess(data : DeleteTeacherModel)
    func teacherDeleteDidfailed()
    func submitSubstitute()
    
    
}


class TeacherListViewModel{
    var isSearching : Bool?
    //Global ViewDelegate weak object
    private weak var teacherListView : ViewDelegate?
    
    //TeacherListDelegate weak object
    private weak var teacherListDelegate : TeacherListDelegate?
    
    //Initiallize the presenter class using delegates
    init(delegate: TeacherListDelegate) {
        teacherListDelegate = delegate
    }
    
    //Attach GlobalViewDelegate
    func attachView(viewDelegate : ViewDelegate){
        teacherListView = viewDelegate
    }
    
    //Deattach View for free the memory from instances
    func deattachView(){
        teacherListView = nil
        teacherListDelegate = nil
    }
    
    //MARK:- Teacher list
    func teacherList(searchText: String,pageSize : Int,filterBy: Int,skip: Int){
        if isSearching == false{
            self.teacherListView?.showLoader()
        }        
        var postDict = [String:Any]()
        
        postDict[KApiParameters.KCommonParametersForList.kSearch] = searchText
        postDict[KApiParameters.KCommonParametersForList.kPageSize] = pageSize
        postDict[KApiParameters.KCommonParametersForList.kSortColumn] = ""
        postDict[KApiParameters.KCommonParametersForList.kSkip] = skip
        postDict[KApiParameters.KCommonParametersForList.kSortColumnDir] = ""
        postDict["ParticularId"] = UserDefaultExtensionModel.shared.HODDepartmentId
        
        TeacherApi.sharedManager.getTeacherList(url: ApiEndpoints.kGetTeacherList, parameters: postDict, completionResponse: { (teacherModel) in
            self.teacherListView?.hideLoader()
            print("teachr data : ",teacherModel.resultData)
            switch teacherModel.statusCode{
            case KStatusCode.kStatusCode200:
//                self.teacherListView?.hideLoader()
                self.teacherListDelegate?.teacherListDidSuccess(data: teacherModel.resultData)
            case KStatusCode.kStatusCode401:
                if let msg = teacherModel.message{
                    self.teacherListView?.showAlert(alert: msg)
                }
                self.teacherListDelegate?.unauthorizedUser()
            default:
                self.teacherListView?.showAlert(alert: teacherModel.message ?? "")
            }
        }, completionnilResponse: { (nilResponseError) in
            self.teacherListView?.hideLoader()
            self.teacherListDelegate?.teacherListDidFailed()
            if let error = nilResponseError{
                self.teacherListView?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Teacher APi Nil response")
            }
        }) { (error) in
            self.teacherListView?.hideLoader()
            self.teacherListDelegate?.teacherListDidFailed()
            if let err = error?.localizedDescription{
                self.teacherListView?.showAlert(alert: err)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Teacher APi error response")
            }
        }
    }
    
    //MARK:- delete Teacher
    func deleteTeacher(teacherId: Int){
        self.teacherListView?.showLoader()
        TeacherApi.sharedManager.deleteTeacherApi(url: ApiEndpoints.kDeleteTeacher+"?teacherId=\(teacherId)", completionResponse: {deleteModel in
            self.teacherListView?.hideLoader()
            switch deleteModel.statusCode{
            case KStatusCode.kStatusCode200:
                if let msg = deleteModel.message{
                    self.teacherListView?.showAlert(alert: msg)
                }
                self.teacherListDelegate?.teacherDeleteDidSuccess(data: deleteModel)
            case KStatusCode.kStatusCode401:
                if let msg = deleteModel.message{
                    self.teacherListView?.showAlert(alert: msg)
                }
                self.teacherListDelegate?.unauthorizedUser()
            default:
                if let msg = deleteModel.message{
                    self.teacherListView?.showAlert(alert: msg)
                }
            }
        }, completionnilResponse: { (nilResponse) in
            self.teacherListView?.hideLoader()
            if let res = nilResponse{
                self.teacherListView?.showAlert(alert: res)
            }
        }) { (error) in
            self.teacherListView?.hideLoader()
            if let err = error{
                self.teacherListView?.showAlert(alert: err.localizedDescription)
            }
        }
    }
    
      //MARK:- Teacher list
        func substituteTeacherList(classId: Int, teacherId: Int){
           
                self.teacherListView?.showLoader()
            
            var postDict = [String:Any]()
            
//            postDict[KApiParameters.KCommonParametersForList.kSearch] = searchText
//            postDict[KApiParameters.KCommonParametersForList.kPageSize] = pageSize
//            postDict[KApiParameters.KCommonParametersForList.kSortColumn] = ""
//            postDict[KApiParameters.KCommonParametersForList.kSkip] = skip
//            postDict[KApiParameters.KCommonParametersForList.kSortColumnDir] = ""
//            postDict["ParticularId"] = UserDefaultExtensionModel.shared.HODDepartmentId
            
            TeacherApi.sharedManager.getSubstituteTeacherList(url: "api/Institute/GetFreeTeacherByClassId"+"?ClassId=\(classId)&teacherId=\(teacherId)", parameters: postDict, completionResponse: { (teacherModel) in
                self.teacherListView?.hideLoader()
                print("teachr data : ",teacherModel.resultData)
                switch teacherModel.statusCode{
                case KStatusCode.kStatusCode200:
    //                self.teacherListView?.hideLoader()
                    self.teacherListDelegate?.substituteTeacherListDidSuccess(data: teacherModel.resultData)
                case KStatusCode.kStatusCode401:
                    if let msg = teacherModel.message{
                        self.teacherListView?.showAlert(alert: msg)
                    }
                    self.teacherListDelegate?.unauthorizedUser()
                default:
                    self.teacherListView?.showAlert(alert: teacherModel.message ?? "")
                }
            }, completionnilResponse: { (nilResponseError) in
                self.teacherListView?.hideLoader()
                self.teacherListDelegate?.teacherListDidFailed()
                if let error = nilResponseError{
                    self.teacherListView?.showAlert(alert: error)
                    
                }else{
                    CommonFunctions.sharedmanagerCommon.println(object: "Teacher APi Nil response")
                }
            }) { (error) in
                self.teacherListView?.hideLoader()
                self.teacherListDelegate?.teacherListDidFailed()
                if let err = error?.localizedDescription{
                    self.teacherListView?.showAlert(alert: err)
                }else{
                    CommonFunctions.sharedmanagerCommon.println(object: "Teacher APi error response")
                }
            }
        }
    
   func substituteTeacherSubmit(SubstituteId: Int, TeacherId: Int,SubstituteTeacherId: Int,ClassId: Int,ClassSubjectId: Int,PeriodId: Int,DayId: Int){
         self.teacherListView?.showLoader()
                
    let paramDict = ["SubstituteId":SubstituteId,"TeacherId": TeacherId,"SubstituteTeacherId" :SubstituteTeacherId,"ClassId" : ClassId,"ClassSubjectId":ClassSubjectId ,"PeriodId": PeriodId,"DayId":DayId] as [String : Any]
                let url = "api/Institute/AddUpdateTimeTableSubstituteTeacher"
                
                print("our param: ",paramDict)
                TeacherRatingListAPI.sharedInstance.AddTeacherFeedback(url: url , parameters: paramDict as [String : Any], completionResponse: { (AddFeedbackModel) in
                    
                    print("your respomnse data : ",AddFeedbackModel.resultData)
                    
                    if AddFeedbackModel.statusCode == KStatusCode.kStatusCode200 {
                        self.teacherListView?.hideLoader()
                         self.teacherListView?.showAlert(alert: AddFeedbackModel.message ?? "")
                        self.teacherListDelegate?.submitSubstitute()
                        
                    }else if AddFeedbackModel.statusCode == KStatusCode.kStatusCode401 {
                        self.teacherListView?.hideLoader()
                        self.teacherListView?.showAlert(alert: AddFeedbackModel.message ?? "")
                        //  self.SubjectListDelegate?.unauthorizedUser()
                    }else{
                        self.teacherListView?.hideLoader()
                        CommonFunctions.sharedmanagerCommon.println(object: "teacher APi status change")
                    }
                    
                }, completionnilResponse: { (nilResponseError) in
                    
                    self.teacherListView?.hideLoader()
                    //   self.SubjectListDelegate?.SubjectListDidFailed()
                    
                    if let error = nilResponseError{
                        self.teacherListView?.showAlert(alert: error)
                        
                    }else{
                        CommonFunctions.sharedmanagerCommon.println(object: "teacher APi Nil response")
                    }
                    
                }) { (error) in
                    self.teacherListView?.hideLoader()
                    
                }
    }
        
}
