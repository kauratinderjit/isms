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
        
        var AssignHomeWorkId : Int?
        var ClassName : String?
        var SubjectName : String?
        var Topic : String?
        
        
        init?(map: Map) {
            
        }
        
        mutating func mapping(map: Map) {
       
            AssignHomeWorkId <- map["AssignHomeWorkId"]
            ClassName <- map["ClassName"]
            SubjectName <- map["SubjectName"]
            Topic <- map["Topic"]
        }
        
    }
    



