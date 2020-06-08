//
//  AddLeaveReqViewModel.swift
//  ISMS
//
//  Created by Poonam  on 08/06/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//
//AddLeaveReqViewModel
import Foundation

protocol AddLeaveReqDelegate: class {
    func addLeaveSucess(msg: String)
}

class AddLeaveReqViewModel{
    
    //Global ViewDelegate weak object
    private weak var ListView : ViewDelegate?
    
    //ClassListDelegate weak object
    private weak var AddLeaveReqDelegate : AddLeaveReqDelegate?
    
    //Initiallize the presenter class using delegates
    init(delegate: AddLeaveReqDelegate) {
        AddLeaveReqDelegate = delegate
    }
    
    //Attach GlobalViewDelegate
    func attachView(viewDelegate : ViewDelegate){
        ListView = viewDelegate
    }
    
    //Deattach View for free the memory from instances
    func deattachView(){
        ListView = nil
        AddLeaveReqDelegate = nil
    }
    
    func submitLeaveReq(LeaveAppId:Int,LeaveAppType:String,Discription:String,StartDate:String,EndDate:String,IsApproved:Int,EnrollmentId:Int,ClassId:Int,GuardianId:Int,IFile: [UploadItems],leaveAppAttachmentDelete:[[String:Any]]) {
        
        let url = "api/Institute/AddUpdateLeaveApplication"
        
        let params = ["LeaveAppId":LeaveAppId,"LeaveAppType":LeaveAppType,"Discription":Discription,"StartDate":StartDate,"EndDate":EndDate,"IsApproved":IsApproved,"EnrollmentId":EnrollmentId,"ClassId":ClassId,"GuardianId":GuardianId,"IFile":IFile,"leaveAppAttachmentDelete":leaveAppAttachmentDelete] as [String : Any]
      print("param: ",params)
            
        self.ListView?.showLoader()
        AddSchoolApi.sharedInstance.updateSchoolInfo(url: url, parameter: params, uploadItems: IFile, completionResponse: { (response) in
            
            self.ListView?.hideLoader()
            self.AddLeaveReqDelegate?.addLeaveSucess(msg: (response).value(forKey: "Message") as? String ?? "")
//            self.ListView?.showAlert(alert: (response).value(forKey: "Message") as? String ?? "")
            print(response)
        }, completionnilResponse: { (nilresponse) in
             self.ListView?.hideLoader()
            self.ListView?.showAlert(alert: "No Record Found")
        }, completionError: { (error) in
             self.ListView?.hideLoader()
            self.ListView?.showAlert(alert:error?.localizedDescription ?? "")
        })
        
    }
    
}
