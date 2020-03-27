//
//  ColorManagement.swift
//  ISMS
//
//  Created by Taranjeet Singh on 11/15/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    func colorFromHexString (_ hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
//enum Theme: Int {
//
//    case HodTheme, StudentTheme, TeacherTheme, AdminTheme
//
//    var mainColor: UIColor {
//        switch self {
//        case .HodTheme:
//            return UIColor().colorFromHexString("#2F452D")
//        case .StudentTheme:
//            return UIColor().colorFromHexString("#919C93")
//        case .TeacherTheme:
//            return UIColor().colorFromHexString("#2DFE9A")
//        case .AdminTheme:
//            return UIColor().colorFromHexString("#B71724")
//        }
//    }
//
//    //Customizing the Navigation Bar
//    var barStyle: UIBarStyle {
//        switch self {
//        case .HodTheme:
//            return .blackTranslucent
//        case .StudentTheme:
//            return .blackTranslucent
//        case .TeacherTheme:
//            return .blackTranslucent
//        case .AdminTheme:
//            return .blackTranslucent
//        }
//    }
//
////    var navigationBackgroundImage: UIImage? {
////        return self == .theme1 ? UIImage(named: "navBackground") : nil
////    }
////
////    var tabBarBackgroundImage: UIImage? {
////        return self == .theme1 ? UIImage(named: "tabBarBackground") : nil
////    }
//
//    var backgroundColor: UIColor {
//        switch self {
//        case .HodTheme:
//            return UIColor().colorFromHexString("#2F452D")
//        case .StudentTheme:
//            return UIColor().colorFromHexString("#919C93")
//        case .TeacherTheme:
//            return UIColor().colorFromHexString("#2DFE9A")
//        case .AdminTheme:
//            return UIColor().colorFromHexString("#B71724")
//        }
//    }
//
////    var secondaryColor: UIColor {
////        switch self {
////        case .theme1:
////            return UIColor().colorFromHexString("ffffff")
////        case .theme2:
////            return UIColor().colorFromHexString("000000")
////        }
////    }
//
//    var titleTextColor: UIColor {
//        switch self {
//        case .HodTheme:
//            return UIColor().colorFromHexString("FEFEFE")
//        case .TeacherTheme:
//            return UIColor().colorFromHexString("FEFEFE")
//        case .AdminTheme:
//            return UIColor().colorFromHexString("FEFEFE")
//        case .StudentTheme:
//            return UIColor().colorFromHexString("FEFEFE")
//        }
//    }
//
//    var subtitleTextColor: UIColor {
//        switch self {
//        case .HodTheme:
//            return UIColor().colorFromHexString("FEFEFE")
//        case .TeacherTheme:
//            return UIColor().colorFromHexString("FEFEFE")
//        case .AdminTheme:
//            return UIColor().colorFromHexString("FEFEFE")
//        case .StudentTheme:
//            return UIColor().colorFromHexString("FEFEFE")
//        }
//    }
//}
//
//// Enum declaration
//let SelectedThemeKey = "SelectedTheme"
//
//// This will let you use a theme in the app.
//class ThemeManager {
//
//    // ThemeManager
//    static func currentTheme() -> Theme {
//        if let storedTheme = (UserDefaults.standard.value(forKey: SelectedThemeKey) as AnyObject).integerValue {
//            return Theme(rawValue: storedTheme)!
//        } else {
//            return .AdminTheme
//        }
//    }
//
//    static func applyTheme(theme: Theme) {
//        // First persist the selected theme using NSUserDefaults.
//        UserDefaults.standard.setValue(theme.rawValue, forKey: SelectedThemeKey)
//        UserDefaults.standard.synchronize()
//
//        // You get your current (selected) theme and apply the main color to the tintColor property of your application’s window.
//        let sharedApplication = UIApplication.shared
//        sharedApplication.delegate?.window??.tintColor = theme.mainColor
//
////        UINavigationBar.appearance().barTintColor = KAPPContentRelatedConstants.kThemeColour
//        UINavigationBar.appearance().tintColor = UIColor.white
//        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//        UINavigationBar.appearance().isTranslucent = false
//        UINavigationBar.appearance().barStyle = theme.barStyle
//
//
//        UIButton.appearance().tintColor = .black
//        UIButton.appearance().backgroundColor = .blue
//
//
////
////        let controlBackground = UIImage(named: "controlBackground")?.withRenderingMode(.alwaysTemplate)
////            .resizableImage(withCapInsets: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))
////        let controlSelectedBackground = UIImage(named: "controlSelectedBackground")?
////            .withRenderingMode(.alwaysTemplate)
////            .resizableImage(withCapInsets: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))
////
////        UISegmentedControl.appearance().setBackgroundImage(controlBackground, for: .normal, barMetrics: .default)
////        UISegmentedControl.appearance().setBackgroundImage(controlSelectedBackground, for: .selected, barMetrics: .default)
////
////        UIStepper.appearance().setBackgroundImage(controlBackground, for: .normal)
////        UIStepper.appearance().setBackgroundImage(controlBackground, for: .disabled)
////        UIStepper.appearance().setBackgroundImage(controlBackground, for: .highlighted)
////        UIStepper.appearance().setDecrementImage(UIImage(named: "fewerPaws"), for: .normal)
////        UIStepper.appearance().setIncrementImage(UIImage(named: "morePaws"), for: .normal)
////
////        UISlider.appearance().setThumbImage(UIImage(named: "sliderThumb"), for: .normal)
////        UISlider.appearance().setMaximumTrackImage(UIImage(named: "maximumTrack")?
////            .resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0.0, bottom: 0, right: 6.0)), for: .normal)
////        UISlider.appearance().setMinimumTrackImage(UIImage(named: "minimumTrack")?
////            .withRenderingMode(.alwaysTemplate)
////            .resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 6.0, bottom: 0, right: 0)), for: .normal)
////
////        UISwitch.appearance().onTintColor = theme.mainColor.withAlphaComponent(0.3)
////        UISwitch.appearance().thumbTintColor = theme.mainColor
//    }
//}





/*
/// Enum Theme Manager
enum Theme: Int {
    case Dark, Graphical
    /// Main Color
    var mainColor: UIColor {
        switch self {
        case .Graphical:
            return UIColor(red: 242.0/255.0, green: 101.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        case .Dark:
            return UIColor(red:0.13, green:0.13, blue:0.17, alpha:1.0)
        }
    }
    
    /// Customizing the Navigation Bar
    var barStyle: UIBarStyle {
        switch self {
        case .Graphical:
            return .default
        case .Dark:
            return .black
        }
    }
    
    /// BackgroundColor properties
    var backgroundColor: UIColor {
        return UIColor(red:0.13, green:0.13, blue:0.17, alpha:1.0)
    }
    
    /// MainLabelColor properties
    var mainLabelColor: UIColor {
        return UIColor(red:0.58, green:0.78, blue:0.44, alpha:1.0)
    }
    
    /// CommentColor properties
    var commentColor: UIColor {
        return UIColor(red:0.61, green:0.64, blue:0.69, alpha:1.0)
    }
    
    /// BlueColor properties
    var blueColor: UIColor {
        return UIColor(red:0.27, green:0.44, blue:0.85, alpha:1.0)
    }
    
    /// OrangeColor properties
    var orangeColor: UIColor {
        return  UIColor(red:0.82, green:0.56, blue:0.36, alpha:1.0)
    }
    
    /// FuchsiaColor
    var fuchsiaColor: UIColor {
        return  UIColor(red:0.72, green:0.22, blue:0.60, alpha:1.0)
    }
}

/// Enum declaration
let SelectedThemeKey = "SelectedTheme"

/// This will let you use a theme in the app.
struct ThemeManager {
    
    /// currentTheme: static function store current theme.
    /// Returns: Theme
    /// Parameters: None
    static func currentTheme() -> Theme {
        if let storedTheme = (UserDefaults.standard.value(forKey: SelectedThemeKey) as AnyObject).integerValue {
            return Theme(rawValue: storedTheme)!
        } else {
            return .Graphical
        }
    }
    
    /// applyTheme: static function applyTheme.
    /// Returns: None
    /// Parameters: theme
    static func applyTheme(theme: Theme) {
        // First persist the selected theme using NSUserDefaults.
        UserDefaults.standard.setValue(theme.rawValue, forKey: SelectedThemeKey)
        UserDefaults.standard.synchronize()
        
        // You get your current (selected) theme and apply the main color to the tintColor property of your application’s window.
        let sharedApplication = UIApplication.shared
        sharedApplication.delegate?.window??.tintColor = theme.mainColor
        
        UINavigationBar.appearance().barTintColor = theme.backgroundColor
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : theme.blueColor]
        
    }
}*/



class ColorManagement
{
    
    static var selectedRoleTheme = UserDefaultExtensionModel.shared.currentUserRoleName
    
    class func labelColor() -> UIColor
    {
        selectedRoleTheme = UserDefaultExtensionModel.shared.appColorName
        
        if (selectedRoleTheme == ThemeMode.HodTheme.rawValue)
        {
            return UIColor(red: 77.0/255.0, green: 59.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        }
        if (selectedRoleTheme == "Student")
        {
            return UIColor(red: 80.0/255.0, green: 70.0/255.0, blue: 140.0/255.0, alpha: 1.0)
        }
        if (selectedRoleTheme == "Teacher")
        {
            return UIColor(red: 120.0/255.0, green: 65.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        }
        
        return UIColor.black
        
    }
    
    class func labelBackgroundColor() -> UIColor
    {
        selectedRoleTheme = UserDefaultExtensionModel.shared.appColorName
        
        if (selectedRoleTheme == "black")
        {
            return UIColor(red: 120.0/255.0, green: 59.0/255.0, blue: 58.0/255.0, alpha: 1.0)
        }
        if (selectedRoleTheme == "red")
        {
            return UIColor(red: 44.0/255.0, green: 180.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        }
        if (selectedRoleTheme == "green")
        {
            return UIColor(red: 20.0/255.0, green: 155.0/255.0, blue: 50.0/255.0, alpha: 1.0)
        }
        
        return UIColor.black
    }
    
    class func buttonColor() -> UIColor
    {
        selectedRoleTheme = UserDefaultExtensionModel.shared.appColorName
        
        if (selectedRoleTheme == "black")
        {
            return UIColor(red: 85.0/255.0, green: 110.0/255.0, blue: 144.0/255.0, alpha: 1.0)
        }
        if (selectedRoleTheme == "red")
        {
            return UIColor(red: 80.0/255.0, green: 70.0/255.0, blue: 140.0/255.0, alpha: 1.0)
        }
        if (selectedRoleTheme == "green")
        {
            return UIColor(red: 56.0/255.0, green: 65.0/255.0, blue:45.0/255.0, alpha: 1.0)
        }
        
        return UIColor.black
    }
    
    class func buttonColorBackground() -> UIColor
    {
        selectedRoleTheme = UserDefaultExtensionModel.shared.appColorName
        
        if (selectedRoleTheme == "black")
        {
            return UIColor(red: 50.0/255.0, green: 55.0/255.0, blue: 60.0/255.0, alpha: 1.0)
        }
        if (selectedRoleTheme == "red")
        {
            return UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 140.0/255.0, alpha: 1.0)
        }
        if (selectedRoleTheme == "green")
        {
            return UIColor(red: 52.0/255.0, green: 0.0/255.0, blue: 11.0/255.0, alpha: 1.0)
        }
        
        return UIColor.black
    }
    
    class func textFieldColor() -> UIColor
    {
        selectedRoleTheme = UserDefaultExtensionModel.shared.appColorName
        
        if (selectedRoleTheme == "black")
        {
            return UIColor(red: 55.0/255.0, green: 0.0/255.0, blue: 55.0/255.0, alpha: 1.0)
        }
        if (selectedRoleTheme == "red")
        {
            return UIColor(red: 85.0/255.0, green: 112.0/255.0, blue: 140.0/255.0, alpha: 1.0)
        }
        if (selectedRoleTheme == "green")
        {
            return UIColor(red: 120.0/255.0, green: 65.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        }
        
        return UIColor.black
    }
    
    class func textFieldBackgroundColor() -> UIColor
    {
        selectedRoleTheme = UserDefaultExtensionModel.shared.appColorName
        
        if (selectedRoleTheme == "black")
        {
            return UIColor(red: 85.0/255.0, green: 100.0/255.0, blue: 130.0/255.0, alpha: 1.0)
        }
        if (selectedRoleTheme == "red")
        {
            return UIColor(red: 88.0/255.0, green: 30.0/255.0, blue: 50.0/255.0, alpha: 1.0)
        }
        if (selectedRoleTheme == "green")
        {
            return UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        }
        
        return UIColor.black
    }
    
    class func textViewColor() -> UIColor
    {
        selectedRoleTheme = UserDefaultExtensionModel.shared.appColorName
        
        if (selectedRoleTheme == "black")
        {
            return UIColor(red: 22.0/255.0, green: 2.0/255.0, blue: 8.0/255.0, alpha: 1.0)
        }
        if (selectedRoleTheme == "red")
        {
            return UIColor(red: 55.0/255.0, green: 55.0/255.0, blue: 55.0/255.0, alpha: 1.0)
        }
        if (selectedRoleTheme == "green")
        {
            return UIColor(red: 20.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        }
        
        return UIColor.black
    }
    
    class func textViewBackgroundColor() -> UIColor
    {
        selectedRoleTheme = UserDefaultExtensionModel.shared.appColorName
        
        if (selectedRoleTheme == "black")
        {
            return UIColor(red: 0.0/255.0, green: 80.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        }
        if (selectedRoleTheme == "red")
        {
            return UIColor(red: 20.0/255.0, green: 50.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        }
        if (selectedRoleTheme == "green")
        {
            return UIColor(red: 120.0/255.0, green: 65.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        }
        
        return UIColor.black
    }
    
    class func imageBackgroundColor() -> UIColor
    {
        selectedRoleTheme = UserDefaultExtensionModel.shared.appColorName
        
        if (selectedRoleTheme == "black")
        {
            return UIColor(red: 85.0/255.0, green: 55.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        }
        if (selectedRoleTheme == "red")
        {
            return UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 190.0/255.0, alpha: 1.0)
        }
        if (selectedRoleTheme == "green")
        {
            return UIColor(red: 50.0/255.0, green: 0.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        }
        
        return UIColor.black
    }
    
    class func viewBackgroundColor() -> UIColor
    {
        selectedRoleTheme = UserDefaultExtensionModel.shared.appColorName
        
        if (selectedRoleTheme == "black")
        {
            return UIColor(red: 72.0/255.0, green: 0.0/255.0, blue: 65.0/255.0, alpha: 1.0)
        }
        if (selectedRoleTheme == "red")
        {
            return UIColor(red: 0.0/255.0, green: 30.0/255.0, blue: 30.0/255.0, alpha: 1.0)
        }
        if (selectedRoleTheme == "green")
        {
            return UIColor(red: 0.0/255.0, green: 80.0/255.0, blue: 80.0/255.0, alpha: 1.0)
        }
        
        return UIColor.black
    }
}

extension UIView
{
    
    func HANDLE_SUBVIEW_COLORS()
    {
        
        let labels = self.subviews.compactMap { $0 as? UILabel }
        for label in labels
        {
            label.textColor = ColorManagement.labelColor()
        }
        
        let buttons = self.subviews.compactMap { $0 as? UIButton }
        for button in buttons
        {
            button.setTitleColor(ColorManagement.buttonColor(), for: .normal)
        }
        
        let txtFields = self.subviews.compactMap { $0 as? UITextField }
        for txtField in txtFields
        {
            txtField.textColor = ColorManagement.textFieldColor()
            txtField.backgroundColor = ColorManagement.textFieldBackgroundColor()
        }
        
        let txtViews = self.subviews.compactMap { $0 as? UITextView }
        for txtView in txtViews
        {
            txtView.textColor = ColorManagement.textViewColor()
        }
        
        let UIImageViews = self.subviews.compactMap { $0 as? UIImageView }
        for UIImageView in UIImageViews
        {
            UIImageView.backgroundColor = ColorManagement.imageBackgroundColor()
        }
        
    }
}


