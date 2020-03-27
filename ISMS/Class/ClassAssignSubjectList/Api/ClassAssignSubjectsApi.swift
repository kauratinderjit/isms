//
//  ClassAssignSubjectsApi.swift
//  ISMS
//
//  Created by Taranjeet Singh on 7/5/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
import Alamofire

class ClassAssignSubjectApi{
    
    static let sharedInstance = ClassAssignSubjectApi()

    //MARK:- Get All Assign Subject Api
    func getAllAssignSubjectList(url : String,parameters: [String : Any]?,completionResponse:  @escaping (GetAllAssignSubjectResponse) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (String?) -> Void){
        
        let urlCmplete = BaseUrl.kBaseURL+url
        var accessTokken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI5ODk2OTUwODkxIiwiZW1haWwiOiJmb2dneUBnbWFpbC5jbyIsImF6cCI6IjI5NSIsInNpZCI6Im1pbmRAMTIzIiwianRpIjoiNzJjN2MyZDUtN2MxNC00NmE5LWFhMTItNDM3ZjM2NmI0OGNkIiwiZXhwIjoxNTc0ODMxNjU1LCJpc3MiOiJUZXN0LmNvbSIsImF1ZCI6IlRlc3QuY29tIn0.ip16bvo0uGKBPPCgmZ0sS7tTGO5VbnnZ1cf7HNPvdJQ"
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
                    print("your data of all subjects : \(responseData)")
                    
                    self.getAllAssignSubjetcListJSON(data: responseData, completionResponse: { (response) in
                        completionResponse(response)
                    }, completionError: { (error) in
                        complitionError(error)
                    })
                    
                }else{
                    CommonFunctions.sharedmanagerCommon.println(object: "Get Class Error:- \(data) ")
                }
                
            }
            else
            {
                complitionError(response.error?.localizedDescription)
                return
            }
        }
        
    }
    
    private func getAllAssignSubjetcListJSON(data: [String : Any],completionResponse:  @escaping (GetAllAssignSubjectResponse) -> Void,completionError: @escaping (String?) -> Void)  {
        
        let classAssignSubjectListData = GetAllAssignSubjectResponse(JSON: data)
        
        if classAssignSubjectListData != nil{
            completionResponse(classAssignSubjectListData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }
    
    
    //MARK:- Assign Subject to class Api
    func assignSubjectToClass(url : String,parameters: [String : Any]?,completionResponse:  @escaping (AssignSubjectsToClassResponseModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (String?) -> Void){
        
        let urlCmplete = BaseUrl.kBaseURL+url
        var accessTokken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI5ODk2OTUwODkxIiwiZW1haWwiOiJmb2dneUBnbWFpbC5jbyIsImF6cCI6IjI5NSIsInNpZCI6Im1pbmRAMTIzIiwianRpIjoiNzJjN2MyZDUtN2MxNC00NmE5LWFhMTItNDM3ZjM2NmI0OGNkIiwiZXhwIjoxNTc0ODMxNjU1LCJpc3MiOiJUZXN0LmNvbSIsImF1ZCI6IlRlc3QuY29tIn0.ip16bvo0uGKBPPCgmZ0sS7tTGO5VbnnZ1cf7HNPvdJQ"
        if let str = UserDefaults.standard.value(forKey: UserDefaultKeys.userAuthToken.rawValue)  as?  String {
            accessTokken = str
        }
        
        let headers = [KConstants.kHeaderAuthorization:KConstants.kHeaderBearer+" "+accessTokken,KConstants.kAccept: KConstants.kApplicationJson]
        
        Alamofire.request(urlCmplete, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            if response.result.isSuccess{
                guard let data = response.value else{return}
                if let responseData  = data as? [String : Any]{
                    self.assignSubjetcToClassJSON(data: responseData, completionResponse: { (response) in
                        completionResponse(response)
                    }, completionError: { (error) in
                        complitionError(error)
                    })
                }else{
                    CommonFunctions.sharedmanagerCommon.println(object: "Assign Subjects to class Error:- \(data) ")
                }
            }else{
                complitionError(response.error?.localizedDescription)
                return
            }
        }
    }
    
    private func assignSubjetcToClassJSON(data: [String : Any],completionResponse:  @escaping (AssignSubjectsToClassResponseModel) -> Void,completionError: @escaping (String?) -> Void)  {
        
        let assignSubjetcToClassData = AssignSubjectsToClassResponseModel(JSON: data)
        
        if assignSubjetcToClassData != nil{
            completionResponse(assignSubjetcToClassData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }
    
    
}
