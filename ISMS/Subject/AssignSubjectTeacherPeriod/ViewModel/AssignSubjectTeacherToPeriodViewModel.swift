//
//  AssignSubjectTeacherToPeriodViewModel.swift
//  ISMS
//
//  Created by Taranjeet Singh on 7/17/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation

protocol AssignSubjectTeacherToPeriodDelegate: class {
    func addSubjectTeacherToPeriodsDidSuccess()
    func addSubjectTeacherToPeriodsDidfailed(data: AddUpdateTimeTableResponseModel?)
    func getTeacherSubjectDropdownDidSuccess(data: GetCommonDropdownModel?)
    func unauthorizedUser()
}

class AssignSubjectTeacherToPeriodViewModel{
    
    //Global ViewDelegate weak object
    private weak var assignSubjectTeacherToPeriodView : ViewDelegate?
    //AssignSubjectTeacherToPeriodDelegate weak object
    private weak var assignSubjectTeacherToPeriodDelegate : AssignSubjectTeacherToPeriodDelegate?
    //Initiallize the presenter class using delegates
    init(delegate: AssignSubjectTeacherToPeriodDelegate) {
        assignSubjectTeacherToPeriodDelegate = delegate
    }
    //Attach GlobalViewDelegate
    func attachView(viewDelegate : ViewDelegate){
        assignSubjectTeacherToPeriodView = viewDelegate
    }
    //Deattach View for free the memory from instances
    func deattachView(){
        assignSubjectTeacherToPeriodView = nil
         assignSubjectTeacherToPeriodDelegate = nil
    }
    //MARK:- Add/Update Subjects,Teacher to Periods of class
    func addUpdateSubjectsTeacherToPeriod(timeTabelId: Int,classId: Int?,classSubjectId: Int?,teacherId:Int?,periodId: Int?,days: String?){
 
        if classSubjectId == nil{
            self.assignSubjectTeacherToPeriodView?.showAlert(alert: "Please select subject.")
        }else if teacherId == nil{
            self.assignSubjectTeacherToPeriodView?.showAlert(alert: "Please select teacher.")
        }else if days == nil || days == ""{
            self.assignSubjectTeacherToPeriodView?.showAlert(alert: "Please select atleaset one day.")
        }else{
            var postDict = [String:Any]()
            postDict[KApiParameters.AddUpdateTimeTableApi.kClassId] = classId
            postDict[KApiParameters.AddUpdateTimeTableApi.kClassSubjectId] = classSubjectId
            postDict[KApiParameters.AddUpdateTimeTableApi.kTeacherId] = teacherId
            postDict[KApiParameters.AddUpdateTimeTableApi.kPeriodId] = periodId
            postDict[KApiParameters.AddUpdateTimeTableApi.kStrDay] = days
            postDict[KApiParameters.AddUpdateTimeTableApi.kTimeTableId] = timeTabelId
            
           SubjectApi.sharedInstance.addUpdateTimeTableApi(url: ApiEndpoints.kAddUpdateTimeTable, parameters: postDict, completionResponse: {(responseModel) in
                
                switch responseModel.statusCode{
                case KStatusCode.kStatusCode200:
                    self.assignSubjectTeacherToPeriodView?.showAlert(alert: responseModel.message ?? "Something went wrong")
                    self.assignSubjectTeacherToPeriodDelegate?.addSubjectTeacherToPeriodsDidSuccess()
                case KStatusCode.kStatusCode400:
                    //When teacher is not available
                    self.assignSubjectTeacherToPeriodDelegate?.addSubjectTeacherToPeriodsDidfailed(data: responseModel)
                case KStatusCode.kStatusCode401:
                    self.assignSubjectTeacherToPeriodView?.showAlert(alert: responseModel.message ?? "Something went wrong")
                    self.assignSubjectTeacherToPeriodDelegate?.unauthorizedUser()
                default :
                    debugPrint("Status Changed.")
                    break
                }
            }) { (error) in
                if let err = error{
                    self.assignSubjectTeacherToPeriodView?.showAlert(alert: err)
                }
            }
        }
        
    }
    
    //MARK:- Subject/Teacher Dropdown Api
    func getSubjectsTeacherListDropdown(selectId : Int,enumType:Int){
        
        self.assignSubjectTeacherToPeriodView?.showLoader()
        
        SubjectApi.sharedInstance.getSubjectTeacherDropdownData(selectedSubjectTeacherId: selectId, enumType: enumType, completionResponse: { (response) in
            print("our subject list : ",response.resultData)
            self.assignSubjectTeacherToPeriodView?.hideLoader()
            
            switch response.statusCode{
            case KStatusCode.kStatusCode200:
                self.assignSubjectTeacherToPeriodDelegate?.getTeacherSubjectDropdownDidSuccess(data: response)
            case KStatusCode.kStatusCode401:
                self.assignSubjectTeacherToPeriodView?.showAlert(alert: response.message ?? "")
                self.assignSubjectTeacherToPeriodDelegate?.unauthorizedUser()
            default:
                self.assignSubjectTeacherToPeriodView?.showAlert(alert: response.message ?? "")
            }
        }, completionnilResponse: { (nilResponse) in
            self.assignSubjectTeacherToPeriodView?.hideLoader()
            self.assignSubjectTeacherToPeriodView?.showAlert(alert: nilResponse ?? "Server Error")
        }) { (error) in
            self.assignSubjectTeacherToPeriodView?.hideLoader()
            self.assignSubjectTeacherToPeriodView?.showAlert(alert: error?.localizedDescription ?? "Error")
        }
    }
}
