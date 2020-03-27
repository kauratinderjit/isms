//
//  AttendanceReportViewModel.swift
//  ISMS
//
//  Created by Navalpreet Kaur on 12/6/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
protocol AttendanceReportDelegate:class
{
    func getAttendanceReportResultData(data:AttendanceReportModel)
    func unauthorizedUser()
    func classListDidSuccess(data:GetCommonDropdownModel)
    func StudentListDidSuccess(data : [GetStudentResultData]?)
    func StudentListDidFailed()
 }
class AttendanceReportViewModel
{
    //Global ViewDelegate weak object
    private weak var attendanceReportView : ViewDelegate?
    //AddStudentDelegate weak object
    private weak var attendanceReportDelegate : AttendanceReportDelegate?
    
    //Initiallize the presenter class using delegates
    init(delegate: AttendanceReportDelegate) {
        attendanceReportDelegate = delegate
    }
    
    //Attach GlobalViewDelegate
    func attachView(viewDelegate : ViewDelegate){
        attendanceReportView = viewDelegate
    }
        //Deattach View for free the memory from instances
    func deattachView(){
        attendanceReportView = nil
        attendanceReportDelegate = nil
    }
    
    //Api to fetch AttendanceReport list
    func GetAttendanceReport(classId: Int,enrollmentId:Int,sessionId:Int)
    {
        self.attendanceReportView?.showLoader()
        let url = ApiEndpoints.kGetAttendenceReportByClassId

        var postDict = [String: Any]()
        postDict["ClassId"] = classId
        postDict["EnrollmentId"] = enrollmentId
        postDict["SessionId"] = sessionId
        
        AttendanceReportApi.sharedInstance.GetAttendenceReportByClassIdApi(url: url, parameter:postDict , completionResponse: { (response) in
            self.attendanceReportView?.hideLoader()
            switch response.statusCode{
            case KStatusCode.kStatusCode200:
                self.attendanceReportDelegate?.getAttendanceReportResultData(data: response)
            case KStatusCode.kStatusCode401:
                if let msg = response.message
                {
                    self.attendanceReportView?.showAlert(alert: msg)
                }
                self.attendanceReportDelegate?.unauthorizedUser()
            default :
                self.attendanceReportView?.hideLoader()
            }
            
        }, completionnilResponse: {
            self.attendanceReportView?.hideLoader()
            
        }, Error: { (error) in
            self.attendanceReportView?.hideLoader()
            if let err = error{
                self.attendanceReportView?.showAlert(alert: err)
            }
        })
    }
    
    //MARK:- Get Class List Dropdown Api
    func getClassListDropdown(selectId : Int,enumType:Int){
        
      self.attendanceReportView?.hideLoader()
        
        ClassApi.sharedManager.getClassDropdownData(selectedId: selectId, enumType: enumType, completionResponse: { (responseClassDropdown) in
            
           self.attendanceReportView?.hideLoader()
            switch responseClassDropdown.statusCode{
            case KStatusCode.kStatusCode200:
                self.attendanceReportDelegate?.classListDidSuccess(data: responseClassDropdown)
            case KStatusCode.kStatusCode401:
                self.attendanceReportView?.showAlert(alert: responseClassDropdown.message ?? "")
                self.attendanceReportDelegate?.unauthorizedUser()
            default:
                self.attendanceReportView?.showAlert(alert: responseClassDropdown.message ?? "")
            }
        }, completionnilResponse: { (nilResponse) in
            self.attendanceReportView?.hideLoader()
            self.attendanceReportView?.showAlert(alert: nilResponse ?? "Server Error")
        }) { (error) in
            self.attendanceReportView?.hideLoader()
            self.attendanceReportView?.showAlert(alert: error?.localizedDescription ?? "Error")
        }
    }
    //MARK:- Get Student List Api
    func studentList(classId: Int?,Search: String?,Skip: Int?,PageSize: Int){
        self.attendanceReportView?.hideLoader()
        
        let paramDict = [KApiParameters.StudentListApi.StudentClassId: classId ?? 0,KApiParameters.StudentListApi.StudentSearch:Search ?? "",KApiParameters.StudentListApi.PageSkip: Skip ?? 10,KApiParameters.StudentListApi.PageSize: PageSize] as [String : Any]
        
        AdStudentApi.sharedInstance.getStudentList(url: ApiEndpoints.KStudentListApi, parameters: paramDict as [String : Any], completionResponse: { (StudentListModel) in
            
            if StudentListModel.statusCode == KStatusCode.kStatusCode200{
                self.attendanceReportView?.hideLoader()
                self.attendanceReportDelegate?.StudentListDidSuccess(data: StudentListModel.resultData)
            }else if StudentListModel.statusCode == KStatusCode.kStatusCode401{
                self.attendanceReportView?.hideLoader()
                self.attendanceReportView?.showAlert(alert: StudentListModel.message ?? "")
                self.attendanceReportDelegate?.unauthorizedUser()
            }else{
                self.attendanceReportView?.hideLoader()
                CommonFunctions.sharedmanagerCommon.println(object: "student APi status change")
            }
            
        }, completionnilResponse: { (nilResponseError) in
            
           self.attendanceReportView?.hideLoader()
            self.attendanceReportDelegate?.StudentListDidFailed()
            
            if let error = nilResponseError{
                self.attendanceReportView?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "student APi Nil response")
            }
            
        }) { (error) in
            self.attendanceReportView?.hideLoader()
            self.attendanceReportDelegate?.StudentListDidFailed()
            if let err = error?.localizedDescription{
                self.attendanceReportView?.showAlert(alert: err)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "student APi error response")
            }
        }
        
    }
    
}

extension AttendanceReportVC : AttendanceReportDelegate
{
    func StudentListDidFailed() {

    }
    
    func StudentListDidSuccess(data: [GetStudentResultData]?) {
        if data != nil{
            if data?.count ?? 0 > 0{
                studentDropdownData = data
                txtSelectStudent.text = data?[0].studentFirstName
                selectedStudentId = data?[0].studentUserId
                self.getAttendanceReportApi(enrollment_Id: 0)

            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Count is zero.")
            }
        }
    }
    
    func classListDidSuccess(data: GetCommonDropdownModel)
    {
        if data.resultData != nil{
            if data.resultData?.count ?? 0 > 0{
                classDropdownData = data
                txtClass.text = data.resultData?[0].name
                selectedClassId = data.resultData?[0].id
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Count is zero.")
            }
        }
    }
    
    func getAttendanceReportResultData(data: AttendanceReportModel) {
        print(data)
        if (data.resultData?.count)! > 0
        {
            barChartsEvent(data:data)
        }else{
            
        }
        
      
    }
    
    func unauthorizedUser() {
        
    }
   
}

//MARK:- UiPicker Delegate
extension AttendanceReportVC:SharedUIPickerDelegate
{
    func DoneBtnClicked()
    {
        var enrollmentId:Int!
        if isClassSelected == true
        {
            if classDropdownData != nil
            {
                if classDropdownData.resultData?.count ?? 0 > 0
                {
                    self.txtClass.text = self.classDropdownData.resultData?[selectedClassIndex].name
                    self.selectedClassId = self.classDropdownData.resultData?[selectedClassIndex].id
                    if isTabClassSelected == true{
                       enrollmentId = 0
                    }
                    else
                    {
                       enrollmentId = selectedStudentId
                    }
                    self.viewModel?.GetAttendanceReport(classId: selectedClassId ?? 0, enrollmentId: enrollmentId, sessionId: 0)
                }
            }
        }
        else
        {
            if studentDropdownData?.count ?? 0 > 0
            {
            txtSelectStudent.text = studentDropdownData?[selectedstudentIndex].studentFirstName ?? ""
            selectedStudentId = studentDropdownData?[selectedstudentIndex].studentUserId ?? 0
                self.viewModel?.GetAttendanceReport(classId: selectedClassId ?? 0, enrollmentId: selectedStudentId ?? 0, sessionId: 0)
            }
        }
    }
    func GetTitleForRow(index: Int) -> String
    {
        if isClassSelected == true
        {
            if classDropdownData.resultData?.count ?? 0 > 0{
            return classDropdownData.resultData?[index].name ?? ""
            }
        }
        else{
        if studentDropdownData?.count ?? 0 > 0 {
            return studentDropdownData?[index].studentFirstName ?? ""
        }
        }
        return ""
    }
    
    func SelectedRow(index: Int)
    {
        if isClassSelected == true{ if classDropdownData != nil
        {
            if classDropdownData.resultData?.count ?? 0 > 0
            {
                txtClass.text = self.classDropdownData.resultData?[index].name ?? ""
                selectedClassId = self.classDropdownData.resultData?[index].id ?? 0
                selectedClassIndex = index
            }
            }}else
            {
            if studentDropdownData != nil {
            if studentDropdownData?.count ?? 0 > 0
            {
                txtSelectStudent.text = studentDropdownData?[index].studentFirstName ?? ""
                selectedStudentId = studentDropdownData?[index].studentUserId
                selectedstudentIndex = index
            }
            }}
       
       
    }
    
    func cancelButtonClicked() {
        
    }
    
}
extension AttendanceReportVC : ViewDelegate
{
    func showAlert(alert: String){
        initializeCustomOkAlert(self.view, isHideBlurView: true)
       // okAlertView.delegate = self
        okAlertView.lblResponseDetailMessage.text = alert
    }
    func showLoader() {
        ShowLoader()
    }
    func hideLoader() {
        HideLoader()
    }
  
}
