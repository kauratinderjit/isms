//
//  SearchModel.swift
//  SeasiaNoticeBoard
//
//  Created by Atinder Kaur on 6/8/20.
//  Copyright © 2020 Poonam Sharma. All rights reserved.
//

import Foundation
import ObjectMapper


class GetSearchResultModel : Mappable{
        
        var message : String?
        var status : Bool?
        var statusCode :  Int?
        var resultData : [getUserDetailResultDataNews]?
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



