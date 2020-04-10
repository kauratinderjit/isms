//
//  SubjectList.swift
//  ISMS
//
//  Created by Poonam Sharma on 7/1/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//hello

import Foundation
import ObjectMapper

class SubjectListModel: Mappable{
    
    var message : String?
    var status : Bool?
    var statusCode :  Int?
    var resultData : [GetSubjectResultData]?
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
struct GetSubjectResultData: Mappable {
    
    var subjectId : Int?
    var subjectName : String?
    
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        subjectId <- map["SubjectId"]
        subjectName <- map["SubjectName"]
        
        
    }
    
}


class SubjectListHomeworkModel: Mappable{
    
    var message : String?
    var status : Bool?
    var statusCode :  Int?
    var resultData : [GetSubjectHWResultData]?
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
struct GetSubjectHWResultData: Mappable {
    
    var ClassSubjectId : Int?
    var Name : String?
     var ID : Int?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        ClassSubjectId <- map["ClassSubjectId"]
          ID <- map["ID"]
        Name <- map["Name"]
    }
    
}
