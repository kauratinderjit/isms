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
        
        var StudentAttacmentUrl : String?
        var Comment : String?
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
        var studentName : String?
        var StuAttachmentModels : [stuAttachmentViewModels]?
        

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
            Comment <- map["Comment"]
            StudentAttacmentUrl <- map["StudentAttacmentUrl"]
            studentName <- map["studentName"]
            StuAttachmentModels <- map["StuAttachmentModels"]
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
    //atinder
    var AssignHomeWorkId : Int?
    var Comment : String?
    var StudentHomeworkId : Int?
    var stuAttachmentViewModels : [stuAttachmentViewModels]?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
   
       AssignHomeWorkId <- map["AssignHomeWorkId"]
        Comment <- map["Comment"]
        StudentHomeworkId <- map["StudentHomeworkId"]
        stuAttachmentViewModels <- map["stuAttachmentViewModels"]

    }
    
}
struct stuAttachmentViewModels: Mappable {
    //atinder
    var AttachmentUrl : String?
    var FileName : String?
    var StudentAttachmentId : Int?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
   
       AttachmentUrl <- map["AttachmentUrl"]
       FileName <- map["FileName"]
        StudentAttachmentId <- map["StudentAttachmentId"]

    }
    
}
