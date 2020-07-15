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
    func addSession()
    func checkSession(data: Bool?)
    func updateSessionStatus(data: String?)
    func sessionListDidSuccess(data:  [GetSessionResultData]?)
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
    
    func AddSession(SessionId: Int,strSessionStartDate: String,strSessionEndDate: String,SessionStartDate:String ,SessionEndDate: String){
        var postDict = [String:Any]()
               
               postDict["SessionId"] = SessionId
               postDict["strSessionStartDate"] = strSessionStartDate
               postDict["strSessionEndDate"] = strSessionEndDate
               postDict["SessionStartDate"] = SessionStartDate
                postDict["SessionEndDate"] = SessionEndDate
                                                  
               print("postDict: ",postDict)
        self.attendanceListView?.showLoader()
               StudentListForAttendenceApi.sharedManager.AddStudentAttendence(url: "api/User/AddUpdateSession", parameters: postDict, completionResponse: { (AddStudentModel) in
                   self.attendanceListView?.hideLoader()
                   print("data: ",AddStudentModel.message)
                
                   switch AddStudentModel.statusCode{
                   case KStatusCode.kStatusCode200:
                       if let msg = AddStudentModel.message{
                           self.attendanceListView?.showAlert(alert: msg)
                        self.StudentGetAttendanceDelegate?.addSession()
                       }
                   case KStatusCode.kStatusCode401:
                       if let msg = AddStudentModel.message{
                           self.attendanceListView?.showAlert(alert: msg)
                       }
                   default:
                       self.attendanceListView?.showAlert(alert: AddStudentModel.message ?? "")
                   }
               }, completionnilResponse: { (nilResponseError) in
                   self.attendanceListView?.hideLoader()
                   
                   if let error = nilResponseError{
                       self.attendanceListView?.showAlert(alert: error)
                       
                   }else{
                       CommonFunctions.sharedmanagerCommon.println(object: "Student List for attendence APi Nil response")
                   }
               }) { (error) in
                   self.attendanceListView?.hideLoader()
                   
                   if let err = error?.localizedDescription{
                       self.attendanceListView?.showAlert(alert: err)
                   }else{
                       CommonFunctions.sharedmanagerCommon.println(object: "Student List for attendence APi error response")
                   }
               }
    }
    
    func sessionCheck(SessionStartDate: String,SessionEndDate: String){
        var postDict = [String:Any]()
       postDict = ["SessionStartDate":SessionStartDate,
                               "SessionEndDate" : SessionEndDate] as [String : Any]
        self.attendanceListView?.showLoader()
        
        StudentListForAttendenceApi.sharedManager.AddStudentAttendence(url: "api/User/GetSessionCheck" + "?SessionStartDate=" + "\(SessionStartDate)" + "&SessionEndDate=" + "\(SessionEndDate)", parameters: postDict, completionResponse: { (AddStudentModel) in
            self.attendanceListView?.hideLoader()
            print("data: ",AddStudentModel.message)
            
            switch AddStudentModel.statusCode{
            case KStatusCode.kStatusCode200:
                if let msg = AddStudentModel.message{
                    self.StudentGetAttendanceDelegate?.checkSession(data: AddStudentModel.status)
                }
            case KStatusCode.kStatusCode401:
                if let msg = AddStudentModel.message{
                    self.attendanceListView?.showAlert(alert: msg)
                }
            default:
                self.attendanceListView?.showAlert(alert: AddStudentModel.message ?? "")
            }
        }, completionnilResponse: { (nilResponseError) in
            self.attendanceListView?.hideLoader()
            
            if let error = nilResponseError{
                self.attendanceListView?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Student List for attendence APi Nil response")
            }
        }) { (error) in
            self.attendanceListView?.hideLoader()
            
            if let err = error?.localizedDescription{
                self.attendanceListView?.showAlert(alert: err)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Student List for attendence APi error response")
            }
        }
    }
    
    func getSessionList(){
        StudentListForAttendenceApi.sharedManager.getSession(url: "api/User/GetSessionDetail", parameters: nil, completionResponse: { (GetSessionModel) in
            self.attendanceListView?.hideLoader()
            print("data: ",GetSessionModel.resultData)
            switch GetSessionModel.statusCode{
            case KStatusCode.kStatusCode200:
                self.StudentGetAttendanceDelegate?.sessionListDidSuccess(data: GetSessionModel.resultData)
                
            case KStatusCode.kStatusCode401:
                if let msg = GetSessionModel.message{
                    self.attendanceListView?.showAlert(alert: msg)
                }
            //                self.studentListDelegate?.unauthorizedUser()
            default:
                self.attendanceListView?.showAlert(alert: GetSessionModel.message ?? "")
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
    
    func updateSessionCheck(SessionId: Int,SessionStatus: Bool){
        var postDict = [String:Any]()
                      
        postDict["SessionId"] = SessionId
        postDict["SessionStatus"] = SessionStatus
        
        print("postDict: ",postDict)
        
        self.attendanceListView?.showLoader()
        StudentListForAttendenceApi.sharedManager.AddStudentAttendence(url: "api/User/UpdateSessionStatus", parameters: postDict, completionResponse: { (AddStudentModel) in
            self.attendanceListView?.hideLoader()
            print("data: ",AddStudentModel.message)
            
            switch AddStudentModel.statusCode{
            case KStatusCode.kStatusCode200:
                if let msg = AddStudentModel.message{
                    
                self.StudentGetAttendanceDelegate?.updateSessionStatus(data: AddStudentModel.message)
                }
            case KStatusCode.kStatusCode401:
                if let msg = AddStudentModel.message{
                    self.attendanceListView?.showAlert(alert: msg)
                }
            default:
                self.attendanceListView?.showAlert(alert: AddStudentModel.message ?? "")
            }
        }, completionnilResponse: { (nilResponseError) in
            self.attendanceListView?.hideLoader()
            
            if let error = nilResponseError{
                self.attendanceListView?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Student List for attendence APi Nil response")
            }
        }) { (error) in
            self.attendanceListView?.hideLoader()
            
            if let err = error?.localizedDescription{
                self.attendanceListView?.showAlert(alert: err)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Student List for attendence APi error response")
            }
        }
    }
    
}
