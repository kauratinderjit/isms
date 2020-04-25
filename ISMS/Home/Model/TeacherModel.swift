//
//  TeacherModel.swift
//  ISMS
//
//  Created by Mohit Sharma on 4/25/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import Foundation
import ObjectMapper

class homeTeacherModel : Mappable
{
    
    var message : String?
    var status : Bool?
    var statusCode :  Int?
    var resultData : teacherData?
    var resourceType : String?
    
    
    required init?(map: Map)
    {
        
    }
    
    func mapping(map: Map)
    {
        message <- map[KApiParameters.KCommonResponsePerameters.kMessage]
        status <- map[KApiParameters.KCommonResponsePerameters.kStatus]
        statusCode <- map[KApiParameters.KCommonResponsePerameters.kStatusCode]
        resultData <- map[KApiParameters.KCommonResponsePerameters.kResultData]
        resourceType <- map[KApiParameters.KCommonResponsePerameters.kResourceType]
    }
    
}

struct teacherData: Mappable
{
    
    //Teacher
    var TeacherName: String?
    var NoOfClasses, NoOfStudents, NoOfSubjects: Int?
    
    var lstclassName: [LstclassNameDec]?
    var lstStudentName: [LstStudentNameDec]?
    var lstSubjectName: [LstSubjectNameDec]?
    
    
    
    init?(map: Map)
    {
        
    }
    
    mutating func mapping(map: Map)
    {
        
        
        //teacher
        TeacherName <- map["TeacherName"]
        lstclassName <- map["lstclassName"]
        lstStudentName <- map["lstStudentName"]
        lstSubjectName <- map["lstSubjectName"]
        
        NoOfClasses <- map["NoOfClasses"]
        NoOfStudents <- map["NoOfStudents"]
        NoOfSubjects <- map["NoOfSubjects"]
        
        
    }
    
}

// MARK: - LstStudentName
struct LstStudentNameDec: Mappable
{
    var studentID: Int?
    var studentName: String?
       
       init?(map: Map)
       {
           
       }
       
       mutating func mapping(map: Map)
       {
           studentID <- map["StudentId"]
           studentName <- map["StudentName"]
       }
}
//
// MARK: - LstSubjectName
struct LstSubjectNameDec: Mappable
{
    var subjectID: Int?
    var subjectName: String?
    
    init?(map: Map)
    {
        
    }
    mutating func mapping(map: Map)
    {
        subjectID <- map["SubjectId"]
        subjectName <- map["SubjectName"]
    }
}

// MARK: - LstclassName
struct LstclassNameDec: Mappable
{
    var classID: Int?
    var className: String?

    init?(map: Map)
    {
        
    }
    mutating func mapping(map: Map)
    {
        classID <- map["ClassId"]
        className <- map["ClassName"]
    }
}




