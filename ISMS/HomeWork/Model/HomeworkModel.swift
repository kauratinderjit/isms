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
        var Details : String?
        var SubmssionDate : String?
        var ClassId : Int?
        var ClassSubjectId : Int?
        var SubjectId : Int?
        var lstattachmentModels: [lstattachmentModels]?
        

        init?(map: Map) {
            
        }
        
        mutating func mapping(map: Map) {
       
            AssignHomeWorkId <- map["AssignHomeWorkId"]
            ClassName <- map["ClassName"]
            SubjectName <- map["SubjectName"]
            Topic <- map["Topic"]
            Details <- map["Details"]
            SubmssionDate <- map["SubmssionDate"]
            ClassId <- map["ClassId"]
            ClassSubjectId <- map["ClassSubjectId"]
            SubjectId <- map["SubjectId"]
            lstattachmentModels <- map["lstattachmentModels"]
            
        }
        
    }

struct lstattachmentModels: Mappable {
     
     var AssignWorkAttachmentId : Int?
     var AttachmentUrl : String?
     var FileName : String?
     var IFile : URL?
     
     init?(map: Map) {
     }
     
     mutating func mapping(map: Map) {
    
        AssignWorkAttachmentId <- map["AssignWorkAttachmentId"]
        AttachmentUrl <- map["AttachmentUrl"]
        FileName <- map["FileName"]

     }
     
 }
    


struct lststuattachmentModels: Mappable {
    
    var AssignHomeWorkId : Int?
    var AttachmentUrl : String?
    var FileName : String?
    var IFile : URL?
    var Comment : String?
    var StudentHomeworkId : Int?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
   
       AssignHomeWorkId <- map["AssignHomeWorkId"]
       AttachmentUrl <- map["AttachmentUrl"]
      Comment <- map["Comment"]
       FileName <- map["FileName"]
        StudentHomeworkId <- map["StudentHomeworkId"]

    }
    
}
