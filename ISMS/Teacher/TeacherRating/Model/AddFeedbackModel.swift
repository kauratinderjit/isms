//
//  AddFeedbackModel.swift
//  ISMS
//
//  Created by Poonam Sharma on 13/4/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import Foundation
import ObjectMapper

class AddFeedbackModel: Mappable{
    
    var message: String?
    var status: Bool?
    var statusCode : Int?
    var resultData : Int?
    var resourceType: String?
    
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

