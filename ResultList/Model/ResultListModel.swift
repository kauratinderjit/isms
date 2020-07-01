//
//  ResultListModel.swift
//  ISMS
//
//  Created by Poonam  on 30/06/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import Foundation
import ObjectMapper

class ResultListModel: Mappable{
    
    var message : String?
    var status : Bool?
    var statusCode :  Int?
    var resultData : [GetListResultData]?
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

struct GetListResultData: Mappable {
    
    var ResultId : Int?
    var SessionId : Int?
    var Title : String?
    var resultAttachmentViewModels : [resultAttachmentViewModels]?
   
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
     
        ResultId <- map["ResultId"]
        SessionId <- map["SessionId"]
        Title <- map["Title"]
        resultAttachmentViewModels <- map["resultAttachmentViewModels"]
        
    }
}
struct resultAttachmentViewModels: Mappable {
    

    var ResultAttachmentId : Int?
    var AttachmentUrl : String?
    var FileName : String?
   
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
     
        ResultAttachmentId <- map["ResultAttachmentId"]
        AttachmentUrl <- map["AttachmentUrl"]
        FileName <- map["FileName"]
    }
}
