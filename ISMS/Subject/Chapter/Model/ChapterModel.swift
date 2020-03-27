//
//  ChapterModel.swift
//  ISMS
//
//  Created by Gurleen Osahan on 11/18/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
import ObjectMapper

class ChapterListModel: Mappable{
    
    var message : String?
    var status : Bool?
    var statusCode :  Int?
    var resultData : [ChaptersData]?
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
struct ChaptersData: Mappable {
    
    var ChapterId : Int?
    var ChapterName : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        ChapterId <- map[ChapterVC.ChapterModelParam.kChatperId]
        ChapterName <- map[ChapterVC.ChapterModelParam.kChapterName]
    }
}
