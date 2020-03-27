//
//  TeacherSubjectWiseModel.swift
//  ISMS
//
//  Created by Kuldeep Singh on 12/5/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation


import ObjectMapper

class TeacherSubjectWiseRatingModel : Mappable {
    
    var message : String?
    var status : Bool?
    var statusCode :  Int?
    var resultData : [TeacherSubjectWiseRatingResultData]?
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

struct TeacherSubjectWiseRatingResultData: Mappable{
    var ClassSubjectId : Int?
    var rating : String?
    var Name : String?
    var isSelected = 0
    var ratingValue = 0
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
         ClassSubjectId <- map["ClassSubjectId"]
        rating <- map["Rating"]
        Name <- map["SubjectName"]
    }
}
