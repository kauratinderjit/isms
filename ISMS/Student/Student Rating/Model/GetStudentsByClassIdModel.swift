//
//  GetStudentsByClassIdModel.swift
//  ISMS
//
//  Created by Poonam Sharma on 8/4/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import Foundation
import ObjectMapper

class GetStudentsByClassIdModel: Mappable {
    
    
    var message : String?
    var status : Bool?
    var statusCode :  Int?
    var resultData : [StudentsByClassId]?
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

struct StudentsByClassId: Mappable{
    
    var classId : Int?
    var enrollmentId : Int?
    var studentId : Int?
    var studentName : String?
    
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        classId <- map["ClassId"]
        enrollmentId <- map["EnrollmentId"]
        
        studentId <- map["StudentId"]
        studentName <- map["StudentName"]
    }
}
