//
//  AssignSubjectTeacherModel.swift
//  ISMS
//
//  Created by Gagan on 09/06/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import Foundation
import ObjectMapper

class AssignSubjectTeacherModel: Mappable{
    
    var message : String?
    var status : Bool?
    var statusCode :  Int?
    var resultData : [GetSubjectListResultData]?
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

struct GetSubjectListResultData: Mappable{
    
    var subjectID : Int?
    var subjectName : String?
    var classSubjectId : Int?
    
    var isSelected = 0
    var ratingValue = 0
    
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        subjectID <- map["ID"]
        subjectName <- map["Name"]
        classSubjectId <- map["ClassSubjectId"]
    }
}

