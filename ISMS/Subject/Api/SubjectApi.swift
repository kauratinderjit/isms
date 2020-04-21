//
//  SubjectApi.swift
//  ISMS
//
//  Created by Poonam Sharma on 7/1/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
import Alamofire

class SubjectApi{
    
    static let sharedInstance = SubjectApi()
    
    func getSubjectList(url : String,parameters: [String : Any]?,completionResponse:  @escaping (SubjectListModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
        
        let urlCmplete = BaseUrl.kBaseURL+url
        var accessTokken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI5ODk2OTUwODkxIiwiZW1haWwiOiJmb2dneUBnbWFpbC5jbyIsImF6cCI6IjI5NSIsInNpZCI6Im1pbmRAMTIzIiwianRpIjoiNWEwNDBlMzgtZWNkZS00OGMzLWE2YzgtYzc4Njk5MWJkZmM0IiwiZXhwIjoxNTc1NzE0MjQ0LCJpc3MiOiJUZXN0LmNvbSIsImF1ZCI6IlRlc3QuY29tIn0.ewRiy_71XXevggx1qQFsEbE7EVzJm-uy5ru_Tr6kxeI"
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
                    print("your response data subjec kk1: \(responseData)")
                    self.getSubjectListJSON(data: responseData, completionResponse: { (responseModel) in
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
    
    private func getSubjectListJSON(data: [String : Any],completionResponse:  @escaping (SubjectListModel) -> Void,completionError: @escaping (String?) -> Void)  {
        
        let SubjectListData = SubjectListModel(JSON: data)
        
        if SubjectListData != nil{
            completionResponse(SubjectListData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }
    private func getChapterDeleteListJSON(data: [String : Any],completionResponse:  @escaping (DeleteSubjectModel) -> Void,completionError: @escaping (String?) -> Void)  {
        
        let SubjectListData = DeleteSubjectModel(JSON: data)
        if SubjectListData != nil{
            completionResponse(SubjectListData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }
    
    func deleteChapter(url : String,parameters: [String : Any]?,completionResponse:  @escaping (DeleteSubjectModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
        
        let urlCmplete = BaseUrl.kBaseURL+url
        var accessTokken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI5ODk2OTUwODkxIiwiZW1haWwiOiJmb2dneUBnbWFpbC5jbyIsImF6cCI6IjI5NSIsInNpZCI6Im1pbmRAMTIzIiwianRpIjoiNzJjN2MyZDUtN2MxNC00NmE5LWFhMTItNDM3ZjM2NmI0OGNkIiwiZXhwIjoxNTc0ODMxNjU1LCJpc3MiOiJUZXN0LmNvbSIsImF1ZCI6IlRlc3QuY29tIn0.ip16bvo0uGKBPPCgmZ0sS7tTGO5VbnnZ1cf7HNPvdJQ"
        if let str = UserDefaults.standard.value(forKey: UserDefaultKeys.userAuthToken.rawValue)  as?  String
        {
            accessTokken = str
        }
        
        let headers = [KConstants.kHeaderAuthorization:KConstants.kHeaderBearer + " " + accessTokken,KConstants.kAccept: KConstants.kApplicationJson]
        
        
        Alamofire.request(urlCmplete, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            CommonFunctions.sharedmanagerCommon.println(object: "response list:- \(response) ")
            if response.result.isSuccess
            {
                guard let data = response.value else{return}
                
                if let responseData  = data as? [String : Any]
                {
                    
                    self.getChapterDeleteListJSON(data: responseData, completionResponse: { (responseModel) in
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
    
    
    
    func deleteSubjectApi(url: String,completionResponse:  @escaping (DeleteSubjectModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
        
        let urlCmplete = BaseUrl.kBaseURL+url
        print("your url : \(urlCmplete)")
        var accessTokken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI5ODk2OTUwODkxIiwiZW1haWwiOiJmb2dneUBnbWFpbC5jbyIsImF6cCI6IjI5NSIsInNpZCI6Im1pbmRAMTIzIiwianRpIjoiNzJjN2MyZDUtN2MxNC00NmE5LWFhMTItNDM3ZjM2NmI0OGNkIiwiZXhwIjoxNTc0ODMxNjU1LCJpc3MiOiJUZXN0LmNvbSIsImF1ZCI6IlRlc3QuY29tIn0.ip16bvo0uGKBPPCgmZ0sS7tTGO5VbnnZ1cf7HNPvdJQ"
        if let str = UserDefaults.standard.value(forKey: UserDefaultKeys.userAuthToken.rawValue)  as?  String
        {
            accessTokken = str
        }
        
        let headers = [KConstants.kHeaderAuthorization:KConstants.kHeaderBearer + " " + accessTokken,KConstants.kContentType:KConstants.kApplicationJson]
        
        Alamofire.request(urlCmplete, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            print("deleteResponse: ",response)
            if response.result.isSuccess
            {
                guard let data = response.value else{return}
                
                if let responseData  = data as? [String : Any]
                {
                    //Convert Data In Mapper
                    self.getDeleteSubjectJSON(data: responseData, completionResponse: { (deleteResponseModel) in
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
    private func getDeleteSubjectJSON(data: [String : Any],completionResponse:  @escaping (DeleteSubjectModel) -> Void,completionError: @escaping (String?) -> Void){
        
        let deleteSubjectData = DeleteSubjectModel(JSON: data)
        
        if deleteSubjectData != nil{
            completionResponse(deleteSubjectData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }
    
    func getClassDropdownData(id : Int,enumType: Int,completionResponse:  @escaping (GetCommonDropdownModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
        
        SignUpApi.sharedInstance.getCommonDropdownApi(url: ApiEndpoints.KClassdropDown+"?id=\(id)&enumType=\(enumType)", parameter: nil, completionResponse: { (responseModel) in
            print(responseModel.resultData ?? "")
            completionResponse(responseModel)
        }, completionnilResponse: { (nilResponse) in
            completionnilResponse(nilResponse)
        }) { (error) in
            complitionError(error)
        }
        
    }
    
    func AddSubject(url : String,parameters: [String : Any]?,completionResponse:  @escaping (AddSubjectModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
        
        let urlCmplete = BaseUrl.kBaseURL+url
        print("your url complete: \(urlCmplete)")
        var accessTokken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI5ODk2OTUwODkxIiwiZW1haWwiOiJmb2dneUBnbWFpbC5jbyIsImF6cCI6IjI5NSIsInNpZCI6Im1pbmRAMTIzIiwianRpIjoiNzJjN2MyZDUtN2MxNC00NmE5LWFhMTItNDM3ZjM2NmI0OGNkIiwiZXhwIjoxNTc0ODMxNjU1LCJpc3MiOiJUZXN0LmNvbSIsImF1ZCI6IlRlc3QuY29tIn0.ip16bvo0uGKBPPCgmZ0sS7tTGO5VbnnZ1cf7HNPvdJQ"
        
        print("parameter is : \(parameters)")
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
                    
                    print("your response data check : \(responseData)")
                    
                    self.AddSubjectModelJSON(data: responseData, completionResponse: { (responseModel) in
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
    
    
    
    func AddChapter(url : String,parameters: [String : Any]?,completionResponse:  @escaping (AddSubjectModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
        
        let urlCmplete = BaseUrl.kBaseURL+url
        var accessTokken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI5ODk2OTUwODkxIiwiZW1haWwiOiJmb2dneUBnbWFpbC5jbyIsImF6cCI6IjI5NSIsInNpZCI6Im1pbmRAMTIzIiwianRpIjoiNzJjN2MyZDUtN2MxNC00NmE5LWFhMTItNDM3ZjM2NmI0OGNkIiwiZXhwIjoxNTc0ODMxNjU1LCJpc3MiOiJUZXN0LmNvbSIsImF1ZCI6IlRlc3QuY29tIn0.ip16bvo0uGKBPPCgmZ0sS7tTGO5VbnnZ1cf7HNPvdJQ"
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
                    
                    self.AddSubjectModelJSON(data: responseData, completionResponse: { (responseModel) in
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
    private func AddSubjectModelJSON(data: [String : Any],completionResponse:  @escaping (AddSubjectModel) -> Void,completionError: @escaping (String?) -> Void)  {
        
        let AddSubjectData = AddSubjectModel(JSON: data)
        
        if AddSubjectData != nil{
            completionResponse(AddSubjectData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }
    
    func getSubjectDetail(url : String,parameters: [String : Any]?,completionResponse:  @escaping (GetSubjectDetail) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
        
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
                    
                    self.getSubjectDetailJSON(data: responseData, completionResponse: { (responseModel) in
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
    private func getSubjectDetailJSON(data: [String : Any],completionResponse:  @escaping (GetSubjectDetail) -> Void,completionError: @escaping (String?) -> Void)  {
        
        let SubjectDetailData = GetSubjectDetail(JSON: data)
        
        if SubjectDetailData != nil{
            completionResponse(SubjectDetailData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }
    
    //MARK:- Assign Subjects,Teacher to periods of Class
    func addUpdateTimeTableApi(url : String,parameters: [String : Any]?,completionResponse:  @escaping () -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (String?) -> Void){
        
        let completeUrl = BaseUrl.kBaseURL+url
        var accessTokken = ""
        if let str = UserDefaults.standard.value(forKey: UserDefaultKeys.userAuthToken.rawValue)  as?  String{
            accessTokken = str
        }
        
        let headers = [KConstants.kHeaderAuthorization:KConstants.kHeaderBearer+" "+accessTokken,KConstants.kAccept: KConstants.kApplicationJson]
        
        Alamofire.request(completeUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            CommonFunctions.sharedmanagerCommon.println(object: "response list:- \(response) ")
            if response.result.isSuccess
            {
                guard let data = response.value else{return}
                
                if data is [String : Any]
                {
                    
                    
                }else{
                    CommonFunctions.sharedmanagerCommon.println(object: "Get StudentList Error:- \(data) ")
                }
            }
            else
            {
                complitionError(response.error?.localizedDescription)
                return
            }
        }
    }
    
    //MARK:- Get Teacher/Subject List DropDown
    func getSubjectTeacherDropdownData(selectedSubjectTeacherId : Int,enumType: Int,completionResponse:  @escaping (GetCommonDropdownModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
        let url = ApiEndpoints.kGetCommonDropdownApi+"?id=\(selectedSubjectTeacherId)&enumType=\(enumType)"
        
        print("url : ",url)
        SignUpApi.sharedInstance.getCommonDropdownApi(url: ApiEndpoints.kGetCommonDropdownApi+"?id=\(selectedSubjectTeacherId)&enumType=\(enumType)", parameter: nil, completionResponse: { (responseModel) in
            completionResponse(responseModel)
        }, completionnilResponse: { (nilResponse) in
            completionnilResponse(nilResponse)
        }) { (error) in
            complitionError(error)
        }
    }
    
    //MARK:- Assign Subjects,Teacher to periods of Class
       func addUpdateTimeTableApi(url : String,parameters: [String : Any]?,completionResponse:  @escaping (AddUpdateTimeTableResponseModel) -> Void,complitionError: @escaping (String?) -> Void){
           
           let completeUrl = BaseUrl.kBaseURL+url
        print("complturl : ",completeUrl)
           var accessTokken = ""
           if let str = UserDefaults.standard.value(forKey: UserDefaultKeys.userAuthToken.rawValue)  as?  String{
               accessTokken = str
           }
           
           let headers = [KConstants.kHeaderAuthorization:KConstants.kHeaderBearer+" "+accessTokken,KConstants.kAccept: KConstants.kApplicationJson]
           
           Alamofire.request(completeUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
               CommonFunctions.sharedmanagerCommon.println(object: "response list:- \(response) ")
               if response.result.isSuccess
               {
                   guard let data = response.value else{return}
                   if let responseData = data as? [String : Any]{
                       self.addUpdateTimeTableJson(data: responseData, completionResponse: { (responseModel) in
                           completionResponse(responseModel)
                       }, completionError: { (error) in
                           complitionError(error)
                       })
                   }else{
                       CommonFunctions.sharedmanagerCommon.println(object: "Get StudentList Error:- \(data) ")
                   }
               }
               else{
                   complitionError(response.error?.localizedDescription)
               }
           }
       }
       
       private func addUpdateTimeTableJson(data: [String : Any],completionResponse:  @escaping (AddUpdateTimeTableResponseModel) -> Void,completionError: @escaping (String?) -> Void)  {
           let addUpdateTimeTableResponse = AddUpdateTimeTableResponseModel(JSON: data)
           if addUpdateTimeTableResponse != nil{
               completionResponse(addUpdateTimeTableResponse!)
           }else{
               completionError(Alerts.kMapperModelError)
           }
       }
}

