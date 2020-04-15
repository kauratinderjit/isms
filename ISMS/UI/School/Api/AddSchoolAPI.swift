//
//  AddSchoolAPI.swift
//  ISMS
//  Api
//  Created by Gurleen Osahan on 6/17/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper


class AddSchoolApi {
    
    //MARK:- variables
    static let sharedInstance = AddSchoolApi()
    
    
    //MARK:- Get School Information api
    func GetSchoolInformationApi(url : String, parameter : [String:Any]?, completionResponse:  @escaping (SchoolData) -> Void,completionnilResponse:  @escaping () -> Void,Error: @escaping (String?) -> Void)
    {

        let urlComplete = BaseUrl.kBaseURL + url

        var accessTokken = ""
        if let str = UserDefaults.standard.value(forKey: UserDefaultKeys.userAuthToken.rawValue)  as?  String
        {
            accessTokken = str
        }
        let headers = [KConstants.kHeaderAuthorization:KConstants.kHeaderBearer+" "+accessTokken,KConstants.kAccept: KConstants.kApplicationJson]

        print(urlComplete)
        Alamofire.request(urlComplete, method: .get, parameters: parameter, encoding: JSONEncoding.default, headers : headers)
            .responseJSON { response in
              
                if response.result.isSuccess
                {
                    guard let data = response.value else{return}
                    print(data)
                    if let responseData  = data as? [String : Any]
                    {
                        self.SchoolDataJSON(data: responseData, completionResponse: { (schoolData) in
                            completionResponse(schoolData)
                        }, completionError: { (error) in
                            Error(error)
                            print("All Country Mapper Error:- ")
                        })
                    }
                }
                else
                {
                    Error(response.error?.localizedDescription)
                    return
                }
        }
    }
    
//    func updateSchoolInfo(url : String, parameter : [String:Any], completionResponse:  @escaping (LoginData) -> Void,completionnilResponse:  @escaping (String) -> Void,completionError: @escaping (Error?) -> Void){
//        let urlComplete = BaseUrl.kBaseURL+url
//        let headers    = [KConstants.kContentType : KConstants.kApplicationJson]
//
//
//        Alamofire.request(urlComplete, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers : headers)
//            .responseJSON { response in
//
//                if response.result.isSuccess
//                {
//                    guard let data = response.value else{return}
//                    let responseData  = data as! [String : Any]
//                    let statusCode = responseData[k_StatusCode] as! Int
//                    if statusCode == KStatusCode.kStatusCode200{
//
//                    }
//                    else if statusCode == KStatusCode.kStatusCode400{
//
//                    }
//                    else
//                    {
//                        completionnilResponse(k_ServerError)
//                    }
//                }
//                else
//                {
//                    completionError(response.error)
//                    return
//                }
//        }
//
//    }
    func updateSchoolInfo(url : String, parameter : [String:Any], uploadItems: [UploadItems]?,completionResponse:  @escaping (NSDictionary) -> Void,completionnilResponse:  @escaping (String) -> Void,completionError: @escaping (Error?) -> Void){
        let strURL =   BaseUrl.kBaseURL+url
      print(parameter)

        var accessTokken = ""
        if let str = UserDefaults.standard.value(forKey: UserDefaultKeys.userAuthToken.rawValue)  as?  String
        {
            accessTokken = str
        }
 //KConstants.kContentType: KConstants.kMultipartFormData,KConstants.kAccept : KConstants.kApplicationJson,
        let headers: HTTPHeaders = [ KConstants.kHeaderAuthorization : KConstants.kHeaderBearer + " " + accessTokken]
                
                let configuration = URLSessionConfiguration.default
                configuration.timeoutIntervalForRequest = 1200
                let alamoManager = Alamofire.SessionManager(configuration: configuration)

                alamoManager.upload(multipartFormData: { (multipartFormData) in
                    
                    // Rest of values
                       for (key, value) in parameter {
                        print(key + "key1")
                        print(value)
                        if key == "IFile"{
                            
                            if let parameterimages = uploadItems{
                                for (key,value) in parameterimages.enumerated(){
                                    print(key)
                                    if let url = value.uRL , let filetype = value.filetype{
                                        print(url)
                                        print(filetype)
                                        multipartFormData.append(url, withName: filetype)
                                        
                                        //multipartFormData.append(url, withName:filetype, fileName: "", mimeType: "")
                                    }
                                }
                            }
                        }
                        else{
                        if(value is URL) {
                            print(value)
                            multipartFormData.append(value as! URL, withName: "Logo", fileName: "MyImage.jpg", mimeType: "Image.jpg")
                        }
                        else
                        {
                            if let Item = value as? String
                            {
                                print(Item)
                                _ = Item.data(using:  String.Encoding.utf8)
                                multipartFormData.append("\(Item)".data(using: String.Encoding.utf8)!, withName: key as String)
                            }
                            if let Item = value as? Int
                            {
                                print(Item)
                                multipartFormData.append("\(Item)".data(using: String.Encoding.utf8)!, withName: key as String)
                                
                            }
                            
                          
                            if let arry = value as? [[String:Any]] {
//                                for (i, value) in arry {
//                                        print(i)
//                                    print(value)
//                                multipartFormData.append("\(85)".data(using: String.Encoding.utf8)!, withName: "LstDeletedAttachment[" + (i) + "].deleteAttachmentId")
//
                                
                                    
                                    
                                    for (i,value1) in arry.enumerated(){
                                        print(value1)
                                        print(i)
                                        if let dict = value1 as? [String: Any] {
                                            print(dict)
                                            if let value2 = dict["deleteAttachmentId"] as? Int {
                                                print(value2)
                                                multipartFormData.append("\(value2)".data(using: String.Encoding.utf8)!, withName: "LstDeletedAttachment[" + "\(i)" + "].deleteAttachmentId")
                                            }
                                        }
                                }
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                }
                            }
                            

                        }
                    }
               
                  
                }, usingThreshold: UInt64.init(), to: strURL, method: .post, headers: headers) { (result) in
                    switch result{
                    case .success(let upload, _, _):
                        upload.responseJSON { response in
                            
                            print(response)
                            print(response.request ?? "")  // original URL request
                            print(response.response ?? "") // URL response
                            print(response.data ?? "")     // server data
                            print(response.result)   // result of response serialization
                            print(response.result.value ?? "" )
                            if let error = response.error
                            {
                                
                                print("Upload failed with error: (\(error))")
                                print("Upload failed with error: (\(error.localizedDescription))")
                              
                            }
                            else
                            {
                                let resdict =  (response.result.value as! NSDictionary)
                                print(resdict)
                                let code = (resdict).value(forKey: "StatusCode") as? Int
                                let message = (resdict).value(forKey: "message") as? String ?? ""
                                if code == 200 {
                                completionResponse(resdict)
                                }
                                else {
                                   print("not 200")
                                }
                                
                            }
                            
                            alamoManager.session.invalidateAndCancel()
                        }
                    case .failure(let error):
                        print("Error in upload: \(error.localizedDescription)")
                        
                    }
                }
    }
    
    //MARK:- Get School Information api
func GetSchoolDropDown(url : String, parameter : [String:Any]?, completionResponse:  @escaping (SchoolData) -> Void,completionnilResponse:  @escaping () -> Void,Error: @escaping (Error?) -> Void){
    
        let urlComplete = BaseUrl.kBaseURL + url
        //let headers    = [KConstants.kContentType : KConstants.kApplicationJson]
        let headers:  HTTPHeaders = [
            "Content-type": "form-data","Accept" : "application/json", "Authorization" : "bearer" + " " + "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI3NzgwOTI0MTM2Iiwic2lkIjoibWluZEAxMjMiLCJqdGkiOiJjNDM5ZTQxMi1iMmE2LTQwN2YtYmE3Ni00NmI3Nzc0OWJkZWYiLCJleHAiOjE1NjA5Mzc3NjcsImlzcyI6IlRlc3QuY29tIiwiYXVkIjoiVGVzdC5jb20ifQ.AlU3d0nKmXeT39PSFG-GJZ2xK2VVJJoUqT0k6My9Sws"
        ]
        print(urlComplete)
        Alamofire.request(urlComplete, method: .get, parameters: parameter, encoding: JSONEncoding.default, headers : headers)
            .responseJSON { response in
                
                if response.result.isSuccess
                {
                    guard let data = response.value else{return}
                    
                    if let responseData  = data as? [String : Any]
                    {
                        
                       print(responseData)
                        
                    }
                    
                    
                }
                else
                {
                    Error(response.error)
                    return
                }
        }
        
    }
    
    
    
    
    private func SchoolDataJSON(data: [String : Any],completionResponse:  @escaping (SchoolData) -> Void,completionError: @escaping (String?) -> Void)  {
        
        let schoolData = SchoolData(JSON: data)
        
        if schoolData != nil{
            completionResponse(schoolData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
        
    }


}
