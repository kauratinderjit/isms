//
//  GetStudentAttendanceModel.swift
//  ISMS
//
//  Created by Poonam Sharma on 17/4/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//
//GetStudentAttendanceModel
import Foundation
import ObjectMapper

class GetStudentAttendanceModel : Mappable {
    
    var message : String?
    var status : Bool?
    var statusCode :  Int?
    var resultData : [GetStudentAttendanceResultData]?
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

struct GetStudentAttendanceResultData: Mappable{
    
    var attendanceDate : String?
    var attendanceStatus : String?

    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        attendanceDate <- map["AttendanceDate"]
        attendanceStatus <- map["AttendanceStatus"]
    }
}
