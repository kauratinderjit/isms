//
//  GetTimeTableModel.swift
//  ISMS
//
//  Created by Taranjeet Singh on 12/2/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
import ObjectMapper

class GetTimeTableModel : Mappable{
    
    var message : String?
    var status : Bool?
    var statusCode :  Int?
    var resultData : ResultData?
    var resourceType : String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        message <- map["Message"]
        status <- map["Status"]
        statusCode <- map["StatusCode"]
        resultData <- map["ResultData"]
        resourceType <- map["ResourceType"]
    }
    
    
    internal struct ResultData : Mappable{
        
        var dayModel : [DaysModel]?
        
        init?(map: Map) {
        }
        
        mutating func mapping(map: Map) {
            dayModel <- map["Days"]
        }
        
        
    }
    
    internal struct DaysModel : Mappable{
        
        var dayId : Int?
        var dayName : String?
        var periodDetailListModel : [PeriodDetailModel]?
        
        init?(map: Map) {
        }
        
        mutating func mapping(map: Map) {
            dayId <- map["DayId"]
            dayName <- map["DayName"]
            periodDetailListModel <- map["PeriodDetails"]
        }
        
    }
    
    internal struct PeriodDetailModel : Mappable{
        
        var timeTableId : Int?
        var teacherName : String?
        var subjectName : String?
        var teacherId : Int?
        var subjectId : Int?
        var className : String?
        var startTime : String?
        var endTime : String?
        var periodName : String?
        var periodId : Int?
        var strTime : String?
         var isTeacher:Bool?
        var substituteTeacherName : String?
        var substituteTeacherId : Int?
        
        init?(map: Map) {
        }
        
        mutating func mapping(map: Map) {
            timeTableId <- map["TimeTableId"]
            teacherName <- map["TeacherName"]
            subjectName <- map["SubjectName"]
            className <- map["ClassName"]
            startTime <- map["StartTime"]
            endTime <- map["EndTime"]
            periodName <- map["PeriodName"]
            periodId <- map["PeriodId"]
            strTime <- map["StrTime"]
            teacherId <- map["TeacherId"]
            subjectId  <- map["ClassSubjectId"]
            isTeacher <- map["IsTeacher"]
            substituteTeacherName  <- map["SubstituteTeacherName"]
            substituteTeacherId <- map["SubstituteTeacherId"]
        }
        
    }
    
}

