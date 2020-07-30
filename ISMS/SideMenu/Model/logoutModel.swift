//
//  logoutModel.swift
//  ISMS
//
//  Created by Poonam  on 27/07/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import Foundation
import ObjectMapper

class logoutModel: Mappable{

  var message : String?
  var status : Bool?
  var statusCode :  Int?
  var resultData : [ResultData]?
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
