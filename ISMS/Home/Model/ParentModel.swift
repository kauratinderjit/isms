//
//  ParentModel.swift
//  ISMS
//
//  Created by Poonam Sharma on 30/4/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import Foundation
//ParentModel
//
//  Student Model.swift
//  ISMS
//
//  Created by Mohit Sharma on 4/25/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

//
//  TeacherModel.swift
//  ISMS
//
//  Created by Mohit Sharma on 4/25/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import Foundation
import ObjectMapper

class ParentModel : Mappable
{
    
    var message : String?
    var status : Bool?
    var statusCode :  Int?
    var resultData : ParentResultData?
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

struct ParentResultData: Mappable
{
    
    //Teacher
    var email: String?
    var noOfGaurdStudents : Int?
    
    var parentId: Int?
    var parentImageUrl: String?
    
    var parentName: String?
    var students : [StudentResultData]?
    
    init?(map: Map)
    {
        
    }
    
    mutating func mapping(map: Map)
    {
        
        
        //teacher
        email <- map["Email"]
        noOfGaurdStudents <- map["NoOfGaurdStudents"]
        parentId <- map["ParentId"]
        parentImageUrl <- map["ParentImageUrl"]
        
        parentName <- map["ParentName"]
        students <- map["students"]
        
    }
    
}



// MARK: - LstclassName
struct StudentResultData: Mappable
{
    var classId: Int?
    var className: String?
    var departmentId: Int?
    var departmentName: String?
    var enrollmentId: Int?
    var studentGuardianRelation: String?
     var studentId: Int?
    var studentImageUrl: String?
    var studentName: String?
    
    init?(map: Map)
    {
        
    }
    mutating func mapping(map: Map)
    {
        classId <- map["ClassId"]
        className <- map["ClassName"]
        departmentId <- map["DepartmentId"]
        departmentName <- map["DepartmentName"]
        enrollmentId <- map["EnrollmentId"]
        studentGuardianRelation <- map["StudentGuardianRelation"]
        studentId <- map["StudentId"]
        studentImageUrl <- map["StudentImageUrl"]
        studentName <- map["StudentName"]
    }
}


