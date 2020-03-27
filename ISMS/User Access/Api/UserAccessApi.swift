//
//  UserAccessApi.swift
//  ISMS
//
//  Created by Taranjeet Singh on 6/25/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
import Alamofire


class UserAccessApi {
    
    static var sharedInstance = UserAccessApi()
    
    //MARK:- Get User List By Role Id
    func getUserListByRoleId(url : String,parameters: [String : Any]?,completionResponse:  @escaping (GetAllUserByRoleIdModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
    
        
            let urlCmplete = BaseUrl.kBaseURL+url
            var accessTokken = ""
            if let str = UserDefaults.standard.value(forKey: UserDefaultKeys.userAuthToken.rawValue)  as?  String
            {
                accessTokken = str
            }
        
            
            let headers = [KConstants.kHeaderAuthorization:KConstants.kHeaderBearer+" "+accessTokken,KConstants.kAccept: KConstants.kApplicationJson]
            
            
            Alamofire.request(urlCmplete, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                
                if response.result.isSuccess
                {
                    debugPrint("User list:- \(response)")
                    guard let data = response.value else{return}
                    
                    if let responseData  = data as? [String : Any]
                    {
                        self.getUserListJSON(data: responseData, completionResponse: { (responseModel) in
                            completionResponse(responseModel)
                        }, completionError: { (mapperError) in
                            completionnilResponse(mapperError)
                        })
                        
                    }else{
                        CommonFunctions.sharedmanagerCommon.println(object: "Get User List Error:- \(data)")
                    }
                    
                }
                else
                {
                    complitionError(response.error)
                    return
                }
            }
            
    }
    
    private func getUserListJSON(data: [String : Any],completionResponse:  @escaping (GetAllUserByRoleIdModel) -> Void,completionError: @escaping (String?) -> Void)  {
        
        let classListData = GetAllUserByRoleIdModel(JSON: data)
        
        if classListData != nil{
            completionResponse(classListData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }
    
    //Mark:- Get Hod/Teacher departments
    func getHodTeacherDropdownData(selectedHodTeacherId : Int,enumType: Int,completionResponse:  @escaping (GetCommonDropdownModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
        
        SignUpApi.sharedInstance.getCommonDropdownApi(url: ApiEndpoints.kGetCommonDropdownApi+"?id=\(selectedHodTeacherId)&enumType=\(enumType)", parameter: nil, completionResponse: { (responseModel) in
            completionResponse(responseModel)
        }, completionnilResponse: { (nilResponse) in
            completionnilResponse(nilResponse)
        }) { (error) in
            complitionError(error)
        }
        
    }
    
    //MARK:- Get User Access
    func getUserAccess(url : String,parameters: [String : Any]?,completionResponse:  @escaping (UserAccesstModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
        
        let urlCmplete = BaseUrl.kBaseURL+url
        print(urlCmplete)
        
        var accessTokken = ""
       if let str = UserDefaults.standard.value(forKey: UserDefaultKeys.userAuthToken.rawValue)  as?  String
        {
            accessTokken = str
        }

        let headers = [KConstants.kHeaderAuthorization:KConstants.kHeaderBearer+" "+accessTokken,KConstants.kAccept: KConstants.kApplicationJson]
        
        
        Alamofire.request(urlCmplete, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            print(response)
            if response.result.isSuccess
            {
                guard let data = response.value else{return}
                
                if let responseData  = data as? [String : Any]
                {
                    print("responseData: ",responseData)
                    self.getUserAccessJSON(data: responseData, completionResponse: { (responseModel) in
                        completionResponse(responseModel)
                    }, completionError: { (mapperError) in
                        completionnilResponse(mapperError)
                    })
                    
                }else{
                    CommonFunctions.sharedmanagerCommon.println(object: "Get User Access Error:- \(data) ")
                }
                
            }
            else
            {
                complitionError(response.error)
                return
            }
        }
        
    }
    
    //MARK:- Update User Access
    func updateUserAccess(url : String,parameters: [String : Any]?,completionResponse:  @escaping (CommonSuccessResponseModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
        
        let urlCmplete = BaseUrl.kBaseURL+url
        var accessTokken = ""
        if let str = UserDefaults.standard.value(forKey: UserDefaultKeys.userAuthToken.rawValue)  as?  String
        {
            accessTokken = str
        }

        
        let headers = [KConstants.kHeaderAuthorization:KConstants.kHeaderBearer+" "+accessTokken,KConstants.kAccept: KConstants.kApplicationJson]
    
        
        Alamofire.request(urlCmplete, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
            if response.result.isSuccess
            {
                guard let data = response.value else{return}
                
                if let responseData  = data as? [String : Any]{
                    self.getUpdateUserAccessJSON(data: responseData, completionResponse: { (successResponseModel) in
                        completionResponse(successResponseModel)
                    }, completionError: { (mapperError) in
                        completionnilResponse(mapperError)
                    })
                }else{
                    CommonFunctions.sharedmanagerCommon.println(object: "Update user access Error:- \(data) ")
                }
            }
            else
{
                complitionError(response.error)
                return
            }
        }
        
    }
    private func getUserAccessJSON(data: [String : Any],completionResponse:  @escaping (UserAccesstModel) -> Void,completionError: @escaping (String?) -> Void)  {
        
        let UserAccessData = UserAccesstModel(JSON: data)
        
        if UserAccessData != nil{
            completionResponse(UserAccessData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }
    
    private func getUpdateUserAccessJSON(data: [String : Any],completionResponse:  @escaping (CommonSuccessResponseModel) -> Void,completionError: @escaping (String?) -> Void)  {
        
        let updateUserAccessData = CommonSuccessResponseModel(JSON: data)
        
        if updateUserAccessData != nil{
            completionResponse(updateUserAccessData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }
    
}
