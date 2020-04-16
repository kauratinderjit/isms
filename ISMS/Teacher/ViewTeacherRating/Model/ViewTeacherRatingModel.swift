//
//  ViewTeacherRatingModel.swift
//  ISMS
//
//  Created by Poonam Sharma on 14/4/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import Foundation
import ObjectMapper

class ViewTeacherRatingModel : Mappable {
    
    
    var message : String?
    var status : Bool?
    var statusCode :  Int?
    var resultData : [ViewTeacherRatingResult]?
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

struct ViewTeacherRatingResult: Mappable{
    
    var teacherId : Int?
    var teacherName : String?
    
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        teacherId <- map["ID"]
        teacherName <- map["Name"]
    }
}
