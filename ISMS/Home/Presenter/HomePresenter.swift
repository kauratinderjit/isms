//
//  HomePresenter.swift
//  ISMS
//
//  Created by Taranjeet Singh on 6/19/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation

protocol HomeViewModelDelegate:class
{
    func didSuccessUserRole(data: UserRoleIdModel)
    func didSuccessMenuAccordingRole(data: GetMenuFromRoleIdModel)
    func userUnauthorize()
    func hodData(data: homeResultData)
    func AdminData(data: homeAdminResultData)
    func teacherData(data: teacherData)
    func studentData(data: StudentData)
}


class HomeViewModel{
 
    //HomeViewModel delegate
    weak var delegate : HomeViewModelDelegate?
    
    //Home View
    weak var homeView : ViewDelegate?

    
    //Initialize the Presenter class
    init(delegate:HomeViewModelDelegate) {
        self.delegate = delegate
    }
    
    //Attaching Home view
    func attachView(view: ViewDelegate) {
        homeView = view
    }
    
    
    //Detaching Home view
    func detachView() {
        homeView = nil
    }
    
    //MARK:- Get Role Id's using userId
    func getRoleId(userID: Int?){
        self.homeView?.showLoader()
        LoginApi.sharedmanagerAuth.getUserRoleId(url: ApiEndpoints.kUserRole + "\(userID ?? 0)", parameters: nil, completionResponse: { (userRoleIdModel) in
            self.homeView?.hideLoader()
            switch userRoleIdModel.statusCode{
            case KStatusCode.kStatusCode200:
                self.delegate?.didSuccessUserRole(data: userRoleIdModel)
            case KStatusCode.kStatusCode401:
                self.homeView?.showAlert(alert: userRoleIdModel.message ?? "Something went wrong")
                self.delegate?.userUnauthorize()
            default:
                self.homeView?.showAlert(alert: userRoleIdModel.message ?? "Something went wrong")
                CommonFunctions.sharedmanagerCommon.println(object: "Get Role Id APi status change")
            }
          
        }, completionnilResponse: { (nilResponseError) in
            self.homeView?.hideLoader()
                self.homeView?.showAlert(alert: nilResponseError ?? "Something went wrong")
                CommonFunctions.sharedmanagerCommon.println(object: "Get Role Id APi Nil response")
        }) { (error) in
            self.homeView?.hideLoader()
                self.homeView?.showAlert(alert: error?.localizedDescription ?? "Something went wrong")
                CommonFunctions.sharedmanagerCommon.println(object: "Get Role Id APi error response")
        }
    }
    
    //MARK:- Get Menu Using Role Id
    func getMenuFromUserRoleId(userId: Int?,roleId : Int?){
        self.homeView?.showLoader()
        var postDict = [String:Any]()
        postDict[KApiParameters.KGetPagesByUserIdIdintifier.kUserId] = userId
        postDict[KApiParameters.KGetPagesByUserIdIdintifier.kRoleId] = roleId
        LoginApi.sharedmanagerAuth.getUserMenuFromRoleId(url: ApiEndpoints.kUserRoleMenu , parameters: postDict, completionResponse: { (getMenuFromRoleIdModel) in
            
            switch getMenuFromRoleIdModel.statusCode{
            case KStatusCode.kStatusCode200:
                self.homeView?.hideLoader()
                self.delegate?.didSuccessMenuAccordingRole(data: getMenuFromRoleIdModel)
            case KStatusCode.kStatusCode401:
                self.homeView?.showAlert(alert: getMenuFromRoleIdModel.message ?? "Something went wrong")
                self.delegate?.userUnauthorize()
            default:
                self.homeView?.hideLoader()
                self.homeView?.showAlert(alert: getMenuFromRoleIdModel.message ?? "Something went wrong")
                CommonFunctions.sharedmanagerCommon.println(object: "Get Menu using Id APi status change")
            }
            
        }, completionnilResponse: { (nilResponseError) in
            self.homeView?.hideLoader()
            self.homeView?.showAlert(alert: nilResponseError ?? "Something went wrong")
        }) { (error) in
            self.homeView?.hideLoader()
                self.homeView?.showAlert(alert: error?.localizedDescription ?? "Something went wrong")
        }
    }
    
    //MARK:- Home  Service
    func getData(userId: Int?)
    {
        self.homeView?.showLoader()
        var postDict = [String:Any]()
        
        
        var strUrl = "api/User/DashboardHod?UserId=\(String(describing: userId!))"
        
        postDict[KApiParameters.KGetPagesByUserIdIdintifier.kUserId] = userId
        
        if UserDefaultExtensionModel.shared.currentHODRoleName.contains("Teacher")
        {
            strUrl = "api/User/DashboardTeacher?UserId=\(String(describing: userId!))"
        }
        
        if UserDefaultExtensionModel.shared.currentHODRoleName.contains("Student")
        {
            strUrl = "api/User/DashboardStudent?UserId=\(String(describing: userId!))"
        }
        
        LoginApi.sharedmanagerAuth.getdata(url: strUrl , parameters: postDict, completionResponse: { (getMenuFromRoleIdModel) in
            
            switch getMenuFromRoleIdModel.statusCode
            {
            case KStatusCode.kStatusCode200:
                self.homeView?.hideLoader()
                self.delegate?.hodData(data: getMenuFromRoleIdModel.resultData!)
            case KStatusCode.kStatusCode401:
                self.homeView?.showAlert(alert: getMenuFromRoleIdModel.message ?? "Something went wrong")
                self.delegate?.userUnauthorize()
            default:
                self.homeView?.hideLoader()
                self.homeView?.showAlert(alert: getMenuFromRoleIdModel.message ?? "Something went wrong")
                CommonFunctions.sharedmanagerCommon.println(object: "Get Menu using Id APi status change")
            }
            
        }, completionnilResponse: { (nilResponseError) in
            self.homeView?.hideLoader()
            self.homeView?.showAlert(alert: nilResponseError ?? "Something went wrong")
        }) { (error) in
            self.homeView?.hideLoader()
                self.homeView?.showAlert(alert: error?.localizedDescription ?? "Something went wrong")
        }
    }
    
    
    //MARK:- Home  Service
    func getDataTeacher(userId: Int?)
    {
        self.homeView?.showLoader()
        var postDict = [String:Any]()
        
        var strUrl = "api/User/DashboardTeacher?UserId=\(String(describing: userId!))"
        postDict[KApiParameters.KGetPagesByUserIdIdintifier.kUserId] = userId
        
        LoginApi.sharedmanagerAuth.getdataTeacherDashboard(url: strUrl , parameters: postDict, completionResponse: { (response) in
            
            switch response.statusCode
            {
            case KStatusCode.kStatusCode200:
                self.homeView?.hideLoader()
                
                if (response.resultData != nil)
                {
                   self.delegate?.teacherData(data: response.resultData!)
                }
                else
                {
                   self.homeView?.showAlert(alert: response.message ?? "Something went wrong")
                }
                
            case KStatusCode.kStatusCode401:
                self.homeView?.showAlert(alert: response.message ?? "Something went wrong")
                self.delegate?.userUnauthorize()
            default:
                self.homeView?.hideLoader()
                self.homeView?.showAlert(alert: response.message ?? "Something went wrong")
                CommonFunctions.sharedmanagerCommon.println(object: "Get Menu using Id APi status change")
            }
            
        }, completionnilResponse: { (nilResponseError) in
            self.homeView?.hideLoader()
            self.homeView?.showAlert(alert: nilResponseError ?? "Something went wrong")
        }) { (error) in
            self.homeView?.hideLoader()
                self.homeView?.showAlert(alert: error?.localizedDescription ?? "Something went wrong")
        }
    }
    
    
    
    //MARK:- Home  Service
    func getDataStudent(userId: Int?)
    {
        self.homeView?.showLoader()
        var postDict = [String:Any]()
        
        let strUrl = "api/User/DashboardStudent?UserId=\(String(describing: userId!))"
        postDict[KApiParameters.KGetPagesByUserIdIdintifier.kUserId] = userId
        
        LoginApi.sharedmanagerAuth.getdataStudentDashboard(url: strUrl , parameters: postDict, completionResponse: { (response) in
            
            switch response.statusCode
            {
            case KStatusCode.kStatusCode200:
                self.homeView?.hideLoader()
                
                if (response.resultData != nil)
                {
                   self.delegate?.studentData(data: response.resultData!)
                }
                else
                {
                   self.homeView?.showAlert(alert: response.message ?? "Something went wrong")
                }
                
            case KStatusCode.kStatusCode401:
                self.homeView?.showAlert(alert: response.message ?? "Something went wrong")
                self.delegate?.userUnauthorize()
            default:
                self.homeView?.hideLoader()
                self.homeView?.showAlert(alert: response.message ?? "Something went wrong")
                CommonFunctions.sharedmanagerCommon.println(object: "Get Menu using Id APi status change")
            }
            
        }, completionnilResponse: { (nilResponseError) in
            self.homeView?.hideLoader()
            self.homeView?.showAlert(alert: nilResponseError ?? "Something went wrong")
        }) { (error) in
            self.homeView?.hideLoader()
                self.homeView?.showAlert(alert: error?.localizedDescription ?? "Something went wrong")
        }
    }
    
    
    //MARK:- Home  Service
     func getDataForAdmin(userId: Int?)
     {
         self.homeView?.showLoader()
         var postDict = [String:Any]()
         postDict[KApiParameters.KGetPagesByUserIdIdintifier.kUserId] = userId
         LoginApi.sharedmanagerAuth.getdataAdmin(url: "api/User/DashboardAdmin?UserId=\(String(describing: userId!))" , parameters: postDict, completionResponse: { (getMenuFromRoleIdModel) in
             
             switch getMenuFromRoleIdModel.statusCode {
             case KStatusCode.kStatusCode200:
                 self.homeView?.hideLoader()
                 self.delegate?.AdminData(data: getMenuFromRoleIdModel.resultData!)
             case KStatusCode.kStatusCode401:
                 self.homeView?.showAlert(alert: getMenuFromRoleIdModel.message ?? "Something went wrong")
                 self.delegate?.userUnauthorize()
             default:
                 self.homeView?.hideLoader()
                 self.homeView?.showAlert(alert: getMenuFromRoleIdModel.message ?? "Something went wrong")
                 CommonFunctions.sharedmanagerCommon.println(object: "Get Menu using Id APi status change")
             }
             
         }, completionnilResponse: { (nilResponseError) in
             self.homeView?.hideLoader()
             self.homeView?.showAlert(alert: nilResponseError ?? "Something went wrong")
         }) { (error) in
             self.homeView?.hideLoader()
                 self.homeView?.showAlert(alert: error?.localizedDescription ?? "Something went wrong")
         }
     }
     
}
