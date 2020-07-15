//
//  UpdateSyllabusApi.swift
//  ISMS
//
//  Created by Kuldeep Singh on 11/20/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
import Alamofire

class HomeworkApi
{
    
    static let sharedManager = HomeworkApi()
    
    
    
    func multipartPostApi( postDict: [String: Any], url: String, completionResponse:  @escaping ([String: Any]) -> Void,completionError: @escaping (Error?) -> Void )
        {

            CommonFunctions.sharedmanagerCommon.println(object: "Post dictionary:- \(postDict)")
            
            let url = BaseUrl.kBaseURL+url
            var accessTokken = ""
            if let str = UserDefaults.standard.value(forKey: UserDefaultKeys.userAuthToken.rawValue)  as?  String
            {
                accessTokken = str
            }
            let headers: HTTPHeaders = [KConstants.kContentType: KConstants.kMultipartFormData,KConstants.kAccept : KConstants.kApplicationJson,KConstants.kHeaderAuthorization: KConstants.kHeaderBearer + " " + accessTokken]
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 1200
            let alamoManager = Alamofire.SessionManager(configuration: configuration)
            
            
            alamoManager.upload(multipartFormData: { (multipartFormData) in
                
                for (key, value) in postDict {
                    print(key)
                    print(value)
                    if let Item = value as? NSMutableArray {
                 
                        if Item.count > 0 {
                        for (_,value) in Item.enumerated()
                                              {
                                                let dd = value as? [String:Any]
                                                if let url = dd?["path"] as? URL {
                                                    let keyName = dd?["type"] as? String
                                                    if keyName == "audio" {
                                                  multipartFormData.append(url, withName: "FeedAudio" )
                                                    }
                                                    else if keyName == "video"  {
                                                        multipartFormData.append(url, withName: "FeedVideo" )
                                                    }

                                                    else {
                                                         multipartFormData.append(url, withName: "FeedImage" )
                                                    }
                                                }}
                        }

                    }
                    else
                    {
                        if tagArray.count > 0 {
                            for (index,value) in tagArray.enumerated() {
                                let tagid = value.UserId
                               
                                multipartFormData.append("\(String(describing: tagid!))".data(using: String.Encoding.utf8)!, withName:"TagIds")
                            }
                            tagArray.removeAll()
                        }
                        
                        if let Item = value as? [Int] {
                            
                            for (_,value) in Item.enumerated() {
                                                     let tagid = value
                                                    multipartFormData.append("\(String(describing: tagid))".data(using: String.Encoding.utf8)!, withName:"TagIds")
                                                 }
                                                 
                                             }
                        
                        if let Item = value as? String
                        {
                            print(Item)
                            multipartFormData.append("\(Item)".data(using: String.Encoding.utf8)!, withName: key as String)
                        }
                        if let Item = value as? Int
                        {
                            print(Item)
                            multipartFormData.append("\(Item)".data(using: String.Encoding.utf8)!, withName: key as String)
                            
                        }
                        if let Item = value as? Data
                                              {
                                                  print(Item)
                                                let formatter: DateFormatter = DateFormatter()
                                                formatter.dateFormat = "dd-MM-yyyy-HH-mm-ss"
                                                let dateTimePrefix: String = formatter.string(from: Date())

                                                multipartFormData.append(value as! Data, withName: "FeedThumbNil", fileName: "\(dateTimePrefix).png", mimeType: "image/png")
                                                
                                                //appendBodyPart(data: value, name: "image", fileName: "Thumbnail.png", mimeType: "image/png")FeedThumbNil

                                                  
                                              }
                        
//                         if let Item = value as? NSMutableArray{
//                            print(Item)
//                            if Item.count > 0 {
//                                 for (ind,element) in Item.enumerated()
//                                               {
//                                let dic = element as? [String : Any]
//                                let dd = dic?["StudentAttachmentId"] as? Int
//                            multipartFormData.append("\(dd!)".data(using: String.Encoding.utf8)!, withName: "lstdeleteattachmentModel[" + "\(ind)" + "].StudentAttachmentId")
//                                }
//                        }
//
//                    }
                }
                }
                
            }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { (result) in
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
                            CommonFunctions.sharedmanagerCommon.println(object: "Upload failed with error: (\(error))")
                            CommonFunctions.sharedmanagerCommon.println(object: "Upload failed with error: (\(error.localizedDescription))")
                            completionError(response.error)
                        }
                        else
                        {
                            let resdict =  (response.result.value as!  [String : Any])
                            CommonFunctions.sharedmanagerCommon.println(object: "here your uploaded result23: \(resdict)")
                            completionResponse(resdict)
                        }
                        
                        alamoManager.session.invalidateAndCancel()
                    }
                case .failure(let error):
                    CommonFunctions.sharedmanagerCommon.println(object: "Error in upload: \(error.localizedDescription)")
                    completionError(error)
                    
                }
            }
            
        }
        
    
    func getNewsFeed(url : String,parameters: [String : Any]?,completionResponse:  @escaping (NewsFeedListModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
           
           let urlCmplete = BaseUrl.kBaseURL+url
           print(urlCmplete)
           print(parameters)
           var accessTokken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI5ODk2OTUwODkxIiwiZW1haWwiOiJmb2dneUBnbWFpbC5jbyIsImF6cCI6IjI5NSIsInNpZCI6Im1pbmRAMTIzIiwianRpIjoiNWEwNDBlMzgtZWNkZS00OGMzLWE2YzgtYzc4Njk5MWJkZmM0IiwiZXhwIjoxNTc1NzE0MjQ0LCJpc3MiOiJUZXN0LmNvbSIsImF1ZCI6IlRlc3QuY29tIn0.ewRiy_71XXevggx1qQFsEbE7EVzJm-uy5ru_Tr6kxeI"
           if let str = UserDefaults.standard.value(forKey: UserDefaultKeys.userAuthToken.rawValue)  as?  String
           {
               accessTokken = str
           }
           
           let headers = [KConstants.kHeaderAuthorization:KConstants.kHeaderBearer+" "+accessTokken,KConstants.kAccept: KConstants.kApplicationJson]
           
           
              Alamofire.request(urlCmplete, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers : headers)
               .responseJSON { response in
               CommonFunctions.sharedmanagerCommon.println(object: "response list:- \(response) ")
               if response.result.isSuccess
               {
                   guard let data = response.value else{return}
                   
                   if let responseData  = data as? [String : Any]
                   {
                       print("your response data subjec kk1: \(responseData)")
                       self.getNewsFeedListJSON(data: responseData, completionResponse: { (responseModel) in
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
    
    private func getNewsFeedListJSON(data: [String : Any],completionResponse:  @escaping (NewsFeedListModel) -> Void,completionError: @escaping (String?) -> Void)  {
        
        let newsListData = NewsFeedListModel(JSON: data)
        
        if newsListData != nil{
            completionResponse(newsListData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }
    
    func getComments(url : String,parameters: [String : Any]?,completionResponse:  @escaping (CommentList) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
           
           let urlCmplete = BaseUrl.kBaseURL+url
           print(urlCmplete)
           print(parameters)
           var accessTokken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI5ODk2OTUwODkxIiwiZW1haWwiOiJmb2dneUBnbWFpbC5jbyIsImF6cCI6IjI5NSIsInNpZCI6Im1pbmRAMTIzIiwianRpIjoiNWEwNDBlMzgtZWNkZS00OGMzLWE2YzgtYzc4Njk5MWJkZmM0IiwiZXhwIjoxNTc1NzE0MjQ0LCJpc3MiOiJUZXN0LmNvbSIsImF1ZCI6IlRlc3QuY29tIn0.ewRiy_71XXevggx1qQFsEbE7EVzJm-uy5ru_Tr6kxeI"
           if let str = UserDefaults.standard.value(forKey: UserDefaultKeys.userAuthToken.rawValue)  as?  String
           {
               accessTokken = str
           }
           
           let headers = [KConstants.kHeaderAuthorization:KConstants.kHeaderBearer+" "+accessTokken,KConstants.kAccept: KConstants.kApplicationJson]
           
           
              Alamofire.request(urlCmplete, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers : headers)
               .responseJSON { response in
               CommonFunctions.sharedmanagerCommon.println(object: "response list:- \(response) ")
               if response.result.isSuccess
               {
                   guard let data = response.value else{return}
                   
                   if let responseData  = data as? [String : Any]
                   {
                       print("your response data subjec kk1: \(responseData)")
                       self.getCommentsListJSON(data: responseData, completionResponse: { (responseModel) in
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
    private func getCommentsListJSON(data: [String : Any],completionResponse:  @escaping (CommentList) -> Void,completionError: @escaping (String?) -> Void)  {
          
          let newsListData = CommentList(JSON: data)
          
          if newsListData != nil{
              completionResponse(newsListData!)
          }else{
              completionError(Alerts.kMapperModelError)
          }
      }
    
    func likePost(url : String,parameters: [String : Any]?,completionResponse:  @escaping ([String:Any]) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
           
           let urlCmplete = BaseUrl.kBaseURL+url
           print(urlCmplete)
           print(parameters)
           var accessTokken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI5ODk2OTUwODkxIiwiZW1haWwiOiJmb2dneUBnbWFpbC5jbyIsImF6cCI6IjI5NSIsInNpZCI6Im1pbmRAMTIzIiwianRpIjoiNWEwNDBlMzgtZWNkZS00OGMzLWE2YzgtYzc4Njk5MWJkZmM0IiwiZXhwIjoxNTc1NzE0MjQ0LCJpc3MiOiJUZXN0LmNvbSIsImF1ZCI6IlRlc3QuY29tIn0.ewRiy_71XXevggx1qQFsEbE7EVzJm-uy5ru_Tr6kxeI"
           if let str = UserDefaults.standard.value(forKey: UserDefaultKeys.userAuthToken.rawValue)  as?  String
           {
               accessTokken = str
           }
           
           let headers = [KConstants.kHeaderAuthorization:KConstants.kHeaderBearer+" "+accessTokken,KConstants.kAccept: KConstants.kApplicationJson]
           
        
           
              Alamofire.request(urlCmplete, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers : headers)
               .responseJSON { response in
               CommonFunctions.sharedmanagerCommon.println(object: "response list:- \(response) ")
               if response.result.isSuccess
               {
                   guard let data = response.value else{return}
                   
                   if let responseData  = data as? [String : Any]
                   {
                       print("your response data subjec kk1: \(responseData)")
                         completionResponse(responseData)
                       
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

       func getLikerList(url : String,parameters: [String : Any]?,completionResponse:  @escaping (LikerListModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
               
               let urlCmplete = BaseUrl.kBaseURL+url
               print(urlCmplete)
               print(parameters)
               var accessTokken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI5ODk2OTUwODkxIiwiZW1haWwiOiJmb2dneUBnbWFpbC5jbyIsImF6cCI6IjI5NSIsInNpZCI6Im1pbmRAMTIzIiwianRpIjoiNWEwNDBlMzgtZWNkZS00OGMzLWE2YzgtYzc4Njk5MWJkZmM0IiwiZXhwIjoxNTc1NzE0MjQ0LCJpc3MiOiJUZXN0LmNvbSIsImF1ZCI6IlRlc3QuY29tIn0.ewRiy_71XXevggx1qQFsEbE7EVzJm-uy5ru_Tr6kxeI"
               if let str = UserDefaults.standard.value(forKey: UserDefaultKeys.userAuthToken.rawValue)  as?  String
               {
                   accessTokken = str
               }
               
               let headers = [KConstants.kHeaderAuthorization:KConstants.kHeaderBearer+" "+accessTokken,KConstants.kAccept: KConstants.kApplicationJson]
               
               
                  Alamofire.request(urlCmplete, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers : headers)
                   .responseJSON { response in
                   CommonFunctions.sharedmanagerCommon.println(object: "response list:- \(response) ")
                   if response.result.isSuccess
                   {
                       guard let data = response.value else{return}
                       
                       if let responseData  = data as? [String : Any]
                       {
                           print("your response data subjec kk1: \(responseData)")
                           self.getLikerListJSON(data: responseData, completionResponse: { (responseModel) in
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
        private func getLikerListJSON(data: [String : Any],completionResponse:  @escaping (LikerListModel) -> Void,completionError: @escaping (String?) -> Void)  {
              
              let newsListData = LikerListModel(JSON: data)
              
              if newsListData != nil{
                  completionResponse(newsListData!)
              }else{
                  completionError(Alerts.kMapperModelError)
              }
          }
}
//NewsFeedListModel
