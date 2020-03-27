//
//  AppDelegateExtension.swift
//  OrganicsBazaar
//
//  Created by Taranjeet Singh on 5/9/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
import UIKit
import SWRevealViewController

var appDelegate: AppDelegate {
    guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
        fatalError("AppDelegate is not UIApplication.shared.delegate")
    }
    return delegate
}


extension AppDelegate{
   //Check User Is Already Logged in or not
    func checkUserAlreadyLoggedIn(){
        
        //Check UserId is saved in userdefault or not
        if UserDefaults.standard.value(forKey: UserDefaultKeys.userId.rawValue) != nil{
            debugPrint("User already logged in")
            //Check User is present on multirole screen or not
            if UserDefaults.standard.value(forKey: UserDefaultKeys.isPresentOnMultiRoleScreen.rawValue) as? Bool == true{
                let storyboard = UIStoryboard.init(name: KStoryBoards.kMain, bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "UserRoleIDNavigationVC")
                appDelegate.window?.rootViewController = vc
            }else{
                let storyboard = UIStoryboard.init(name: KStoryBoards.kHome, bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: KStoryBoards.kSWRevealVC)
                appDelegate.window?.rootViewController = vc
            }
        }else{
            
        }
        
    }
    
    //MARK:- Customize Navigation Controller
    func customizeThemeColors(){
        
        if let themeValues = ThemeColors.getCurrentThemeColorsFromDefaults() {
            let theme = Theme(themeColors: themeValues)
            ThemeManager.shared.currentTheme = theme
            ThemeManager.applyTheme(theme: theme)
        } else {
            setTheme()
        }
    }
    
    func setTheme(){
//            let colors = ["mainColor": "A90222",
//                          "textFieldBackgroundColor": "FFFFFF",
//                "uiButtonBackgroundColor": "A90222",
//                "uiBarButtonBackgroundColor" : "FFFFFF",
//                "uiButtonTintColor" : "FFFFF",
//                "uiButtonTextColor" : "FFFFFF",
//                "textFieldTextColor" : "000000",
//                "labelTextColor" : "000000",
//                "navigationTitleColor" : "FFFFFF",
//                "labelBackgroundColor" : "A90222",
//                "tableCellColor" : "A90222",
//                "subheader1Color": "FF0000",
//                "navigationTitleColor": "FFFFFF",
//                "titleColor": "FFFFFF",
//                "tabBarBackgroundColor": "000000"
//            ]
        
            let themeColors = ThemeColors(values: defaultThemeDict)
            let theme = Theme(themeColors: themeColors)
            ThemeManager.applyTheme(theme: theme)
    }
    
}

