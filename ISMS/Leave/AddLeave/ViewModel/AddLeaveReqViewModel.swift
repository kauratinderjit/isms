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
    func submitAcceptReject(LeaveAppId : Int,IsApproved: Int){
        let parameters = ["LeaveAppId":LeaveAppId,"IsApproved":IsApproved] as [String : Any]
        self.ListView?.showLoader()
       SubjectApi.sharedInstance.AddSubject(url: "api/Institute/ApprovedRejectLeaveApp", parameters: parameters, completionResponse: { (responseModel) in
            print(responseModel)
            
            self.ListView?.hideLoader()
            if responseModel.statusCode == KStatusCode.kStatusCode200{
                
                if responseModel.resultData != nil{
                    self.ListView?.showAlert(alert: responseModel.message ?? "")
//                    self.SubjectListDelegate?.UpdatedSubject(msg: responseModel.message ?? "")
                }else{
//                    self.SubjectListDelegate?.UpdatedSubject(msg: responseModel.message ?? "")
                    self.ListView?.showAlert(alert: responseModel.message ?? "")
                }
              //  self.subjectList(search : "",skip : KIntegerConstants.kInt0,pageSize: 10,sortColumnDir: "",sortColumn: "")

                
            }else if responseModel.statusCode == KStatusCode.kStatusCode401{
                self.ListView?.showAlert(alert: responseModel.message ?? "")
//                self.SubjectListDelegate?.unauthorizedUser()
            }
            
            if responseModel.statusCode == KStatusCode.kStatusCode400{
                self.ListView?.showAlert(alert: responseModel.message ?? "")
            }
            
        }, completionnilResponse: { (nilResponse) in
            self.ListView?.hideLoader()
            self.ListView?.showAlert(alert: nilResponse ?? Alerts.kMapperModelError)
        }) { (error) in
            self.ListView?.hideLoader()
            self.ListView?.showAlert(alert: error.debugDescription)
            
            
        }
    }
}
