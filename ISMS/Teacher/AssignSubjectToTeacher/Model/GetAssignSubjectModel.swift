//
//  GetAssignSubjectModel.swift
//  ISMS
//
//  Created by Poonam  on 12/06/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import Foundation
import ObjectMapper

class GetAssignSubjectModel: Mappable{
    
    var message : String?
    var status : Bool?
    var statusCode :  Int?
    var resultData : [GetAssignSubjectListResultData]?
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

struct GetAssignSubjectListResultData: Mappable{
    
    var classId : Int?
    var teacherId : Int?
    var subjectsLists : [subjectsLists]?
    
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        classId <- map["ClassId"]
        teacherId <- map["TeacherId"]
        subjectsLists <- map["subjectsLists"]
    }
}
struct subjectsLists: Mappable{
    
    var classSubjectId : Int?
    var subjectName : String?
    var occurrence : Int?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        classSubjectId <- map["ClassSubjectId"]
        subjectName <- map["SubjectName"]
        occurrence <- map["Occurrence"]
    }
}
