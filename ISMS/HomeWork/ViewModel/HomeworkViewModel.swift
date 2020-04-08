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
    
    
    
    func getData(StringChapterID : String , ClassSubject : Int , classId : Int , userID : Int) {
        
       let url = KApiParameters.kUpdateSyllabusApiParameter.kAddUpdateSyllabus
        let param = [KApiParameters.kUpdateSyllabusApiParameter.kStrChapterId: StringChapterID ,KApiParameters.kUpdateSyllabusApiParameter.kClassSubjectId : ClassSubject,KApiParameters.kUpdateSyllabusApiParameter.kClassId :1 ,KApiParameters.kUpdateSyllabusApiParameter.kUserId : userID ] as [String : Any]
        
        
        HomeworkApi.sharedManager.UpdateHomeworkData(url:url , parameters: param, completionResponse: { (UpdateSyllabusModel) in
            self.homeworkViewDelegate?.hideLoader()
            if let msg = UpdateSyllabusModel.message {
             self.homeworkViewDelegate?.showAlert(alert: msg)
            }
        }, completionnilResponse: { (nilResponseError) in
            self.homeworkViewDelegate?.hideLoader()
            // self.syllabusCoverageDelegate?.SyllabusCoverageFailour(msg :
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
   
    func GetSchoolList(search : String ,Skip : Int,  PageSize : Int , SortColumnDir : String , SortCoumn : String, particularId : Int) {
        
        let url = KApiParameters.kUpdateSyllabusApiParameter.kChapterAndTopicApi
      
        let param = [KApiParameters.kUpdateSyllabusApiParameter.kSearch : "" ,KApiParameters.kUpdateSyllabusApiParameter.kPageSize: 0, KApiParameters.kUpdateSyllabusApiParameter.kSkip : 0 ,KApiParameters.kUpdateSyllabusApiParameter.kSortColumnDir : "",KApiParameters.kUpdateSyllabusApiParameter.kSortCoumn :"" ,KApiParameters.kUpdateSyllabusApiParameter.kParticularId : particularId ] as [String : Any]
       
        HomeworkApi.sharedManager.UpdateHomeworkData(url:url , parameters: param, completionResponse: { (UpdateSyllabusModel) in
             self.homeworkViewDelegate?.hideLoader()
                if let result = UpdateSyllabusModel.resultData {
                    self.addHomeworkDelegate?.AddHomeworkSucceed(array: result)
                }
        }, completionnilResponse: { (nilResponseError) in
            self.homeworkViewDelegate?.hideLoader()
            // self.syllabusCoverageDelegate?.SyllabusCoverageFailour(msg :
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
    
    
   
}
