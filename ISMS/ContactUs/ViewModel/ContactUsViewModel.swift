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
            
            let paramDict = ["id": 31] as [String : Any]
        let contactId = 31
            let url = "api/User/GetContactUsDetail" + "?id=" + "\(contactId)"
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
    
    func addContact(ContactId: Int,InstituteId: Int,Message: String,lstEmergencyInquiryViewModels: [[String: Any]],lstAdmissionInquiryViewModels: [[String: Any]],lstGeneralInquiryViewModels: [[String: Any]],lstdeleteEmergencyInquiryViewModels: [[String: Any]],lstdeleteAdmissionInquiryViewModels: [[String: Any]],lstdeleteGeneralInquiryViewModels : [[String: Any]]){
        
        let parameters = ["ContactId": 31,"InstituteId": 1,"Message": "","lstEmergencyInquiryViewModels": lstEmergencyInquiryViewModels,"lstAdmissionInquiryViewModels": lstAdmissionInquiryViewModels,"lstGeneralInquiryViewModels": lstGeneralInquiryViewModels,"lstdeleteEmergencyInquiryViewModels": lstdeleteEmergencyInquiryViewModels,"lstdeleteAdmissionInquiryViewModels": lstdeleteAdmissionInquiryViewModels,"lstdeleteGeneralInquiryViewModels" : lstdeleteGeneralInquiryViewModels] as [String : Any]
        self.ContactUsView?.showLoader()
        SubjectApi.sharedInstance.AddSubject(url: "api/User/AddUpdateContactUsDetail", parameters: parameters, completionResponse: { (responseModel) in
            print(responseModel)
            self.ContactUsView?.hideLoader()
            if responseModel.statusCode == KStatusCode.kStatusCode200{
                
                if responseModel.resultData != nil{
                    self.ContactUsView?.showAlert(alert: responseModel.message ?? "")
                    
                }else{
                   
                    self.ContactUsView?.showAlert(alert: responseModel.message ?? "")
                }
                
            }else if responseModel.statusCode == KStatusCode.kStatusCode401{
                self.ContactUsView?.showAlert(alert: responseModel.message ?? "")
                //                self.SubjectListDelegate?.unauthorizedUser()
            }
            
            if responseModel.statusCode == KStatusCode.kStatusCode400{
                self.ContactUsView?.showAlert(alert: responseModel.message ?? "")
            }
            
        }, completionnilResponse: { (nilResponse) in
            self.ContactUsView?.hideLoader()
            self.ContactUsView?.showAlert(alert: nilResponse ?? Alerts.kMapperModelError)
        }) { (error) in
            self.ContactUsView?.hideLoader()
            self.ContactUsView?.showAlert(alert: error.debugDescription)
            
            
        }
    }
}
