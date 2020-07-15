//
//  SubjectListHomeWork.swift
//  ISMS
//
//  Created by Atinder Kaur on 4/21/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//


import ObjectMapper


class SubjectListHomeWorkModel : Mappable{
        
        var message : String?
        var status : Bool?
        var statusCode :  Int?
        var resultData : [HomeworkResultHWData]?
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
    
    struct HomeworkResultHWData: Mappable {
        
        var ClassName : String?
        var SubjectName : String?
        var SubjectId : Int?
        var lstASTopic: [lstASTopic]?
        

        init?(map: Map) {
            
        }
        
        mutating func mapping(map: Map) {
       
            ClassName <- map["ClassName"]
            SubjectName <- map["SubjectName"]
            SubjectId <- map["subjectId"]
            lstASTopic <- map["lstASTopic"]
            
        }
        
    }

struct lstASTopic: Mappable {
    
    var AssignHomeWorkId : Int?
    var Topic : String?
    var SubmssionDate : String?
    
    

    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
   
        AssignHomeWorkId <- map["AssignHomeWorkId"]
        Topic <- map["Topic"]
        SubmssionDate <- map["SubmssionDate"]
       
        
    }
    
}
