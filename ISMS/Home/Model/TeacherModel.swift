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
    var dashBoardTeacherViewModel: [dashBoardTeacherViewModel]?
    var departmentList : [departmentList]?
    
    init?(map: Map)
    {
        
    }
    
    mutating func mapping(map: Map)
    {
        dashBoardTeacherViewModel <- map["DashBoardTeacherViewModel"]
        departmentList <- map["DepartmentList"]
        
    }
    
}

// MARK: - LstStudentName
struct dashBoardTeacherViewModel: Mappable
{
    var teacherId: Int?
    var teacherImage: String?
    var teacherName: String?
  
       
       init?(map: Map)
       {
           
       }
       
       mutating func mapping(map: Map)
       {
           teacherId <- map["TeacherId"]
           teacherImage <- map["TeacherImage"]
         teacherName <- map["TeacherName"]
       }
}
//
// MARK: - LstSubjectName
struct departmentList: Mappable
{
    var departmentId: Int?
    var departmentName: String?
    var deptImage: String?
    var noOfClasses: Int?
    var noOfStudents: Int?
    var noOfSubjects: Int?
    
    init?(map: Map)
    {
        
    }
    mutating func mapping(map: Map)
    {
        departmentId <- map["DepartmentId"]
        departmentName <- map["DepartmentName"]
        deptImage <- map["DeptImage"]
        noOfClasses <- map["NoOfClasses"]
        noOfStudents <- map["NoOfStudents"]
        noOfSubjects <- map["NoOfSubjects"]
    }
}





