//
//  DeleteClassModel.swift
//  ISMS
//
//  Created by Taranjeet Singh on 6/19/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
import ObjectMapper

class DeleteClassModel: Mappable{
    
    var message: String?
    var status: Bool?
    var statusCode : Int?
    var resultData : [ResultData]?
    var resourceType: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        message <- map[KApiParameters.KCommonResponsePerameters.kMessage]
        status <- map[KApiParameters.KCommonResponsePerameters.kStatus]
        statusCode <- map[KApiParameters.KCommonResponsePerameters.kStatusCode]
        resultData <- map[KApiParameters.KCommonResponsePerameters.kResultData]
        resourceType <- map[KApiParameters.KCommonResponsePerameters.kResourceType]
    }
    
    
    internal struct ResultData: Mappable {
        
        var id : Int?
        
        init?(map: Map) {
            
        }
        
        mutating func mapping(map: Map) {
            id <- map[KApiParameters.KCommonResponsePerameters.kResultData]
        }
    }
    
}
