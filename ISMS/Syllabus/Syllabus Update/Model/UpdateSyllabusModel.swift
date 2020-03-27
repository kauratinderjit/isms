//
//  UpdateSyllabusModel.swift
//  ISMS
//
//  Created by Kuldeep Singh on 11/18/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

import ObjectMapper


class UpdateSyllabusModel : Mappable{
        
        var message : String?
        var status : Bool?
        var statusCode :  Int?
        var resultData : [UpdateSyllabusResultData]?
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
    
    struct UpdateSyllabusResultData: Mappable {
        
        var isSelected = 0
        var subjectPercentage : String?
        var SubjectName : String?
        var chapter : String?
        
        var chapterID : Int?
        var chapterName : String?
        
        
        
        init?(map: Map) {
            
        }
        
        mutating func mapping(map: Map) {
       
            chapter <- map[KApiParameters.kUpdateSyllabusApiParameter.kChapter]
            SubjectName <- map[KApiParameters.kUpdateSyllabusApiParameter.kSubjectName]
            chapterID <- map[KApiParameters.kUpdateSyllabusApiParameter.kChapterId]
            
            chapterName <- map[KApiParameters.kUpdateSyllabusApiParameter.kChapterName]
        }
        
    }
    



