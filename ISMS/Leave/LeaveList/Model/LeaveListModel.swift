//
//  LeaveListModel.swift
//  ISMS
//
//  Created by Poonam  on 08/06/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//
//LeaveListModel
import Foundation
import ObjectMapper

class LeaveListModel: Mappable{
    
    var message : String?
    var status : Bool?
    var statusCode :  Int?
    var resultData : [GetLeaveListResultData]?
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

struct GetLeaveListResultData: Mappable {
    
    var leaveAppId : Int?
    var leaveAppType : String?
    var discription : String?
    var startDate : String?
    
    var endDate : String?
       var attachmentList : [attachmentListData]?
       var status : String?
       var isApproved : Int?
    var strStartDate : String?
       var strEndDate : String?
      var studentName : String?
      
   
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
     
        leaveAppId <- map["LeaveAppId"]
        leaveAppType <- map["LeaveAppType"]
        discription <- map["Discription"]
        startDate <- map["StartDate"]
        
        endDate <- map["EndDate"]
        attachmentList <- map["AttachmentList"]
        status <- map["Status"]
        isApproved <- map["IsApproved"]
        studentName <- map["StudentName"]
        
        strStartDate <- map["StrStartDate"]
        strEndDate <- map["StrEndDate"]
    }
}

struct attachmentListData: Mappable {
    
   
  
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
  
    }
}

