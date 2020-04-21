//
//  StudentGetAttendanceViewModel.swift
//  ISMS
//
//  Created by Poonam Sharma on 17/4/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import Foundation

protocol StudentGetAttendanceDelegate: class {
    func attendanceListDidSuccess(data: [GetStudentAttendanceResultData]?)
}
class StudentGetAttendanceViewModel {
    private weak var attendanceListView : ViewDelegate?
    
    //TeacherListDelegate weak object
    private weak var StudentGetAttendanceDelegate : StudentGetAttendanceDelegate?
    
    //Initiallize the presenter class using delegates
    init(delegate: StudentGetAttendanceDelegate) {
        StudentGetAttendanceDelegate = delegate
    }
    
    //Attach GlobalViewDelegate
    func attachView(viewDelegate : ViewDelegate){
        attendanceListView = viewDelegate
    }
    
    //Deattach View for free the memory from instances
    func deattachView(){
        attendanceListView = nil
        StudentGetAttendanceDelegate = nil
    }
    
    func GetAttendance(StartDate: String,EndDate: String,StudentId: Int,PeriodId: Int,SubjectId: Int,EnrollmentId: Int,ClassId: Int,SessionId: Int){
        var postDict = [String:Any]()
        
        postDict["StartDate"] = StartDate
        postDict["EndDate"] = EndDate
        postDict["StudentId"] = StudentId
        postDict["PeriodId"] = PeriodId
        
        postDict["SubjectId"] = SubjectId
        postDict["EnrollmentId"] = EnrollmentId
        postDict["ClassId"] = ClassId
        postDict["SessionId"] = SessionId
        
        print("data dict",postDict)
        StudentListForAttendenceApi.sharedManager.StudentGetAttendence(url: ApiEndpoints.kGetAttendanceReportByEnrollmentId, parameters: postDict, completionResponse: { (GetStudentAttendanceModel) in
            self.attendanceListView?.hideLoader()
            print("data: ",GetStudentAttendanceModel.resultData)
            switch GetStudentAttendanceModel.statusCode{
            case KStatusCode.kStatusCode200:
                self.StudentGetAttendanceDelegate?.attendanceListDidSuccess(data: GetStudentAttendanceModel.resultData)
                
            case KStatusCode.kStatusCode401:
                if let msg = GetStudentAttendanceModel.message{
                    self.attendanceListView?.showAlert(alert: msg)
                }
//                self.studentListDelegate?.unauthorizedUser()
            default:
                self.attendanceListView?.showAlert(alert: GetStudentAttendanceModel.message ?? "")
            }
        },completionnilResponse: { (nilResponseError) in
            
            self.attendanceListView?.hideLoader()
            //   self.SubjectListDelegate?.SubjectListDidFailed()
            
            if let error = nilResponseError{
                self.attendanceListView?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "teacher APi Nil response")
            }
            
        }) { (error) in
            self.attendanceListView?.hideLoader()
            //   self.SubjectListDelegate?.SubjectListDidFailed()
            //            if let err = error?.localizedDescription{
            //                self.studentRatingView?.showAlert(alert: err)
            //            }else{
            //                CommonFunctions.sharedmanagerCommon.println(object: "student APi error response")
            //            }
        }
        
    }
    
    
}
