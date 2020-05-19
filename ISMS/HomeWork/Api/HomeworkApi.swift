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
    
    
    //MARK:- Homework Api
   
    func multipartApi( postDict: [String: Any], url: String, completionResponse:  @escaping ([String: Any]) -> Void,completionError: @escaping (Error?) -> Void )
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
                if let Item = value as? [URL]{
                    

//                        for (i,value1) in arry.enumerated(){
//                            print(value1)
//                            print(i)
//                            if let dict = value1 as? [String: Any] {
//                                print(dict)
//                                if let value2 = dict["deleteAttachmentId"] as? Int {
//                                    print(value2)
                               //     multipartFormData.append(value, withName: "LstDeletedAttachment[" + "\(i)" + "].deleteAttachmentId")
                              //  }
                           // }
                  
                    if Item.count > 0 {
                    for (_,value) in Item.enumerated()
                                          {
                                              multipartFormData.append(value, withName: "IFile" )
                                          }
                    }

                }
                else
                {
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
                     if let Item = value as? NSMutableArray{
                        print(Item)
                        if Item.count > 0 {
                             for (ind,element) in Item.enumerated()
                                           {
                            let dic = element as? [String : Any]
                            let dd = dic?["StudentAttachmentId"] as? Int
                        multipartFormData.append("\(dd!)".data(using: String.Encoding.utf8)!, withName: "lstdeleteattachmentModel[" + "\(ind)" + "].StudentAttachmentId")
                            }
                    }
                    
                }
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
    
    private func getHomeWorkJSON(data: [String : Any],completionResponse:  @escaping (HomeworkListModel) -> Void,completionError: @escaping (String?) -> Void)  {
        
        let ListData = HomeworkListModel(JSON: data)
        
        if ListData != nil{
            completionResponse(ListData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }
    
    func getHWSubjectList(url : String,parameters: [String : Any]?,completionResponse:  @escaping (SubjectListHomeworkModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
        
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
    
    
    func getHoweworkList(url : String,parameters: [String : Any]?,completionResponse:  @escaping (StundentHWListModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
        
        let urlCmplete = BaseUrl.kBaseURL+url
        print(urlCmplete)
        print(parameters)
        var accessTokken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI5ODk2OTUwODkxIiwiZW1haWwiOiJmb2dneUBnbWFpbC5jbyIsImF6cCI6IjI5NSIsInNpZCI6Im1pbmRAMTIzIiwianRpIjoiNWEwNDBlMzgtZWNkZS00OGMzLWE2YzgtYzc4Njk5MWJkZmM0IiwiZXhwIjoxNTc1NzE0MjQ0LCJpc3MiOiJUZXN0LmNvbSIsImF1ZCI6IlRlc3QuY29tIn0.ewRiy_71XXevggx1qQFsEbE7EVzJm-uy5ru_Tr6kxeI"
        if let str = UserDefaults.standard.value(forKey: UserDefaultKeys.userAuthToken.rawValue)  as?  String
        {
            accessTokken = str
        }
        
        let headers = [KConstants.kHeaderAuthorization:KConstants.kHeaderBearer+" "+accessTokken,KConstants.kAccept: KConstants.kApplicationJson]
        
        
                Alamofire.request(urlCmplete, method: .get, parameters: parameters, encoding: JSONEncoding.default, headers : headers)
            .responseJSON { response in
            CommonFunctions.sharedmanagerCommon.println(object: "response list:- \(response) ")
            if response.result.isSuccess
            {
                guard let data = response.value else{return}
                
                if let responseData  = data as? [String : Any]
                {
                    print("your response data subjec kk1: \(responseData)")
                    self.getStuHomeworkListJSON(data: responseData, completionResponse: { (responseModel) in
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
    
    
    
    private func getStuHomeworkListJSON(data: [String : Any],completionResponse:  @escaping (StundentHWListModel) -> Void,completionError: @escaping (String?) -> Void)  {
        
        let SubjectListData = StundentHWListModel(JSON: data)
        
        if SubjectListData != nil{
            completionResponse(SubjectListData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }
    
    private func getHomeworkListJSON(data: [String : Any],completionResponse:  @escaping (HomeworkListModel) -> Void,completionError: @escaping (String?) -> Void)  {
        
        let SubjectListData = HomeworkListModel(JSON: data)
        
        if SubjectListData != nil{
            completionResponse(SubjectListData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }
    
    private func getSubjectListJSON(data: [String : Any],completionResponse:  @escaping (SubjectListHomeworkModel) -> Void,completionError: @escaping (String?) -> Void)  {
        
        let SubjectListData = SubjectListHomeworkModel(JSON: data)
        
        if SubjectListData != nil{
            completionResponse(SubjectListData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }
    
    func getHoweworkDetailData(url : String,parameters: [String : Any]?,completionResponse:  @escaping (HomeworkListModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (Error?) -> Void){
        
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
                    self.getHomeworkListJSON(data: responseData, completionResponse: { (responseModel) in
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
                                                  multipartFormData.append(url, withName: "audio" )
                                                    }
                                                    else if keyName == "video"  {
                                                        multipartFormData.append(url, withName: "video" )
                                                    }
                                                    
                                                    else {
                                                         multipartFormData.append(url, withName: "image" )
                                                    }
                                                }}
                        }

                    }
                    else
                    {
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
