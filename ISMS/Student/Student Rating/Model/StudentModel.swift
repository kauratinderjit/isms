//
//  StudentModel.swift
//  ISMS
//
//  Created by Kuldeep Singh on 11/27/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation


import ObjectMapper

class StudentRatingListModel : Mappable {
    
    var message : String?
    var status : Bool?
    var statusCode :  Int?
    var resultData : [StudentRatingResultData]?
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

struct StudentRatingResultData: Mappable{
  
    var studentRating : String?
    var studentName : String?
    var teacherName : String?
    var teacherID : String?
    
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        studentRating <- map["Rating"]
        studentName <- map["StudentName"]
       
        teacherName <- map["TeacherName"]
        teacherID <- map["TeacherId"]
    }
}
