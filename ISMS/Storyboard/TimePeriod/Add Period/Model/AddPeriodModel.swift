//
//  AddPeriodModel.swift
//  ISMS
//
//  Created by Poonam Sharma on 7/10/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
import ObjectMapper

class AddPeriodModel: Mappable{
    
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

