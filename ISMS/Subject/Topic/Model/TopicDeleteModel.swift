//
//  TopicDeleteModel.swift
//  ISMS
//
//  Created by Kuldeep Singh on 11/25/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation

import ObjectMapper


class DeleteTopicModel: Mappable{
    
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
