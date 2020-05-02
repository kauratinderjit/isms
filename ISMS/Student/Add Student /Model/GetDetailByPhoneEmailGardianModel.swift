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
        var guardianImageUrl : String?
        
        
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
            
            guardianId <- map["UserId"]
            guardianUserId <- map["UserId"]
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
            
            
            GuardianFirstName <- map["FirstName"]
            GuardianLastName <- map["FirstName"]
            GuardianEmail <- map["Email"]
            GuardianPhoneNo <- map["PhoneNo"]
            GuardianIDProofTitle <- map["GuardianIDProofTitle"]
            GuardianAddress <- map["Address"]
            GuardianOthers <- map["GuardianOthers"]
            GuardianDOB <- map["DOB"]
            GuardianGender <- map["Gender"]
            guardianIDProof <- map["guardianIDProof"]
            guardianImageUrl <- map["ImageUrl"]
            
            
        }
        
    }
    
}
