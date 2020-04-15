//
//  GetStudentTeacherRatingModel.swift
//  ISMS
//
//  Created by Poonam Sharma on 14/4/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import Foundation
import ObjectMapper

class GetStudentTeacherRatingModel : Mappable {
    
    
    var message : String?
    var status : Bool?
    var statusCode :  Int?
    var resultData : [GetViewTeacherRatingResult]?
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

struct GetViewTeacherRatingResult: Mappable{
    
    var teacherId : Int?
    var teacherName : String?
    var studentId : Int?
    var studentName : String?
    var className : String?
    var subjectName : String?
    var date : String?
    var imageUrl : String?
    var comment : String?
    
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        teacherId <- map["TeacherId"]
        teacherName <- map["TeacherName"]
        studentId <- map["StudentId"]
        studentName <- map["StudentName"]
        className <- map["ClassName"]
        subjectName <- map["SubjectName"]
        date <- map["Date"]
        imageUrl <- map["ImageUrl"]
        comment <- map["Comment"]
    }
}
