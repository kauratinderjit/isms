//
//  UpdateSyllabusViewModel.swift
//  ISMS
//
//  Created by Kuldeep Singh on 11/18/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

protocol UpdateSyllabusDelegate: class {
    func UpdateSyllabusSucceed(array : [UpdateSyllabusResultData])
    func UpdateSyllabusFailour(msg : String)
}


class UpdateSyllabusViewModel {

    
    //Global ViewDelegate weak object
    private weak var updateSyllabusViewDelegate : ViewDelegate?
    
    //registerCustomerDelegate weak object
    private weak var updateSyllabusDelegate : UpdateSyllabusDelegate?
    
    //Initiallize the presenter class using delegates
    init(delegate: UpdateSyllabusDelegate) {
        updateSyllabusDelegate = delegate
    }
    
    //Attach GlobalViewDelegate
    func attachView(viewDelegate : ViewDelegate){
        updateSyllabusViewDelegate = viewDelegate
    }
    
    
    
    func getData(StringChapterID : String , ClassSubject : Int , classId : Int , userID : Int) {
        
       let url = KApiParameters.kUpdateSyllabusApiParameter.kAddUpdateSyllabus
        let param = [KApiParameters.kUpdateSyllabusApiParameter.kStrChapterId: StringChapterID ,KApiParameters.kUpdateSyllabusApiParameter.kClassSubjectId : ClassSubject,KApiParameters.kUpdateSyllabusApiParameter.kClassId :1 ,KApiParameters.kUpdateSyllabusApiParameter.kUserId : userID ] as [String : Any]
        
        
        UpdateSyllabusApi.sharedManager.UpdateSyllabusData(url:url , parameters: param, completionResponse: { (UpdateSyllabusModel) in
            self.updateSyllabusViewDelegate?.hideLoader()
            if let msg = UpdateSyllabusModel.message {
             self.updateSyllabusViewDelegate?.showAlert(alert: msg)
            }
        }, completionnilResponse: { (nilResponseError) in
            self.updateSyllabusViewDelegate?.hideLoader()
            // self.syllabusCoverageDelegate?.SyllabusCoverageFailour(msg :
            if let error = nilResponseError{
                self.updateSyllabusViewDelegate?.showAlert(alert: error.description)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: SyllabusCoverage.kSyllabusResponseNotGet)
            }
        }) { (error) in
            self.updateSyllabusViewDelegate?.hideLoader()
            if let err = error?.localizedDescription{
                self.updateSyllabusViewDelegate?.showAlert(alert: err)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: SyllabusCoverage.kSyllabusResponseError)
            }
        }
        
        
        
        
        
    }
   
    func GetChapterList(search : String ,Skip : Int,  PageSize : Int , SortColumnDir : String , SortCoumn : String, particularId : Int) {
        
        let url = KApiParameters.kUpdateSyllabusApiParameter.kChapterListApi
      
        let param = [KApiParameters.kUpdateSyllabusApiParameter.kSearch : "" ,KApiParameters.kUpdateSyllabusApiParameter.kPageSize: 0, KApiParameters.kUpdateSyllabusApiParameter.kSkip : 0 ,KApiParameters.kUpdateSyllabusApiParameter.kSortColumnDir : "",KApiParameters.kUpdateSyllabusApiParameter.kSortCoumn :"" ,KApiParameters.kUpdateSyllabusApiParameter.kParticularId : 40 ] as [String : Any]
       
        UpdateSyllabusApi.sharedManager.UpdateSyllabusData(url:url , parameters: param, completionResponse: { (UpdateSyllabusModel) in
             self.updateSyllabusViewDelegate?.hideLoader()
                if let result = UpdateSyllabusModel.resultData {
                self.updateSyllabusDelegate?.UpdateSyllabusSucceed(array: result)
                }
        }, completionnilResponse: { (nilResponseError) in
            self.updateSyllabusViewDelegate?.hideLoader()
            // self.syllabusCoverageDelegate?.SyllabusCoverageFailour(msg :
            if let error = nilResponseError{
                self.updateSyllabusViewDelegate?.showAlert(alert: error.description)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: SyllabusCoverage.kSyllabusResponseNotGet)
            }
        }) { (error) in
            self.updateSyllabusViewDelegate?.hideLoader()
            if let err = error?.localizedDescription{
                self.updateSyllabusViewDelegate?.showAlert(alert: err)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: SyllabusCoverage.kSyllabusResponseError)
            }
        }
        
        
        
        
        
        
        
    }
    
    
   
}
