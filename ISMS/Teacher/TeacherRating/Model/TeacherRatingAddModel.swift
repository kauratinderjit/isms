//
//  TeacherRatingAddModel.swift
//  ISMS
//
//  Created by Poonam Sharma on 13/4/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import Foundation
import ObjectMapper

class TeacherRatingAddModel : Mappable {
    
    
    var message : String?
    var status : Bool?
    var statusCode :  Int?
    var resultData : [TeacherRatingList]?
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

struct TeacherRatingList: Mappable{
    
    var studentId : Int?
    var teacherId : Int?
    var teacherName : String?
    var classId : Int?
    
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        studentId <- map["StudentId"]
        teacherId <- map["TeacherId"]
        
        teacherName <- map["TeacherName"]
        classId <- map["classId"]
    }
}

