//
//  ContactUsViewModel.swift
//  ISMS
//
//  Created by Poonam Sharma on 12/5/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//
//ContactUsViewModel

import Foundation

protocol ContactUsViewModelDelegate: class {
    func ContactUsDidSuccess(data: ContactUsResult?)
}
class ContactUsViewModel {
    private weak var ContactUsView : ViewDelegate?
    
    //TeacherListDelegate weak object
    private weak var ContactUsViewModelDelegate : ContactUsViewModelDelegate?
    
    //Initiallize the presenter class using delegates
    init(delegate: ContactUsViewModelDelegate) {
        ContactUsViewModelDelegate = delegate
    }
    
    //Attach GlobalViewDelegate
    func attachView(viewDelegate : ViewDelegate){
        ContactUsView = viewDelegate
    }
    
    //Deattach View for free the memory from instances
    func deattachView(){
        ContactUsView = nil
        ContactUsViewModelDelegate = nil
    }
    
    func getContactUs(){
    
            self.ContactUsView?.showLoader()
            
            let paramDict = ["id": 4] as [String : Any]
        let contactId = 4
            let url = "/api/User/GetContactUsDetailById" + "?id=" + "\(contactId)"
            print("url: ",url)
            ContactUsAPI.sharedInstance.GetContactUs(url: url, parameters: paramDict as [String : Any], completionResponse: { (ContactUsModel) in
                print("teacher list: ",ContactUsModel.resultData)
                if ContactUsModel.statusCode == KStatusCode.kStatusCode200{
                    self.ContactUsView?.hideLoader()
                    self.ContactUsViewModelDelegate?.ContactUsDidSuccess(data: ContactUsModel.resultData)
                }else if ContactUsModel.statusCode == KStatusCode.kStatusCode401{
                    self.ContactUsView?.hideLoader()
                    self.ContactUsView?.showAlert(alert: ContactUsModel.message ?? "")
                    //                    self.ViewTeacherRatingDelegate?.unauthorizedUser()
                }else{
                    self.ContactUsView?.hideLoader()
                    CommonFunctions.sharedmanagerCommon.println(object: "student APi status change")
                }
                
            }, completionnilResponse: { (nilResponseError) in
                
                self.ContactUsView?.hideLoader()
                
                if let error = nilResponseError{
                    self.ContactUsView?.showAlert(alert: error)
                    
                }else{
                    CommonFunctions.sharedmanagerCommon.println(object: "student APi Nil response")
                }
                
            }) { (error) in
                
            }
            
        }
}
