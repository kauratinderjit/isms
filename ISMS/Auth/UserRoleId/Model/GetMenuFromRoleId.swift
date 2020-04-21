//
//  GetMenuFromRoleId.swift
//  ISMS
//
//  Created by Poonam Sharma on 7/5/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
import ObjectMapper

class GetMenuFromRoleIdModel: Mappable{
    
    var message : String?
    var status : Bool?
    var statusCode :  Int?
    var resultData : [ResultData]?
    var resourceType : String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        message <- map["Message"]
        status <- map["Status"]
        statusCode <- map["StatusCode"]
        resultData <- map["ResultData"]
        resourceType <- map["ResourceType"]
    }
    
    
    struct ResultData: Mappable
    {
        var pageId : Int?
        var pageName : String?
        var lstActionAccess :[LstActionAccess]?
        var pageUrl:String?
        var displayOrder:Int?
        var ImageUrl:String?
        
        init?(map: Map) {
        }
        
        mutating func mapping(map: Map) {
            pageId <- map["PageId"]
            pageName <- map["PageName"]
            lstActionAccess <- map["LstActionAccess"]
            pageUrl <- map["PageUrl"]
            displayOrder <- map["DisplayOrder"]
            ImageUrl <- map["ImageUrl"]
        }
        
    }
    
    struct LstActionAccess:Mappable {
        var actionId : Int?
        var  actionName: String?
        
        init?(map: Map) {
            
        }
        mutating func mapping(map: Map) {
            actionId <- map["ActionId"]
            actionName <- map["ActionName"]
        }
    }
}
