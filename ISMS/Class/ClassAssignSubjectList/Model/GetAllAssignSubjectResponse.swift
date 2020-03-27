//
//  GetAllAssignSubjectResponse.swift
//  ISMS
//
//  Created by Taranjeet Singh on 7/5/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
import ObjectMapper

class GetAllAssignSubjectResponse: Mappable {
    
    var message : String?
    var status : Int?
    var statusCode :  Int?
    var resultData : [GetAllAssignSubjectResultData]?
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

struct GetAllAssignSubjectResultData: Mappable{
    var isSelected = 0
    var subjectId : Int?
    var subjectName : String?
    var classSubjectId : Int?
    
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        subjectId <- map["SubjectId"]
        subjectName <- map["SubjectName"]
        classSubjectId <- map["ClassSubjectId"]
        
        if let classSubId = classSubjectId{
            if classSubId > 0{
                isSelected = 1
            }else{
                isSelected = 0
            }
        }else{
            isSelected = 0
        }
    }
}
