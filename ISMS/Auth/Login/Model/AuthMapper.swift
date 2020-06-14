//
//  AuthMapper.swift
//  LatestArchitechtureDemo
//
//  Created by Atinder Kaur on 5/23/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
import ObjectMapper


class LoginData: Mappable {
    
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
    
    struct ResultData : Mappable{
        
        var userId : Int?
        var token : String?
        
        
        init?(map: Map) {
            
        }
        
        mutating func mapping(map: Map) {
            userId <- map["UserId"]
            token <- map["Token"]
        }
        
        
        
        
        
    }
    
    
    //User Address
    struct UserData : Mappable {
        
        var About : String?
        var AccessToken: Int?
        var AddById: String?
        var Address: Int?
        var BirthDate: String?
        var BusId : String?
        var BusinessId: String?
        var CircleStatus: String?
        var City : String?
        var CountryId: String?
        var CountryName: String?
        var DEVICE_ID: Int?
        var DEVICE_TOKEN: String?
        var DEVICE_TYPE: String?
        var Date : String?
        var Designation : String?
        var DistrictId : String?
        var DistrictName : String?
        var Email: String?
        var FName : String?
        var Gender : String?
        var IsRegister  : Int?
        var LName : String?
        
        //var custom_attributes: [CustomAttributes]?
        
        var LocationReq : Int?
        var MName : String?
        var Message : String?
        var Phone : String?
        var Photo : String?
        var PinCode  : String?
        var PrivacyAccess  : String?
        var ProfileImg : String?
        var RegistrationNumber  : String?
        var ResponseCode : Int?
        var ShowPhoneNumberForAll : Int?
        var StateId : Int?
        var StateName : String?
        var Status : Int?
        var StrBirthDate : String?
        var Street  : String?
        var UserId: Int?
        var UserPassword  : String?
        
        init?(map: Map) {
        }
       
        
        mutating func mapping(map: Map) {
            About <- map["About"]
            AccessToken <- map["AccessToken"]
            AddById <- map["AddById"]
            Address <- map["Address"]
            BirthDate <- map["BirthDate"]
            BusId <- map["BusId"]
            BusinessId <- map["BusinessId"]
            CircleStatus <- map["CircleStatus"]
            City <- map["City"]
            CountryId <- map["CountryId"]
            CountryName <- map["CountryName"]
            DEVICE_ID <- map["DEVICE_ID"]
            DEVICE_TOKEN <- map["DEVICE_TOKEN"]
            DEVICE_TYPE <- map["DEVICE_TYPE"]
            Date <- map["Date"]
            Designation <- map["Designation"]
            DistrictId <- map["DistrictId"]
            DistrictName <- map["DistrictName"]
            Email <- map["Email"]
            FName <- map["FName"]
            Gender <- map["Gender"]
            IsRegister <- map["IsRegister"]
            LName <- map["LName"]
            
             LocationReq <- map["LocationReq"]
             MName <- map["MName"]
             Message <- map["Message"]
             Phone <- map["Phone"]
             Photo <- map["Photo"]
             PinCode  <- map["PinCode"]
             PrivacyAccess <- map["PrivacyAccess"]
             ProfileImg <- map["ProfileImg"]
             RegistrationNumber  <- map["RegistrationNumber"]
             ResponseCode <- map["ResponseCode"]
             ShowPhoneNumberForAll <- map["ShowPhoneNumberForAll"]
             StateId <- map["StateId"]
             StateName <- map["StateName"]
             Status <- map["Status"]
             StrBirthDate <- map["StrBirthDate"]
             Street <- map["Street"]
             UserId <- map["UserId"]
             UserPassword <- map["UserPassword"]
        }
    }
}
