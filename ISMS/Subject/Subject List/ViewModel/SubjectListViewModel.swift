//
//  SubjectListViewModel.swift
//  ISMS
//
//  Created by Poonam Sharma on 7/1/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation

protocol SubjectListDelegate: class {
    func unauthorizedUser()
    func SubjectListDidSuccess(data: [GetSubjectResultData]?)
    func SubjectListDidFailed()
    func SubjectDeleteSuccess(data: DeleteSubjectModel)
    func SubjectDetailDidSuccess(Data: GetSubjectDetail)
    func SubjectDetailDidFailed()
    func UpdatedSubject(msg:String?)
}
class SubjectListViewModel{
    
    //Global ViewDelegate weak object
    private weak var SubjectListVC : ViewDelegate?
    
    //StudentListDelegate weak object
    private weak var SubjectListDelegate : SubjectListDelegate?
    
    //Initiallize the ViewModel StudentList using delegates
    init(delegate:SubjectListDelegate) {
        SubjectListDelegate = delegate
    }
    
    //Attach GlobalViewDelegate
    func attachView(viewDelegate : ViewDelegate){
        SubjectListVC = viewDelegate
    }
    
    //Deattach View for free the memory from instances
    func deattachView(){
        SubjectListVC = nil
        SubjectListDelegate = nil
    }
   
    
    func subjectList(search : String?,skip : Int?,pageSize: Int?,sortColumnDir: String?,sortColumn: String?){
        self.SubjectListVC?.showLoader()
        
        let paramDict = [KApiParameters.SubjectListApi.subjectSearch: search ?? "",KApiParameters.SubjectListApi.PageSkip:skip ?? 0,KApiParameters.SubjectListApi.PageSize: pageSize ?? 0,KApiParameters.SubjectListApi.sortColumnDir: sortColumnDir ?? "", KApiParameters.SubjectListApi.sortColumn: sortColumn ?? "",
                         KApiParameters.kUpdateSyllabusApiParameter.kParticularId : UserDefaultExtensionModel.shared.HODDepartmentId] as [String : Any]
        SubjectApi.sharedInstance.getSubjectList(url: ApiEndpoints.KSubjectListApi, parameters: paramDict as [String : Any], completionResponse: { (SubjectListModel) in
            
            if SubjectListModel.statusCode == KStatusCode.kStatusCode200{
                self.SubjectListVC?.hideLoader()
                self.SubjectListDelegate?.SubjectListDidSuccess(data: SubjectListModel.resultData)
            }else if SubjectListModel.statusCode == KStatusCode.kStatusCode401{
                self.SubjectListVC?.hideLoader()
                self.SubjectListVC?.showAlert(alert: SubjectListModel.message ?? "")
                self.SubjectListDelegate?.unauthorizedUser()
            }else{
                self.SubjectListVC?.hideLoader()
                CommonFunctions.sharedmanagerCommon.println(object: "student APi status change")
            }
            
        }, completionnilResponse: { (nilResponseError) in
            
            self.SubjectListVC?.hideLoader()
            self.SubjectListDelegate?.SubjectListDidFailed()
            
            if let error = nilResponseError{
                self.SubjectListVC?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "student APi Nil response")
            }
            
        }) { (error) in
            self.SubjectListVC?.hideLoader()
            self.SubjectListDelegate?.SubjectListDidFailed()
            if let err = error?.localizedDescription{
                self.SubjectListVC?.showAlert(alert: err)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "student APi error response")
            }
        }
        
    }
    
    func deleteSubject(SubjectId: Int){
        
        self.SubjectListVC?.showLoader()
        SubjectApi.sharedInstance.deleteSubjectApi(url: ApiEndpoints.KDeleteSubject+"\(SubjectId)", completionResponse: {DeleteSubjectModel in
            
            if DeleteSubjectModel.statusCode == KStatusCode.kStatusCode200{
                
                if DeleteSubjectModel.status == true{
                    CommonFunctions.sharedmanagerCommon.println(object: "delete student true")
                    self.SubjectListVC?.hideLoader()
                    self.SubjectListDelegate?.SubjectDeleteSuccess(data: DeleteSubjectModel)
                }else{
                    CommonFunctions.sharedmanagerCommon.println(object: "delete student false")
                    self.SubjectListVC?.hideLoader()
                    self.SubjectListVC?.showAlert(alert: DeleteSubjectModel.message ?? Alerts.kServerErrorAlert)
                }
                
            }else{
                self.SubjectListVC?.hideLoader()
                if let msg = DeleteSubjectModel.message{
                    self.SubjectListVC?.showAlert(alert: msg)
                    
                }
                CommonFunctions.sharedmanagerCommon.println(object: "Status code is diffrent.")
            }
            
        }, completionnilResponse: { (nilResponse) in
            
            self.SubjectListVC?.hideLoader()
            if let res = nilResponse{
                self.SubjectListVC?.showAlert(alert: res)
            }
            
        }) { (error) in
            self.SubjectListVC?.hideLoader()
            if let err = error{
                self.SubjectListVC?.showAlert(alert: err.localizedDescription)
            }
        }
        
    }
    
    func addSubject(subjectName: String?, DeptId: Int?,DeptSubjectID: Int?){
        self.SubjectListVC?.showLoader()
        do {
            try validationsAddSubject(subjectName: subjectName)
            
            let paramDict = [KApiParameters.AddSubjectApi.subjectName:subjectName ?? "", "DeptId": DeptId ?? 0, "DeptSubjectID": DeptSubjectID] as [String : Any]
            print("value of param: ",paramDict)
            
            SubjectApi.sharedInstance.AddSubject(url: ApiEndpoints.KAddSubject, parameters: paramDict, completionResponse: { (responseModel) in
                print(responseModel)
                
                self.SubjectListVC?.hideLoader()
                if responseModel.statusCode == KStatusCode.kStatusCode200{
                    
                    if responseModel.resultData != nil{
                       // self.SubjectListVC?.showAlert(alert: responseModel.message ?? "")
                        self.SubjectListDelegate?.UpdatedSubject(msg: responseModel.message ?? "")
                    }else{
                        self.SubjectListDelegate?.UpdatedSubject(msg: responseModel.message ?? "")
                       // self.SubjectListVC?.showAlert(alert: responseModel.message ?? "")
                    }
                  //  self.subjectList(search : "",skip : KIntegerConstants.kInt0,pageSize: 10,sortColumnDir: "",sortColumn: "")

                    
                }else if responseModel.statusCode == KStatusCode.kStatusCode401{
                    self.SubjectListVC?.showAlert(alert: responseModel.message ?? "")
                    self.SubjectListDelegate?.unauthorizedUser()
                }
                
                if responseModel.statusCode == KStatusCode.kStatusCode400{
                    self.SubjectListVC?.showAlert(alert: responseModel.message ?? "")
                }
                
            }, completionnilResponse: { (nilResponse) in
                self.SubjectListVC?.hideLoader()
                self.SubjectListVC?.showAlert(alert: nilResponse ?? Alerts.kMapperModelError)
            }) { (error) in
                self.SubjectListVC?.hideLoader()
                self.SubjectListVC?.showAlert(alert: error.debugDescription)
                
                
            }
        }
        catch let error {
            
            switch  error {
                
            case ValidationError.emptySubjectName:
                self.SubjectListVC?.showAlert(alert: Alerts.kEmptySubjectName)
                
                
            default:
                break
                //                self.signUPView?.showAlert(alertMessage: SignUpStrings.Alerts.k_EmptyFirstName)
            }
            
            
        }
    }
    func validationsAddSubject(subjectName: String?) throws
    {
        guard let subjectName  = subjectName, !subjectName.isEmpty, !subjectName.trimmingCharacters(in: .whitespaces).isEmpty else
        {
            throw ValidationError.emptySubjectName
        }
    }
    
    func subjectDetail(subjectId: Int?){
        self.SubjectListVC?.showLoader()
        
        SubjectApi.sharedInstance.getSubjectDetail(url: ApiEndpoints.KSubjectDetailApi + "\(subjectId ?? 0)", parameters: nil, completionResponse: { (GetSubjectDetail) in
            
            print(ApiEndpoints.KSubjectDetailApi + "\(subjectId ?? 0)")
            if GetSubjectDetail.statusCode == KStatusCode.kStatusCode200{
                self.SubjectListVC?.hideLoader()
                self.SubjectListDelegate?.SubjectDetailDidSuccess(Data: GetSubjectDetail)
                
            }else if GetSubjectDetail.statusCode == KStatusCode.kStatusCode401{
                self.SubjectListVC?.showAlert(alert: GetSubjectDetail.message ?? "")
                self.SubjectListDelegate?.unauthorizedUser()
            }else{
                self.SubjectListVC?.hideLoader()
                CommonFunctions.sharedmanagerCommon.println(object: "student APi status change")
            }
            
        }, completionnilResponse: { (nilResponseError) in
            
            self.SubjectListVC?.hideLoader()
            self.SubjectListDelegate?.SubjectDetailDidFailed()
            
            if let error = nilResponseError{
                self.SubjectListVC?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "student APi Nil response")
            }
            
        }) { (error) in
            self.SubjectListVC?.hideLoader()
            self.SubjectListDelegate?.SubjectDetailDidFailed()
            if let err = error?.localizedDescription{
                self.SubjectListVC?.showAlert(alert: err)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "student APi error response")
            }
        }
    }
    
    
}
