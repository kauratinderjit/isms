//
//  SubstituteModel.swift
//  ISMS
//
//  Created by Poonam  on 01/07/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import Foundation
import ObjectMapper
class SubstituteModel: Mappable{
    
    var message : String?
    var status : Bool?
    var statusCode :  Int?
    var resultData : [GetSubstituteTeacherData]?
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

struct GetSubstituteTeacherData: Mappable {
    
    var teacherId : Int?
    var teacherName : String?
   
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        teacherId <- map["TeacherId"]
        teacherName <- map["TeacherName"]
        
    }
    
}

