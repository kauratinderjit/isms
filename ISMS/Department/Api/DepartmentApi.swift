//
//  AddDepartmentApi.swift
//  ISMS
//
//  Created by Taranjeet Singh on 6/17/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
import Alamofire

class DepartmentApi{
    
    static let sharedInstance = DepartmentApi()
    
    //MARK:- Add/update Department Post Api
    func addDepartment(url : String,parameters: [String : Any],completionResponse:  @escaping (AddDepartmentModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
        
        SignUpApi.sharedInstance.multipartApi(postDict: parameters, url: url, completionResponse: { (response) in
            self.addDepartmentJSON(data: response, completionResponse: { (responseModel) in
                completionResponse(responseModel)
            }, completionError: { (error) in
                completionnilResponse(error)
            })
            
        }) { (error) in
            complitionError(error)
        }
 
    
    }

    //Convert Json data into mapper
    private func addDepartmentJSON(data: [String : Any],completionResponse:  @escaping (AddDepartmentModel) -> Void,completionError: @escaping (String?) -> Void){
       
        let adddepartmentData = AddDepartmentModel(JSON: data)
        
        if adddepartmentData != nil{
            completionResponse(adddepartmentData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }
    
    //MARK:- Department List Api
    func getDepartmentList(url : String,parameters: [String : Any]?,completionResponse:  @escaping (DepartmentListModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
        
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
                    self.getDepartmentListJSON(data: responseData, completionResponse: { (responseModel) in
                        completionResponse(responseModel)
                    }, completionError: { (mapperError) in
                        completionnilResponse(mapperError)
                    })
                    
                }else{
                    CommonFunctions.sharedmanagerCommon.println(object: "Get Department Error:- \(data) ")
                }
                
            }
            else
            {
                complitionError(response.error)
                return
            }
        }
        
    }
    
    private func getDepartmentListJSON(data: [String : Any],completionResponse:  @escaping (DepartmentListModel) -> Void,completionError: @escaping (String?) -> Void)  {
    
        let departmentListData = DepartmentListModel(JSON: data)
    
        if departmentListData != nil{
            completionResponse(departmentListData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }
    
    //MARK:- Delete Department
    func deleteDepartmentApi(url: String,completionResponse:  @escaping (AddDepartmentModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
     
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
                    self.detDeleteDepartmentJSON(data: responseData, completionResponse: { (deleteResponseModel) in
                        completionResponse(deleteResponseModel)
                    }, completionError: { (error) in
                        completionnilResponse(error)
                    })
                    
                }else{
                    CommonFunctions.sharedmanagerCommon.println(object: "Delete Department Error:- \(data) ")
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
    private func detDeleteDepartmentJSON(data: [String : Any],completionResponse:  @escaping (AddDepartmentModel) -> Void,completionError: @escaping (String?) -> Void){
            
        let deleteDepartmentData = AddDepartmentModel(JSON: data)
            
        if deleteDepartmentData != nil{
            completionResponse(deleteDepartmentData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }
    
    
    //MARK:- Update Department
    func updateDepartmentApi(url : String,parameters: [String : Any],completionResponse:  @escaping (AddDepartmentModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
        
        SignUpApi.sharedInstance.multipartApi(postDict: parameters, url: url, completionResponse: { (response) in
            self.addDepartmentJSON(data: response, completionResponse: { (responseModel) in
                completionResponse(responseModel)
            }, completionError: { (error) in
                completionnilResponse(error)
            })
            
        }) { (error) in
            complitionError(error)
        }
        
        
        
    }
    
    //MARK:- Get Department detail
    func getDepartmentDetail(url: String,completionResponse:  @escaping (DepartmentDetailModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
        
        
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
                    self.getDepartmentDetailJSON(data: responseData, completionResponse: { (detailModel) in
                        completionResponse(detailModel)
                    }, completionError: { (mapperError) in
                        completionnilResponse(mapperError)
                    })
                    
                    
                }else{
                    CommonFunctions.sharedmanagerCommon.println(object: "Detail Department Error:- \(data) ")
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
    private func getDepartmentDetailJSON(data: [String : Any],completionResponse:  @escaping (DepartmentDetailModel) -> Void,completionError: @escaping (String?) -> Void)  {
        
        let departmentDetailData = DepartmentDetailModel(JSON: data)
        
        if departmentDetailData != nil{
            completionResponse(departmentDetailData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }
    
    
}
