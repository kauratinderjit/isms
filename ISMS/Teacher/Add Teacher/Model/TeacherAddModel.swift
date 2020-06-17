//
//  TeacherAddModel.swift
//  ISMS
//
//  Created by Poonam  on 12/06/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import Foundation
import ObjectMapper

class TeacherAddModel: Mappable{
    
    var message: String?
    var status: Bool?
    var statusCode : Int?
    var resultData : Int?
    var resourceType: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        message <- map[KApiParameters.KCommonResponsePerameters.kMessage]
        status <- map[KApiParameters.KCommonResponsePerameters.kStatus]
        statusCode <- map[KApiParameters.KCommonResponsePerameters.kStatusCode]
        resourceType <- map[KApiParameters.KCommonResponsePerameters.kResourceType]
        resultData <- map[KApiParameters.KCommonResponsePerameters.kResultData]
    }
}
