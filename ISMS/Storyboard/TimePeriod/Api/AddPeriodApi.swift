//
//  AddPeriodApi.swift
//  ISMS
//
//  Created by Poonam Sharma on 7/10/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
import Alamofire

class AddPeriodApi{
     static let sharedInstance = AddPeriodApi()
    
    func getClassDropdownData(id : Int,enumType: Int,completionResponse:  @escaping (GetDropDownModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
        
        SignUpApi.sharedInstance.getCommonDropdownApiPeriod(url: ApiEndpoints.KClassdropDown+"?id=\(id)&enumType=\(enumType)", parameter: nil, completionResponse: { (responseModel) in
            completionResponse(responseModel)
        }, completionnilResponse: { (nilResponse) in
            completionnilResponse(nilResponse)
        }) { (error) in
            complitionError(error)
        }
        
    }
    
    func AddPeriodList(url : String,parameters: [String : Any]?,completionResponse:  @escaping (AddPeriodModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
        print("our parametersL: ",parameters)
        let urlCmplete = BaseUrl.kBaseURL+url
        var accessTokken = ""
        if let str = UserDefaults.standard.value(forKey: UserDefaultKeys.userAuthToken.rawValue)  as?  String
        {
            accessTokken = str
        }
        
        let headers = [KConstants.kHeaderAuthorization:KConstants.kHeaderBearer+" "+accessTokken,KConstants.kAccept: KConstants.kApplicationJson]
        
        
        Alamofire.request(urlCmplete, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            CommonFunctions.sharedmanagerCommon.println(object: "response list:- \(response) ")
            if response.result.isSuccess
            {
                guard let data = response.value else{return}
                
                if let responseData  = data as? [String : Any]
                {
                    
                    self.addPeriodListJSON(data: responseData, completionResponse: { (responseModel) in
                        CommonFunctions.sharedmanagerCommon.println(object: "response list2:- \(String(describing: responseModel.resultData)) ")
                        completionResponse(responseModel)
                    }, completionError: { (mapperError) in
                        completionnilResponse(mapperError)
                    })
                    
                }else{
                    CommonFunctions.sharedmanagerCommon.println(object: "Get StudentList Error:- \(data) ")
                }
                
            }
            else
            {
                complitionError(response.error)
                return
            }
        }
    }
    
    private func addPeriodListJSON(data: [String : Any],completionResponse:  @escaping (AddPeriodModel) -> Void,completionError: @escaping (String?) -> Void)  {
        
        let AddPeriodListData = AddPeriodModel(JSON: data)
        
        if AddPeriodListData != nil{
            completionResponse(AddPeriodListData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }
    
    func GetPeriodList(url : String,parameters: [String : Any]?,completionResponse:  @escaping (GetPeriodListModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
        print("our parametersL: ",parameters)
        let urlCmplete = BaseUrl.kBaseURL+url
        var accessTokken = ""
        if let str = UserDefaults.standard.value(forKey: UserDefaultKeys.userAuthToken.rawValue)  as?  String
        {
            accessTokken = str
        }
        
        let headers = [KConstants.kHeaderAuthorization:KConstants.kHeaderBearer+" "+accessTokken,KConstants.kAccept: KConstants.kApplicationJson]
        
        
        Alamofire.request(urlCmplete, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            CommonFunctions.sharedmanagerCommon.println(object: "response list:- \(response) ")
            if response.result.isSuccess
            {
                guard let data = response.value else{return}
                
                if let responseData  = data as? [String : Any]
                {
                    
                 self.getPeriodListJSON(data: responseData, completionResponse: { (responseModel) in
//                        CommonFunctions.sharedmanagerCommon.println(object: "response list2:- \(String(describing: responseModel.resultData)) ")
                        completionResponse(responseModel)
                    }, completionError: { (mapperError) in
                        completionnilResponse(mapperError)
                    })
                    
                }else{
                    CommonFunctions.sharedmanagerCommon.println(object: "Get StudentList Error:- \(data) ")
                }
                
            }
            else
            {
                complitionError(response.error)
                return
            }
        }
    }
    
    private func getPeriodListJSON(data: [String : Any],completionResponse:  @escaping (GetPeriodListModel) -> Void,completionError: @escaping (String?) -> Void)  {
       
        let getPeriodListData = GetPeriodListModel(JSON: data)
        
        if getPeriodListData != nil{
            completionResponse(getPeriodListData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }
    
    func deletePeriod(url : String,parameters: [String : Any]?,completionResponse:  @escaping (DeletePeriodModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
        print("our parametersL: ",parameters)
        let urlCmplete = BaseUrl.kBaseURL+url
        var accessTokken = ""
        if let str = UserDefaults.standard.value(forKey: UserDefaultKeys.userAuthToken.rawValue)  as?  String
        {
            accessTokken = str
        }
        
        let headers = [KConstants.kHeaderAuthorization:KConstants.kHeaderBearer+" "+accessTokken,KConstants.kAccept: KConstants.kApplicationJson]
        
        
        Alamofire.request(urlCmplete, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            CommonFunctions.sharedmanagerCommon.println(object: "response list:- \(response) ")
            if response.result.isSuccess
            {
                guard let data = response.value else{return}
                
                if let responseData  = data as? [String : Any]
                {
                    
                    self.DeletePeriosJSON(data: responseData, completionResponse: { (responseModel) in
                            CommonFunctions.sharedmanagerCommon.println(object: "response list2:- \(String(describing: responseModel.resultData)) ")
                        completionResponse(responseModel)
                    }, completionError: { (mapperError) in
                        completionnilResponse(mapperError)
                    })
                    
                }else{
                    CommonFunctions.sharedmanagerCommon.println(object: "Get StudentList Error:- \(data) ")
                }
                
            }
            else
            {
                complitionError(response.error)
                return
            }
        }
    }
    
    private func DeletePeriosJSON(data: [String : Any],completionResponse:  @escaping (DeletePeriodModel) -> Void,completionError: @escaping (String?) -> Void)  {
        
        let deletePeriodData = DeletePeriodModel(JSON: data)
        
        if deletePeriodData != nil{
            completionResponse(deletePeriodData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }
    
}
