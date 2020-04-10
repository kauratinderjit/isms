//
//  UpdateSyllabusViewModel.swift
//  ISMS
//
//  Created by Kuldeep Singh on 11/18/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

protocol AddHomeWorkDelegate: class {
    func AddHomeworkSucceed(array : [HomeworkResultData])
    func AddHomeworkFailour(msg : String)
    func classListDidSuccess(data: GetCommonDropdownModel)
    func getSubjectList (arr :[GetSubjectHWResultData])
    func addedSuccessfully ()
}


class HomeworkViewModel {

    
    //Global ViewDelegate weak object
    private weak var homeworkViewDelegate : ViewDelegate?
    
    //registerCustomerDelegate weak object
    private weak var addHomeworkDelegate : AddHomeWorkDelegate?
    
    //Initiallize the presenter class using delegates
    init(delegate: AddHomeWorkDelegate) {
        addHomeworkDelegate = delegate
    }
    
    //Attach GlobalViewDelegate
    func attachView(viewDelegate : ViewDelegate){
        homeworkViewDelegate = viewDelegate
    }
    
    
    
    func getData(classId : Int , teacherId : Int) {
         homeworkViewDelegate?.showLoader()
        
        let url = "api/Institute/GetClassSubjectsforHomeworkByteacherId"+"?classid=\(classId)&teacherId=\(teacherId)"
        
        HomeworkApi.sharedManager.getHWSubjectList(url:url , parameters: nil, completionResponse: { (responseModel) in
            
            self.homeworkViewDelegate?.hideLoader()
            if let msg = responseModel.resultData {
            self.addHomeworkDelegate?.getSubjectList(arr:responseModel.resultData!)
            }
            
        }, completionnilResponse: { (nilResponseError) in
            self.homeworkViewDelegate?.hideLoader()
            if let error = nilResponseError{
                self.homeworkViewDelegate?.showAlert(alert: error.description)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: SyllabusCoverage.kSyllabusResponseNotGet)
            }
        }) { (error) in
            self.homeworkViewDelegate?.hideLoader()
            if let err = error?.localizedDescription{
                self.homeworkViewDelegate?.showAlert(alert: err)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: SyllabusCoverage.kSyllabusResponseError)
            }
        }
        
        
        
        
        
    }
   
    func saveHomework(AssignHomeWorkId : Int ,ClassId : Int,  SubjectId : Int , Topic : String ,ClassSubjectId:Int, Details : String,SubmissionDate: String, lstAssignHomeAttachmentMapping : [URL]) {
        
         homeworkViewDelegate?.showLoader()
        
        let url = "api/Institute/AddUpdateAssignHomeWork"
      
        let param = [
                     "teacherId" : UserDefaultExtensionModel.shared.userRoleParticularId,
                     "AssignHomeWorkId" : AssignHomeWorkId ,
                     "ClassId": ClassId,
                     "SubjectId" : SubjectId ,
                     "Topic" : Topic,
                     "ClassSubjectId" :ClassSubjectId ,
                     "Details" : Details,
                     "SubmissionDate" : SubmissionDate,
                     "File":lstAssignHomeAttachmentMapping] as [String : Any]
        
        
        HomeworkApi.sharedManager.multipartApi(postDict: param, url: url, completionResponse: { (response) in
            
            self.homeworkViewDelegate?.hideLoader()
            
            switch response["StatusCode"] as? Int{
            case 200:
                self.homeworkViewDelegate?.showAlert(alert: "Homework upoaded successfully.")
                self.addHomeworkDelegate?.addedSuccessfully()
            case 401:
                self.homeworkViewDelegate?.showAlert(alert: response["Message"] as? String ?? "")
                //self.AddHomeWorkDelegate?.unauthorizedUser()
            default:
                self.homeworkViewDelegate?.showAlert(alert: response["Message"] as? String ?? "")
            }

            
        }) { (error) in
                        self.homeworkViewDelegate?.hideLoader()
            if let err = error?.localizedDescription{
                self.homeworkViewDelegate?.showAlert(alert: err)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: SyllabusCoverage.kSyllabusResponseError)
            }

        }
    }
    
    func getHomeworkData(teacherId : Int) {
        
         homeworkViewDelegate?.showLoader()
        
        let url = "api/Institute/GetAssignHomeWorklistByTeacherId"+"?teacherId=\(teacherId)"
        
      
      //  let param = ["teacherId" : teacherId] as [String : Any]
        
        
        HomeworkApi.sharedManager.getHoweworkList(url: url, parameters: nil, completionResponse: { (response) in
                   self.homeworkViewDelegate?.hideLoader()
                switch response.statusCode{
                case KStatusCode.kStatusCode200:
                    self.addHomeworkDelegate?.AddHomeworkSucceed(array: response.resultData! )
                case KStatusCode.kStatusCode401:
                    self.homeworkViewDelegate?.showAlert(alert: response.message ?? "")
                    //self.AddHomeWorkDelegate?.unauthorizedUser()
                default:
                    self.homeworkViewDelegate?.showAlert(alert: response.message ?? "")
                }
            }, completionnilResponse: { (nilResponse) in
                self.homeworkViewDelegate?.hideLoader()
                self.homeworkViewDelegate?.showAlert(alert: nilResponse ?? "Server Error")
            }) { (error) in
                self.homeworkViewDelegate?.hideLoader()
                self.homeworkViewDelegate?.showAlert(alert: error?.localizedDescription ?? "Error")
            }
    }
    
    
    //MARK:- Get Class List Dropdown Api
    func getClassListDropdown(selectId : Int,enumType:Int){
        
        homeworkViewDelegate?.showLoader()
        
        ClassApi.sharedManager.getClassDropdownData(selectedId: selectId, enumType: enumType, completionResponse: { (responseClassDropdown) in
        
            self.homeworkViewDelegate?.hideLoader()
            switch responseClassDropdown.statusCode{
            case KStatusCode.kStatusCode200:
                self.addHomeworkDelegate?.classListDidSuccess(data: responseClassDropdown)
            case KStatusCode.kStatusCode401:
                self.homeworkViewDelegate?.showAlert(alert: responseClassDropdown.message ?? "")
                //self.AddHomeWorkDelegate?.unauthorizedUser()
            default:
                self.homeworkViewDelegate?.showAlert(alert: responseClassDropdown.message ?? "")
            }
        }, completionnilResponse: { (nilResponse) in
            self.homeworkViewDelegate?.hideLoader()
            self.homeworkViewDelegate?.showAlert(alert: nilResponse ?? "Server Error")
        }) { (error) in
            self.homeworkViewDelegate?.hideLoader()
            self.homeworkViewDelegate?.showAlert(alert: error?.localizedDescription ?? "Error")
        }
    }
    
    
    func deleteHW(homeworkId: Int?) {
        
        let url = "api/Institute/DeleteAssignHomework"+"?assignHomeWorkId=\(String(describing: homeworkId!))"
                self.homeworkViewDelegate?.showLoader()
                SubjectApi.sharedInstance.deleteSubjectApi(url: url,completionResponse: {DeleteSubjectModel in
                     self.homeworkViewDelegate?.hideLoader()
                    if DeleteSubjectModel.statusCode == KStatusCode.kStatusCode200{
                        if DeleteSubjectModel.status == true{
                           self.homeworkViewDelegate?.hideLoader()
                    self.getHomeworkData(teacherId: UserDefaultExtensionModel.shared.userRoleParticularId)
                        }else{
                           self.homeworkViewDelegate?.hideLoader()
                           self.homeworkViewDelegate?.showAlert(alert: DeleteSubjectModel.message ?? Alerts.kServerErrorAlert)
                             }
                    }
            }, completionnilResponse: { (nilResponse) in
                    self.homeworkViewDelegate?.hideLoader()
                    if let res = nilResponse{
                        self.homeworkViewDelegate?.showAlert(alert: res)
                    }
                }) { (error) in
                    self.homeworkViewDelegate?.hideLoader()
                    if let err = error{
                        self.homeworkViewDelegate?.showAlert(alert: err.localizedDescription)
                    }
                }
    }
   
}