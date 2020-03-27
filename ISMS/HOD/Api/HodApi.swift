//
//  HodApi.swift
//  ISMS
//
//  Created by Taranjeet Singh on 6/19/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
import Alamofire

class HODApi{
    
    static let sharedManager = HODApi()
    
    //MARK:- Add/Update HOD Api
    func addUpdateHod(url : String,parameters: [String : Any],completionResponse:  @escaping (CommonSuccessResponseModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
        
        SignUpApi.sharedInstance.multipartApi(postDict: parameters, url: url, completionResponse: { (response) in
            self.addHODJSON(data: response, completionResponse: { (responseModel) in
                completionResponse(responseModel)
            }, completionError: { (error) in
                completionnilResponse(error)
            })
            
        }) { (error) in
            complitionError(error)
        }
        
        
    }
    
    //Convert Json data into mapper
    private func addHODJSON(data: [String : Any],completionResponse:  @escaping (CommonSuccessResponseModel) -> Void,completionError: @escaping (String?) -> Void){
        
        let addHodResponseData = CommonSuccessResponseModel(JSON: data)
        
        if addHodResponseData != nil{
            completionResponse(addHodResponseData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }
    
    //MARK:- HOD List Api
    func getHODList(url : String,parameters: [String : Any]?,completionResponse:  @escaping (HODListModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
        
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
                
                if let responseData  = data as? [String : Any]
                {
                    CommonFunctions.sharedmanagerCommon.println(object: responseData)
                    self.getHODListJSON(data: responseData, completionResponse: { (responseModel) in
                        completionResponse(responseModel)
                    }, completionError: { (mapperError) in
                        completionnilResponse(mapperError)
                    })
                    
                }else{
                    CommonFunctions.sharedmanagerCommon.println(object: "Get HOD Error:- \(data) ")
                }
                
            }
            else
            {
                complitionError(response.error)
                return
            }
        }
        
    }
    
    private func getHODListJSON(data: [String : Any],completionResponse:  @escaping (HODListModel) -> Void,completionError: @escaping (String?) -> Void)  {
        
        let hodListData = HODListModel(JSON: data)
        
        if hodListData != nil{
            completionResponse(hodListData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }
    
    //MARK:- Delete Hod
    func deleteHODApi(url: String,completionResponse:  @escaping (DeleteHODModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
        
        let urlCmplete = BaseUrl.kBaseURL+url
        var accessTokken = ""
        if let str = UserDefaults.standard.value(forKey: UserDefaultKeys.userAuthToken.rawValue)  as?  String
        {
            accessTokken = str
        }
        
        let headers = [KConstants.kHeaderAuthorization:KConstants.kHeaderBearer + " " + accessTokken,KConstants.kContentType:KConstants.kApplicationJson]
        
        Alamofire.request(urlCmplete, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
            if response.result.isSuccess
            {
                guard let data = response.value else{return}
                
                if let responseData  = data as? [String : Any]
                {
                    //Convert Data In Mapper
                    self.getDeleteHODJSON(data: responseData, completionResponse: { (deleteResponseModel) in
                        completionResponse(deleteResponseModel)
                    }, completionError: { (error) in
                        completionnilResponse(error)
                    })
                    
                }else{
                    CommonFunctions.sharedmanagerCommon.println(object: "Delete HOD Error:- \(data) ")
                }
                
            }
            else
            {
                complitionError(response.error)
                return
            }
        }
    }
    
    //Delete Department
    private func getDeleteHODJSON(data: [String : Any],completionResponse:  @escaping (DeleteHODModel) -> Void,completionError: @escaping (String?) -> Void){
        
        let deleteHODData = DeleteHODModel(JSON: data)
        
        if deleteHODData != nil{
            completionResponse(deleteHODData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }
    
    
//    //MARK:- Update HOD
//    func updateHODApi(url : String,parameters: [String : Any],completionResponse:  @escaping (AddHODModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
//
//        SignUpApi.sharedInstance.multipartApi(postDict: parameters, url: url, completionResponse: { (response) in
//            self.addHODJSON(data: response, completionResponse: { (responseModel) in
//                completionResponse(responseModel)
//            }, completionError: { (error) in
//                completionnilResponse(error)
//            })
//
//        }) { (error) in
//            complitionError(error)
//        }
//
//
//
//    }
    
    //MARK:- Get HOD detail
    func getHODDetail(url: String,completionResponse:  @escaping (HODDetailModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
        
        
        let urlCmplete = BaseUrl.kBaseURL+url
        var accessTokken = ""
        if let str = UserDefaults.standard.value(forKey: UserDefaultKeys.userAuthToken.rawValue)  as?  String
        {
            accessTokken = str
        }
        
        let headers = [KConstants.kHeaderAuthorization:KConstants.kHeaderBearer + " " + accessTokken,KConstants.kContentType:KConstants.kApplicationJson]
        
        Alamofire.request(urlCmplete, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
            if response.result.isSuccess
            {
                guard let data = response.value else{return}
                
                if let responseData  = data as? [String : Any]
                {
                    CommonFunctions.sharedmanagerCommon.println(object: responseData)
                    self.getHODDetailJSON(data: responseData, completionResponse: { (detailModel) in
                        completionResponse(detailModel)
                    }, completionError: { (mapperError) in
                        completionnilResponse(mapperError)
                    })
                    
                    
                }else{
                    CommonFunctions.sharedmanagerCommon.println(object: "Detail HOD Error:- \(data) ")
                }
                
            }
            else
            {
                complitionError(response.error)
                return
            }
        }
        
        
        
    }
    //For Department Detail
    private func getHODDetailJSON(data: [String : Any],completionResponse:  @escaping (HODDetailModel) -> Void,completionError: @escaping (String?) -> Void)  {
        
        let hodDetailData = HODDetailModel(JSON: data)
        
        if hodDetailData != nil{
            completionResponse(hodDetailData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }
    
    //Mark:- Get departments
    func getDepartmentsDropdownData(selectedDepartmentId : Int,enumType: Int,completionResponse:  @escaping (GetCommonDropdownModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
        
        SignUpApi.sharedInstance.getCommonDropdownApi(url: ApiEndpoints.kGetCommonDropdownApi+"?id=\(selectedDepartmentId)&enumType=\(enumType)", parameter: nil, completionResponse: { (responseModel) in
            completionResponse(responseModel)
        }, completionnilResponse: { (nilResponse) in
            completionnilResponse(nilResponse)
        }) { (error) in
            complitionError(error)
        }
        
    }
    
    func PhoneEmailVerify(url : String,parameters: [String : Any]?,completionResponse:  @escaping (GetDetailByPhoneEmailModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
        
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
                    
                    self.getVerifyEmailPhoneJSON(data: responseData, completionResponse: { (responseModel) in
                        CommonFunctions.sharedmanagerCommon.println(object: "response list2:- \(String(describing: responseModel.resultData)) ")
                        completionResponse(responseModel)
                    }, completionError: { (mapperError) in
                        completionnilResponse(mapperError)
                    })
                    
                }else{
                    CommonFunctions.sharedmanagerCommon.println(object: "Get HOD Error:- \(data) ")
                }
                
            }
            else
            {
                complitionError(response.error)
                return
            }
        }
    }
    
    private func getVerifyEmailPhoneJSON(data: [String : Any],completionResponse:  @escaping (GetDetailByPhoneEmailModel) -> Void,completionError: @escaping (String?) -> Void)  {
        
        let VerifyUserListData = GetDetailByPhoneEmailModel(JSON: data)
        
        if VerifyUserListData != nil{
            completionResponse(VerifyUserListData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }
}
