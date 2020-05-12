//
//  ContactUsAPI.swift
//  ISMS
//
//  Created by Poonam Sharma on 12/5/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//
//ContactUsAPI

import Foundation
import Alamofire

class ContactUsAPI{
      public static let sharedInstance = ContactUsAPI()
    
    func GetContactUs(url : String,parameters: [String : Any]?,completionResponse:  @escaping (ContactUsModel) -> Void,completionnilResponse:  @escaping (String?) -> Void,complitionError: @escaping (String?) -> Void){
           
           let urlCmplete = BaseUrl.kBaseURL+url
          
           
           print("your complete address of api :\(urlCmplete)")
           var accessTokken =   ""
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
                       self.ContactUsJSON(data: responseData, completionResponse: { (response) in
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
       
       private func ContactUsJSON(data: [String : Any],completionResponse:  @escaping (ContactUsModel) -> Void,completionError: @escaping (String?) -> Void)  {
           
           let ContactUsData = ContactUsModel(JSON: data)
           
           if ContactUsData != nil{
               completionResponse(ContactUsData!)
           }else{
               completionError(Alerts.kMapperModelError)
           }
       }
}
