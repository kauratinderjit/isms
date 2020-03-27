//
//  UserRoleIdApi.swift
//  ISMS
//
//  Created by Poonam Sharma on 7/5/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
import Alamofire

class UserRoleIdApi{
     static let sharedManager = UserRoleIdApi()
    
    func getUserMenuFromRoleId(url : String,parameters: [String : Any]?,completionResponse:  @escaping (GetMenuFromRoleIdModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
        
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
                    self.getMenuFromUserRoleIdJSON(data: responseData, completionResponse: { (responseModel) in
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
    
    private func getMenuFromUserRoleIdJSON(data: [String : Any],completionResponse:  @escaping (GetMenuFromRoleIdModel) -> Void,completionError: @escaping (String?) -> Void)  {
        
        let UserMenuRoleIdData = GetMenuFromRoleIdModel(JSON: data)
        
        if UserMenuRoleIdData != nil{
            completionResponse(UserMenuRoleIdData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }
}
