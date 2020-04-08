//
//  HomeworkModel.swift
//  ISMS
//
//  Created by Atinder Kaur on 4/7/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//


import ObjectMapper


class HomeworkListModel : Mappable{
        
        var message : String?
        var status : Bool?
        var statusCode :  Int?
        var resultData : [HomeworkResultData]?
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
    
    struct HomeworkResultData: Mappable {
        
        var isSelected = 0
        var subjectPercentage : String?
        var SubjectName : String?
        var chapter : String?
        var collapsed: Bool?

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
    



