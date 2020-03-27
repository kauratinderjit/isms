//
//  DepartmentDetailModel.swift
//  ISMS
//
//  Created by Taranjeet Singh on 6/18/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
import ObjectMapper

class DepartmentDetailModel : Mappable {
    
    var resultData: ResultData?
    var message: String?
    var status: String?
    var statusCode: Int?
    var resourceType: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        resultData <- map[KApiParameters.KCommonResponsePerameters.kResultData]
        resourceType <- map[KApiParameters.KCommonResponsePerameters.kResourceType]
        message <- map[KApiParameters.KCommonResponsePerameters.kMessage]
        status <- map[KApiParameters.KCommonResponsePerameters.kStatus]
        statusCode <- map[KApiParameters.KCommonResponsePerameters.kStatusCode]
    }
    
    internal struct ResultData :Mappable {
        
        var departmentId: Int?
        var title: String?
        var description: String?
        var others: String?
        var logoUrl: String?
        
        
        init?(map: Map) {
            
        }
        
        mutating func mapping(map: Map) {
            departmentId <- map["DepartmentId"]
            title <- map["Title"]
            description <- map["Description"]
            others <- map["Others"]
            logoUrl <- map["LogoUrl"]
        }
    }
}
