//
//  GetAllCountryModel.swift
//  ISMS
//
//  Created by Navalpreet Kaur on 6/3/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit
import ObjectMapper

class GetCommonDropdownModel: Mappable{

    var message: String?
    var status: Int?
    var statusCode : Int?
    var resultData : [ResultData]?
    var resourceType : String?
    
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        message <- map[KApiParameters.KCommonResponsePerameters.kMessage]
        status <- map[KApiParameters.KCommonResponsePerameters.kStatus]
        statusCode <- map[KApiParameters.KCommonResponsePerameters.kStatusCode]
        resultData <- map[KApiParameters.KCommonResponsePerameters.kResultData]
    }
    //Get Result
    struct ResultData : Mappable{
        var id : Int?
        var name : String?
        init?(map: Map) {
            
        }
        mutating func mapping(map: Map) {
            id <- map["ID"]
            name <- map["Name"]
        }
    }
}



