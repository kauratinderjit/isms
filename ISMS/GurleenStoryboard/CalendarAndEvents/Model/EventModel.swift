//
//  SyllabusCoverageModel.swift
//  ISMS
//
//  Created by Kuldeep Singh on 11/15/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

import ObjectMapper

class EventScheduleListModel: Mappable{
    
    var message : String?
    var status : Bool?
    var statusCode :  Int?
    var resultData : [EventScheduleListResultData]?
    var resourceType : String?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        message <- map[KApiParameters.KCommonResponsePerameters.kMessage]
        status <- map[KApiParameters.KCommonResponsePerameters.kStatus]
        statusCode <- map[KApiParameters.KCommonResponsePerameters.kStatusCode]
        resultData <- map[KApiParameters.KCommonResponsePerameters.kResultData]
        resourceType <- map[KApiParameters.KCommonResponsePerameters.kResourceType]
    }
    
}

struct EventScheduleListResultData: Mappable {
    
    var Description : String?
    var EndDate : String?
    var EndTime : String?
    var EventId : Int?
    var StartDate : String?
    var StartTime : String?
    var StrEndTime : String?
    var StrStartTime : String?
    var Title : String?
    var lstEventImages : [ImageArray]?
    var strEndDate : String?
    var strStartDate : String?

    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        Description <- map["Description"]
        EndDate <- map["EndDate"]
        EndTime <- map["EndTime"]
        EventId <- map["EventId"]
        StartDate <- map["StartDate"]
        StartTime <- map["StartTime"]
        StrEndTime <- map["StrEndTime"]
        StrStartTime <- map["StrStartTime"]
        Title <- map["Title"]
        lstEventImages <- map["lstEventImages"]
        strEndDate <- map["strEndDate"]
        strStartDate <- map["strStartDate"]
    }
    
}

struct ImageArray: Mappable {
    
   
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
      
    }
    
}
