//
//  StudentListForAttendenceApi.swift
//  ISMS
//
//  Created by Poonam Sharma on 12/5/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
import Alamofire

class StudentListForAttendenceApi {
    
    static let sharedManager = StudentListForAttendenceApi()
    
    func getStudentList(url : String,parameters: [String : Any]?,completionResponse:  @escaping (StudentListForAttendenceModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
        
        let urlCmplete = BaseUrl.kBaseURL+url
        
        print("url: ",urlCmplete)
        var accessTokken = ""
        if let str = UserDefaults.standard.value(forKey: UserDefaultKeys.userAuthToken.rawValue)  as?  String
        {
            accessTokken = str
        }
        
//         accessTokken =  "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI5ODk2OTUwODkxIiwiZW1haWwiOiJmb2dneUBnbWFpbC5jbyIsImF6cCI6IjI5NSIsInNpZCI6Im1pbmRAMTIzIiwianRpIjoiMWU5NDUxODgtNWZkZi00NGJhLTk1YjItOTFiMDA0Mzc5MjQxIiwiZXhwIjoxNTc1NjIyODEyLCJpc3MiOiJUZXN0LmNvbSIsImF1ZCI6IlRlc3QuY29tIn0.QKJDHrDsB85F5KOliGnjIPsCzNuwRV9vPe45ZtIlRDI"
        
        let headers = [KConstants.kHeaderAuthorization:KConstants.kHeaderBearer+" "+accessTokken,KConstants.kAccept: KConstants.kApplicationJson]
        
        
        Alamofire.request(urlCmplete, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
            print("response: ",response)
            
            if response.result.isSuccess
            {
                guard let data = response.value else{return}
                
                if let responseData  = data as? [String : Any]
                {
                    self.getStudentListAttJSON(data: responseData, completionResponse: { (responseModel) in
                        completionResponse(responseModel)
                    }, completionError: { (mapperError) in
                        completionnilResponse(mapperError)
                    })
                    
                }else{
                    CommonFunctions.sharedmanagerCommon.println(object: "Get student list for attendence Error:- \(data) ")
                }
                
            }
            else
            {
                complitionError(response.error)
                return
            }
        }
        
    }
    
    private func getStudentListAttJSON(data: [String : Any],completionResponse:  @escaping (StudentListForAttendenceModel) -> Void,completionError: @escaping (String?) -> Void)  {
        
        let studentListData = StudentListForAttendenceModel(JSON: data)
        
        if studentListData != nil{
            completionResponse(studentListData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }
    
    func AddStudentAttendence(url : String,parameters: [String : Any]?,completionResponse:  @escaping (AddStudentModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
        
        let urlCmplete = BaseUrl.kBaseURL+url
         print("url: ",urlCmplete)
        var accessTokken = ""
        if let str = UserDefaults.standard.value(forKey: UserDefaultKeys.userAuthToken.rawValue)  as?  String
        {
            accessTokken = str
        }
        
//        accessTokken =  "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI5ODk2OTUwODkxIiwiZW1haWwiOiJmb2dneUBnbWFpbC5jbyIsImF6cCI6IjI5NSIsInNpZCI6Im1pbmRAMTIzIiwianRpIjoiMWU5NDUxODgtNWZkZi00NGJhLTk1YjItOTFiMDA0Mzc5MjQxIiwiZXhwIjoxNTc1NjIyODEyLCJpc3MiOiJUZXN0LmNvbSIsImF1ZCI6IlRlc3QuY29tIn0.QKJDHrDsB85F5KOliGnjIPsCzNuwRV9vPe45ZtIlRDI"
        
        let headers = [KConstants.kHeaderAuthorization:KConstants.kHeaderBearer+" "+accessTokken,KConstants.kAccept: KConstants.kApplicationJson]
        
        
        Alamofire.request(urlCmplete, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            print("data respomnse: ",response)
            if response.result.isSuccess
            {
                guard let data = response.value else{return}
                
                if let responseData  = data as? [String : Any]
                {
                    self.addStudentListAttJSON(data: responseData, completionResponse: { (responseModel) in
                        completionResponse(responseModel)
                    }, completionError: { (mapperError) in
                        completionnilResponse(mapperError)
                    })
                    
                }else{
                    CommonFunctions.sharedmanagerCommon.println(object: "Get student list for attendence Error:- \(data) ")
                }
                
            }
            else
            {
                complitionError(response.error)
                return
            }
        }
        
    }
    
    private func addStudentListAttJSON(data: [String : Any],completionResponse:  @escaping (AddStudentModel) -> Void,completionError: @escaping (String?) -> Void)  {
        
        let AddstudentAttData = AddStudentModel(JSON: data)
        
        if AddstudentAttData != nil{
            completionResponse(AddstudentAttData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }
    
    
    func StudentGetAttendence(url : String,parameters: [String : Any]?,completionResponse:  @escaping (GetStudentAttendanceModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
        
        let urlCmplete = BaseUrl.kBaseURL+url
        print("url: ",urlCmplete)
        var accessTokken = ""
        if let str = UserDefaults.standard.value(forKey: UserDefaultKeys.userAuthToken.rawValue)  as?  String
        {
            accessTokken = str
        }
        
        //        accessTokken =  "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI5ODk2OTUwODkxIiwiZW1haWwiOiJmb2dneUBnbWFpbC5jbyIsImF6cCI6IjI5NSIsInNpZCI6Im1pbmRAMTIzIiwianRpIjoiMWU5NDUxODgtNWZkZi00NGJhLTk1YjItOTFiMDA0Mzc5MjQxIiwiZXhwIjoxNTc1NjIyODEyLCJpc3MiOiJUZXN0LmNvbSIsImF1ZCI6IlRlc3QuY29tIn0.QKJDHrDsB85F5KOliGnjIPsCzNuwRV9vPe45ZtIlRDI"
        
        let headers = [KConstants.kHeaderAuthorization:KConstants.kHeaderBearer+" "+accessTokken,KConstants.kAccept: KConstants.kApplicationJson]
        
        
        Alamofire.request(urlCmplete, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            print("response: ",response)
            if response.result.isSuccess
            {
                guard let data = response.value else{return}
                
                if let responseData  = data as? [String : Any]
                {
                    self.GetStudentAttendanceJSON(data: responseData, completionResponse: { (responseModel) in
                        completionResponse(responseModel)
                    }, completionError: { (mapperError) in
                        completionnilResponse(mapperError)
                    })
                    
                }else{
                    CommonFunctions.sharedmanagerCommon.println(object: "Get student list for attendence Error:- \(data) ")
                }
                
            }
            else
            {
                complitionError(response.error)
                return
            }
        }
        
    }
    
    private func GetStudentAttendanceJSON(data: [String : Any],completionResponse:  @escaping (GetStudentAttendanceModel) -> Void,completionError: @escaping (String?) -> Void)  {
        
        let GetStudentAttendanceData = GetStudentAttendanceModel(JSON: data)
        
        if GetStudentAttendanceData != nil{
            completionResponse(GetStudentAttendanceData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }
    
//    func getSession(url : String,parameters: [String : Any]?,completionResponse:  @escaping (GetSessionModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
//
//        let urlCmplete = BaseUrl.kBaseURL+url
//        print("url: ",urlCmplete)
//        var accessTokken = ""
//        if let str = UserDefaults.standard.value(forKey: UserDefaultKeys.userAuthToken.rawValue)  as?  String
//        {
//            accessTokken = str
//        }
//
//        //        accessTokken =  "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI5ODk2OTUwODkxIiwiZW1haWwiOiJmb2dneUBnbWFpbC5jbyIsImF6cCI6IjI5NSIsInNpZCI6Im1pbmRAMTIzIiwianRpIjoiMWU5NDUxODgtNWZkZi00NGJhLTk1YjItOTFiMDA0Mzc5MjQxIiwiZXhwIjoxNTc1NjIyODEyLCJpc3MiOiJUZXN0LmNvbSIsImF1ZCI6IlRlc3QuY29tIn0.QKJDHrDsB85F5KOliGnjIPsCzNuwRV9vPe45ZtIlRDI"
//
//        let headers = [KConstants.kHeaderAuthorization:KConstants.kHeaderBearer+" "+accessTokken,KConstants.kAccept: KConstants.kApplicationJson]
//
//
//        Alamofire.request(urlCmplete, method: .get, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
//              print("response: ",response)
//            if response.result.isSuccess
//            {
//                guard let data = response.value else{return}
//
//                if let responseData  = data as? [String : Any]
//                {
//                    self.GetSessionJSON(data: responseData, completionResponse: { (responseModel) in
//                        completionResponse(responseModel)
//                    }, completionError: { (mapperError) in
//                        completionnilResponse(mapperError)
//                    })
//
//                }else{
//                    CommonFunctions.sharedmanagerCommon.println(object: "Get student list for attendence Error:- \(data) ")
//                }
//
//            }
//            else
//            {
//                complitionError(response.error)
//                return
//            }
//        }
//
//    }
    func getSession(url : String,parameters: [String : Any]?,completionResponse:  @escaping (GetSessionModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
           
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
                       
                       self.GetSessionJSON(data: responseData, completionResponse: { (responseModel) in
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
       
    
    private func GetSessionJSON(data: [String : Any],completionResponse:  @escaping (GetSessionModel) -> Void,completionError: @escaping (String?) -> Void)  {
        
        let GetStudentAttendanceData = GetSessionModel(JSON: data)
        
        if GetStudentAttendanceData != nil{
            completionResponse(GetStudentAttendanceData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }
}
