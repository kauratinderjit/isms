//
//  EventViewModel.swift
//  ISMS
//
//  Created by Atinder Kaur on 4/3/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import Foundation


import UIKit

protocol EventScheduleDelegate: class {
    func EventScheduleSucceed(array : [EventScheduleListResultData])
    func EventScheduleFailour(msg : String)
    func AddEventScheduleSucceed()
    func SubjectEventSuccess()
}


class EventScheduleViewModel {

    //Global ViewDelegate weak object
    private weak var viewGlobalDelegate : ViewDelegate?
    private weak var eventScheduleDelegate : EventScheduleDelegate?
    
    //Initiallize the presenter class using delegates
    init(delegate: EventScheduleDelegate) {
        eventScheduleDelegate = delegate
    }

    //Attach GlobalViewDelegate
    func attachView(viewDelegate : ViewDelegate){
        viewGlobalDelegate = viewDelegate
    }
 

    func getData(RoleId : Int , ParticularId : Int) {
        
        //let url = SyllabusCoverage.kSyllabusCoverageUrl
        let param = [ "RoleId":RoleId , "ParticularId": ParticularId] as [String : Any]
        

        EventScheduleApi.sharedManager.EventScheduleData(url:"api/Institute/GetEventsByRoleParticularId" , parameters: param, completionResponse: { (SyllabusModel) in
            self.viewGlobalDelegate?.hideLoader()
            if let result = SyllabusModel.resultData {
                self.eventScheduleDelegate?.EventScheduleSucceed(array : result)
            }
        }, completionnilResponse: { (nilResponseError) in
            self.viewGlobalDelegate?.hideLoader()
           // self.syllabusCoverageDelegate?.SyllabusCoverageFailour(msg :
            if let error = nilResponseError{
                self.viewGlobalDelegate?.showAlert(alert: error.description)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: SyllabusCoverage.kSyllabusResponseNotGet)
            }
        }) { (error) in
            self.viewGlobalDelegate?.hideLoader()
            if let err = error?.localizedDescription{
                self.viewGlobalDelegate?.showAlert(alert: err)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: SyllabusCoverage.kSyllabusResponseError)
            }
        }
    }
    
    
    //MARK:- Add Department
    func addUpdateEvent(eventId:Int?,title: String?,description : String?,startTime: String?,endTime: String?, evntStartDate: String?,evntEndDate: String?)
    {
        //MARK:- Validations
        if(title!.trimmingCharacters(in: .whitespaces).isEmpty)
        {
            self.viewGlobalDelegate?.showAlert(alert: Alerts.kEmptyTitle)
        }
        else if(description!.trimmingCharacters(in: .whitespaces).isEmpty)
        {
            self.viewGlobalDelegate?.showAlert(alert: Alerts.kEmptyDescription)
        }
        else
        {
            guard let eventId = eventId else{return}
          
            let parameters = ["EventId":eventId,"Title": title!,"Description" : description!, "strStartDate" : evntStartDate!,"StrStartTime" : startTime!, "StrEndTime" :endTime!, "strEndDate": evntEndDate!] as [String : Any]
            print(parameters)
            self.viewGlobalDelegate?.showLoader()
            //AddDepartment API
            DepartmentApi.sharedInstance.addDepartment(url: "api/Institute/AddUpdateEvent", parameters: parameters, completionResponse: { (responseModel) in
                CommonFunctions.sharedmanagerCommon.println(object: "Response Model of addDepartment:- \(responseModel) ")
                self.viewGlobalDelegate?.hideLoader()
                
                switch responseModel.statusCode{
                case KStatusCode.kStatusCode200:
                    self.eventScheduleDelegate?.AddEventScheduleSucceed()
                case KStatusCode.kStatusCode401:
                    self.viewGlobalDelegate?.showAlert(alert: responseModel.message ?? "")
                   // self.viewGlobalDelegate?.unauthorizedUser()
                default:
                    self.viewGlobalDelegate?.showAlert(alert: responseModel.message ?? "")
                }
            }, completionnilResponse: { (nilresponse) in
                self.viewGlobalDelegate?.hideLoader()
                self.viewGlobalDelegate?.showAlert(alert: nilresponse ?? Alerts.kMapperModelError)
            }) { (error) in
                self.viewGlobalDelegate?.hideLoader()
                self.viewGlobalDelegate?.showAlert(alert: error?.localizedDescription ?? Alerts.kMapperModelError)
            }
        }
    }
    
    
    //Deelete Event
    
       func deleteEvent(eventId: Int){
            let url = "api/Institute/DeleteEvent?eventId=" +  "\(eventId)"
            self.viewGlobalDelegate?.showLoader()
            SubjectApi.sharedInstance.deleteSubjectApi(url: url,completionResponse: {DeleteSubjectModel in
                 self.viewGlobalDelegate?.hideLoader()
                if DeleteSubjectModel.statusCode == KStatusCode.kStatusCode200{
                    if DeleteSubjectModel.status == true{
                       self.viewGlobalDelegate?.hideLoader()
                 self.eventScheduleDelegate?.SubjectEventSuccess()
                    }else{
                       self.viewGlobalDelegate?.hideLoader()
                       self.viewGlobalDelegate?.showAlert(alert: DeleteSubjectModel.message ?? Alerts.kServerErrorAlert)
                         }
                }
        }, completionnilResponse: { (nilResponse) in
                self.viewGlobalDelegate?.hideLoader()
                if let res = nilResponse{
                    self.viewGlobalDelegate?.showAlert(alert: res)
                }
            }) { (error) in
                self.viewGlobalDelegate?.hideLoader()
                if let err = error{
                    self.viewGlobalDelegate?.showAlert(alert: err.localizedDescription)
                }
            }
        }
    
    
}
