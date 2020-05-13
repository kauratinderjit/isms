//
//  ContactUsModel.swift
//  ISMS
//
//  Created by Poonam Sharma on 12/5/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//
//
import Foundation
import ObjectMapper

class ContactUsModel : Mappable {
    
    
    var message : String?
    var status : Bool?
    var statusCode :  Int?
    var resultData : ContactUsResult?
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

struct ContactUsResult: Mappable{
    
    var contactId : Int?
    var name : String?
    var admissionEmail : String?
    var admissionNumber : String?
    var genernalEmail : String?
    var genernalNumber : String?
    var message : String?
    var latitude : String?
    var longtitude : String?
    var imageUrl : String?
    var strEstablishDate : String?
    var establishDate : String?
    
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        contactId <- map["ContactId"]
        name <- map["Name"]
        admissionEmail <- map["AdmissionEmail"]
        admissionNumber <- map["AdmissionNumber"]
        genernalEmail <- map["GenernalEmail"]
        genernalNumber <- map["GenernalNumber"]
        message <- map["Message"]
        latitude <- map["Latitude"]
        longtitude <- map["Longtitude"]
        imageUrl <- map["ImageUrl"]
        strEstablishDate <- map["strEstablishDate"]
        establishDate <- map["EstablishDate"]
    }
}
