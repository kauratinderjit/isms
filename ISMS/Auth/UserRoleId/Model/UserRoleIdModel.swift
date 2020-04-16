//
//  UserRoleIdModel.swift
//  ISMS
//
//  Created by Poonam Sharma on 7/4/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
import ObjectMapper

class UserRoleIdModel: Mappable{
    
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
    
    
    internal struct ResultData: Mappable {
        
        var roleId : Int?
        var roleName : String?
        var primaryRole : Int?
        var particularId : Int?
        var departmentId : Int?
        
        init?(map: Map) {
            
        }
        
        mutating func mapping(map: Map) {
            roleId <- map["RoleId"]
            roleName <- map["RoleName"]
            primaryRole <- map["PrimaryRole"]
            particularId <- map["ParticularId"]
            departmentId <- map["DepartmentId"]
        }
        
    }
    
}
