//
//  UserDefaultExtensionModel.swift
//  ISMS
//
//  Created by Taranjeet Singh on 11/15/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation

class UserDefaultExtensionModel : NSObject{
    
    static let shared = UserDefaultExtensionModel()
    
    //MARK:- Current User Access Token
    var currentUserAccessToken : String{
        get {
            let accessToken =  UserDefaults.standard.string(forKey: UserDefaultKeys.userAuthToken.rawValue) ?? ""
            return accessToken
        }
        set{
            UserDefaults.standard.set(newValue, forKey: UserDefaultKeys.userAuthToken.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    //MARK:- Current User Id
    var currentUserId : Int{
        get {
            let userId = UserDefaults.standard.integer(forKey: UserDefaultKeys.userId.rawValue)
            return userId
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultKeys.userId.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    //MARK:- Current User Role Id
    var currentUserRoleId : Int{
        get {
            let userRoleId = UserDefaults.standard.integer(forKey: UserDefaultKeys.userRoleId.rawValue)
            return userRoleId
        }
        set{
            UserDefaults.standard.set(newValue, forKey: UserDefaultKeys.userRoleId.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    //MARK:- User Role Count
    var userRoleCount : Int{
        get {
            let userRoleCount = UserDefaults.standard.integer(forKey: UserDefaultKeys.userRolesCount.rawValue)
            return userRoleCount
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultKeys.userRolesCount.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    //MARK:- Check User is Kill The while logged in and move to multi role screen
    var isPresentOnMultiRoleScreen : Bool{
        get{
            let isPresentOnMultiRoleScreen = UserDefaults.standard.bool(forKey: UserDefaultKeys.isPresentOnMultiRoleScreen.rawValue)
            return isPresentOnMultiRoleScreen
        }
        set{
            UserDefaults.standard.set(newValue, forKey: UserDefaultKeys.isPresentOnMultiRoleScreen.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    var appColorName: String
    {
        get{
            let appColor_Name =  UserDefaults.standard.string(forKey: UserDefaultKeys.appThemeColorName.rawValue) ?? ""
            return appColor_Name
        }
        set{
            UserDefaults.standard.set(newValue, forKey: UserDefaultKeys.appThemeColorName.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    //Mark:- User Role Name When User Select Role
    var currentUserRoleName : String{
        get {
            let userRoleName = UserDefaults.standard.string(forKey: UserDefaultKeys.userRoleName.rawValue) ?? ""
            return userRoleName
        }
        set{
            UserDefaults.standard.set(newValue, forKey: UserDefaultKeys.userRoleName.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    var userName : String{
           get {
               let userName = UserDefaults.standard.string(forKey: UserDefaultKeys.userName.rawValue) ?? ""
               return userName
           }
           set{
               UserDefaults.standard.set(newValue, forKey: UserDefaultKeys.userName.rawValue)
               UserDefaults.standard.synchronize()
           }
       }
    
    var userProfile : String{
        get {
            let userProfile = UserDefaults.standard.string(forKey: UserDefaultKeys.userProfile.rawValue) ?? ""
            return userProfile
        }
        set{
            UserDefaults.standard.set(newValue, forKey: UserDefaultKeys.userProfile.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    //Mark:- HOD Role
    var currentHODRoleName : String{
        get {
            let HODName = UserDefaults.standard.string(forKey: UserDefaultKeys.HODName.rawValue) ?? ""
            return HODName
        }
        set{
            UserDefaults.standard.set(newValue, forKey: UserDefaultKeys.HODName.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    //MARK:- User Role ParticularId
    var userRoleParticularId : Int{
        get {
            let userRoleParticularId = UserDefaults.standard.integer(forKey: UserDefaultKeys.userRoleParticularId.rawValue)
            return userRoleParticularId
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultKeys.userRoleParticularId.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    var HODDepartmentId : Int{
        get {
            let HODDepartmentId = UserDefaults.standard.integer(forKey: UserDefaultKeys.HODDepartmentId.rawValue)
            return HODDepartmentId
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultKeys.HODDepartmentId.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
   
    
    var HODDepartmentName : String{
        get {
            let HODDepartmentName = UserDefaults.standard.string(forKey: UserDefaultKeys.HODDepartmentName.rawValue) ?? ""
            return HODDepartmentName
        }
        set{
            UserDefaults.standard.set(newValue, forKey: UserDefaultKeys.HODDepartmentName.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
}
