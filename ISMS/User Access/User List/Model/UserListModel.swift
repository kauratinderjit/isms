//
//  UserListModel.swift
//  ISMS
//
//  Created by Taranjeet Singh on 6/25/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
import ObjectMapper

class GetAllUserByRoleIdModel  : Mappable {
    
    
    var message: String?
    var statusCode: Int?
    var status : Int?
    var resourceType : String?
    var resultData: [GetAllUserByRoleIdResultData]?
    
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

struct GetAllUserByRoleIdResultData : Mappable {
    
    var userId:Int?
    var userName:String?
    var roleId:Int?
    var roleName:String?
    var imageUrl:String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        userId <- map[KApiParameters.KAllUserByRoleIdParameter.kUserId]
        userName <- map[KApiParameters.KAllUserByRoleIdParameter.kUserName]
        roleId <- map[KApiParameters.KAllUserByRoleIdParameter.kRoleId]
        roleName <- map[KApiParameters.KAllUserByRoleIdParameter.kRoleName]
        imageUrl <- map[KApiParameters.KAllUserByRoleIdParameter.kImageUrl]
    }
    
}
