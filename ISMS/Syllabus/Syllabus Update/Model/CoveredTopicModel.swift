//
//  CoveredTopicModel.swift
//  ISMS
//
//  Created by Poonam Sharma on 20/4/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//
//CoveredTopicModel
import Foundation
import ObjectMapper

class CoveredTopicModel: Mappable{
    
    var message : String?
    var status : Bool?
    var statusCode :  Int?
    var resultData : [coveredTopicList]?
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

struct coveredTopicList: Mappable {
    var chapterId : Int?
    var topicId : Int?

    
    init() {
        
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        chapterId <- map["ChapterId"]
        topicId <- map["TopicId"]
        
    }
    
}
