//
//  StudentListModel.swift
//  ISMS
//
//  Created by Poonam Sharma on 6/27/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
import ObjectMapper

class StudentListModel: Mappable{
    
    var message : String?
    var status : Bool?
    var statusCode :  Int?
    var resultData : [GetStudentResultData]?
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

struct GetStudentResultData: Mappable {
    
    var studentFirstName : String?
    var studentLastName : String?
    var studentUserId : Int?
    var studentImageURL : String?
    var classId : Int?
    var className : String?
    var enrollmentId: Int?
    
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        studentFirstName <- map["StudentFirstName"]
        studentLastName <- map["StudentLastName"]
        studentUserId <- map["StudentUserId"]
        studentImageURL <- map["StudentImageURL"]
        classId <- map["ClassId"]
        className <- map["ClassName"]
        enrollmentId <- map["EnrollmentId"]
    }
    
}
