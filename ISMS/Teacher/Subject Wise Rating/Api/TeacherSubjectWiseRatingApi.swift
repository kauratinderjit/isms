//
//  TeacherSubjectWiseRatingApi.swift
//  ISMS
//
//  Created by Kuldeep Singh on 12/5/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation


import Alamofire

class TeacherSubjectWiseRatingApi {
    
    public static let sharedInstance = TeacherSubjectWiseRatingApi()
    
    
    
    //MARK:- Assign Subject to class Api
    func SubjectWiseList(url : String,parameters: [String : Any]?,completionResponse:  @escaping (TeacherSubjectWiseRatingModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (String?) -> Void){
        
        let urlCmplete = BaseUrl.kBaseURL+url
        //"http://stgsd.appsndevs.com/EducationProApi/api/Institute/GetAllStudentRatingByClassSubjecId"
        print("your complete address of api :\(urlCmplete)")
        print("param of this : \(parameters)")
        var accessTokken =   "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI5ODk2OTUwODkxIiwiZW1haWwiOiJmb2dneUBnbWFpbC5jbyIsImF6cCI6IjI5NSIsInNpZCI6Im1pbmRAMTIzIiwianRpIjoiYmYyZjNhZTktM2Y4OS00NGE1LWEzYmYtZmJlNzlkNmZkYTZlIiwiZXhwIjoxNTc1NjA2NjAyLCJpc3MiOiJUZXN0LmNvbSIsImF1ZCI6IlRlc3QuY29tIn0._PigzNXu2u6QaEYSR2acRABPHVhTcPkwBQFvzmdAdpI"
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
    
    private func SubmitApiJSON(data: [String : Any],completionResponse:  @escaping (TeacherSubjectWiseRatingModel) -> Void,completionError: @escaping (String?) -> Void)  {
        let assignSubjetcToClassData = TeacherSubjectWiseRatingModel(JSON: data)
        if assignSubjetcToClassData != nil{
            completionResponse(assignSubjetcToClassData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }
    
    
    
    
    
    
    
}
