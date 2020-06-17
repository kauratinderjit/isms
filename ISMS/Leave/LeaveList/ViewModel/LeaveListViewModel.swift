//
//  LeaveListViewModel.swift
//  ISMS
//
//  Created by Poonam  on 08/06/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import Foundation
protocol LeaveListDelegate: class {
    func unauthorizedUser()
    func leaveListDidSuccess(data : [GetLeaveListResultData]?)
    func leaveListDidFailed()
}

class LeaveListViewModel{
    var isSearching : Bool?
    //Global ViewDelegate weak object
    private weak var ListView : ViewDelegate?
    
    //ClassListDelegate weak object
    private weak var LeaveListDelegate : LeaveListDelegate?
    
    //Initiallize the presenter class using delegates
    init(delegate: LeaveListDelegate) {
        LeaveListDelegate = delegate
    }
    
    //Attach GlobalViewDelegate
    func attachView(viewDelegate : ViewDelegate){
        ListView = viewDelegate
    }
    
    //Deattach View for free the memory from instances
    func deattachView(){
        ListView = nil
        LeaveListDelegate = nil
    }
    //MARK:- Class list
    func LeaveList(Search: String, Skip: Int,PageSize: Int,SortColumnDir: String,  SortColumn: String, ParticularId : Int,EnrollmentId: Int){
        
        if isSearching == false{
            self.ListView?.showLoader()
        }
        
        var postDict = [String:Any]()
        
       
        postDict = ["Search": Search ?? "","Skip":Skip ?? 0,"PageSize": PageSize ?? 0,"SortColumnDir": SortColumnDir ?? "", "SortColumn": SortColumn ?? "","ParticularId" : ParticularId,"EnrollmentId": EnrollmentId] as [String : Any]
       let url = "api/Institute/GetLeaveAppList"
         print("param: ",postDict)
        
        ClassApi.sharedManager.getLeaveList(url: url, parameters: postDict, completionResponse: { (LeaveListModel) in
            
            self.ListView?.hideLoader()

            switch LeaveListModel.statusCode{
            case KStatusCode.kStatusCode200:
                self.LeaveListDelegate?.leaveListDidSuccess(data: LeaveListModel.resultData)
            case KStatusCode.kStatusCode401:
                if let msg = LeaveListModel.message{
                    self.ListView?.showAlert(alert: msg)
                }
                self.LeaveListDelegate?.unauthorizedUser()
            default:
                if let msg = LeaveListModel.message{
                    self.ListView?.showAlert(alert: msg)
                }
            }
        }, completionnilResponse: { (nilResponseError) in
            
            self.ListView?.hideLoader()
            self.LeaveListDelegate?.leaveListDidFailed()
            
            if let error = nilResponseError{
                self.ListView?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Class APi Nil response")
            }
            
        }) { (error) in
            self.ListView?.hideLoader()
            self.LeaveListDelegate?.leaveListDidFailed()
            if let err = error?.localizedDescription{
                self.ListView?.showAlert(alert: err)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Class APi error response")
            }
        }
    }
}
