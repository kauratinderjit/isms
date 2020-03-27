//
//  SignUpResponseModel.swift
//  ISMS
//
//  Created by Taranjeet Singh on 6/27/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
import ObjectMapper

class SignUpResponseModel : Mappable{
    var message : String?
    var resourceType : String?
    var status : Int?
    var statusCode : Int?
    var resultData : Int?
    
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
