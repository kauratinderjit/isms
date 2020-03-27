//
//  VerifyEmailPhoneUserDetail.swift
//  ISMS
//
//  Created by Poonam Sharma on 6/27/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
import ObjectMapper

class VerifyEmailPhoneUserModel: Mappable{
    
    var message : String?
    var status : Bool?
    var statusCode :  Int?
    var resultData : ResultData?
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
    
    
    internal struct ResultData: Mappable {
        var address : String?
        var classId : Int?
        var dob : String?
        var email : String?
        var firstName : String?
        var gender : String?
        var idProof : String?
        var idProofTitle : String?
        var imageUrl : String?
        var lastName : String?
        var phoneNo : String?
        var rollnumberOrAddmissionId : Int?
        var sessionId : Int?
        var strDOB : String?
        var userId : Int?
        var studentId : Int?
        var guardianId : Int?
        var relationId : Int?
        var className : String?
        var departmentId : Int?
        var departmentName : String?
        
        
        
        init?(map: Map) {
            
        }
        
        mutating func mapping(map: Map) {
            address <- map["Address"]
            classId <- map["ClassId"]
            dob <- map["DOB"]
            email <- map["Email"]
            firstName <- map["FirstName"]
            gender <- map["Gender"]
            idProof <- map["IDProof"]
            idProofTitle <- map["IDProofTitle"]
            imageUrl <- map["ImageURL"]
            lastName <- map["LastName"]
            phoneNo <- map["PhoneNo"]
            rollnumberOrAddmissionId <- map["RollNo"]
            sessionId <- map["SessionId"]
            strDOB <- map["StrDOB"]
            userId <- map["UserId"]
            studentId <- map["StudentId"]
            className <- map["ClassName"]
            departmentId <- map["DepartmentId"]
            departmentName <- map["DepartmentName"]
//            guardianId <- map["GuardianId"]
//            relationId <- map["RelationId"]
        }
        
    }
    
}
