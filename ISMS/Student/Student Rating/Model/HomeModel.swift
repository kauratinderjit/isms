//
//  DepartmentListModel.swift
//  ISMS
//
//  Created by Taranjeet Singh on 6/17/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
import ObjectMapper

class homeModel : Mappable{
    
    var message : String?
    var status : Bool?
    var statusCode :  Int?
    var resultData : homeResultData?
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

struct homeResultData: Mappable {
    
    var HodName : String?
    var DepartmentName : String?
    var NumberofClasses : Int?
    var NumberofTeacher : Int?
    var NumberofStudent : Int?
    var lstEvent : [ListData]?
    var lstStudent : [ListData]?
     var lstTeacher : [ListData]?
     var lstclass : [ListData]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        HodName <- map["HodName"]
        DepartmentName <- map["DepartmentName"]
        NumberofClasses <- map["NumberofClasses"]
        NumberofTeacher <- map["NumberofTeacher"]
        NumberofStudent <- map["NumberofStudent"]
        lstEvent <- map["lstEvent"]
        lstStudent <- map["lstStudent"]
        lstTeacher <- map["lstTeacher"]
        lstclass <- map["lstclass"]
        

    }
    
}

struct ListData: Mappable {
    
    var Name : String?
    var ID : Int?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        Name <- map["Name"]
        ID <- map["ID"]
 
    }
    
}

class homeAdminModel : Mappable{
    
    var message : String?
    var status : Bool?
    var statusCode :  Int?
    var resultData : homeAdminResultData?
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

struct homeAdminResultData: Mappable {
    
    var Address : String?
    var AdminName : String?
    var EmailId : String?
    var NoOfClasses : Int?
    var NoOfHODs : Int?
    var NoOfTeachers : Int?
    var PhoneNo : Int?
    var lstEvent : [ListData]?
    var lstOfClasses : [ListData]?
    var lstOfHODs : [ListData]?
    var lstOfTeachers : [ListData]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        Address <- map["Address"]
        AdminName <- map["AdminName"]
        EmailId <- map["EmailId"]
        NoOfClasses <- map["NoOfClasses"]
        NoOfHODs <- map["NoOfHODs"]
        NoOfTeachers <- map["NoOfTeachers"]
        PhoneNo <- map["PhoneNo"]
        lstEvent <- map["lstEvent"]
        lstOfClasses <- map["lstOfClasses"]
        lstOfHODs <- map["lstOfHODs"]
        lstOfTeachers <- map["lstOfTeachers"]
        

    }
    
}

