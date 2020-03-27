//
//  GetDetailByPhoneEmailModel.swift
//  ISMS
//
//  Created by Poonam Sharma on 7/18/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
import ObjectMapper

class GetDetailByPhoneEmailModel: Mappable{
    
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
        
        var hodId : Int?
        var userId : Int?
        var imageURL : String?
        var firstName : String?
        var lastName : String?
        var address : String?
        var dob : String?
        var gender : String?
        var email : String?
        var phoneNo : String?
        var iDProof :String?
        var iDProofTitle : String?
        
        var departmentId : Int?
        var departmentName : String?
        var qualification :String?
        var workExperience : String?
        var additionalSkills : String?
        var others : String?
        
        init?(map: Map) {
            
        }
        
        mutating func mapping(map: Map) {
            
            hodId <- map["HODId"]
            userId <- map["UserId"]
            imageURL <- map["ImageURL"]
            firstName <- map["FirstName"]
            lastName <- map["LastName"]
            address <- map["Address"]
            dob <- map["DOB"]
            gender <- map["Gender"]
            email <- map["Email"]
            phoneNo <- map["PhoneNo"]
            iDProof <- map["IDProof"]
            iDProofTitle <- map["IDProofTitle"]
            departmentId <- map["DepartmentId"]
            departmentName <- map["DepartmentName"]
            qualification <- map["Qualification"]
            workExperience <- map["WorkExperience"]
            additionalSkills <- map["AdditionalSkills"]
            others <- map["Others"]
            
        }
        
    }
    
}
