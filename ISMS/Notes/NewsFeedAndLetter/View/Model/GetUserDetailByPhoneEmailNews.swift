//
//  GetUserDetailByPhoneEmail.swift
//  ISMS
//
//  Created by Poonam Sharma on 29/4/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import Foundation
import ObjectMapper

class GetUserDetailByPhoneEmailNews: Mappable{
    
    var message : String?
    var status : Bool?
    var statusCode :  Int?
    var resultData : getUserDetailResultDataNews?
    var resourceType : String?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        message <- map["Message"]
        status <- map["Status"]
        statusCode <- map["StatusCode"]
        resultData <- map["ResultData"]
        resourceType <- map["ResourceType"]
    }
    

}

  
struct getUserDetailResultDataNews: Mappable {
      
      var userId : Int?
      var imageUrl : String?
      var firstName : String?
      var lastName : String?
      var address : String?
      var DOB : String?
      var strDOB : String?
      var gender : String?
      var email : String?
      var phoneNo : String?
       var Bio : String?
       var UserName : String?
      var IsSelected : Bool = false
      
      init?(map: Map) {
          
      }
      
      mutating func mapping(map: Map) {
          userId <- map["UserId"]
          imageUrl <- map["ImageUrl"]
          firstName <- map["FirstName"]
          lastName <- map["LastName"]
          address <- map["Address"]
          DOB <- map["DOB"]
          strDOB <- map["StrDOB"]
          gender <- map["Gender"]
          email <- map["Email"]
          phoneNo <- map["PhoneNo"]
          Bio <- map["Bio"]
          UserName <- map["UserName"]
      }
  }
