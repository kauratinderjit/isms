//
//  GetStudentDetail.swift
//  ISMS
//
//  Created by Poonam Sharma on 6/27/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
import ObjectMapper

class GetStudentDetail: Mappable{
    
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
        
        var classId : Int?
        var className : String?
        var departmentId : Int?
        var departmentName : String?
        var studentId : Int?
        var studentRollNo : Int?
        var studentImageUrl : String?
        var studentFirstName : String?
        var studentLastName : String?
        var studentAddress : String?
        var studentDOB : String?
        var strStudentDOB : String?
        var studentGender : String?
        var studentEmail  : String?
        var studentPhoneNo : String?
        var studentIDProof : String?
        var studentIDProofTitle : String?
        var studentOthers : String?
        var studentUserId : Int?

        var guardianId : Int?
        var guardianUserId : Int?
        var guardianImageUrl : String?
        var guardianFirstName : String?
        var guardianLastName : String?
        var guardianAddress : String?
        var guardianDOB : String?
        var strGuardianDOB : String?
        var guardianGender : String?
        var guardianEmail : String?
        var guardianPhoneNo : String?
        var guardianIDProof : String?
        var guardianIDProofTitle : String?
        var guardianOthers : String?
        var relationId  : Int?
        var relationName : String?
        
        init?(map: Map) {
            
        }
        
        mutating func mapping(map: Map) {
            classId <- map["ClassId"]
            className <- map["ClassName"]
            departmentId <- map["DepartmentId"]
            departmentName <- map["DepartmentName"]
            studentId <- map["StudentId"]
            studentRollNo <- map["StudentRollNo"]
            studentImageUrl <- map["StudentImageUrl"]
            studentFirstName <- map["StudentFirstName"]
            studentLastName <- map["StudentLastName"]
            studentAddress <- map["StudentAddress"]
            studentDOB <- map["StudentDOB"]
            strStudentDOB <- map["StrStudentDOB"]
            studentGender <- map["StudentGender"]
            studentEmail <- map["StudentEmail"]
            studentPhoneNo <- map["StudentPhoneNo"]
            studentIDProof <- map["StudentIDProof"]
            studentIDProofTitle <- map["StudentIDProofTitle"]
            studentOthers <- map["StudentOthers"]
            studentUserId <- map["StudentUserId"]
            
            guardianId <- map["GuardianId"]
            guardianUserId <- map["GuardianUserId"]
            guardianImageUrl <- map["GuardianImageUrl"]
            guardianFirstName <- map["GuardianFirstName"]
            guardianLastName <- map["GuardianLastName"]
            guardianAddress <- map["GuardianAddress"]
            guardianDOB <- map["GuardianDOB"]
            strGuardianDOB <- map["StrGuardianDOB"]
            guardianGender <- map["GuardianGender"]
            guardianEmail <- map["GuardianEmail"]
            guardianPhoneNo <- map["GuardianPhoneNo"]
            guardianIDProof <- map["GuardianIDProof"]
            guardianIDProofTitle <- map["GuardianIDProofTitle"]
            guardianOthers <- map["GuardianOthers"]
            relationId <- map["RelationId"]
            relationName <- map["RelationName"]
        }
    }
}

