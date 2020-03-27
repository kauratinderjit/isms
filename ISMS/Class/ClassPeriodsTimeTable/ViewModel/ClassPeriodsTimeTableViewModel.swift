//
//  ClassPeriodsTimeTableViewModel.swift
//  ISMS
//
//  Created by Taranjeet Singh on 7/17/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation

protocol ClassPeriodsTimeTableDelegate:class {
    func classListDidSuccess(data: GetCommonDropdownModel)
    func classListDidFailed()
    func getTimeTableSuccess(data : GetTimeTableModel)
    func getTimeTableFailed()
    func unauthorizedUser()
}


class ClassPeriodsTimetableViewModel{

    //Global ViewDelegate weak object
    private weak var classPeriodsTimeTableView : ViewDelegate?
    //ClassPeriodstimeTableViewModel weak object
    private weak var classPeriodsTimeTableDelegate : ClassPeriodsTimeTableDelegate?
    //Initiallize the presenter class using delegates
    init(delegate: ClassPeriodsTimeTableDelegate) {
        classPeriodsTimeTableDelegate = delegate
    }
    //Attach GlobalViewDelegate
    func attachView(viewDelegate : ViewDelegate){
        classPeriodsTimeTableView = viewDelegate
    }
    //Deattach View for free the memory from instances
    func deattachView(){
        classPeriodsTimeTableView = nil
        classPeriodsTimeTableDelegate = nil
    }
    
    //MARK:- Get Class List Dropdown Api
    func getClassListDropdown(selectId : Int,enumType:Int){
        
        classPeriodsTimeTableView?.showLoader()
        
        ClassApi.sharedManager.getClassDropdownData(selectedId: selectId, enumType: enumType, completionResponse: { (responseClassDropdown) in
        
            self.classPeriodsTimeTableView?.hideLoader()
            switch responseClassDropdown.statusCode{
            case KStatusCode.kStatusCode200:
                self.classPeriodsTimeTableDelegate?.classListDidSuccess(data: responseClassDropdown)
            case KStatusCode.kStatusCode401:
                self.classPeriodsTimeTableView?.showAlert(alert: responseClassDropdown.message ?? "")
                self.classPeriodsTimeTableDelegate?.unauthorizedUser()
            default:
                self.classPeriodsTimeTableView?.showAlert(alert: responseClassDropdown.message ?? "")
            }
        }, completionnilResponse: { (nilResponse) in
            self.classPeriodsTimeTableView?.hideLoader()
            self.classPeriodsTimeTableView?.showAlert(alert: nilResponse ?? "Server Error")
        }) { (error) in
            self.classPeriodsTimeTableView?.hideLoader()
            self.classPeriodsTimeTableView?.showAlert(alert: error?.localizedDescription ?? "Error")
        }
    }
    
    //Get Time Table According to class
    func getTimeTableAccordingClass(classId: Int?,teacherId: Int?){

        self.classPeriodsTimeTableView?.showLoader()
        
        var postDict = [String:Any]()
        postDict[KApiParameters.KCommonParametersForList.kSearch] = ""
        postDict[KApiParameters.KCommonParametersForList.kPageSize] = 0
        postDict[KApiParameters.KCommonParametersForList.kSortColumn] = ""
        postDict[KApiParameters.KCommonParametersForList.kSkip] = 0
        postDict[KApiParameters.KCommonParametersForList.kSortColumnDir] = ""
        postDict["ParticularId"] = classId
        //Check If user have particular id
        switch teacherId {
        case 0:
            postDict["TeacherId"] = 0
        default:
            postDict["TeacherId"] = UserDefaultExtensionModel.shared.userRoleParticularId
        }
        
        ClassApi.sharedManager.getClassTimeTable(url: ApiEndpoints.getTimeTableListApi, params: postDict, completionResponse: { (getTimetabelResponse) in
            
            self.classPeriodsTimeTableView?.hideLoader()
            switch getTimetabelResponse.statusCode{
            case KStatusCode.kStatusCode200:
                self.classPeriodsTimeTableDelegate?.getTimeTableSuccess(data: getTimetabelResponse)
            case KStatusCode.kStatusCode401:
                self.classPeriodsTimeTableView?.showAlert(alert: getTimetabelResponse.message ?? "Something went wrong.")
                self.classPeriodsTimeTableDelegate?.unauthorizedUser()
            default:
                self.classPeriodsTimeTableView?.showAlert(alert: getTimetabelResponse.message ?? "Something went wrong.")
            }
        }) { (error) in
            self.classPeriodsTimeTableView?.showAlert(alert: error ?? "Something went wrong")
        }
    }
    
    
}
