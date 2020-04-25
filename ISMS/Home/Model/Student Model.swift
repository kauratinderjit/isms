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

class homeStudentModel : Mappable
{
    
    var message : String?
    var status : Bool?
    var statusCode :  Int?
    var resultData : StudentData?
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

struct StudentData: Mappable
{
    
    //Teacher
    var StudentName: String?
    var StudentId : Int?
    
    var subjectNameLists: [subjectNameLists]?
    var lstEvent: [ListData]?
    
    init?(map: Map)
    {
        
    }
    
    mutating func mapping(map: Map)
    {
        
        
        //teacher
        StudentName <- map["StudentName"]
        StudentId <- map["StudentId"]
        subjectNameLists <- map["subjectNameLists"]
        lstEvent <- map["lstEvent"]
        
    }
    
}



// MARK: - LstclassName
struct subjectNameLists: Mappable
{
    var SubjectId: Int?
    var SubjectName: String?

    init?(map: Map)
    {
        
    }
    mutating func mapping(map: Map)
    {
        SubjectId <- map["SubjectId"]
        SubjectId <- map["SubjectId"]
    }
}


