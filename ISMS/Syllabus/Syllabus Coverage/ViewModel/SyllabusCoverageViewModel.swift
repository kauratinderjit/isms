//
//  SyllabusCoveragePresenter.swift
//  ISMS
//
//  Created by Kuldeep Singh on 11/15/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

protocol SyllabusCoverageDelegate: class {
    func SyllabusCoverageSucceed(array : [SyllabusCoverageListResultData])
    func SyllabusCoverageFailour(msg : String)
    func classListDidSuccess(data: GetCommonDropdownModel)
       func classListDidFailed()
}


class SyllabusCoverageViewModel {

    //Global ViewDelegate weak object
    private weak var syllabusCoverageViewDelegate : ViewDelegate?
    
    //registerCustomerDelegate weak object
    private weak var syllabusCoverageDelegate : SyllabusCoverageDelegate?
    
    //Initiallize the presenter class using delegates
    init(delegate: SyllabusCoverageDelegate) {
        syllabusCoverageDelegate = delegate
    }

    //Attach GlobalViewDelegate
    func attachView(viewDelegate : ViewDelegate){
        syllabusCoverageViewDelegate = viewDelegate
    }
 

    func getData(teacherId : Int , classID : Int) {
        
        let url = SyllabusCoverage.kSyllabusCoverageUrl
        let param = [SyllabusCoverage.kTeacherId :teacherId , SyllabusCoverage.kClassId: classID] as [String : Any]
        

        SyllabusCoveragApi.sharedManager.SyllabusCoverageData(url:url , parameters: param, completionResponse: { (SyllabusModel) in
            self.syllabusCoverageViewDelegate?.hideLoader()
            if let result = SyllabusModel.resultData {
               
                self.syllabusCoverageDelegate?.SyllabusCoverageSucceed(array : result)
                
            }
            

        }, completionnilResponse: { (nilResponseError) in
            self.syllabusCoverageViewDelegate?.hideLoader()
           // self.syllabusCoverageDelegate?.SyllabusCoverageFailour(msg :
            if let error = nilResponseError{
                self.syllabusCoverageViewDelegate?.showAlert(alert: error.description)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: SyllabusCoverage.kSyllabusResponseNotGet)
            }
        }) { (error) in
            self.syllabusCoverageViewDelegate?.hideLoader()
            if let err = error?.localizedDescription{
                self.syllabusCoverageViewDelegate?.showAlert(alert: err)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: SyllabusCoverage.kSyllabusResponseError)
            }
        }
        
        
        
        
        
    }
    
  //MARK:- Get Class List Dropdown Api
    func getClassListDropdown(selectId : Int,enumType:Int){
        
      syllabusCoverageViewDelegate?.showLoader()
        
        ClassApi.sharedManager.getClassDropdownData(selectedId: selectId, enumType: enumType, completionResponse: { (responseClassDropdown) in
        
            self.syllabusCoverageViewDelegate?.hideLoader()
            switch responseClassDropdown.statusCode{
            case KStatusCode.kStatusCode200:
                self.syllabusCoverageDelegate?.classListDidSuccess(data: responseClassDropdown)
            case KStatusCode.kStatusCode401:
                self.syllabusCoverageViewDelegate?.showAlert(alert: responseClassDropdown.message ?? "")
              //  self.syllabusCoverageViewDelegate?.unauthorizedUser()
            default:
                self.syllabusCoverageViewDelegate?.showAlert(alert: responseClassDropdown.message ?? "")
            }
        }, completionnilResponse: { (nilResponse) in
            self.syllabusCoverageViewDelegate?.hideLoader()
            self.syllabusCoverageViewDelegate?.showAlert(alert: nilResponse ?? "Server Error")
        }) { (error) in
            self.syllabusCoverageViewDelegate?.hideLoader()
            self.syllabusCoverageViewDelegate?.showAlert(alert: error?.localizedDescription ?? "Error")
        }
    }
    
}
