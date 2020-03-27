//
//  ClassListModel.swift
//  ISMS
//
//  Created by Taranjeet Singh on 6/18/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
import ObjectMapper


class ClassListModel : Mappable{
    
    var message : String?
    var status : Bool?
    var statusCode :  Int?
    var resultData : [GetClassListResultData]?
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

struct GetClassListResultData: Mappable {
    
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
