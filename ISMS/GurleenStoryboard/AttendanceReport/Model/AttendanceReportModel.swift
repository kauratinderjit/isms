//
//  AttendanceReportModel.swift
//  ISMS
//
//  Created by Navalpreet Kaur on 12/6/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
import ObjectMapper

class AttendanceReportModel: Mappable
{
    
    var message : String?
    var status : Bool?
    var statusCode :  Int?
    var resultData : [AttendanceReportResultData]?
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

struct AttendanceReportResultData: Mappable {
    
    var months : String?
    var attendance : Double?
  
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        months <- map["Months"]
        attendance <- map["Attendance"]
    }
    
}
