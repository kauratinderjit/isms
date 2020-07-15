//
//  StudentSessionModel.swift
//  ISMS
//
//  Created by Poonam  on 15/07/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import Foundation
import ObjectMapper

class StudentSessionModel: Mappable{
    
    var message : String?
    var status : Bool?
    var statusCode :  Int?
    var resultData : GetStudentSessionResultData?
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

struct GetStudentSessionResultData: Mappable {
    
    var activeSessionId : Int?
    var activeSession : String?
    var currentSessionId : Int?
    var currentSession : String?
    var classId : Int?
    var className : String?
    var studentDetail: [studentDetail]?
    
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        activeSessionId <- map["ActiveSessionId"]
        activeSession <- map["ActiveSession"]
        currentSessionId <- map["CurrentSessionId"]
        currentSession <- map["CurrentSession"]
        classId <- map["ClassId"]
        className <- map["ClassName"]
        studentDetail <- map["StudentDetail"]
    }
    
}
struct studentDetail: Mappable {
    
    var studentId : Int?
    var studentName : String?
    var imageUrl : String?
   
    
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        studentId <- map["StudentId"]
        studentName <- map["StudentName"]
        imageUrl <- map["ImageUrl"]
        
    }
    
}
