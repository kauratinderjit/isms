//
//  ClassDetailModel.swift
//  ISMS
//
//  Created by Taranjeet Singh on 6/18/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
import ObjectMapper

class ClassDetailModel : Mappable {
        
    var resultData: ResultData?
    var message: String?
    var status: String?
    var statusCode: Int?
    private var resourceType: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        resultData <- map[KApiParameters.KCommonResponsePerameters.kResultData]
        message <- map[KApiParameters.KCommonResponsePerameters.kMessage]
        status <- map[KApiParameters.KCommonResponsePerameters.kStatus]
        statusCode <- map[KApiParameters.KCommonResponsePerameters.kStatusCode]
        resourceType <- map[KApiParameters.KCommonResponsePerameters.kResourceType]
    }
    
    internal struct ResultData :Mappable {
        
        var classId: Int?
        var description: String?
        var others: String?
        var logoUrl: String?
        var name : String?
        var depertmentName : String?
        var departmentId : Int?
        
        
        init?(map: Map) {
            
        }
        
        mutating func mapping(map: Map) {
            classId <- map["ClassId"]
            description <- map["Description"]
            others <- map["Others"]
            logoUrl <- map["LogoUrl"]
            name <- map["Name"]
            depertmentName <- map["DepartmentName"]
            departmentId <- map["DepartmentId"]
        }
    }
}
