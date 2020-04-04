//
//  SchoolPresenter.swift
//  ISMS
//  Presenter
//  Created by Gurleen Osahan on 6/17/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
import UIKit

protocol AddSchoolDelegate:class{
    func dataSchoolInfo(data:SchoolData)
    func getAllSchoolcollegeData(data: GetCommonDropdownModel)
    func unauthorizedUser()
}

class AddSchoolViewModel{
    weak var delegate:AddSchoolDelegate?
    weak var addSchoolView: ViewDelegate?
    
    init(delegate:AddSchoolDelegate){
        self.delegate = delegate
    }
    
    //Attaching view
    func attachView(view: ViewDelegate) {
        addSchoolView = view
    }
    //Detaching view
    func detachView() {
        addSchoolView = nil
    }
    
    //Api to fetch Country list
    func GetSchoolInformation(institudeId: Int){
        self.addSchoolView?.showLoader()
        let url = ApiEndpoints.kGetSchoolApi+"?instituteid=\(institudeId)"
        AddSchoolApi.sharedInstance.GetSchoolInformationApi(url: url, parameter:nil , completionResponse: { (response) in
            self.addSchoolView?.hideLoader()
            switch response.statusCode{
            case KStatusCode.kStatusCode200:
                self.delegate?.dataSchoolInfo(data: response)
            case KStatusCode.kStatusCode401:
                if let msg = response.message{
                    self.addSchoolView?.showAlert(alert: msg)
                }
                self.delegate?.unauthorizedUser()
            default :
                self.addSchoolView?.hideLoader()
            }

        }, completionnilResponse: {
             self.addSchoolView?.hideLoader()
            
        }, Error: { (error) in
             self.addSchoolView?.hideLoader()
            if let err = error{
                self.addSchoolView?.showAlert(alert: err)
            }
        })
    }
    
    func updateSchoolAPI(InstititeId:Int,Name:String,Latitude:String,Longtitude:String,WebsiteLink:String,Address:String,PhoneNo:String,Email:String,BoardId:Int,BoardName:String,Inquiry:String,EstablishDate:String,TypeId:Int,TypeName:String,IFile: [UploadItems],LstDeletedAttachment:[[String:Any]]) {
        
        let url = ApiEndpoints.kUpdateSchoolApi
        
        let params = ["InstititeId":InstititeId,"Name":Name,"Latitude":Latitude,"Longtitude":Longtitude,"WebsiteLink":WebsiteLink,"Address":Address,"PhoneNo":PhoneNo,"Email":Email,"BoardId":BoardId,"BoardName":BoardName,"Inquiry":Inquiry,"EstablishDate":EstablishDate,"TypeId":TypeId,"TypeName":TypeName,"IFile":IFile,"LstDeletedAttachment":LstDeletedAttachment] as [String : Any]
        
        if Name.isEmpty, Name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
            addSchoolView?.showAlert(alert: "Please Enter name")
        }
        else if  WebsiteLink.isEmpty,WebsiteLink.trimmingCharacters(in: .whitespaces).isEmpty{
            addSchoolView?.showAlert(alert: "Please enter website name")
        }
        else if Address.isEmpty, Address.trimmingCharacters(in: .whitespaces).isEmpty{
         addSchoolView?.showAlert(alert: Alerts.kEmptyAddress)
        }
        else if PhoneNo.isEmpty,PhoneNo.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
         addSchoolView?.showAlert(alert: Alerts.kEmptyPhoneNumber)
        }
        else if Email.isEmpty,Email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
            addSchoolView?.showAlert(alert: Alerts.kEmptyEmail)
        }
        else if !Email.isValidEmail(){
            addSchoolView?.showAlert(alert: Alerts.kInvalidEmail)
        }
        else if Inquiry.isEmpty,Inquiry.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
           addSchoolView?.showAlert(alert: "Please enter text for inquiry")
        }
        else {
        self.addSchoolView?.showLoader()
        AddSchoolApi.sharedInstance.updateSchoolInfo(url: url, parameter: params, uploadItems: IFile, completionResponse: { (response) in
            self.addSchoolView?.hideLoader()
             self.addSchoolView?.showAlert(alert: "Institute updated successfully")
            print(response)
        }, completionnilResponse: { (nilresponse) in
             self.addSchoolView?.hideLoader()
            self.addSchoolView?.showAlert(alert: "No Record Found")
        }, completionError: { (error) in
             self.addSchoolView?.hideLoader()
            self.addSchoolView?.showAlert(alert:error?.localizedDescription ?? "")
        })
        }
    }
    
    func getSchoolColleges(id:Int, enumType:Int) {
        self.addSchoolView?.showLoader()
        let url = ApiEndpoints.kGetCommonDropdownApi+"?id=\(id)&enumType=\(enumType)"
        print("Get Country Url:- \(url)")
        SignUpApi.sharedInstance.getCommonDropdownApi(url: url, parameter: nil, completionResponse: { (data) in
            self.addSchoolView?.hideLoader()
            self.delegate?.getAllSchoolcollegeData(data: data)
            
        }, completionnilResponse:
            {_ in
            self.addSchoolView?.hideLoader()
          self.addSchoolView?.showAlert(alert: "No Record Found")
        }) { (error) in
        self.addSchoolView?.hideLoader()
       self.addSchoolView?.showAlert(alert: (error?.localizedDescription)!)
        }
        
    }
    
    
    func validationsUpdate(Name:String?,WebsiteLink:String?,Address:String?,PhoneNo:String?,Email:String?,Inquiry:String?){
        
        if let Name = Name,  !Name.isEmpty, !Name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
        }
        else{
            addSchoolView?.showAlert(alert: "Please Enter name")
        }
        
        if let WebsiteLink  = WebsiteLink, !WebsiteLink.isEmpty, !WebsiteLink.trimmingCharacters(in: .whitespaces).isEmpty{
            
        } else{
            addSchoolView?.showAlert(alert: "Please enter website name")
        }
        
        if let Address  = Address, !Address.isEmpty, !Address.trimmingCharacters(in: .whitespaces).isEmpty{
            
        }
        else{
            addSchoolView?.showAlert(alert: Alerts.kEmptyAddress)
        }
        if let PhoneNo = PhoneNo,!PhoneNo.isEmpty,!PhoneNo.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
           
        }
        else{
            addSchoolView?.showAlert(alert: Alerts.kEmptyPhoneNumber)
        }
        
        if let Email = Email,!Email.isEmpty,!Email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
            if !Email.isValidEmail(){
                addSchoolView?.showAlert(alert: Alerts.kEmptyEmail)
            }
        }else{
            addSchoolView?.showAlert(alert: Alerts.kEmptyEmail)
        }
        
        
        if let Inquiry = Inquiry,!Inquiry.isEmpty,!Inquiry.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
            
        }
        else{
            addSchoolView?.showAlert(alert: "Please enter text for inquiry")
        }
        
        
    }
    
}
