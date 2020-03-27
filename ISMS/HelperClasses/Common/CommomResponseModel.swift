//
//  CommomResponseModel.swift
//  ISMS
//
//  Created by Taranjeet Singh on 6/20/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
import ObjectMapper

class CommonSuccessResponseModel: Mappable{
    
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
        resourceType <- map[KApiParameters.KCommonResponsePerameters.kResourceType]
        resultData <- map[KApiParameters.KCommonResponsePerameters.kResultData]
    }
    
    
    struct ResultData: Mappable {
        
        var id : Int?
        
        init?(map: Map) {
            
        }
        
        mutating func mapping(map: Map) {
            id <- map[KApiParameters.KCommonResponsePerameters.kResultData]
        }
    }
}
