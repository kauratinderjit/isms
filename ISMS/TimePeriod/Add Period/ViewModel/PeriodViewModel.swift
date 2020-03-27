//
//  PeriodViewModel.swift
//  ISMS
//
//  Created by Poonam Sharma on 7/10/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation

protocol PeriodDelegate: class {
    func unauthorizedUser()
    func getClassdropdownDidSucceed(data : [ResultData]?)
    func getPeriodListSucced(data: [PeriodsListData])
    
}

class PeriodViewModel{
    
    //Global ViewDelegate weak object
    private weak var TimePeriodVC : ViewDelegate?
    
    //StudentListDelegate weak object
    private weak var PeriodDelegate : PeriodDelegate?
    
    //Initiallize the presenter StudentList using delegates
    init(delegate:PeriodDelegate) {
        PeriodDelegate = delegate
    }
    
    //Attach GlobalViewDelegate
    func attachView(viewDelegate : ViewDelegate){
        TimePeriodVC = viewDelegate
    }
    
    //Deattach View for free the memory from instances
    func deattachView(){
        TimePeriodVC = nil
        PeriodDelegate = nil
    }
    
    func getClassId(id: Int?, enumtype: Int?){
        guard let selectId = id else{ return }
        guard let enumType = enumtype else { return }
        
        self.TimePeriodVC?.showLoader()
        
        AddPeriodApi.sharedInstance.getClassDropdownData(id: selectId, enumType: enumType, completionResponse: { (responseModel) in
            
            self.PeriodDelegate?.getClassdropdownDidSucceed(data: responseModel.resultData)
            self.TimePeriodVC?.hideLoader()
            
            
        }, completionnilResponse: { (nilResponse) in
            self.TimePeriodVC?.hideLoader()
            if let nilRes = nilResponse{
                self.TimePeriodVC?.showAlert(alert: nilRes)
            }
        }) { (error) in
            self.TimePeriodVC?.hideLoader()
            if let err = error{
                self.TimePeriodVC?.showAlert(alert: err.localizedDescription)
            }
        }
    }
    
    func addPeriod(periodList: [PeriodsListData], ClassId: Int?){
        
        var newList = periodList
        for  (i,value) in  newList.enumerated(){
            
            if let startTime  = value.strStartTime {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = KConstants.kTime
                if let date = dateFormatter.date(from:startTime) {
                    print(date)
                    dateFormatter.dateFormat = "HH:mm"
                    let datestr = dateFormatter.string(from: date)
                    print(datestr)
                    newList[i].strStartTime = datestr
                }
            }
            if let endTime  = value.strEndTime {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = KConstants.kTime
                if let date = dateFormatter.date(from:endTime) {
                    print(date)
                    dateFormatter.dateFormat = "HH:mm"
                    let datestr = dateFormatter.string(from: date)
                    print(datestr)
                    newList[i].strEndTime = datestr
                    print(newList[i])
                }
            }
        }
        
        let params = ["PeriodListViewModel": newList.toJSON(), "ClassId":ClassId ?? 0] as [String : Any]
        print(params)
        self.TimePeriodVC?.showLoader()
        AddPeriodApi.sharedInstance.AddPeriodList(url: ApiEndpoints.kAddPeriod, parameters: params as [String : Any], completionResponse: { (AddPeriodModel) in
            
            if AddPeriodModel.statusCode == KStatusCode.kStatusCode200{
                self.TimePeriodVC?.hideLoader()
                self.TimePeriodVC?.showAlert(alert: AddPeriodModel.message ?? "")
            }else if AddPeriodModel.statusCode == KStatusCode.kStatusCode401{
                self.TimePeriodVC?.hideLoader()
                self.TimePeriodVC?.showAlert(alert: AddPeriodModel.message ?? "")
                self.PeriodDelegate?.unauthorizedUser()
            }else if AddPeriodModel.statusCode == KStatusCode.kStatusCode400 {
                self.TimePeriodVC?.hideLoader()
                self.TimePeriodVC?.showAlert(alert: AddPeriodModel.message ?? "")
            }else{
                self.TimePeriodVC?.hideLoader()
                CommonFunctions.sharedmanagerCommon.println(object: "student APi status change")
            }
            
        }, completionnilResponse: { (nilResponseError) in
            
            self.TimePeriodVC?.hideLoader()
            
            if let error = nilResponseError{
                self.TimePeriodVC?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "student APi Nil response")
            }
            
        }) { (error) in
            self.TimePeriodVC?.hideLoader()
            if let err = error?.localizedDescription{
                self.TimePeriodVC?.showAlert(alert: err)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "student APi error response")
            }
        }
        
    }
    
    func getPeriodList(classId: Int, Search: String, Skip: Int,PageSize: Int, SortColumnDir: String,SortColumn: String){
        
        let params = ["ClassId":classId, "Search":Search, "Skip": Skip,"PageSize": PageSize,"SortColumnDir": "", "SortColumn": "" ] as [String : Any]
        
        self.TimePeriodVC?.showLoader()
        
        AddPeriodApi.sharedInstance.GetPeriodList(url: ApiEndpoints.kGetPeriod, parameters: params as [String : Any], completionResponse: { (GetPeriodListModel) in
            
            if GetPeriodListModel.statusCode == KStatusCode.kStatusCode200{
                self.TimePeriodVC?.hideLoader()
                if let result = GetPeriodListModel.resultData {
                    self.PeriodDelegate?.getPeriodListSucced(data: result)
                }
            }else if GetPeriodListModel.statusCode == KStatusCode.kStatusCode401{
                self.TimePeriodVC?.hideLoader()
                self.TimePeriodVC?.showAlert(alert: GetPeriodListModel.message ?? "")
                self.PeriodDelegate?.unauthorizedUser()
            }else if GetPeriodListModel.statusCode == KStatusCode.kStatusCode400{
                self.TimePeriodVC?.hideLoader()
                self.TimePeriodVC?.showAlert(alert: GetPeriodListModel.message ?? "")
            }else{
                self.TimePeriodVC?.hideLoader()
                CommonFunctions.sharedmanagerCommon.println(object: "student APi status change")
            }
            
        }, completionnilResponse: { (nilResponseError) in
            
            self.TimePeriodVC?.hideLoader()
            
            if let error = nilResponseError{
                self.TimePeriodVC?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "student APi Nil response")
            }
            
        }) { (error) in
            self.TimePeriodVC?.hideLoader()
            if let err = error?.localizedDescription{
                self.TimePeriodVC?.showAlert(alert: err)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "student APi error response")
            }
        }
    }
    
    func deletePeriod(periodId: Int){
        self.TimePeriodVC?.showLoader()
        
        AddPeriodApi.sharedInstance.deletePeriod(url: ApiEndpoints.kDeletePeriod + "\(periodId )", parameters: nil, completionResponse: { (DeletePeriodModel) in
            
            if DeletePeriodModel.statusCode == KStatusCode.kStatusCode200{
                self.TimePeriodVC?.hideLoader()
                self.TimePeriodVC?.showAlert(alert: DeletePeriodModel.message ?? "")
            }else{
                self.TimePeriodVC?.hideLoader()
                CommonFunctions.sharedmanagerCommon.println(object: "student APi status change")
            }
            
        }, completionnilResponse: { (nilResponseError) in
            
            self.TimePeriodVC?.hideLoader()
            
            if let error = nilResponseError{
                self.TimePeriodVC?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "student APi Nil response")
            }
            
        }) { (error) in
            self.TimePeriodVC?.hideLoader()
            if let err = error?.localizedDescription{
                self.TimePeriodVC?.showAlert(alert: err)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "student APi error response")
            }
        }
        
    }
    
}
