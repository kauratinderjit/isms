//
//  TopicModel.swift
//  ISMS
//
//  Created by Kuldeep Singh on 11/25/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation

import ObjectMapper

class TopicListModel: Mappable{
    
    var message : String?
    var status : Bool?
    var statusCode :  Int?
    var resultData : [GetTopicResultData]?
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
struct GetTopicResultData: Mappable {
    
    var topicId : Int?
    var topicName : String?
    
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        topicId <- map["TopicId"]
        topicName <- map["TopicName"]
    }
    
}

