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
    
    
    
    func getData(ClassSubjectId : Int, ClassId :Int, UserId : Int, lstchaptertopiclists : [[String: Any]]) {
        
       let url = KApiParameters.kUpdateSyllabusApiParameter.kAddUpdateSyllabus
        let param = ["ClassSubjectId": ClassSubjectId ,"ClassId" : ClassId,"UserId" :UserId ,"lstchaptertopiclists" : lstchaptertopiclists ] as [String : Any]
        print("our params: ",param)
        
        UpdateSyllabusApi.sharedManager.UpdateSyllabusData(url:url , parameters: param, completionResponse: { (UpdateSyllabusModel) in
              print("our resposne: ",UpdateSyllabusModel)
            self.updateSyllabusViewDelegate?.hideLoader()
            if let msg = UpdateSyllabusModel.message {
             self.updateSyllabusViewDelegate?.showAlert(alert: msg)
            }
            self.GetChapterList(search : "" ,Skip : 0,  PageSize : 0 , SortColumnDir : "" , SortCoumn : "" , particularId : ClassSubjectId)
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
        
        let url = KApiParameters.kUpdateSyllabusApiParameter.kChapterAndTopicApi
      
        let param = [KApiParameters.kUpdateSyllabusApiParameter.kSearch : "" ,KApiParameters.kUpdateSyllabusApiParameter.kPageSize: 0, KApiParameters.kUpdateSyllabusApiParameter.kSkip : 0 ,KApiParameters.kUpdateSyllabusApiParameter.kSortColumnDir : "",KApiParameters.kUpdateSyllabusApiParameter.kSortCoumn :"" ,KApiParameters.kUpdateSyllabusApiParameter.kParticularId : particularId ] as [String : Any]
       
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
