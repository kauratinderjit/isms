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
    var lstAdmissionInquiryViewModels : [lstAdmissionInquiryViewModels]?
    var lstGeneralInquiryViewModels : [lstGeneralInquiryViewModels]?
    var lstEmergencyInquiryViewModels : [lstEmergencyInquiryViewModels]?
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
        lstAdmissionInquiryViewModels <- map["lstAdmissionInquiryViewModels"]
        lstGeneralInquiryViewModels <- map["lstGeneralInquiryViewModels"]
        lstEmergencyInquiryViewModels <- map["lstEmergencyInquiryViewModels"]
        message <- map["Message"]
        latitude <- map["Latitude"]
        longtitude <- map["Longtitude"]
        imageUrl <- map["ImageUrl"]
        strEstablishDate <- map["strEstablishDate"]
        establishDate <- map["EstablishDate"]
    }
}
struct lstAdmissionInquiryViewModels: Mappable{
    
    var AdmissionEmail : String?
    var AdmissionInquiryId : Int?
    var AdmissionNumber : String?
    
    
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        AdmissionEmail <- map["AdmissionEmail"]
        AdmissionInquiryId <- map["AdmissionInquiryId"]
        AdmissionNumber <- map["AdmissionNumber"]
    }
}
struct lstEmergencyInquiryViewModels: Mappable{
    
    var EmergencyEmail : String?
    var EmergencyInquiryId : Int?
    var EmergencyNumber : String?
    
    
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        EmergencyEmail <- map["EmergencyEmail"]
        EmergencyInquiryId <- map["EmergencyInquiryId"]
        EmergencyNumber <- map["EmergencyNumber"]
    }
}

struct lstGeneralInquiryViewModels: Mappable{
    
    var GenernalEmail : String?
    var GeneralInquiryId : Int?
    var GenernalNumber : String?
    
    
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        GenernalEmail <- map["GenernalEmail"]
        GeneralInquiryId <- map["GeneralInquiryId"]
        GenernalNumber <- map["GenernalNumber"]
    }
}

