//
//  Enums.swift
//  OrganicsBazaar
//
//  Created by TaranjeetSingh on 5/6/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation


enum ValidationError: Error {
    case emptyUsername
    case emptyPassword
    case emptyOldPassword
    case wrongOldPassword
    case emptyNewPassword
    case emptyConfirmPassword
    case emptyNewPasswordDoesntMatch
    case invalidEmail
    case emptyFirstName
    case emptyLastName
    case emptyImg
    case emptyEmailAddress
    case emptyMessage
    case emptyOTPAddress
    case emptyParentFirstName
    case emptyParentLastName
    case emptyParentAddress
    case emptyParentDOB
    case emptyParentEmail
    case emptyParentPhoneNo
    case firstNameMinChar
    case lastNameMinChar
    case userNameMinChar
    case passwordMinChar
    case addressMinChar
    case emptyTitle
    case emptyArtistName
    case minTitleLength
    case emptyDescription
    case invalidBookUrl
    case emptyBidAmount
    case emptyBidType
    case emptyLocation
    case emptyNumOfpage
    case emptyGenre
    case emptyName
    case emptyDuration
    case incorrectDuration
    case emptyKeySearchWord
    case emptyTCService
    case emptyPdf
    case emptyImages
    case emptyAudios
    case emptyVideos
    case emptyCardNum
    case emptyCvv
    case emptyExpireDate
    case incorrectCardNum
    case incorrectCvv
    case incorrectExpireDate
    case incorrectExpireMonthAndYear
    case incorrectExpireMonth
    case incorrectExpireYear
    case phoneOrEmailIsEmpty
    case emptyAmount
    case passwordSufficientComplexity
    case confirmPasswordNotMatchWithPassword
    case emptyPhoneNumber
    case minCharactersPhoneNumber
    case emptyAddress
    case emptyDateOfBith
    case emptyGender
    case emptyAssignDepartment
    case emptyIdProof
    case emptyOthers
    case emptyStudentClass
    case emptyRollNoAdmissionId
    case emptyFatherName
    case emptyMotherName
    case emptyAllocatedBus
    case emptyDesignation
    case emptyQualification
    case emptyWorkExperience
    case emptyAdditionalSkills
    case emptyAllocatedClassesAndSubjects
    case emptyRelation
    case passwordlengthshouldbe8to16long
    case emptyIDProofName
    case emptyIdProofImage
    case emptyDepartmentID
    case emptyAssignHOD
    case emptyClassId
    case emptySubjectName
    case emptySubjectDescription
    case emptyParentprofId
    
}

enum CountryStateCity : Int{
    case country = 1
    case state = 2
    case city = 3
    case teacher = 12
    case department = 5
    case hod = 7
    case classSubjects = 10
    case subject = 11
    case classes = 6
}



enum NetworkingError: Error {
    case nullData
}

enum UserDefaultKeys : String{
    case userAuthToken = "userAuthToken"
    case userId = "userId"
    case userRoleName = "userRoleName"
    case userRolesCount = "userRolesCount"
    case userRoleId = "userRoleId"
    case isPresentOnMultiRoleScreen = "isPresentOnMultiRoleScreen"
    case appThemeColorName = "appThemeColorName"
    case currentTheme = "currentTheme"
    case userRoleParticularId = "particularId"
    case HODDepartmentId = "DepartmentId"
    case HODName = "HOD"
    case userName = "userName"
    case userProfile = "userProfile"
    case firebaseVID = "firebaseVID"
    case forgotUserId = "forgotUserId"
    case StudentClassId = "ClassId"
    case HODDepartmentName = "DepartmentName"
    case UserName = "UserName"
    case enrollmentIdStudent = "EnrollmentId"
    case classNameStudent = "ClassName"
    case ImageUrl = "ImageUrl"
}
