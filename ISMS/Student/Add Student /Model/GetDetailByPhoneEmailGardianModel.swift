//
//  GetDetailByPhoneEmailGardianModel.swift
//  ISMS
//
//  Created by Poonam Sharma on 7/18/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation

import ObjectMapper

class GetDetailByPhoneEmailGardianModel: Mappable{
    
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
        
        var guardianId : Int?
        var guardianUserId: Int?
        var userId : Int?
        var imageURL : String?
        var firstName : String?
        var lastName : String?
        var address : String?
        var strDOB : String?
        var gender : String?
        var email : String?
        var phoneNo : String?
        var iDProof :String?
        var iDProofTitle : String?
        var studentID : Int?
        var relationId : Int?
      //  var guardianDOB : String?
        var relationName : String?
        
        
        //Gurdian
        var GuardianFirstName : String?
        var GuardianLastName : String?
        var GuardianEmail : String?
        var GuardianPhoneNo : String?
        var GuardianIDProofTitle : String?
        var GuardianAddress : String?
        var GuardianOthers : String?
        var GuardianDOB : String?
        var GuardianGender : String?
        var guardianIDProof: String?
        
        
        
        init?(map: Map) {
            
        }
        
        mutating func mapping(map: Map) {
            
            guardianId <- map["GuardianId"]
            guardianUserId <- map["guardianUserId"]
            userId <- map["UserId"]
            imageURL <- map["ImageURL"]
            firstName <- map["FirstName"]
            lastName <- map["LastName"]
            address <- map["Address"]
            strDOB <- map["StrDOB"]
            gender <- map["Gender"]
            email <- map["Email"]
            phoneNo <- map["PhoneNo"]
            iDProof <- map["IDProof"]
            iDProofTitle <- map["IDProofTitle"]
            studentID <- map["StudentID"]
            relationId <- map["RelationId"]
          //  guardianDOB <- map["DOB"]
            relationName <- map["RelationName"]
            
            
            GuardianFirstName <- map["GuardianFirstName"]
            GuardianLastName <- map["GuardianLastName"]
            GuardianEmail <- map["GuardianEmail"]
            GuardianPhoneNo <- map["GuardianPhoneNo"]
            GuardianIDProofTitle <- map["GuardianIDProofTitle"]
            GuardianAddress <- map["GuardianAddress"]
            GuardianOthers <- map["GuardianOthers"]
            GuardianDOB <- map["GuardianDOB"]
            GuardianGender <- map["GuardianGender"]
            guardianIDProof <- map["guardianIDProof"]
            
        }
        
    }
    
}
