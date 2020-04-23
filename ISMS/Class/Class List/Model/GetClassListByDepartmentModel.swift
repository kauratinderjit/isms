//
//  GetClassListByDepartmentModel.swift
//  ISMS
//
//  Created by Poonam Sharma on 22/4/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//
//GetClassListByDepartmentModel
import Foundation
import ObjectMapper


class GetClassListByDepartmentModel : Mappable{
    
    var message : String?
    var status : Bool?
    var statusCode :  Int?
    var resultData : [GetClassListByDeptResultData]?
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

struct GetClassListByDeptResultData: Mappable {
    
    var classId : Int?
    var logoUrl : String?
    var name : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        classId <- map["ClassId"]
        logoUrl <- map["LogoUrl"]
        name <- map["Name"]
    }
    
}
