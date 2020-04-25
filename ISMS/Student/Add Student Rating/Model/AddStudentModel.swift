//
//  AddStudentModel.swift
//  ISMS
//
//  Created by Kuldeep Singh on 11/28/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
import ObjectMapper

class AddStudentRatingListModel : Mappable {
    
    var message : String?
    var status : Bool?
    var statusCode :  Int?
    var resultData : [AddStudentRatingResultData]?
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

struct AddStudentRatingResultData: Mappable{
    
    var studentID : Int?
    var studentName : String?
    var classSubjectId : Int?
    
    var isSelected = 0
    var ratingValue = 0
    
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        studentID <- map["ID"]
        studentName <- map["Name"]
        classSubjectId <- map["ClassSubjectId"]
    }
}
