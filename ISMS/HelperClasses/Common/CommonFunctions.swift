//
//  CommonFunctions.swift
//  LatestArchitechtureDemo
//
//  Created by Atinder Kaur on 5/24/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
import UIKit
import SWRevealViewController

class CommonFunctions: BaseUIViewController
{
    static let sharedmanagerCommon = CommonFunctions()
    static var isAnimating = false
    //For globally print the objects
    func println(object: Any) {
        print(object)
    }
    
    //MARK:-For Convert Date Into String dd/mm/yyyy
    func convertDateIntoStringWithDDMMYYYY(date: Date) -> String{
        let dateFormatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //Date which you need to convert in string
        let dateString = dateFormatter.string(from: date)
        let date = dateFormatter.date(from: dateString)
        //then again set the date format whhich type of output you need
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.locale = Locale.current
        // again convert your date to string
        if date != nil{
            let strDate = dateFormatter.string(from: date!)
            return strDate
        }
        return ""
    }
    
    //MARK:- Convert Server Date Time into local date
    func convertBackendDateFormatToLocalDate(serverSideDate: String) -> String {
        let dateFormatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
        let date: Date? = dateFormatter.date(from: serverSideDate)
        //then again set the date format whhich type of output you need
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.locale = Locale.current
        // again convert your date to string
        if date != nil{
            let strDate = dateFormatter.string(from: date!)
            return strDate
        }
        return ""
        
    }
    
    //MARK:- Using for getting years between two dates
    func getYearsBetweenDates(startDate: Date, endDate: Date) -> Int? {
        
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.year], from: startDate, to: endDate)
        
        if components.year != nil{
            return components.year
        }
        
        return 0
    }
    
    //MARK:- Create string first letter on image
    func addLabelOnTheImgeViewWithFirstCharacter(string:String,imgView: UIImageView)
    {
        let lblNameInitialize = UILabel()
        lblNameInitialize.frame.size = CGSize(width: imgView.frame.width, height: imgView.frame.width)
        lblNameInitialize.textColor = UIColor.white
        lblNameInitialize.font = UIFont(name: lblNameInitialize.font.fontName, size: 26)
        
        lblNameInitialize.text = string.first?.description.uppercased()
        lblNameInitialize.textAlignment = NSTextAlignment.center
        lblNameInitialize.backgroundColor = UIColor.random
        lblNameInitialize.layer.cornerRadius = 30
        
        UIGraphicsBeginImageContext(lblNameInitialize.frame.size)
        lblNameInitialize.layer.render(in: UIGraphicsGetCurrentContext()!)
        imgView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
   
    func setNavigationColorText(navigationController : UINavigationController){
        
        navigationController.navigationBar.barTintColor = KAPPContentRelatedConstants.kThemeColour
        navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
    }
    
    //MARK:- Move to login if user unauthorize
    func setRootLogin(){
        UserDefaultExtensionModel.shared.currentUserAccessToken = ""
        UserDefaultExtensionModel.shared.currentUserId = 0
        UserDefaultExtensionModel.shared.isPresentOnMultiRoleScreen = false
        UserDefaultExtensionModel.shared.appColorName = ""
        UserDefaultExtensionModel.shared.currentUserRoleName = ""
          UserDefaultExtensionModel.shared.currentHODRoleName = ""
        
        let themeColors = ThemeColors.init(values: defaultThemeDict)
        let theme = Theme.init(themeColors: themeColors)
        ThemeManager.applyTheme(theme: theme)
        
        UserDefaults.standard.set(nil, forKey: UserDefaultKeys.userAuthToken.rawValue)
        UserDefaults.standard.set(nil, forKey: UserDefaultKeys.userId.rawValue)
        UserDefaults.standard.set(false, forKey: UserDefaultKeys.isPresentOnMultiRoleScreen.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.userAuthToken.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.userId.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.isPresentOnMultiRoleScreen.rawValue)
        
        UserDefaults.standard.synchronize()
        
        let mainStoryBoard = UIStoryboard(name: KStoryBoards.kMain, bundle: nil)
        let vc = mainStoryBoard.instantiateViewController(withIdentifier: KStoryBoards.KWelcomeIdentifiers.kWelcomeNav)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = vc
    }
    
    //MARK:- Move to Home dashboard
    func setRootHome(){
        let storyboard = UIStoryboard.init(name: KStoryBoards.kHome, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: KStoryBoards.kSWRevealVC)
        appDelegate.window?.rootViewController = vc
    }
    
//    //MARK:- For Connecting textfields
//    func connectFields(fields:[UITextField]) -> Void {
//        guard let last = fields.last else {
//            return
//        }
//        for i in 0 ..< fields.count - 1 {
//            fields[i].returnKeyType = .next
//            fields[i].addTarget(fields[i+1], action: #selector(UIResponder.becomeFirstResponder), for: .editingDidEndOnExit)
//        }
//        last.returnKeyType = .done
//        last.addTarget(last, action: #selector(UIResponder.resignFirstResponder), for: .editingDidEndOnExit)
//    }
    
    
      //For Disable/Enable User Intraction
      func disableEnableUserIntractionOfViews(_ arrViews: [UIView],_ isUserIntractionEnable: Bool){
          _ = arrViews.map({ (view) in
              view.isUserInteractionEnabled = isUserIntractionEnable
          })
      }
      
      //For Set Color in array
      func setColorsForMultipleViews(_ arrViews: [UIView], _ color : UIColor){
          _ = arrViews.map({ (view) in
              view.backgroundColor = color
          })
      }
    
    //For GettingIndex Of Particular Text In UiPicker
    func getIndexOfPickerModelObject(data: Any,pickerTextfieldString: String?) -> Int{
        
        if let arrString = data as? [String]{
            if let index = arrString.index(where: { (string) -> Bool in
                return string == pickerTextfieldString // Will found index of matched id
            }) {
                return index
            }else{
                return 0
            }
        }else if let dropdownModel = data as? GetCommonDropdownModel{
            if let index = dropdownModel.resultData?.index(where: { (dict) -> Bool in
                return dict.name ?? "" == pickerTextfieldString // Will found index of matched id
            }) {
                return index
            }else{
                return 0
            }
        }else{
            debugPrint("Another type is present.")
            return 0
        }
    }
    
}

