//
//  ForgotApi.swift
//  ISMS
//
//  Created by Navaldeep Kaur on 23/04/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//


import Foundation
import Alamofire
import UIKit

class ForgotApi
{
    //MARK:- variables
    static let sharedmanagerAuth = ForgotApi()
    
    private init()
    {
    }

    
    func forgotPasswordApi(url : String,parameters: [String : Any]?,completionResponse:  @escaping (VerifyPhoneNumberModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
        
        let urlCmplete = BaseUrl.kBaseURL+url
        print(urlCmplete)
        
        var accessTokken = ""
        if let str = UserDefaults.standard.value(forKey: UserDefaultKeys.userAuthToken.rawValue)  as?  String
        {
            accessTokken = str
        }
        
        let headers = [KConstants.kHeaderAuthorization:KConstants.kHeaderBearer+" "+accessTokken,KConstants.kAccept: KConstants.kApplicationJson]
        
        
        Alamofire.request(urlCmplete, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            print(response)
            if response.result.isSuccess
            {
                guard let data = response.value else{return}
                
                if let responseData  = data as? [String : Any]
                {
                    print("responseData: ",responseData)
                    self.getUserRoleIdJSON(data: responseData, completionResponse: { (responseModel) in
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
//                return
            }
        }
        
    }
    
    private func getUserRoleIdJSON(data: [String : Any],completionResponse:  @escaping (VerifyPhoneNumberModel) -> Void,completionError: @escaping (String?) -> Void)  {
        
        let UserRoleIdData = VerifyPhoneNumberModel(JSON: data)
        
        if UserRoleIdData != nil{
            completionResponse(UserRoleIdData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }
  
    
}
