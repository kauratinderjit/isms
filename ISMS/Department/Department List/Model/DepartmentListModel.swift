//
//  DepartmentListModel.swift
//  ISMS
//
//  Created by Taranjeet Singh on 6/17/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
import ObjectMapper

class DepartmentListModel : Mappable{
    
    var message : String?
    var status : Bool?
    var statusCode :  Int?
    var resultData : [GetDepartmentListResultData]?
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

struct GetDepartmentListResultData: Mappable {
    
    var departmentId : Int?
    var title : String?
    var logoUrl : String?
    var description : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        departmentId <- map["DepartmentId"]
        title <- map["Title"]
        logoUrl <- map["LogoUrl"]
        description <- map["Ddescription"]
        
    }
    
}
