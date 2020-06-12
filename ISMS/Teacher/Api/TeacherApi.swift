//
//  TeacherApi.swift
//  ISMS
//
//  Created by Taranjeet Singh on 6/20/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
import Alamofire

class TeacherApi {
    
    static let sharedManager = TeacherApi()
    
    func getClassDropdownData(id : Int,enumType: Int,completionResponse:  @escaping (GetCommonDropdownModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
          
          SignUpApi.sharedInstance.getCommonDropdownApi(url: ApiEndpoints.KClassdropDown+"?id=\(id)&enumType=\(enumType)", parameter: nil, completionResponse: { (responseModel) in
              completionResponse(responseModel)
          }, completionnilResponse: { (nilResponse) in
              completionnilResponse(nilResponse)
          }) { (error) in
              complitionError(error)
          }
          
      }
    
    func GetSubjectList(url : String,parameters: [String : Any]?,completionResponse:  @escaping (AssignSubjectTeacherModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (String?) -> Void){
        
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
                    print("your Subject list rating responsedd : \(responseData)")
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
    
    
    
    
    
    
    
    private func GetSubjectListJSON(data: [String : Any],completionResponse:  @escaping (AssignSubjectTeacherModel) -> Void,completionError: @escaping (String?) -> Void)  {
          
          let assignSubjetcToTeacherData = AssignSubjectTeacherModel(JSON: data)
          
          if assignSubjetcToTeacherData != nil{
              completionResponse(assignSubjetcToTeacherData!)
          }else{
              completionError(Alerts.kMapperModelError)
          }
      }
    
    
    //MARK:- Add/Update Teacher Api
    func addUpdateTeacher(url : String,parameters: [String : Any],completionResponse:  @escaping (CommonSuccessResponseModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
        
        SignUpApi.sharedInstance.multipartApi(postDict: parameters, url: url, completionResponse: { (response) in
            self.addUpdateTeacherJSON(data: response, completionResponse: { (responseModel) in
                completionResponse(responseModel)
            }, completionError: { (error) in
                completionnilResponse(error)
            })
            
        }) { (error) in
            complitionError(error)
        }
        
        
    }
    
    //Convert Json data into mapper
    private func addUpdateTeacherJSON(data: [String : Any],completionResponse:  @escaping (CommonSuccessResponseModel) -> Void,completionError: @escaping (String?) -> Void){
        
        let addHodResponseData = CommonSuccessResponseModel(JSON: data)
        
        if addHodResponseData != nil{
            completionResponse(addHodResponseData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }
    
    //MARK:- Teacher List Api
    func getTeacherList(url : String,parameters: [String : Any]?,completionResponse:  @escaping (TeacherListModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
        
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
                    self.getTeacherListJSON(data: responseData, completionResponse: { (responseModel) in
                        completionResponse(responseModel)
                    }, completionError: { (mapperError) in
                        completionnilResponse(mapperError)
                    })
                    
                }else{
                    CommonFunctions.sharedmanagerCommon.println(object: "Get Teacher list Error:- \(data) ")
                }
                
            }
            else
            {
                complitionError(response.error)
                return
            }
        }
        
    }
    
    private func getTeacherListJSON(data: [String : Any],completionResponse:  @escaping (TeacherListModel) -> Void,completionError: @escaping (String?) -> Void)  {
        
        let teacherListData = TeacherListModel(JSON: data)
        
        if teacherListData != nil{
            completionResponse(teacherListData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }
    
    //MARK:- Delete Teacher
    func deleteTeacherApi(url: String,completionResponse:  @escaping (DeleteTeacherModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
        
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
                    self.getDeleteTeacherJSON(data: responseData, completionResponse: { (deleteResponseModel) in
                        completionResponse(deleteResponseModel)
                    }, completionError: { (error) in
                        completionnilResponse(error)
                    })
                    
                }else{
                    CommonFunctions.sharedmanagerCommon.println(object: "Delete Teacher Error:- \(data) ")
                }
                
            }
            else
            {
                complitionError(response.error)
                return
            }
        }
    }
    
    //Delete Teacher
    private func getDeleteTeacherJSON(data: [String : Any],completionResponse:  @escaping (DeleteTeacherModel) -> Void,completionError: @escaping (String?) -> Void){
        
        let deleteTeacherData = DeleteTeacherModel(JSON: data)
        
        if deleteTeacherData != nil{
            completionResponse(deleteTeacherData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }

    //MARK:- Get Teacher detail
    func getTeacherDetail(url: String,completionResponse:  @escaping (TeacherDetailModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
        
        
        let urlCmplete = BaseUrl.kBaseURL+url
        var accessTokken = ""
        if let str = UserDefaults.standard.value(forKey: UserDefaultKeys.userAuthToken.rawValue)  as?  String
        {
            accessTokken = str
        }
        
        let headers = [KConstants.kHeaderAuthorization:KConstants.kHeaderBearer + " " + accessTokken,KConstants.kContentType:KConstants.kApplicationJson]
        
        Alamofire.request(urlCmplete, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            CommonFunctions.sharedmanagerCommon.println(object: "Get Teacher Detail by teacher id:- \(response)")

            if response.result.isSuccess
            {
                guard let data = response.value else{return}
                
                if let responseData  = data as? [String : Any]
                {
                    self.getTeacherDetailJSON(data: responseData, completionResponse: { (detailModel) in
                        completionResponse(detailModel)
                    }, completionError: { (mapperError) in
                        completionnilResponse(mapperError)
                    })
                    
                    
                }else{
                    CommonFunctions.sharedmanagerCommon.println(object: "Detail HOD Error:- \(data) ")
                }
                
            }
            else
            {
                complitionError(response.error)
                return
            }
        }
        
        
        
    }
    //For Teacher Detail
    private func getTeacherDetailJSON(data: [String : Any],completionResponse:  @escaping (TeacherDetailModel) -> Void,completionError: @escaping (String?) -> Void)  {
        
        let teacherDetailData = TeacherDetailModel(JSON: data)
        
        if teacherDetailData != nil{
            completionResponse(teacherDetailData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }
    
    //MARK:- Get Teacher Detail using PhoneEmail
    func getTeacherDetailPhoneEmail(url : String,parameters: [String : Any]?,completionResponse:  @escaping (TeacherDetailModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
        
        let urlCmplete = BaseUrl.kBaseURL+url
        var accessTokken = ""
        if let str = UserDefaults.standard.value(forKey: UserDefaultKeys.userAuthToken.rawValue)  as?  String{
            accessTokken = str
        }
        
        let headers = [KConstants.kHeaderAuthorization:KConstants.kHeaderBearer+" "+accessTokken,KConstants.kAccept: KConstants.kApplicationJson]
        
        Alamofire.request(urlCmplete, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            if response.result.isSuccess{
                CommonFunctions.sharedmanagerCommon.println(object: "Get Teacher Detail By Phone Email:- \(response)")
                guard let data = response.value else{return}
                if let responseData  = data as? [String : Any]{
                    self.getTeacherDetailByPhoneEmailJSON(data: responseData, completionResponse: { (responseModel) in
                        completionResponse(responseModel)
                    }, completionError: { (mapperError) in
                        completionnilResponse(mapperError)
                    })
                }else{
                    CommonFunctions.sharedmanagerCommon.println(object: "Get Teacher Detail by PhoneEmail Error:- \(data) ")
                }
            }
            else{
                complitionError(response.error)
                return
            }
        }
    }
    
    //Convert GetTeacherDetailByPhoneEmail Json Data into model
    func getTeacherDetailByPhoneEmailJSON(data: [String : Any],completionResponse:  @escaping (TeacherDetailModel) -> Void,completionError: @escaping (String?) -> Void){
        let teacherDetailData = TeacherDetailModel(JSON: data)
        if teacherDetailData != nil{
            completionResponse(teacherDetailData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }
    
    //Mark:- Get Assign Dropdown
    func getAssignDepartmentDropdownList(selectedDepartmentId : Int,enumType: Int,completionResponse:  @escaping (GetCommonDropdownModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
        SignUpApi.sharedInstance.getCommonDropdownApi(url: ApiEndpoints.kGetCommonDropdownApi+"?id=\(selectedDepartmentId)&enumType=\(enumType)", parameter: nil, completionResponse: { (responseModel) in
            completionResponse(responseModel)
        }, completionnilResponse: { (nilResponse) in
            completionnilResponse(nilResponse)
        }) { (error) in
            complitionError(error)
        }
    }
}

