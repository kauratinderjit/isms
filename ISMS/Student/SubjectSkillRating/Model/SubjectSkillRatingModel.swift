//
//  SubjectSkillRatingModel.swift
//  ISMS
//
//  Created by Kuldeep Singh on 12/5/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation



import ObjectMapper

class SubjectSkillRatingModel : Mappable {
    
    var message : String?
    var status : Bool?
    var statusCode :  Int?
    var resultData : [SubjectSkillRatingResultData]?
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

struct SubjectSkillRatingResultData: Mappable{
    
    var rating : Int?
    var Name : String?
    var isSelected = 0
    var ratingValue = 0
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        rating <- map["Rating"]
        Name <- map["Name"]
    }
}
