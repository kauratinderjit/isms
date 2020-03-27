//
//  TeacherDetailModel.swift
//  ISMS
//
//  Created by Taranjeet Singh on 6/20/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
import ObjectMapper

class TeacherDetailModel : Mappable {
    var message : String?
    var status : Bool?
    var statusCode : Int?
    var resourceType : String?
    var resultData : ResultData?
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        message <- map[KApiParameters.KCommonResponsePerameters.kMessage]
        status <- map[KApiParameters.KCommonResponsePerameters.kStatus]
        statusCode <- map[KApiParameters.KCommonResponsePerameters.kStatusCode]
        resourceType <- map[KApiParameters.KCommonResponsePerameters.kResourceType]
        resultData <- map[KApiParameters.KCommonResponsePerameters.kResultData]
    }
    internal struct ResultData : Mappable{
        var teacherId : Int?
        var imageUrl : String?
        var firstName : String?
        var lastName : String?
        var address : String?
        var dob : String?
        var gender : String?
        var email : String?
        var phoneNo: String?
        var idProof : String?
        var departmentListModel : [DepartmentListModel]?
        var qualification: String?
        var workExperience : String?
        var additionalSkills : String?
        var others : String?
        var userId:Int?
        var idProofTitle : String?
        var hodId : Int?
        var hodName : String?
        init?(map: Map) {
        }
        mutating func mapping(map: Map) {
            teacherId <- map[KApiParameters.KAddTeacherApiParameters.kTeacherId]
            imageUrl <- map[KApiParameters.KAddTeacherApiParameters.kImageUrl]
            firstName <- map[KApiParameters.KAddTeacherApiParameters.kFirstName]
            lastName <- map[KApiParameters.KAddTeacherApiParameters.kLastName]
            address <- map[KApiParameters.KAddTeacherApiParameters.kAddress]
            dob <- map[KApiParameters.KAddTeacherApiParameters.kDOB]
            gender <- map[KApiParameters.KAddTeacherApiParameters.kGender]
            email <- map[KApiParameters.KAddTeacherApiParameters.kEmail]
            phoneNo <- map[KApiParameters.KAddTeacherApiParameters.kPhoneNo]
            idProof <- map[KApiParameters.KAddTeacherApiParameters.kIDProof]
            idProofTitle <- map[KApiParameters.KAddTeacherApiParameters.kIDProofTitle]
            qualification <- map[KApiParameters.KAddTeacherApiParameters.kQualification]
            workExperience <- map[KApiParameters.KAddTeacherApiParameters.kWorkExperience]
            departmentListModel <- map[KApiParameters.KAddTeacherApiParameters.kDepartmentListModels]
            additionalSkills <- map[KApiParameters.KAddTeacherApiParameters.kAdditionalSkills]
            others <- map[KApiParameters.KAddTeacherApiParameters.kOthers]
            userId <- map["UserId"]
            hodId <- map[KApiParameters.KAddTeacherApiParameters.kHODId]
            hodName <- map[KApiParameters.KAddTeacherApiParameters.kHODName]
        }
    }
    internal struct DepartmentListModel: Mappable{
        var departmentId: Int?
        var departmentName : String?
                init?(map: Map) {
        }
        mutating func mapping(map: Map) {
            departmentId <- map[KApiParameters.KAddTeacherApiParameters.kDepartmentId]
            departmentName <- map[KApiParameters.KAddTeacherApiParameters.kDepartmentName]
        }
    }
}
