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
    var Comment : String?
    var lsTopicAttachmentMapping : [lsTopicAttachmentMapping]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        topicId <- map["TopicId"]
        topicName <- map["TopicName"]
        Comment <- map["Comment"]
        lsTopicAttachmentMapping <- map["lsTopicAttachmentMapping"]
    }
    
}


struct lsTopicAttachmentMapping: Mappable {
    
    var TopicAttachmentId : Int?
    var AttachmentUrl : String?
    var FileName : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        TopicAttachmentId <- map["TopicAttachmentId"]
        AttachmentUrl <- map["AttachmentUrl"]
        FileName <- map["FileName"]
    }
    
}
