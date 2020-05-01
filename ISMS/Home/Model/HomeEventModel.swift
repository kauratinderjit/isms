//
//  EventModel.swift
//  ISMS
//
//  Created by Poonam Sharma on 1/5/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import Foundation
import ObjectMapper

class HomeEventModel : Mappable
{
    
    var message : String?
    var status : Bool?
    var statusCode :  Int?
    var resultData : [EventResultData]?
    var resourceType : String?
    
    
    required init?(map: Map)
    {
        
    }
    
    func mapping(map: Map) {
        message <- map[KApiParameters.KCommonResponsePerameters.kMessage]
        status <- map[KApiParameters.KCommonResponsePerameters.kStatus]
        statusCode <- map[KApiParameters.KCommonResponsePerameters.kStatusCode]
        resultData <- map[KApiParameters.KCommonResponsePerameters.kResultData]
        resourceType <- map[KApiParameters.KCommonResponsePerameters.kResourceType]
    }
    
}

struct EventResultData: Mappable
{
    //HOD
    var eventId : Int?
    var title : String?
    var description : String?
    var startDate : String?
    var strStartDate : String?
    var startTime : String?
    
    var endDate : String?
    var strEndDate : String?
    var strStartTime : String?
    var endTime : String?
    var strEndTime : String?

    
    init?(map: Map)
    {
        
    }
    
    mutating func mapping(map: Map)
    {
        
        eventId <- map["EventId"]
        title <- map["Title"]
        description <- map["Description"]
        startDate <- map["StartDate"]
        strStartDate <- map["strStartDate"]
        endDate <- map["EndDate"]
        strEndDate <- map["strEndDate"]
        startTime <- map["StartTime"]
        strStartTime <- map["StrStartTime"]
        endTime <- map["EndTime"]
        strEndTime <- map["StrEndTime"]
        
    }
    
}

