//
//  GetPeriodList.swift
//  ISMS
//
//  Created by Poonam Sharma on 7/11/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
import ObjectMapper

class GetPeriodListModel: Mappable{
    
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
    
    
    internal struct ResultData: Mappable {
          var periodId : Int?
          var title : String?
          var strStartTime : String?
          var strEndTime : String?
          var startTime : String?
          var endTime : String?
        
        init?(map: Map) {
            
        }
        
        mutating func mapping(map: Map) {
            
             periodId <- map["PeriodId"]
             title <- map["Title"]
            strStartTime <- map["StrStartTime"]
             strEndTime <- map["StrEndTime"]
             startTime <- map["StartTime"]
             endTime <- map["EndTime"]
            
        }
        
    }
    
    
}

