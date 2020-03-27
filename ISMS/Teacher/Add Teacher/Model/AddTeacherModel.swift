//
//  AddTeacherModel.swift
//  ISMS
//
//  Created by Taranjeet Singh on 6/20/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
import ObjectMapper

class AddTeacherModel: Mappable{
    
    var teacherId: Int?
    var profileImageUrl: String?
    var firstName: String?
    var lastName: String?
    var address: String?
    var dob: String?//"2019-06-19T04:43:33.561Z",
    var gender: String?
    var email: String?
    var phoneNo: String?
    var idProof: String?
    var departmentId: Int?
    var departmentName: String?
    var qualification: String?
    var workExperience: String?
    var additionalSkills: String?
    var others: String?
    var isHide: Bool?
    var iFileData : [iFile]?
    var roleid : Int?
    var userId : Int?
    var cityId : Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        teacherId <- map["TeacherId"]
        profileImageUrl <- map["ImageUrl"]
        firstName <- map["FirstName"]
        lastName <- map["LastName"]
        address <- map["Address"]
        dob <- map["DOB"]
        gender <- map["Gender"]
        email <- map["Email"]
        phoneNo <- map["PhoneNo"]
        idProof <- map["IDProof"]
        departmentId <- map["DepartmentId"]
        departmentName <- map["DepartmentName"]
        qualification <- map["Qualification"]
        workExperience <- map["WorkExperience"]
        additionalSkills <- map["AdditionalSkills"]
        others <- map["Others"]
        isHide <- map["IsHide"]
        iFileData <- map["IFile"]
        roleid <- map["Roleid"]
        userId <- map["UserId"]
        cityId <- map["CityId"]
        
    }
    
    internal struct iFile : Mappable{
        
        init?(map: Map) {
            
        }
        
        mutating func mapping(map: Map) {
            
        }
        
    }
    
}


