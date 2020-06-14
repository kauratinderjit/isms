//
//  StudentListForAttendenceModel.swift
//  ISMS
//
//  Created by Poonam Sharma on 12/5/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
import ObjectMapper

class StudentListForAttendenceModel: Mappable{
    
    var message : String?
    var status : Bool?
    var statusCode :  Int?
    var resultData : [GetStudentListForAttResultData]?
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

struct GetStudentListForAttResultData: Mappable {
    
    var enrollmentId : Int?
    var studentName : String?
    var status : String?
    var imageUrl : String?
    var isSelected = 0
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
     
        enrollmentId <- map[KApiParameters.kStudentListForAttApiParameter.kEnrollmentId]
        studentName <- map[KApiParameters.kStudentListForAttApiParameter.kStudentName]
        status <- map[KApiParameters.kStudentListForAttApiParameter.kStatus]
        imageUrl <- map[KApiParameters.kStudentListForAttApiParameter.kImageUrl]
    }
}

