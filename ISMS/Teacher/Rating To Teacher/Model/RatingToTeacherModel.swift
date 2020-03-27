//
//  RatingToTeacherModel.swift
//  ISMS
//
//  Created by Kuldeep Singh on 12/2/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation


import ObjectMapper

class TeacherAllListModel : Mappable {
    
    var message : String?
    var status : Bool?
    var statusCode :  Int?
    var resultData : [TeacherResultData]?
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

struct TeacherResultData: Mappable{
    
    var teacherID : Int?
    var teacherFirstName : String?
    
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
       teacherID <- map["TeacherId"]
        teacherFirstName <- map["FirstName"]
    }
}
