//
//  HODModel.swift
//  ISMS
//
//  Created by Poonam  on 20/08/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//



import Foundation
import ObjectMapper


class HODModel : Mappable{
    
    var message : String?
    var status : Bool?
    var statusCode :  Int?
    var resultData : homeHODData?
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

struct homeHODData: Mappable {
    
    var departmentName : String?
    var hodName : String?
    var numberofClasses : Int?
    var numberofStudent : Int?
    var numberofTeacher : Int?
    var totalStudentCountOfMalesAndFemales : Int?
    var image : String?
    var lstEvent : String?
    var lstStudent : String?
    var lstTeacher : String?
    var countOfStudentFemales : Int?
    var countOfStudentMales : Int?
    var lstclass : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        departmentName <- map["DepartmentName"]
        hodName <- map["HodName"]
        numberofClasses <- map["NumberofClasses"]
        numberofStudent <- map["NumberofStudent"]
        numberofTeacher <- map["NumberofTeacher"]
        totalStudentCountOfMalesAndFemales <- map["TotalStudentCountOfMalesAndFemales"]
        image <- map["image"]
        lstEvent <- map["lstEvent"]
        lstStudent <- map["lstStudent"]
        lstTeacher <- map["lstTeacher"]
        countOfStudentFemales <- map["CountOfStudentFemales"]
        countOfStudentMales <- map["CountOfStudentMales"]
         lstclass <- map["lstclass"]
        
    }
    
}





