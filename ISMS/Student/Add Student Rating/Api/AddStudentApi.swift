//
//  AddStudentApi.swift
//  ISMS
//
//  Created by Kuldeep Singh on 11/28/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
import Alamofire

class AddStudentRatingApi {
    
    static let sharedInstance = AddStudentRatingApi()
    
    //MARK:- Assign Subject to class Api
    func GetSkillList(url : String,parameters: [String : Any]?,completionResponse:  @escaping (AddStudentRatingListModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (String?) -> Void){
        
        let urlCmplete = BaseUrl.kBaseURL+url
        //"http://stgsd.appsndevs.com/EducationProApi/api/Institute/GetAllStudentRatingByClassSubjecId"
        
        print("your complete address of api :\(urlCmplete)")
        var accessTokken =   "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI5ODk2OTUwODkxIiwiZW1haWwiOiJmb2dneUBnbWFpbC5jbyIsImF6cCI6IjI5NSIsInNpZCI6Im1pbmRAMTIzIiwianRpIjoiMjY4NDA4MDMtZmE4Ni00NDVkLTliYmItNTU2YWZmODJhMTMyIiwiZXhwIjoxNTc1NDM4ODc2LCJpc3MiOiJUZXN0LmNvbSIsImF1ZCI6IlRlc3QuY29tIn0.jRGWxJRGlCLi59rElllYgYTx3RNjp2jN7MMwpIxAADQ"
        if let str = UserDefaults.standard.value(forKey: UserDefaultKeys.userAuthToken.rawValue)  as?  String {
            accessTokken = str
        }
        
        let headers = [KConstants.kHeaderAuthorization:KConstants.kHeaderBearer+" "+accessTokken,KConstants.kAccept: KConstants.kApplicationJson]
        
        Alamofire.request(urlCmplete, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            if response.result.isSuccess{
                guard let data = response.value else{return}
                if let responseData  = data as? [String : Any]{
                    print("your Subject list rating responsedd : \(responseData)")
                    self.GetSkillListJSON(data: responseData, completionResponse: { (response) in
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
    
    private func GetSkillListJSON(data: [String : Any],completionResponse:  @escaping (AddStudentRatingListModel) -> Void,completionError: @escaping (String?) -> Void)  {
        
        let assignSubjetcToClassData = AddStudentRatingListModel(JSON: data)
        
        if assignSubjetcToClassData != nil{
            completionResponse(assignSubjetcToClassData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }
    
    
    //MARK:- Assign Subject to class Api
    func SubmitApiList(url : String,parameters: [String : Any]?,completionResponse:  @escaping (SubjectWiseRatingModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (String?) -> Void){
        
        let urlCmplete = BaseUrl.kBaseURL+url
        //"http://stgsd.appsndevs.com/EducationProApi/api/Institute/GetAllStudentRatingByClassSubjecId"
        
        print("your complete address of api :\(urlCmplete)")
        print("param of this : \(parameters)")
        var accessTokken =   "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI5ODk2OTUwODkxIiwiZW1haWwiOiJmb2dneUBnbWFpbC5jbyIsImF6cCI6IjI5NSIsInNpZCI6Im1pbmRAMTIzIiwianRpIjoiM2VlYzFiODMtMzY1Mi00YzBjLTg1NTUtMzhmYTUyZTg2MzRlIiwiZXhwIjoxNTc1NTIxNTYyLCJpc3MiOiJUZXN0LmNvbSIsImF1ZCI6IlRlc3QuY29tIn0.gbcuYC8l7TTGvbb5XFfSGY9qWBO5-5ST9jwxXkWgzPI"
        if let str = UserDefaults.standard.value(forKey: UserDefaultKeys.userAuthToken.rawValue)  as?  String {
            accessTokken = str
        }
        
        let headers = [KConstants.kHeaderAuthorization:KConstants.kHeaderBearer+" "+accessTokken,KConstants.kAccept: KConstants.kApplicationJson]
        
        Alamofire.request(urlCmplete, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            if response.result.isSuccess {
                guard let data = response.value else{return}
                if let responseData  = data as? [String : Any]{
                    print("your student rating Submit Result: \(responseData)")
                    self.SubmitApiJSON(data: responseData, completionResponse: { (response) in
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
    
    private func SubmitApiJSON(data: [String : Any],completionResponse:  @escaping (SubjectWiseRatingModel) -> Void,completionError: @escaping (String?) -> Void)  {
        
        let assignSubjetcToClassData = SubjectWiseRatingModel(JSON: data)
        
        if assignSubjetcToClassData != nil{
            completionResponse(assignSubjetcToClassData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }
    
    
    
    
    
}
