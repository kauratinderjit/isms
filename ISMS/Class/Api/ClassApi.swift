//
//  AddClassApi.swift
//  ISMS
//
//  Created by Taranjeet Singh on 6/18/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
import Alamofire

class ClassApi{
    
    static let sharedManager = ClassApi()
    
    //MARK:- Add/update Class Api
    func addUpdateClass(url : String,parameters: [String : Any],completionResponse:  @escaping (CommonSuccessResponseModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
        
        SignUpApi.sharedInstance.multipartApi(postDict: parameters, url: url, completionResponse: { (response) in
            self.addClassJSON(data: response, completionResponse: { (responseModel) in
                completionResponse(responseModel)
            }, completionError: { (error) in
                completionnilResponse(error)
            })
            
        }) { (error) in
            complitionError(error)
        }
        
        
    }
    
    //Convert Json data into mapper
    private func addClassJSON(data: [String : Any],completionResponse:  @escaping (CommonSuccessResponseModel) -> Void,completionError: @escaping (String?) -> Void){
        
        let addClassData = CommonSuccessResponseModel(JSON: data)
        
        if addClassData != nil{
            completionResponse(addClassData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }
    
    //MARK:- Class List Api
    func getClassList(url : String,parameters: [String : Any]?,completionResponse:  @escaping (ClassListModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
        
        let urlCmplete = BaseUrl.kBaseURL+url
//        var accessTokken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI5ODk2OTUwODkxIiwiZW1haWwiOiJmb2dneUBnbWFpbC5jbyIsImF6cCI6IjI5NSIsInNpZCI6Im1pbmRAMTIzIiwianRpIjoiNWEwNDBlMzgtZWNkZS00OGMzLWE2YzgtYzc4Njk5MWJkZmM0IiwiZXhwIjoxNTc1NzE0MjQ0LCJpc3MiOiJUZXN0LmNvbSIsImF1ZCI6IlRlc3QuY29tIn0.ewRiy_71XXevggx1qQFsEbE7EVzJm-uy5ru_Tr6kxeI"
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
                    print("your response data here : \(responseData)")
                    
                    self.getClassListJSON(data: responseData, completionResponse: { (responseModel) in
                        completionResponse(responseModel)
                    }, completionError: { (mapperError) in
                        completionnilResponse(mapperError)
                    })
                    
                }else{
                    CommonFunctions.sharedmanagerCommon.println(object: "Get Class Error:- \(data) ")
                }
                
            }
            else
            {
                complitionError(response.error)
                return
            }
        }
        
    }
    
    private func getClassListJSON(data: [String : Any],completionResponse:  @escaping (ClassListModel) -> Void,completionError: @escaping (String?) -> Void)  {
        
        let classListData = ClassListModel(JSON: data)
        
        if classListData != nil{
            completionResponse(classListData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }
    
    //MARK:- Delete Department
    func deleteClassApi(url: String,completionResponse:  @escaping (DeleteClassModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
        
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
                    self.getDeleteClassJSON(data: responseData, completionResponse: { (deleteResponseModel) in
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
    private func getDeleteClassJSON(data: [String : Any],completionResponse:  @escaping (DeleteClassModel) -> Void,completionError: @escaping (String?) -> Void){
        
        let deleteClassData = DeleteClassModel(JSON: data)
        
        if deleteClassData != nil{
            completionResponse(deleteClassData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }
    
    //MARK:- Get Class detail
    func getClassDetail(url: String,completionResponse:  @escaping (ClassDetailModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
        
        
        let urlCmplete = BaseUrl.kBaseURL+url
//        var accessTokken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI5ODk2OTUwODkxIiwiZW1haWwiOiJmb2dneUBnbWFpbC5jbyIsImF6cCI6IjI5NSIsInNpZCI6Im1pbmRAMTIzIiwianRpIjoiNzJjN2MyZDUtN2MxNC00NmE5LWFhMTItNDM3ZjM2NmI0OGNkIiwiZXhwIjoxNTc0ODMxNjU1LCJpc3MiOiJUZXN0LmNvbSIsImF1ZCI6IlRlc3QuY29tIn0.ip16bvo0uGKBPPCgmZ0sS7tTGO5VbnnZ1cf7HNPvdJQ"
        var accessTokken = ""

        if let str = UserDefaults.standard.value(forKey: UserDefaultKeys.userAuthToken.rawValue)  as?  String
        {
            accessTokken = str
        }
        
        let headers = [KConstants.kHeaderAuthorization:KConstants.kHeaderBearer + " " + accessTokken,KConstants.kContentType:KConstants.kApplicationJson]
        
        Alamofire.request(urlCmplete, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
            if response.result.isSuccess
            {
                CommonFunctions.sharedmanagerCommon.println(object: "Response:- \(response)")
                guard let data = response.value else{return}
                
                if let responseData  = data as? [String : Any]
                {
                    self.getClassDetailJSON(data: responseData, completionResponse: { (detailModel) in
                        completionResponse(detailModel)
                    }, completionError: { (mapperError) in
                        completionnilResponse(mapperError)
                    })
                    
                    
                }else{
                    CommonFunctions.sharedmanagerCommon.println(object: "Detail Class Error:- \(data) ")
                }
                
            }
            else
            {
                complitionError(response.error)
                return
            }
        }
        
        
        
    }
    //For Class Detail
    private func getClassDetailJSON(data: [String : Any],completionResponse:  @escaping (ClassDetailModel) -> Void,completionError: @escaping (String?) -> Void)  {
        
        let classDetailData = ClassDetailModel(JSON: data)
        
        if classDetailData != nil{
            completionResponse(classDetailData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }
    
    //Mark:- Get Classes departments
    func getDepartmentsDropdownData(selectedDepartmentId : Int,enumType: Int,completionResponse:  @escaping (GetCommonDropdownModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
        
        SignUpApi.sharedInstance.getCommonDropdownApi(url: ApiEndpoints.kGetCommonDropdownApi+"?id=\(selectedDepartmentId)&enumType=\(enumType)", parameter: nil, completionResponse: { (responseModel) in
            completionResponse(responseModel)
        }, completionnilResponse: { (nilResponse) in
            completionnilResponse(nilResponse)
        }) { (error) in
            complitionError(error)
        }
        
    }
    
    //MARK:- Class List Dropdown
    func getClassDropdownData(selectedId : Int,enumType: Int,completionResponse:  @escaping (GetCommonDropdownModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
        SignUpApi.sharedInstance.getCommonDropdownApi(url: ApiEndpoints.kGetCommonDropdownApi+"?id=\(selectedId)&enumType=\(enumType)", parameter: nil, completionResponse: { (responseModel) in
            completionResponse(responseModel)
        }, completionnilResponse: { (nilResponse) in
            completionnilResponse(nilResponse)
        }) { (error) in
            complitionError(error)
        }
    }
    
    
    //Get Class TimeTable
    func getClassTimeTable(url: String,params: [String:Any],completionResponse:  @escaping (GetTimeTableModel) -> Void,complitionError: @escaping (String?) -> Void){
        let urlCmplete = BaseUrl.kBaseURL+url
        var accessTokken = ""
        if let str = UserDefaults.standard.value(forKey: UserDefaultKeys.userAuthToken.rawValue)  as?  String{
            accessTokken = str
        }
        
        let headers = [KConstants.kHeaderAuthorization:KConstants.kHeaderBearer + " " + accessTokken,KConstants.kContentType:KConstants.kApplicationJson]
        
        Alamofire.request(urlCmplete, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            if response.result.isSuccess
            {
                CommonFunctions.sharedmanagerCommon.println(object: "Response:- \(response)")
                guard let data = response.value else{return}
                if let responseData  = data as? [String : Any]
                {
                    self.getClassTimeTableJSON(data: responseData, completionResponse: { (detailModel) in
                        completionResponse(detailModel)
                    }, completionError: { (mapperError) in
                        complitionError(mapperError)
                    })
                }else{
                    CommonFunctions.sharedmanagerCommon.println(object: "Detail Class Error:- \(data) ")
                }
            }
            else{
                complitionError(response.error?.localizedDescription)
            }
        }
    }
    
    //Get ClassTimeTable JSON
    private func getClassTimeTableJSON(data: [String : Any],completionResponse:  @escaping (GetTimeTableModel) -> Void,completionError: @escaping (String?) -> Void){
        let getTimeTableData = GetTimeTableModel(JSON: data)
        if getTimeTableData != nil{
            completionResponse(getTimeTableData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }
}
