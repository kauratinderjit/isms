//
//  ClassListViewModel.swift
//  ISMS
//
//  Created by Taranjeet Singh on 6/18/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation


protocol ClassListDelegate: class {
    func unauthorizedUser()
     func getClassDetailDidSucceed(data : ClassDetailModel)
    func classListDidSuccess(data : [GetClassListResultData]?)
    func classListDidFailed()
    func classDeleteDidSuccess(data : DeleteClassModel)
    func classDeleteDidfailed()
}

class ClassListViewModel{
    var isSearching : Bool?
    //Global ViewDelegate weak object
    private weak var classListView : ViewDelegate?
    
    //ClassListDelegate weak object
    private weak var classListDelegate : ClassListDelegate?
    
    //Initiallize the presenter class using delegates
    init(delegate: ClassListDelegate) {
        classListDelegate = delegate
    }
    
    //Attach GlobalViewDelegate
    func attachView(viewDelegate : ViewDelegate){
        classListView = viewDelegate
    }
    
    //Deattach View for free the memory from instances
    func deattachView(){
        classListView = nil
        classListDelegate = nil
    }
    
    //MARK:- Class list
    func classList(Search: String, Skip: Int,PageSize: Int,SortColumnDir: String,  SortColumn: String, ParticularId : Int){
        
        if isSearching == false{
            self.classListView?.showLoader()
        }
        
        var postDict = [String:Any]()
        
        
        postDict = ["Search": Search ?? "","Skip":Skip ?? 0,"PageSize": PageSize ?? 0,"SortColumnDir": SortColumnDir ?? "", "SortColumn": SortColumn ?? "","ParticularId" : ParticularId] as [String : Any]
//        postDict["departmentId"] = departmentId
       
       let url = "api/Institute/GetClassListByDepartmentId"
        
        
        ClassApi.sharedManager.getClassList(url: url, parameters: postDict, completionResponse: { (ClassListModel) in
            
            self.classListView?.hideLoader()

            switch ClassListModel.statusCode{
            case KStatusCode.kStatusCode200:
                self.classListDelegate?.classListDidSuccess(data: ClassListModel.resultData)
            case KStatusCode.kStatusCode401:
                if let msg = ClassListModel.message{
                    self.classListView?.showAlert(alert: msg)
                }
                self.classListDelegate?.unauthorizedUser()
            default:
                if let msg = ClassListModel.message{
                    self.classListView?.showAlert(alert: msg)
                }
            }
        }, completionnilResponse: { (nilResponseError) in
            
            self.classListView?.hideLoader()
            self.classListDelegate?.classListDidFailed()
            
            if let error = nilResponseError{
                self.classListView?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Class APi Nil response")
            }
            
        }) { (error) in
            self.classListView?.hideLoader()
            self.classListDelegate?.classListDidFailed()
            if let err = error?.localizedDescription{
                self.classListView?.showAlert(alert: err)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Class APi error response")
            }
        }
    }
    
    func addUpdateClass(classid : Int,className : String?,selectedDepartmentId : Int?,departmentName : String?,description : String?,others : String?,imageUrl : URL?){
        
        //MARK:- Validations
//        if (className!.trimmingCharacters(in: .whitespaces).isEmpty){
//            self.classListView?.showAlert(alert: Alerts.kEmptyClass)
//        }
//        else if selectedDepartmentId == nil{
//            self.classListView?.showAlert(alert: Alerts.kEmptyDepartment)
//        }
//        else if(description!.trimmingCharacters(in: .whitespaces).isEmpty)
//        {
//            self.classListView?.showAlert(alert: Alerts.kEmptyDescription)
//        }
//        else{
            var othrs : String?
            guard let departmentID = selectedDepartmentId else{
                return
            }
            if others == ""{
                othrs = nil
            }else{
                othrs = others
            }
            
            let parameters = [KApiParameters.KAddClassApiPerameters.kClassId:classid,KApiParameters.KAddClassApiPerameters.kDepartmentId:selectedDepartmentId,KApiParameters.KAddClassApiPerameters.kName: className!,KApiParameters.KAddClassApiPerameters.kDescription : description!,KApiParameters.KAddClassApiPerameters.kOthers : othrs as Any,KApiParameters.KAddClassApiPerameters.kLogoUrl : imageUrl as Any] as [String : Any]
            self.classListView?.showLoader()
            ClassApi.sharedManager.addUpdateClass(url: ApiEndpoints.kAddClass, parameters: parameters, completionResponse: { (responseModel) in
                CommonFunctions.sharedmanagerCommon.println(object: "Response Model of addClass:- \(responseModel) ")
                self.classListView?.hideLoader()
                switch responseModel.statusCode{
                case KStatusCode.kStatusCode200:
                    self.classListView?.showAlert(alert: responseModel.message ?? "")
                    
                    self.classList(Search: "", Skip: KIntegerConstants.kInt0,PageSize: KIntegerConstants.kInt10,SortColumnDir: "",  SortColumn: "", ParticularId : selectedDepartmentId ?? 0)
                case KStatusCode.kStatusCode401:
                    self.classListView?.showAlert(alert: responseModel.message ?? "")
                    self.classListDelegate?.unauthorizedUser()
                default:
                    self.classListView?.showAlert(alert: responseModel.message ?? "")
                    self.classList(Search: "", Skip: KIntegerConstants.kInt0,PageSize: KIntegerConstants.kInt10,SortColumnDir: "",  SortColumn: "", ParticularId : selectedDepartmentId ?? 0)
                }
            }, completionnilResponse: { (nilresponse) in
                self.classListView?.hideLoader()
                self.classListView?.showAlert(alert: nilresponse ?? Alerts.kMapperModelError)
            }) { (error) in
                self.classListView?.hideLoader()
                self.classListView?.showAlert(alert: error?.localizedDescription ?? Alerts.kMapperModelError)
            }
//        }
    }
    
    //MARK:- Get Class Detail
    func getClassDetail(classId : Int){
        
        let getUrl = ApiEndpoints.kGetClassDetail + "?classId=\(classId)"
        self.classListView?.showLoader()
        ClassApi.sharedManager.getClassDetail(url: getUrl, completionResponse: { (classDetailresponse) in
            self.classListView?.hideLoader()
            switch classDetailresponse.statusCode{
            case KStatusCode.kStatusCode200:
                self.classListDelegate?.getClassDetailDidSucceed(data: classDetailresponse)
            case KStatusCode.kStatusCode401:
                self.classListView?.showAlert(alert: classDetailresponse.message ?? "")
                self.classListDelegate?.unauthorizedUser()
            default:
                self.classListView?.showAlert(alert: classDetailresponse.message ?? "Server Error")
            }
        }, completionnilResponse: { (error) in
            self.classListView?.hideLoader()
            if let nilResponse = error{
                self.classListView?.showAlert(alert: nilResponse)
            }
        }) { (error) in
            self.classListView?.hideLoader()
            if let err = error{
                self.classListView?.showAlert(alert: err.localizedDescription)
            }
        }
    }
    
    //MARK:- delete Class
    func deleteClass(classId: Int){
        
        self.classListView?.showLoader()
        ClassApi.sharedManager.deleteClassApi(url: ApiEndpoints.kDeleteClass+"?classId=\(classId)", completionResponse: {deleteModel in
            
            self.classListView?.hideLoader()
            
            switch deleteModel.statusCode{
            case KStatusCode.kStatusCode200:
                if let msg = deleteModel.message{
                    self.classListView?.showAlert(alert: msg)
                }
                self.classListDelegate?.classDeleteDidSuccess(data: deleteModel)
            case KStatusCode.kStatusCode401:
                    if let res = deleteModel.message{
                        self.classListView?.showAlert(alert: res)
                    }
                    self.classListDelegate?.unauthorizedUser()
            default:
                if let msg = deleteModel.message{
                    self.classListView?.showAlert(alert: msg)
                }
            }
        }, completionnilResponse: { (nilResponse) in
            
            self.classListView?.hideLoader()
            if let res = nilResponse{
                self.classListView?.showAlert(alert: res)
            }
            
        }) { (error) in
            self.classListView?.hideLoader()
            if let err = error{
                self.classListView?.showAlert(alert: err.localizedDescription)
            }
        }
    }
}
