//
//  TeacherListModel.swift
//  ISMS
//
//  Created by Taranjeet Singh on 6/20/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
import ObjectMapper

class TeacherListModel: Mappable{
    
    var message : String?
    var status : Bool?
    var statusCode :  Int?
    var resultData : [GetTeacherListResultData]?
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

struct GetTeacherListResultData: Mappable {
    
    var additionalSkills : String?
    var address : String?
    var dob : String?
    var email : String?
    var gender : String?
    var teacherId : Int?
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
        
        additionalSkills <- map[KApiParameters.KAddTeacherApiParameters.kAdditionalSkills]
        address <- map[KApiParameters.KAddTeacherApiParameters.kAddress]
        dob <- map[KApiParameters.KAddTeacherApiParameters.kDOB]
        email <- map[KApiParameters.KAddTeacherApiParameters.kEmail]
        gender <- map[KApiParameters.KAddTeacherApiParameters.kGender]
        teacherId <- map[KApiParameters.KAddTeacherApiParameters.kTeacherId]
        idProof <- map[KApiParameters.KAddTeacherApiParameters.kIDProof]
        idProofTitle <- map[KApiParameters.KAddTeacherApiParameters.kIDProofTitle]
        imageUrl <- map[KApiParameters.KAddTeacherApiParameters.kImageUrl]
        firstName <- map[KApiParameters.KAddTeacherApiParameters.kFirstName]
        lastName <- map[KApiParameters.KAddTeacherApiParameters.kLastName]
        others <- map[KApiParameters.KAddTeacherApiParameters.kOthers]
        phoneNo <- map[KApiParameters.KAddTeacherApiParameters.kPhoneNo]
        qualification <- map[KApiParameters.KAddTeacherApiParameters.kQualification]
        userId <- map[KApiParameters.KAddTeacherApiParameters.kuserId]
        workExperience <- map[KApiParameters.KAddTeacherApiParameters.kWorkExperience]
        
    }
    
}

