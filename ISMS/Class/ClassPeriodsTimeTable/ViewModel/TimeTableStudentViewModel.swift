//
//  TimeTableStudentViewModel.swift
//  ISMS
//
//  Created by Poonam Sharma on 17/4/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//
//TimeTableStudentViewModel
import Foundation

protocol TimeTableStudentDelegate:class {
   
    func getTimeTableSuccess(data : GetTimeTableModel)
    func unauthorizedUser()
}


class TimeTableStudentViewModel{
    
    //Global ViewDelegate weak object
    private weak var classPeriodsTimeTableView : ViewDelegate?
    //ClassPeriodstimeTableViewModel weak object
    private weak var TimeTableStudentDelegate : TimeTableStudentDelegate?
    //Initiallize the presenter class using delegates
    init(delegate: TimeTableStudentDelegate) {
        TimeTableStudentDelegate = delegate
    }
    //Attach GlobalViewDelegate
    func attachView(viewDelegate : ViewDelegate){
        classPeriodsTimeTableView = viewDelegate
    }
    //Deattach View for free the memory from instances
    func deattachView(){
        classPeriodsTimeTableView = nil
        TimeTableStudentDelegate = nil
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
        case 3:
            postDict["TeacherId"] = 0
        default:
            postDict["TeacherId"] = UserDefaultExtensionModel.shared.userRoleParticularId
        }
        
        print("array post timetable : ",postDict)
        
        ClassApi.sharedManager.getClassTimeTable(url: ApiEndpoints.getTimeTableListApi, params: postDict, completionResponse: { (getTimetabelResponse) in
            
            self.classPeriodsTimeTableView?.hideLoader()
            switch getTimetabelResponse.statusCode{
            case KStatusCode.kStatusCode200:
                self.TimeTableStudentDelegate?.getTimeTableSuccess(data: getTimetabelResponse)
            case KStatusCode.kStatusCode401:
                self.classPeriodsTimeTableView?.showAlert(alert: getTimetabelResponse.message ?? "Something went wrong.")
                self.TimeTableStudentDelegate?.unauthorizedUser()
            default:
                self.classPeriodsTimeTableView?.showAlert(alert: getTimetabelResponse.message ?? "Something went wrong.")
            }
        }) { (error) in
            self.classPeriodsTimeTableView?.showAlert(alert: error ?? "Something went wrong")
        }
    }
    
    
}
