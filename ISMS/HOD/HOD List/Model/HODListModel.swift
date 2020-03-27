//
//  HODListModel.swift
//  ISMS
//
//  Created by Taranjeet Singh on 6/19/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
import ObjectMapper

class HODListModel: Mappable{
    
    var message : String?
    var status : Bool?
    var statusCode :  Int?
    var resultData : [GetHodListResultData]?
    var resourceType : String?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        message <- map[KApiParameters.KCommonResponsePerameters.kMessage]
        status <- map[KApiParameters.KCommonResponsePerameters.kStatus]
        statusCode <- map[KApiParameters.KCommonResponsePerameters.kStatusCode]
        resultData <- map[KApiParameters.KCommonResponsePerameters.kResultData]
        resourceType <- map[KApiParameters.KCommonResponsePerameters.kResourceType]
    }
    
}

struct GetHodListResultData: Mappable {
    
    var additionalSkills : String?
    var address : String?
    var departmentId : Int?
    var departmentName : String?
    var dob : String?
    var email : String?
    var gender : String?
    var hodId : Int?
    var idProof : String?
    var idProofTitle  : String?
    var imageUrl : String?
    var firstName : String?
    var lastName : String?
    var others : String?
    var phoneNo : Int?
    var qualification : String?
    var userId : Int?
    var workExperience : Int?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        additionalSkills <- map[KApiParameters.KAddHODApiParameters.kAdditionalSkills]
        address <- map[KApiParameters.KAddHODApiParameters.kAddress]
        departmentId <- map[KApiParameters.KAddHODApiParameters.kDepartmentId]
        departmentName <- map[KApiParameters.KAddHODApiParameters.kDepartmentName]
        dob <- map[KApiParameters.KAddHODApiParameters.kDOB]
        email <- map[KApiParameters.KAddHODApiParameters.kEmail]
        gender <- map[KApiParameters.KAddHODApiParameters.kGender]
        hodId <- map[KApiParameters.KAddHODApiParameters.kHODId]
        idProof <- map[KApiParameters.KAddHODApiParameters.kIDProof]
        idProofTitle <- map[KApiParameters.KAddHODApiParameters.kIDProofTitle]
        imageUrl <- map[KApiParameters.KAddHODApiParameters.kImageUrl]
        firstName <- map[KApiParameters.KAddHODApiParameters.kFirstName]
        lastName <- map[KApiParameters.KAddHODApiParameters.kLastName]
        others <- map[KApiParameters.KAddHODApiParameters.kOthers]
        phoneNo <- map[KApiParameters.KAddHODApiParameters.kPhoneNo]
        qualification <- map[KApiParameters.KAddHODApiParameters.kQualification]
        userId <- map[KApiParameters.KAddHODApiParameters.kuserId]
        workExperience <- map[KApiParameters.KAddHODApiParameters.kWorkExperience]
        
    }
    
}
