//
//  SchoolModel.swift
//  ISMS
//  Model
//  Created by Gurleen Osahan on 6/17/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
import ObjectMapper

class SchoolData: Mappable {
    
    var statusCode : Int?
    var status : Bool?
    var message : String?
    var resultData: ResultData?
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
    

    //User Address
    struct ResultData : Mappable {
        
        
        var address : String?
        var attachmentId: Int?
        var boardName: String?
        var boardId: Int?
        var email: String?
        var establishDate : String?
        var iFile: Array<Any>?
        var inquiry: String?
        var instititeId : Int?
        var instituteAttachmentList: [ListAttachment]?
        var latitude: String?
        var logo: String?
        var longtitude: String?
        var name: String?
        var phoneNo : String?
        var establishType:Int?
        var thumbLogo : String?
        var typeId : Int?
        var typeName : String?
        var websiteLink: String?
       
      
        init?(map: Map) {
        }

        mutating func mapping(map: Map) {
             address <- map["Address"]
             attachmentId <- map["AttachmentId"]
             boardId <- map["BoardId"]
             boardName <- map["BoardName"]
             email <- map["Email"]
             establishDate <- map["EstablishDate"]
             iFile <- map["IFile"]
             instititeId <- map["InstititeId"]
             instituteAttachmentList <- map["InstituteAttachmentList"]
             latitude <- map["Latitude"]
             logo <- map["Logo"]
             longtitude <- map["Longtitude"]
             name <- map["Name"]
             phoneNo <- map["PhoneNo"]
             thumbLogo <- map["ThumbLogo"]
             typeId <- map["TypeId"]
             typeName <- map["TypeName"]
             websiteLink <- map["WebsiteLink"]
            inquiry <- map["Inquiry"]
            establishType <- map["EstablishType"]
        }
        
    }
    
    struct ListAttachment : Mappable{
        
        var createdBy : String?
        var createdDate : String?
        var instititeId : Int?
        var institute : String?
        var instituteAttachmentId : Int?
        var instituteAttachmentName : String?
        var instituteFileName : String?
        var isActive : Int?
        var isDeleted :Int?
        var modifiedBy :String?
        var modifiedDate :String?
        var type :String?
        init?(map: Map) {
            
        }
        
        mutating func mapping(map: Map) {
            createdBy <- map["CreatedBy"]
            createdDate <- map["CreatedDate"]
            instititeId <- map["InstititeId"]
            institute <- map["Institute"]
            instituteAttachmentId <- map["InstituteAttachmentId"]
            instituteAttachmentName <- map["InstituteAttachmentName"]
            instituteFileName <- map["InstituteFileName"]
            isActive <- map["IsActive"]
            isDeleted <- map["IsDeleted"]
            modifiedBy <- map["ModifiedBy"]
            modifiedDate <- map["ModifiedDate"]
            type <- map["Type"]
        }
    }
}












