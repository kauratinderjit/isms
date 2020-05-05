//
//  AdStudentApi.swift
//  ISMS
//
//  Created by Poonam Sharma on 6/26/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
import Foundation
import Alamofire
import ObjectMapper


class AdStudentApi {
    
    //MARK:- variables
    static let sharedInstance = AdStudentApi()
    
    
    func addStudent(url : String,parameters: [String : Any],completionResponse:  @escaping (AddStudentModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
        
        SignUpApi.sharedInstance.multipartApi(postDict: parameters, url: url, completionResponse: { (response) in
            self.addStudentJSON(data: response, completionResponse: { (responseModel) in
                completionResponse(responseModel)
            }, completionError: { (error) in
                completionnilResponse(error)
            })
            
        }) { (error) in
            complitionError(error)
        }
        
        
    }
    private func addStudentJSON(data: [String : Any],completionResponse:  @escaping (AddStudentModel) -> Void,completionError: @escaping (String?) -> Void){
        
        let addStudentData = AddStudentModel(JSON: data)
        
        if addStudentData != nil{
            completionResponse(addStudentData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }
    
    
    
    
    func getStudentList(url : String,parameters: [String : Any]?,completionResponse:  @escaping (StudentListModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
        
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
                    
                    self.getStudentListJSON(data: responseData, completionResponse: { (responseModel) in
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
    
    private func getStudentListJSON(data: [String : Any],completionResponse:  @escaping (StudentListModel) -> Void,completionError: @escaping (String?) -> Void)  {
        
        let StudentListData = StudentListModel(JSON: data)
        
        if StudentListData != nil{
            completionResponse(StudentListData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }
    
    //MARK:- For Student
    func PhoneEmailVerify(url : String,parameters: [String : Any]?,completionResponse:  @escaping (VerifyEmailPhoneUserModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
        
        let urlCmplete = BaseUrl.kBaseURL+url
        var accessTokken = ""
        if let str = UserDefaults.standard.value(forKey: UserDefaultKeys.userAuthToken.rawValue)  as?  String
        {
            accessTokken = str
        }
        
        let headers = [KConstants.kHeaderAuthorization:KConstants.kHeaderBearer+" "+accessTokken,KConstants.kAccept: KConstants.kApplicationJson]
        
        
        Alamofire.request(urlCmplete, method: .post, parameters: parameters, encoding: JSONEncoding.prettyPrinted, headers: headers).responseJSON { (response) in
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
    
    private func getVerifyEmailPhoneJSON(data: [String : Any],completionResponse:  @escaping (VerifyEmailPhoneUserModel) -> Void,completionError: @escaping (String?) -> Void)  {
        
        let VerifyUserListData = VerifyEmailPhoneUserModel(JSON: data)
        
        if VerifyUserListData != nil{
            completionResponse(VerifyUserListData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }
    
    func PhoneEmailVerifyGardian(url : String,parameters: [String : Any]?,completionResponse:  @escaping (GetDetailByPhoneEmailGardianModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
        
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
                    
                    self.getVerifyEmailPhoneGarddianJSON(data: responseData, completionResponse: { (responseModel) in
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
    
    private func getVerifyEmailPhoneGarddianJSON(data: [String : Any],completionResponse:  @escaping (GetDetailByPhoneEmailGardianModel) -> Void,completionError: @escaping (String?) -> Void)  {
        
        let VerifyUserListData = GetDetailByPhoneEmailGardianModel(JSON: data)
        
        if VerifyUserListData != nil{
            completionResponse(VerifyUserListData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }
    
    
    func getStudentDetail(url : String,parameters: [String : Any]?,completionResponse:  @escaping (GetStudentDetail) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
        
        let urlCmplete = BaseUrl.kBaseURL+url
        var accessTokken = ""
        if let str = UserDefaults.standard.value(forKey: UserDefaultKeys.userAuthToken.rawValue)  as?  String
        {
            accessTokken = str
        }
        
        let headers = [KConstants.kHeaderAuthorization:KConstants.kHeaderBearer+" "+accessTokken,KConstants.kAccept: KConstants.kApplicationJson]
        
        
        Alamofire.request(urlCmplete, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            CommonFunctions.sharedmanagerCommon.println(object: "response list:- \(response) ")
            if response.result.isSuccess
            {
                guard let data = response.value else{return}
                
                if let responseData  = data as? [String : Any]
                {
                    
                    self.getStudentDetailJSON(data: responseData, completionResponse: { (responseModel) in
                        CommonFunctions.sharedmanagerCommon.println(object: "response list2:- \(String(describing: responseModel.resultData)) ")
                        completionResponse(responseModel)
                    }, completionError: { (mapperError) in
                        completionnilResponse(mapperError)
                    })
                    
                }else{
                    CommonFunctions.sharedmanagerCommon.println(object: "Get student Error:- \(data) ")
                }
                
            }
            else
            {
                complitionError(response.error)
                return
            }
        }
    }
    
    private func getStudentDetailJSON(data: [String : Any],completionResponse:  @escaping (GetStudentDetail) -> Void,completionError: @escaping (String?) -> Void)  {
        
        let StudentDetailData = GetStudentDetail(JSON: data)
        
        if StudentDetailData != nil{
            completionResponse(StudentDetailData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }
    
    func deleteStudentApi(url: String,completionResponse:  @escaping (DeleteStudentModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
        
        let urlCmplete = BaseUrl.kBaseURL+url
        var accessTokken = ""
        if let str = UserDefaults.standard.value(forKey: UserDefaultKeys.userAuthToken.rawValue)  as?  String
        {
            accessTokken = str
        }
        
        let headers = [KConstants.kHeaderAuthorization:KConstants.kHeaderBearer + " " + accessTokken,KConstants.kContentType:KConstants.kApplicationJson]
        
        Alamofire.request(urlCmplete, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            print("deleteResponse: ",response)
            if response.result.isSuccess
            {
                guard let data = response.value else{return}
                
                if let responseData  = data as? [String : Any]
                {
                    //Convert Data In Mapper
                    self.getDeleteStudentJSON(data: responseData, completionResponse: { (deleteResponseModel) in
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
    
    private func getDeleteStudentJSON(data: [String : Any],completionResponse:  @escaping (DeleteStudentModel) -> Void,completionError: @escaping (String?) -> Void){
        
        let deleteStudentData = DeleteStudentModel(JSON: data)
        
        if deleteStudentData != nil{
            completionResponse(deleteStudentData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }
    
    func getClassDropdownData(id : Int,enumType: Int,completionResponse:  @escaping (GetCommonDropdownModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
        
        SignUpApi.sharedInstance.getCommonDropdownApi(url: ApiEndpoints.KClassdropDown+"?id=\(id)&enumType=\(enumType)", parameter: nil, completionResponse: { (responseModel) in
            completionResponse(responseModel)
        }, completionnilResponse: { (nilResponse) in
            completionnilResponse(nilResponse)
        }) { (error) in
            complitionError(error)
        }
        
    }
    func getDepartmentDropdownData(id : Int,enumType: Int,completionResponse:  @escaping (GetDropDownModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
       
        
        SignUpApi.sharedInstance.getCommonDropdownApiPeriod(url: ApiEndpoints.KClassdropDown+"?id=\(id)&enumType=\(enumType)", parameter: nil, completionResponse: { (responseModel) in
            completionResponse(responseModel)
        }, completionnilResponse: { (nilResponse) in
            completionnilResponse(nilResponse)
        }) { (error) in
            complitionError(error)
        }
        
    }
    
}
