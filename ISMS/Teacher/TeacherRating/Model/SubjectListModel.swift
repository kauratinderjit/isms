//
//  SubjectListModel.swift
//  ISMS
//
//  Created by Poonam Sharma on 13/4/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import Foundation
import ObjectMapper

class SubjectListTeacherModel : Mappable {
    
    
    var message : String?
    var status : Bool?
    var statusCode :  Int?
    var resultData : [SubjectListResult]?
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

struct SubjectListResult: Mappable{
    
    var id : Int?
    var classSubjectId : Int?
    var name : String?
    
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        id <- map["ID"]
        name <- map["Name"]
        classSubjectId <- map["ClassSubjectId"]
    }
}


