//
//  TeacherRatingListAPI.swift
//  ISMS
//
//  Created by Poonam Sharma on 13/4/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import Foundation
import Alamofire

class TeacherRatingListAPI{
      public static let sharedInstance = TeacherRatingListAPI()
    
    func GetTeacherList(url : String,parameters: [String : Any]?,completionResponse:  @escaping (TeacherRatingAddModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (String?) -> Void){
        
        let urlCmplete = BaseUrl.kBaseURL+url
        //"http://stgsd.appsndevs.com/EducationProApi/api/Institute/GetAllStudentRatingByClassSubjecId"
        
        print("your complete address of api :\(urlCmplete)")
        var accessTokken =   "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI5ODk2OTUwODkxIiwiZW1haWwiOiJmb2dneUBnbWFpbC5jbyIsImF6cCI6IjI5NSIsInNpZCI6Im1pbmRAMTIzIiwianRpIjoiMjY4NDA4MDMtZmE4Ni00NDVkLTliYmItNTU2YWZmODJhMTMyIiwiZXhwIjoxNTc1NDM4ODc2LCJpc3MiOiJUZXN0LmNvbSIsImF1ZCI6IlRlc3QuY29tIn0.jRGWxJRGlCLi59rElllYgYTx3RNjp2jN7MMwpIxAADQ"
        if let str = UserDefaults.standard.value(forKey: UserDefaultKeys.userAuthToken.rawValue)  as?  String {
            accessTokken = str
        }
        
        let headers = [KConstants.kHeaderAuthorization:KConstants.kHeaderBearer+" "+accessTokken,KConstants.kAccept: KConstants.kApplicationJson]
        
        Alamofire.request(urlCmplete, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            print("your responsedd : \(response)")
            if response.result.isSuccess{
                guard let data = response.value else{return}
                if let responseData  = data as? [String : Any]{
                    print("your teacher list responsedd : \(responseData)")
                    self.GetTeacherListJSON(data: responseData, completionResponse: { (response) in
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
    
    private func GetTeacherListJSON(data: [String : Any],completionResponse:  @escaping (TeacherRatingAddModel) -> Void,completionError: @escaping (String?) -> Void)  {
        
        let TeacherListData = TeacherRatingAddModel(JSON: data)
        
        if TeacherListData != nil{
            completionResponse(TeacherListData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }
    
    func GetSubjectList(url : String,parameters: [String : Any]?,completionResponse:  @escaping (SubjectListTeacherModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (String?) -> Void){
        
        let urlCmplete = BaseUrl.kBaseURL+url
        //"http://stgsd.appsndevs.com/EducationProApi/api/Institute/GetAllStudentRatingByClassSubjecId"
        
        print("your complete address of api :\(urlCmplete)")
        var accessTokken =   "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI5ODk2OTUwODkxIiwiZW1haWwiOiJmb2dneUBnbWFpbC5jbyIsImF6cCI6IjI5NSIsInNpZCI6Im1pbmRAMTIzIiwianRpIjoiMjY4NDA4MDMtZmE4Ni00NDVkLTliYmItNTU2YWZmODJhMTMyIiwiZXhwIjoxNTc1NDM4ODc2LCJpc3MiOiJUZXN0LmNvbSIsImF1ZCI6IlRlc3QuY29tIn0.jRGWxJRGlCLi59rElllYgYTx3RNjp2jN7MMwpIxAADQ"
        if let str = UserDefaults.standard.value(forKey: UserDefaultKeys.userAuthToken.rawValue)  as?  String {
            accessTokken = str
        }
        
        let headers = [KConstants.kHeaderAuthorization:KConstants.kHeaderBearer+" "+accessTokken,KConstants.kAccept: KConstants.kApplicationJson]
        
        Alamofire.request(urlCmplete, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            print("your responsedd : \(response)")
            if response.result.isSuccess{
                guard let data = response.value else{return}
                if let responseData  = data as? [String : Any]{
                    print("your teacher list responsedd : \(responseData)")
                    self.GetSubjectListJSON(data: responseData, completionResponse: { (response) in
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
    
    private func GetSubjectListJSON(data: [String : Any],completionResponse:  @escaping (SubjectListTeacherModel) -> Void,completionError: @escaping (String?) -> Void)  {
        
        let subjectListData = SubjectListTeacherModel(JSON: data)
        
        if subjectListData != nil{
            completionResponse(subjectListData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }
    
    func AddTeacherFeedback(url : String,parameters: [String : Any]?,completionResponse:  @escaping (AddFeedbackModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (String?) -> Void){
        
        let urlCmplete = BaseUrl.kBaseURL+url
        //"http://stgsd.appsndevs.com/EducationProApi/api/Institute/GetAllStudentRatingByClassSubjecId"
        
        print("your complete address of api :\(urlCmplete)")
        var accessTokken =   ""
        if let str = UserDefaults.standard.value(forKey: UserDefaultKeys.userAuthToken.rawValue)  as?  String {
            accessTokken = str
        }
        
        let headers = [KConstants.kHeaderAuthorization:KConstants.kHeaderBearer+" "+accessTokken,KConstants.kAccept: KConstants.kApplicationJson]
        
        print("header: ",headers)
        
        
        Alamofire.request(urlCmplete, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            print("your responsedd : \(response)")
            if response.result.isSuccess{
                guard let data = response.value else{return}
                if let responseData  = data as? [String : Any]{
                    print("your teacher list responsedd : \(responseData)")
                    self.AddTeacherFeedbackJSON(data: responseData, completionResponse: { (response) in
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
    
    private func AddTeacherFeedbackJSON(data: [String : Any],completionResponse:  @escaping (AddFeedbackModel) -> Void,completionError: @escaping (String?) -> Void)  {
        
        let AddTeacherFeedbackData = AddFeedbackModel(JSON: data)
        
        if AddTeacherFeedbackData != nil{
            completionResponse(AddTeacherFeedbackData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }
    
    
    func ViewTeacherRating(url : String,parameters: [String : Any]?,completionResponse:  @escaping (ViewTeacherRatingModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (String?) -> Void){
        
        let urlCmplete = BaseUrl.kBaseURL+url
        //"http://stgsd.appsndevs.com/EducationProApi/api/Institute/GetAllStudentRatingByClassSubjecId"
        
        print("your complete address of api :\(urlCmplete)")
        var accessTokken =   ""
        if let str = UserDefaults.standard.value(forKey: UserDefaultKeys.userAuthToken.rawValue)  as?  String {
            accessTokken = str
        }
        
        let headers = [KConstants.kHeaderAuthorization:KConstants.kHeaderBearer+" "+accessTokken,KConstants.kAccept: KConstants.kApplicationJson]
        
        Alamofire.request(urlCmplete, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            print("your responsedd : \(response)")
            if response.result.isSuccess{
                guard let data = response.value else{return}
                if let responseData  = data as? [String : Any]{
                    print("your teacher list responsedd : \(responseData)")
                    self.ViewTeacherRatingJSON(data: responseData, completionResponse: { (response) in
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
    
    private func ViewTeacherRatingJSON(data: [String : Any],completionResponse:  @escaping (ViewTeacherRatingModel) -> Void,completionError: @escaping (String?) -> Void)  {
        
        let ViewTeacherRatingData = ViewTeacherRatingModel(JSON: data)
        
        if ViewTeacherRatingData != nil{
            completionResponse(ViewTeacherRatingData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }
    
    func GetTeacherRating(url : String,parameters: [String : Any]?,completionResponse:  @escaping (GetStudentTeacherRatingModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (String?) -> Void){
        
        let urlCmplete = BaseUrl.kBaseURL+url
        //"http://stgsd.appsndevs.com/EducationProApi/api/Institute/GetAllStudentRatingByClassSubjecId"
        
        print("your complete address of api :\(urlCmplete)")
        var accessTokken =   ""
        if let str = UserDefaults.standard.value(forKey: UserDefaultKeys.userAuthToken.rawValue)  as?  String {
            accessTokken = str
        }
        
        let headers = [KConstants.kHeaderAuthorization:KConstants.kHeaderBearer+" "+accessTokken,KConstants.kAccept: KConstants.kApplicationJson]
        
        Alamofire.request(urlCmplete, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            print("your responsedd : \(response)")
            if response.result.isSuccess{
                guard let data = response.value else{return}
                if let responseData  = data as? [String : Any]{
                    print("your teacher list responsedd : \(responseData)")
                    self.GetTeacherRatingJSON(data: responseData, completionResponse: { (response) in
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
    
    private func GetTeacherRatingJSON(data: [String : Any],completionResponse:  @escaping (GetStudentTeacherRatingModel) -> Void,completionError: @escaping (String?) -> Void)  {
        
        let GetStudentTeacherRatingData = GetStudentTeacherRatingModel(JSON: data)
        
        if GetStudentTeacherRatingData != nil{
            completionResponse(GetStudentTeacherRatingData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }
}
