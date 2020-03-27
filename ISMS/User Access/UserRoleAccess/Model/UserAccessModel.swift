//
//  UserAccessModel.swift
//  ISMS
//  Model
//  Created by Poonam Sharma on 6/21/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
import ObjectMapper

class UserAccesstModel : Mappable{
    
    var message : String?
    var status : Int?
    var statusCode :  Int?
    var resultData : ResultData?
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
    
    
     struct ResultData: Mappable {
        
        var userId : Int?
        var moduleIds : Int?
        var pageIds : Int?
        var actionIds : Int?
        var lstModuleAccess : Int?
        var lstPageAccess : [lstPageAccessData]?
        
        init?(map: Map) {
            
        }
        
        mutating func mapping(map: Map) {
            userId <- map[KApiParameters.KUserAccessRoleParameter.kUserId]
            moduleIds <- map[KApiParameters.KUserAccessRoleParameter.kModuleIds]
            pageIds <- map[KApiParameters.KUserAccessRoleParameter.kPageIds]
            actionIds <- map[KApiParameters.KUserAccessRoleParameter.kActionIds]
            lstModuleAccess <- map[KApiParameters.KUserAccessRoleParameter.kLstModuleAccess]
            lstPageAccess <- map[KApiParameters.KUserAccessRoleParameter.kLstPageAccess]
        }
        
    }
    
    
    internal struct lstPageAccessData : Mappable{
        var isSelected = 0
        var pageName : String?
        var displayOrder : String?
        var pageId : Int?
        var moduleId : Int?
        var isAccess = false
        var lstActionAccess : [lstActionAccessData]?
        
        init?(map: Map) {
            
        }
        
        mutating func mapping(map: Map) {
            pageName <- map[KApiParameters.KUserAccessRoleParameter.kPageName]
            displayOrder <- map[KApiParameters.KUserAccessRoleParameter.kDisplayOrder]
            pageId <- map[KApiParameters.KUserAccessRoleParameter.kPageId]
            moduleId <- map[KApiParameters.KUserAccessRoleParameter.kModuleId]
            isAccess <- map[KApiParameters.KUserAccessRoleParameter.kIsAccess]
            lstActionAccess <- map[KApiParameters.KUserAccessRoleParameter.kLstActionAccess]
        }
    }
    
    internal struct lstActionAccessData : Mappable{
        var isSelected = 0
        var actionName : String?
        var tabId : Int?
        var actionId : Int?
        var displayOrder : String?
        var isAccess = false
        
        init?(map: Map) {
            
        }
        
        mutating func mapping(map: Map) {
            actionName <- map[KApiParameters.KUserAccessRoleParameter.kActionName]
            tabId <- map[KApiParameters.KUserAccessRoleParameter.kTabId]
            actionId <- map[KApiParameters.KUserAccessRoleParameter.kActionId]
            displayOrder <- map[KApiParameters.KUserAccessRoleParameter.kDisplayOrder]
            isAccess <- map[KApiParameters.KUserAccessRoleParameter.kIsAccess]
        }
    }
    
}

struct PageIdModel{
    
    var isSelected = 0
    var pageId : Int?
    
    init(isSelected : Int?,pageId : Int?) {
        self.isSelected = isSelected!
        self.pageId = pageId
    }
    
    
}
