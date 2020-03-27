//
//  AddUpdateTimeTableResponseModel.swift
//  ISMS
//
//  Created by Taranjeet Singh on 11/28/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
import ObjectMapper

class AddUpdateTimeTableResponseModel:Mappable{
    
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
    
    internal struct ResultData : Mappable{
        
        var className : String?
        var endTime : String?
        var id : Int?
        var reason : String?
        var startTime : String?
        var strDay : String?
        var subject : String?
        var teacher : String?
        
        
        init?(map: Map) {
            
        }
        
        mutating func mapping(map: Map) {
            className <- map["ClassName"]
            endTime <- map["EndTime"]
            id <- map["Id"]
            reason <- map["Reason"]
            startTime <- map["StartTime"]
            strDay <- map["StrDay"]
            subject <- map["Subject"]
            teacher <- map["Teacher"]
        }
    }
}
