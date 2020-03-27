//
//  SubjectTopicApi.swift
//  ISMS
//
//  Created by Kuldeep Singh on 11/25/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
import Alamofire

class SubjectTopicApi{
    
    static let sharedInstance = SubjectTopicApi()
    
    func getTopicList(url : String,parameters: [String : Any]?,completionResponse:  @escaping (TopicListModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
        //eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI5ODk2OTUwODkxIiwiZW1haWwiOiJmb2dneUBnbWFpbC5jbyIsImF6cCI6IjI5NSIsInNpZCI6Im1pbmRAMTIzIiwianRpIjoiZWYwZDVjZjUtNWMxNC00ZmM3LWEyZTktZjk5M2EzNTg4ZmMzIiwiZXhwIjoxNTc0NzQ0MjE2LCJpc3MiOiJUZXN0LmNvbSIsImF1ZCI6IlRlc3QuY29tIn0.g-ZemVayVOl1lqQG6LaIWlLcX00Cfsec9WM82v1IWIA
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
                    
                    self.getChapterListJSON(data: responseData, completionResponse: { (responseModel) in
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
    
    private func getChapterListJSON(data: [String : Any],completionResponse:  @escaping (TopicListModel) -> Void,completionError: @escaping (String?) -> Void)  {
        
        let SubjectListData = TopicListModel(JSON: data)
        
        if SubjectListData != nil{
            completionResponse(SubjectListData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
}

    func deleteTopicApi(url: String,completionResponse:  @escaping (DeleteTopicModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
        
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
                    self.getDeleteTopicJSON(data: responseData, completionResponse: { (deleteResponseModel) in
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
    private func getDeleteTopicJSON(data: [String : Any],completionResponse:  @escaping (DeleteTopicModel) -> Void,completionError: @escaping (String?) -> Void){
        
        let deleteSubjectData = DeleteTopicModel(JSON: data)
        
        if deleteSubjectData != nil{
            completionResponse(deleteSubjectData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }
    
    
    
}
