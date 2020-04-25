//
//  LoginApi.swift
//  LatestArchitechtureDemo
//
//  Created by Atinder Kaur on 5/23/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

//

import Foundation
import Alamofire
import UIKit

class LoginApi
{
    //MARK:- variables
    static let sharedmanagerAuth = LoginApi()
    
    private init()
    {
    }
    
    
    //MARK:- Login Api
    func LogInApi(url : String, parameter : [String:Any], completionResponse:  @escaping (LoginData) -> Void,completionnilResponse:  @escaping (String) -> Void,completionError: @escaping (Error?) -> Void)
    {
            let urlComplete = BaseUrl.kBaseURL+url
            let headers    = [KConstants.kContentType : KConstants.kApplicationJson]
            
            
            Alamofire.request(urlComplete, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers : headers)
                .responseJSON { response in
                  
                    print(response)
                    if response.result.isSuccess
                    {
                        guard let data = response.value else{return}
                        
                        if let responseData  = data as? [String : Any]
                        {
                            self.userDataJSON(data: responseData, completionResponse: { (UserData) in
                                completionResponse(UserData)
                            }, completionError: { (error) in
                                CommonFunctions.sharedmanagerCommon.println(object: error!)
                                
                            })
                        }else
                        {
                            completionnilResponse(k_ServerError)
                        }
                        
                       
                        
                        
                    }
                    else
                    {
                        completionError(response.error)
                        return
                    }
            }
            
        }
    
    
    /*func GetApi(url : String, completionResponse:  @escaping ([String : Any]) -> Void,completionnilResponse:  @escaping ([String : Any]) -> Void,completionError: @escaping (Error?) -> Void)
    {
        
        let urlComplete = BaseUrl.kBaseURL+url
            print(urlComplete)
            print(urlComplete)
            
            let headers    =  [KConstants.kContentType : KConstants.kApplicationJson]
            Alamofire.request(urlComplete, method: .get, parameters: nil, encoding: JSONEncoding.default, headers : headers)
                .responseJSON { response in
                    if response.result.isSuccess
                    {
                        guard let data = response.value else{return}

                        if statusCode == KStatusCode.kStatusCode200
                        {
                            completionResponse(responseData)
                        }
                        else
                        {
                            completionnilResponse(responseData)
                        }
                    }
                    else
                    {
                        completionError(response.error)
                        return
                    }
            }
       
        
    }*/
    
    //MARK:- Verify Phone Number
    func veriFyPhoneNumberApi(url: String,parameter: [String:Any],completionResponse:  @escaping (VerifyPhoneNumberModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,completionError: @escaping (Error?) -> Void){
        
        let urlComplete = BaseUrl.kBaseURL+url
        let headers    = [KConstants.kContentType : KConstants.kApplicationJson,KConstants.kAccept: KConstants.kApplicationJson]

        
        Alamofire.request(urlComplete, method: .post, parameters: nil, encoding: JSONEncoding.default, headers : headers)
            .responseJSON { response in
                
                if response.result.isSuccess
                {
                    guard let data = response.value else{return}
   
                    if let responseData  = data as? [String : Any]
                    {
                        self.verifyPhoneNoData(data: responseData, completionResponse: { (responseModel) in
                            completionResponse(responseModel)
                        }, completionError: { (error) in
                            CommonFunctions.sharedmanagerCommon.println(object: error!)
                        })
                    }else
                    {
                        completionnilResponse(k_ServerError)
                    }
                }
                else
                {
                    completionError(response.error)
                    return
                }
        }
        
    }
    
    
    //using For Login User Json Response convert into model
    private func userDataJSON(data: [String : Any],completionResponse:  @escaping (LoginData) -> Void,completionError: @escaping (Error?) -> Void)  {
        
        
        let user = LoginData(JSON: data)
        
        completionResponse(user!)
        
    }
    
    //Using for convert verifyPhone number json into model
    private func verifyPhoneNoData(data: [String : Any],completionResponse:  @escaping (VerifyPhoneNumberModel) -> Void,completionError: @escaping (String?) -> Void)  {
        
        let verifyPhoneNumberData = VerifyPhoneNumberModel(JSON: data)
        
        if verifyPhoneNumberData != nil{
            completionResponse(verifyPhoneNumberData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
        
    }
    
    func postAction(url: String?,param:[String:Any]) {
        let Url = String(format: url!)
        guard let serviceUrl = URL(string: Url) else { return }
        let parameterDictionary = param
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: .prettyPrinted)else {return}
        
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch {
                    print(error)
                }
            }
            }.resume()
    }
    
    func getUserRoleId(url : String,parameters: [String : Any]?,completionResponse:  @escaping (UserRoleIdModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
        
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
    
    private func getUserRoleIdJSON(data: [String : Any],completionResponse:  @escaping (UserRoleIdModel) -> Void,completionError: @escaping (String?) -> Void)  {
        
        let UserRoleIdData = UserRoleIdModel(JSON: data)
        
        if UserRoleIdData != nil{
            completionResponse(UserRoleIdData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }
    
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
    
//homeAdminModel
       func getdata(url : String,parameters: [String : Any]?,completionResponse:  @escaping (homeModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
            
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
                        
                        self.getHomeModel(data: responseData, completionResponse: { (responseModel) in
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
    
    
    
    
    func getdataTeacherDashboard(url : String,parameters: [String : Any]?,completionResponse:  @escaping (homeTeacherModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
            
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
                        
                        self.getTeacherHomeModel(data: responseData, completionResponse: { (responseModel) in
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
    
    
    
    func getdataStudentDashboard(url : String,parameters: [String : Any]?,completionResponse:  @escaping (homeStudentModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
            
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
                        
                        self.getStudentHomeModel(data: responseData, completionResponse: { (responseModel) in
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
    
    
    private func getHomeModel(data: [String : Any],completionResponse:  @escaping (homeModel) -> Void,completionError: @escaping (String?) -> Void)  {
        
        let UserMenuRoleIdData = homeModel(JSON: data)
        
        if UserMenuRoleIdData != nil
        {
            completionResponse(UserMenuRoleIdData!)
        }
        else
        {
            completionError(Alerts.kMapperModelError)
        }
    }
    
       func getdataAdmin(url : String,parameters: [String : Any]?,completionResponse:  @escaping (homeAdminModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
            
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
                        self.getAdminHomeModel(data: responseData, completionResponse: { (responseModel) in
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
    
    
    private func getAdminHomeModel(data: [String : Any],completionResponse:  @escaping (homeAdminModel) -> Void,completionError: @escaping (String?) -> Void)  {
        
        let UserMenuRoleIdData = homeAdminModel(JSON: data)
        
        if UserMenuRoleIdData != nil{
            completionResponse(UserMenuRoleIdData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }
    
    
    private func getTeacherHomeModel(data: [String : Any],completionResponse:  @escaping (homeTeacherModel) -> Void,completionError: @escaping (String?) -> Void)  {
        
        let UserMenuRoleIdData = homeTeacherModel(JSON: data)
        
        if UserMenuRoleIdData != nil{
            completionResponse(UserMenuRoleIdData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }
    
    private func getStudentHomeModel(data: [String : Any],completionResponse:  @escaping (homeStudentModel) -> Void,completionError: @escaping (String?) -> Void)  {
        
        let UserMenuRoleIdData = homeStudentModel(JSON: data)
        
        if UserMenuRoleIdData != nil{
            completionResponse(UserMenuRoleIdData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }
    
}
