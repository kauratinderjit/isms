//
//  SyllabusCoverageModel.swift
//  ISMS
//
//  Created by Kuldeep Singh on 11/15/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

import ObjectMapper

class SyllabusCoverageListModel: Mappable{
    
    var message : String?
    var status : Bool?
    var statusCode :  Int?
    var resultData : [SyllabusCoverageListResultData]?
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

struct SyllabusCoverageListResultData: Mappable {
    
  
    var ClassSubjectId : Int?
    var coveragePercentage : String?
    var subjectName : String?
    
  
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        ClassSubjectId <- map[KApiParameters.kSyllabusCoverageApiParameter.kClassSubjectId]
coveragePercentage <- map[KApiParameters.kSyllabusCoverageApiParameter.kCoveragePercentage]
      subjectName <- map[KApiParameters.kSyllabusCoverageApiParameter.kSubjectName]
    }
    
}

