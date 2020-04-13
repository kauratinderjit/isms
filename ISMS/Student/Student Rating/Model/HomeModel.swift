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

    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        HodName <- map["HodName"]
        DepartmentName <- map["DepartmentName"]
        NumberofClasses <- map["NumberofClasses"]
        NumberofTeacher <- map["NumberofTeacher"]
        NumberofStudent <- map["NumberofStudent"]

    }
    
}

