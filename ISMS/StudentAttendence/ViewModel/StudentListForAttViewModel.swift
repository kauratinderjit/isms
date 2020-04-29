//
//  StudentListForAttViewModel.swift
//  ISMS
//
//  Created by Poonam Sharma on 12/5/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation

protocol StudentListForAttDelegate: class {
    func unauthorizedUser()
    func studentListDidSuccess(data : [GetStudentListForAttResultData]?)
    func studentListDidFailed()
    func addStudentAttendenceSuccess()
    func addStudentAttendenceFailed()
}


class StudentListForAttViewModel {
    private weak var studentListView : ViewDelegate?
    
    //TeacherListDelegate weak object
    private weak var studentListDelegate : StudentListForAttDelegate?
    
    //Initiallize the presenter class using delegates
    init(delegate: StudentListForAttDelegate) {
        studentListDelegate = delegate
    }
    
    //Attach GlobalViewDelegate
    func attachView(viewDelegate : ViewDelegate){
        studentListView = viewDelegate
    }
    
    //Deattach View for free the memory from instances
    func deattachView(){
        studentListView = nil
        studentListDelegate = nil
    }
    
    func StudentList(TimeTableId: Int, ClassId: Int){
   
       
        var postDict = [String:Any]()
        
        postDict[KApiParameters.kStudentListForAttendence.kTimeTableId] = TimeTableId
        postDict[KApiParameters.kStudentListForAttendence.kClassId] = ClassId

        
        StudentListForAttendenceApi.sharedManager.getStudentList(url: ApiEndpoints.kStudentListForAttendence, parameters: postDict, completionResponse: { (StudentListForAttModel) in
            self.studentListView?.hideLoader()
            print("studentList: ",StudentListForAttModel.resultData)
//            print(StudentListForAttModel.resultData)
            switch StudentListForAttModel.statusCode{
            case KStatusCode.kStatusCode200:
                //                self.teacherListView?.hideLoader()
                self.studentListDelegate?.studentListDidSuccess(data: StudentListForAttModel.resultData)
            case KStatusCode.kStatusCode401:
                if let msg = StudentListForAttModel.message{
                    self.studentListView?.showAlert(alert: msg)
                }
                self.studentListDelegate?.unauthorizedUser()
            default:
                self.studentListView?.showAlert(alert: StudentListForAttModel.message ?? "")
            }
        }, completionnilResponse: { (nilResponseError) in
            self.studentListView?.hideLoader()
            self.studentListDelegate?.studentListDidFailed()
            if let error = nilResponseError{
                self.studentListView?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Student List for attendence APi Nil response")
            }
        }) { (error) in
            self.studentListView?.hideLoader()
            self.studentListDelegate?.studentListDidFailed()
            if let err = error?.localizedDescription{
                self.studentListView?.showAlert(alert: err)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Student List for attendence APi error response")
            }
        }
    }
    
    func submitStudentListAttendence(TimeTableId: Int,
    TeacherId: Int, ClassSubjectId : Int,ListAttendences : [[String:Any]]){
        var postDict = [String:Any]()
        
        postDict[KApiParameters.kAddStudentAttendence.kTimeTableId] = TimeTableId
        postDict[KApiParameters.kAddStudentAttendence.kTeacherId] = TeacherId
        postDict[KApiParameters.kAddStudentAttendence.kClassSubjectId] = ClassSubjectId
        postDict[KApiParameters.kAddStudentAttendence.kListAttendences] = ListAttendences
        
        print("postDict: ",postDict)
        StudentListForAttendenceApi.sharedManager.AddStudentAttendence(url: ApiEndpoints.kAddStudentListForAttendence, parameters: postDict, completionResponse: { (AddStudentModel) in
            self.studentListView?.hideLoader()
            print("data: ",AddStudentModel.message)
            switch AddStudentModel.statusCode{
            case KStatusCode.kStatusCode200:
                //                self.teacherListView?.hideLoader()
                if let msg = AddStudentModel.message{
                    self.studentListView?.showAlert(alert: msg)
                }
            case KStatusCode.kStatusCode401:
                if let msg = AddStudentModel.message{
                    self.studentListView?.showAlert(alert: msg)
                }
                self.studentListDelegate?.unauthorizedUser()
            default:
                self.studentListView?.showAlert(alert: AddStudentModel.message ?? "")
            }
        }, completionnilResponse: { (nilResponseError) in
            self.studentListView?.hideLoader()
            self.studentListDelegate?.studentListDidFailed()
            if let error = nilResponseError{
                self.studentListView?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Student List for attendence APi Nil response")
            }
        }) { (error) in
            self.studentListView?.hideLoader()
            self.studentListDelegate?.studentListDidFailed()
            if let err = error?.localizedDescription{
                self.studentListView?.showAlert(alert: err)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Student List for attendence APi error response")
            }
        }
    
    }
}
