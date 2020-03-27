//
//  GetDropDownDataModel.swift
//  ISMS
//
//  Created by Poonam Sharma on 7/16/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

class GetDropDownModel: Mappable{
    
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
    
    //Get Country Result
    
    
}
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
