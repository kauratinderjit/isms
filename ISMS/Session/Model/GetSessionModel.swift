//
//  GetSessionModel.swift
//  ISMS
//
//  Created by Poonam  on 07/07/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import Foundation
import ObjectMapper

class GetSessionModel: Mappable{
    
    var message : String?
    var status : Bool?
    var statusCode :  Int?
    var resultData : [GetSessionResultData]?
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

struct GetSessionResultData: Mappable {
    
    var id : Int?
    var isActive : Bool?
    var sessionStartDate : String?
    var strSessionStartDate : String?
    
    var sessionEndDate : String?
    var strSessionEndDate : String?
    var sessionName : String?
   
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
     
        id <- map["Id"]
        isActive <- map["IsActive"]
        sessionStartDate <- map["SessionStartDate"]
        strSessionStartDate <- map["strSessionStartDate"]
        
        sessionEndDate <- map["SessionEndDate"]
        strSessionEndDate <- map["strSessionEndDate"]
        sessionName <- map["SessionName"]
    }
}
