//
//  UserRolePresenter.swift
//  ISMS
//
//  Created by Poonam Sharma on 7/5/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation

protocol UserRoleDelegate: class {
    func didSuccessUserRole(data: UserRoleIdModel)
    func didSuccedRoleMenu(data: GetMenuFromRoleIdModel)
    func unauthorizedUser()
}

class UserRoleViewModel{
    private weak var userRoleVC : ViewDelegate?
    
    //StudentListDelegate weak object
    private weak var userRoleDelegate : UserRoleDelegate?
    
    //Initiallize the presenter StudentList using delegates
    init(delegate:UserRoleDelegate) {
        userRoleDelegate = delegate
    }
    
    //Attach GlobalViewDelegate
    func attachView(viewDelegate : ViewDelegate){
        userRoleVC = viewDelegate
    }
    
    //Deattach View for free the memory from instances
    func deattachView(){
        userRoleVC = nil
        userRoleDelegate = nil
    }
    func getMenuFromUserRoleId(userId: Int?,roleId : Int?){
        self.userRoleVC?.showLoader()
        var postDict = [String:Any]()
        postDict[KApiParameters.KGetPagesByUserIdIdintifier.kUserId] = userId
        postDict[KApiParameters.KGetPagesByUserIdIdintifier.kRoleId] = roleId
        UserRoleIdApi.sharedManager.getUserMenuFromRoleId(url: ApiEndpoints.kUserRoleMenu, parameters: postDict, completionResponse: { (getMenuFromRoleIdModel) in
            self.userRoleVC?.hideLoader()

            
            switch getMenuFromRoleIdModel.statusCode{
            case KStatusCode.kStatusCode200:
                self.userRoleDelegate?.didSuccedRoleMenu(data: getMenuFromRoleIdModel)
            case KStatusCode.kStatusCode401:
                self.userRoleVC?.showAlert(alert: getMenuFromRoleIdModel.message ?? "Something went wrong")
                self.userRoleDelegate?.unauthorizedUser()
            default:
                self.userRoleVC?.showAlert(alert: getMenuFromRoleIdModel.message ?? "Something went wrong")
            }
            
        }, completionnilResponse: { (nilResponseError) in
            self.userRoleVC?.hideLoader()
            if let error = nilResponseError{
                self.userRoleVC?.showAlert(alert: error)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Class APi Nil response")
            }
            
        }) { (error) in
            self.userRoleVC?.hideLoader()
            if let err = error?.localizedDescription{
                self.userRoleVC?.showAlert(alert: err)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Class APi error response")
            }
        }
        
    }
    
    func deviceTokenApi(DeviceType: String,DeviceToken: String,UserId:Int) {
                              userRoleVC?.showLoader()
                   let param = [       "DeviceType" : DeviceType,
                                        "DeviceToken" : DeviceToken,
                                        "UserId": UserId
                                       
                                        ] as [String : Any]
                                       
                                    let url = "api/User/AddUpdateDeviceDetail"
                              HomeworkApi.sharedManager.likePost(url:url , parameters: param, completionResponse: { (response) in
                                           
                                           self.userRoleVC?.hideLoader()
                                           switch response["StatusCode"] as? Int{
                                           case 200: break
                                                         // self.uploadPostViewDelegate?.showAlert(alert: response["Message"]  as? String ?? "")
                                                        //  self.UploadPostDelegate?.addedSuccessfully()
                                                      case 401: break
                                                         // self.uploadPostViewDelegate?.showAlert(alert: response["Message"] as? String ?? "")
                                                          //self.AddHomeWorkDelegate?.unauthorizedUser()
                                                      default: break
                                                         // self.uploadPostViewDelegate?.showAlert(alert: response["Message"] as? String ?? "")
                                                      }

                                           
                                       }, completionnilResponse: { (nilResponseError) in
                                           self.userRoleVC?.hideLoader()
                                           if let error = nilResponseError{
                                              // self.uploadPostViewDelegate?.showAlert(alert: error.description)
                                               
                                           }else{
                                               CommonFunctions.sharedmanagerCommon.println(object: SyllabusCoverage.kSyllabusResponseNotGet)
                                           }
                                       }) { (error) in
                                           self.userRoleVC?.hideLoader()
                                           if let err = error?.localizedDescription{
                                             //  self.uploadPostViewDelegate?.showAlert(alert: err)
                                           }else{
                                               CommonFunctions.sharedmanagerCommon.println(object: SyllabusCoverage.kSyllabusResponseError)
                                           }
                                       }
                        
                         }
    
    //MARK:- Get Role Id's using userId
    func getRoleId(userID: Int?){
        self.userRoleVC?.showLoader()
        LoginApi.sharedmanagerAuth.getUserRoleId(url: ApiEndpoints.kUserRole + "\(userID ?? 0)", parameters: nil, completionResponse: { (userRoleIdModel) in
            self.userRoleVC?.hideLoader()
            switch userRoleIdModel.statusCode{
            case KStatusCode.kStatusCode200:
                self.userRoleDelegate?.didSuccessUserRole(data: userRoleIdModel)
            case KStatusCode.kStatusCode401:
                self.userRoleVC?.showAlert(alert: userRoleIdModel.message ?? "Something went wrong")
                self.userRoleDelegate?.unauthorizedUser()
            default:
                self.userRoleVC?.showAlert(alert: userRoleIdModel.message ?? "Something went wrong")
                CommonFunctions.sharedmanagerCommon.println(object: "Get Role Id APi status change")
            }
            
        }, completionnilResponse: { (nilResponseError) in
            self.userRoleVC?.hideLoader()
            self.userRoleVC?.showAlert(alert: nilResponseError ?? "Something went wrong")
            CommonFunctions.sharedmanagerCommon.println(object: "Get Role Id APi Nil response")
        }) { (error) in
            self.userRoleVC?.hideLoader()
            self.userRoleVC?.showAlert(alert: error?.localizedDescription ?? "Something went wrong")
            CommonFunctions.sharedmanagerCommon.println(object: "Get Role Id APi error response")
        }
    }
    
}
