//
//  ThemeManager.swift
//  ISMS
//
//  Created by Taranjeet Singh on 11/18/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

extension UIColor {
    static func colorFromHexString (_ hex:String) -> UIColor {
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


let hodThemeDict : [String:String] = ["mainColor":"4BBEF8","textFieldBackgroundColor":"FFFFFF","uiButtonBackgroundColor":"4BBEF8","uiBarButtonBackgroundColor":"4ABCF5","uiButtonTintColor":"FFFFFF","uiButtonTextColor":"FFFFFF","textFieldTextColor":"A9A9A9","labelTextColor":"000000","labelBackgroundColor":"4BBEF8","navigationTintColor":"#00008b","navigationBarTintColor":"FFFFFF","statusBarColor": "4BBEF8"] //["mainColor":"00008b","textFieldBackgroundColor":"FFFFFF","uiButtonBackgroundColor":"#00008b","uiBarButtonBackgroundColor":"#00008b","uiButtonTintColor":"FFFFFF","uiButtonTextColor":"FFFFFF","textFieldTextColor":"A9A9A9","labelTextColor":"000000","labelBackgroundColor":"#00008b","navigationTintColor":"#FFFFFF","navigationBarTintColor":"#00008b","statusBarColor":"#00008b"]

let studentThemeDict : [String:String] = ["mainColor":"4BBEF8","textFieldBackgroundColor":"FFFFFF","uiButtonBackgroundColor":"4BBEF8","uiBarButtonBackgroundColor":"4ABCF5","uiButtonTintColor":"FFFFFF","uiButtonTextColor":"FFFFFF","textFieldTextColor":"A9A9A9","labelTextColor":"000000","labelBackgroundColor":"4BBEF8","navigationTintColor":"#00008b","navigationBarTintColor":"FFFFFF","statusBarColor": "4BBEF8"]


//["mainColor":"17442A","textFieldBackgroundColor":"FFFFFF","uiButtonBackgroundColor":"17442A","uiBarButtonBackgroundColor":"17442A","uiButtonTintColor":"FFFFFF","uiButtonTextColor":"FFFFFF","textFieldTextColor":"A9A9A9","labelTextColor":"000000","labelBackgroundColor":"17442A","navigationTintColor":"FFFFFF","navigationBarTintColor":"17442A","statusBarColor": "17442A"]


//let defaultThemeDict : [String:String] = ["mainColor":"A90222","textFieldBackgroundColor":"FFFFFF","uiButtonBackgroundColor":"A90222","uiBarButtonBackgroundColor":"A90222","uiButtonTintColor":"FFFFFF","uiButtonTextColor":"FFFFFF","textFieldTextColor":"A9A9A9","labelTextColor":"000000","labelBackgroundColor":"A90222","navigationTintColor":"FFFFFF","navigationBarTintColor":"A90222","statusBarColor": "A90222"]

let defaultThemeDict : [String:String] = ["mainColor":"4BBEF8","textFieldBackgroundColor":"FFFFFF","uiButtonBackgroundColor":"4BBEF8","uiBarButtonBackgroundColor":"4ABCF5","uiButtonTintColor":"FFFFFF","uiButtonTextColor":"FFFFFF","textFieldTextColor":"A9A9A9","labelTextColor":"000000","labelBackgroundColor":"4BBEF8","navigationTintColor":"#00008b","navigationBarTintColor":"FFFFFF","statusBarColor": "4BBEF8"]

struct ThemeColors: Codable {

    var mainColor: String = "4BBEF8"//"A90222"//Current Theme Main Color(White)
    var textFieldBackgroundColor : String = "FFFFFF"//(White)
    var uiButtonBackgroundColor : String = "4BBEF8"//"A90222"//Default Color ISMS(Red)
    var uiBarButtonBackgroundColor : String = "4BBEF8"//"A90222"//DefaultColor(Red)
    var uiButtonTintColor :String = "FFFFFF"
    var uiButtonTextColor : String = "FFFFFF"
    var textFieldTextColor : String = "FFFFFF"
    var labelTextColor : String = "FFFFFF"
    var labelBackgroundColor : String = "4BBEF8"//"A90222"
    var navigationTintColor : String = "#00008b"//"FFFFFF"
    var navigationBarTintColor : String = "FFFFFF"//"A90222"
    var statusBarColor : String = "4BBEF8"//"4BBEF8"//"A90222"
    var titleColor = "FFFFFF"

    
    var circleMenuColor: String = "FF0000"
    var header1Color: String = "D20000"
    var subheader1Color: String = "D20000"
    var header2Color: String = "000000" //topnav bar right colour
    var navigationTitleColor = "#000000"//"FFFFFF"
    var tabBarBackgroundColor = "000000"
    var tabBarTextColor = "BFBBBB"
    var tabBarHighlightTextColor = "FFFFFF"
    var tabBarIconColor = "BFBBBB"
    var tabBarHighlightIconColor = "FFFFFF"
    var tabBarBackdropColor = "000000"
    var tabBarHighlightBackdropColor = "000000"
    var datePickerTextfieldColor = "4A4A4A"
    var tableBGColor = "FFFFFF"
    var tableCellColor = "FFFFFF"
    var polylineStartColor = "86cd0b"
    var polylineEndColor = "35bbdd"
    var redHightlightColor = "de2419"
    var yellowHightlightColor = "ffd200"
    var swipeGreenColor = "7bb51a"
    var swipeRedColor = "d0021b"
    
    var headerFontColor = "000000"
    var headerFontFamily = "Roboto"
    var headerFontSize = "18"
    var menuFontColor = "000000"
    var menuFontFamily = "Roboto"
    var menuFontSize = "15"
    var menuFontFamily2 = "Roboto"
    var menuFontSize2 = "15"
    var menuFontFamily3 = "Roboto"
    var menuFontSize3 = "15"
    var buttonFontFamily = "Roboto"
    var buttonFontSize = "15"
    var navigationFontFamily = "Roboto"
    var navigationFontSize = "15"
    var pageFontFamily = "Roboto"
    var pageFontSize = "15"
    var elementsFontFamily = "Roboto"
    var errorHighlighter = "F89491"
    
    init() { }
    
    init(values: [String: String]) {
        mainColor = values["mainColor"] ?? "4BBEF8"
        textFieldBackgroundColor = values["textFieldBackgroundColor"] ?? "FFFFFF"
        uiButtonBackgroundColor = values["uiButtonBackgroundColor"] ?? "FFFFFF"
        uiBarButtonBackgroundColor = values["uiBarButtonBackgroundColor"] ?? "FFFFFF"
        uiButtonTintColor = values["uiButtonTintColor"] ?? "FFFFFF"
        uiButtonTextColor = values["uiButtonTextColor"] ?? "FFFFFF"
        textFieldTextColor = values["textFieldTextColor"] ?? "FFFFFF"
        labelTextColor = values["labelTextColor"] ?? "FFFFFF"
        labelBackgroundColor = values["labelBackgroundColor"] ?? "FFFFFF"
        navigationTintColor = values["navigationTintColor"] ?? "FFFFFF"
        navigationBarTintColor = values["navigationBarTintColor"] ?? "FFFFFF"
        titleColor = values["titleColor"] ?? "FFFFFF"
        tableCellColor = values["tableCellColor"] ?? "ffffff"
        statusBarColor = values["statusBarColor"] ?? "A90222"

        
        circleMenuColor = values["circleMenuColor"] ?? "000000"
        header1Color = values["header1Color"] ?? "000000"
        header2Color = values["header2Color"] ?? "000000"
        subheader1Color = values["subheader1Color"] ?? "000000"
        navigationTitleColor = values["navigationTitleColor"] ?? "FFFFFF"
        tabBarBackgroundColor = values["tabBarBackgroundColor"] ?? "000000"
        tabBarTextColor = values["tabBarTextColor"] ?? "BFBBBB"
        tabBarHighlightTextColor = values["tabBarHighlightTextColor"] ?? "FFFFFF"
        tabBarIconColor = values["tabBarIconColor"] ?? "BFBBBB"
        tabBarHighlightIconColor = values["tabBarHighlightIconColor"] ?? "FFFFFF"
        tabBarBackdropColor = values["tabBarBackdropColor"] ?? "000000"
        tabBarHighlightBackdropColor = values["tabBarHighlightBackdropColor"] ?? "000000"
        datePickerTextfieldColor = values["datePickerTextfieldColor"] ?? "4A4A4A"
        tableBGColor = values["tableBGColor"] ?? "f5f5f3"
        polylineStartColor = values["polylineStartColor"] ?? "86cd0b"
        polylineEndColor = values["polylineEndColor"] ?? "35bbdd"
        redHightlightColor = values["polylineEndColor"] ?? "de2419"
        yellowHightlightColor = values["polylineEndColor"] ?? "ffd200"
        swipeGreenColor = values["swipeGreenColor"] ?? "7bb51a"
        swipeRedColor = values["swipeRedColor"] ?? "d0021b"
        
        headerFontColor = values["headerFontColor"] ?? "d0021b"
        headerFontFamily = values["headerFontFamily"] ?? "Roboto-Regular"
        headerFontSize = values["headerFontSize"] ?? "18"
        menuFontColor = values["menuFontColor"] ?? "d0021b"
        menuFontFamily = values["menuFontFamily"] ?? "Roboto-Regular"
        menuFontSize = values["menuFontSize"] ?? "14"
        menuFontFamily2 = values["menuFontFamily2"] ?? "Roboto-Regular"
        menuFontSize2 = values["menuFontSize2"] ?? "14"
        menuFontFamily3 = values["menuFontFamily3"] ?? "Roboto-Regular"
        menuFontSize3 = values["menuFontSize3"] ?? "14"
        
        buttonFontFamily = values["buttonFontFamily"] ?? "Roboto"
        buttonFontSize = values["buttonFontSize"] ?? "15"
        navigationFontFamily = values["navigationFontFamily"] ?? "Roboto"
        navigationFontSize = values["navigationFontSize"] ?? "15"
        pageFontFamily = values["pageFontFamily"] ?? "Roboto"
        pageFontSize = values["pageFontSize"] ?? "15"
        elementsFontFamily = values["elementsFontFamily"] ?? "Roboto"
        
        errorHighlighter = values["errorHighlighter"] ?? "F89491"
    }
    
    //MARK:- Save Theme Values in Userdefaults
    static func saveCurrentThemeColorsToUserDefaults(modal: ThemeColors) {
        
        let encodedData = try? JSONEncoder().encode(modal)
        UserDefaults.standard.set(encodedData, forKey: UserDefaultKeys.currentTheme.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    //MARK:- Get Theme Values from Userdefaults
    static func getCurrentThemeColorsFromDefaults() -> ThemeColors? {
        if let data = UserDefaults.standard.value(forKey: UserDefaultKeys.currentTheme.rawValue) {
            let decodedData = try? JSONDecoder().decode(ThemeColors.self, from: data as! Data)
            if let wrappedData = decodedData{
                return wrappedData
            }
            return ThemeColors()
        }
        return ThemeColors()
    }
    
}

class Theme {
    
    var mainColor: UIColor = UIColor.colorFromHexString("4BBEF8")//UIColor.colorFromHexString("A90222")
    var textFieldBackgroundColor : UIColor = .white
    var uiButtonBackgroundColor : UIColor = UIColor.colorFromHexString("4BBEF8")//UIColor.colorFromHexString("A90222")
    var uiBarButtonBackgroundColor : UIColor = .clear
    var uiButtonTintColor :UIColor = .white
    var uiButtonTextColor : UIColor = .white
    var textFieldTextColor : UIColor = .gray
    var labelTextColor : UIColor = .black
    var navigationTintColor : UIColor = UIColor.colorFromHexString("B1B7BB")//UIColor.colorFromHexString("FFFFFF")
    var navigationBarTintColor : UIColor = UIColor.colorFromHexString("4BBEF8")//UIColor.colorFromHexString("A90222")
    var labelBackgroundColor : UIColor = UIColor.colorFromHexString("4BBEF8")//UIColor.colorFromHexString("A90222")
    var statusBarColr : UIColor = UIColor.colorFromHexString("4BBEF8")//UIColor.colorFromHexString("A90222")
    var boarderColor :UIColor = UIColor.colorFromHexString("E3F0FE")
    var circleMenuColor: UIColor = .black
    var header1Color: UIColor = .black
    var subheader1Color: UIColor = .black
    var header2Color: UIColor = .white
    var navigationTitleColor: UIColor = .white
    var titleColor: UIColor = .white
    
    var tabBarBackgroundColor: UIColor = .black
    var tabBarTextColor: UIColor = .white
    var tabBarHighlightTextColor: UIColor = .white
    var tabBarIconColor: UIColor = .white
    var tabBarHighlightIconColor: UIColor = .white
    var tabBarBackdropColor: UIColor = .white
    var tabBarHighlightBackdropColor: UIColor = .white
    var datePickerTextfieldColor: UIColor?
    
    var tableBGColor: UIColor?
    var tableHeaderColor: UIColor?
    var tableCellColor: UIColor?
    var polylineStartColor: UIColor?
    var polylineEndColor: UIColor?
    var redHightlightColor: UIColor?
    var yellowHightlightColor: UIColor?
    var swipeGreenColor: UIColor?
    var swipeRedColor: UIColor?
    
    var headerFontColor: UIColor?
    var headerFontFamily: String?
    var headerFontSize: String?
    var menuFontColor: UIColor?
    var menuFontFamily: String?
    var menuFontSize: String?
    var menuFontFamily2: String?
    var menuFontSize2: String?
    var menuFontFamily3: String?
    var menuFontSize3: String?
    
    var buttonFontFamily: String?
    var buttonFontSize: String?
    var navigationFontFamily: String?
    var navigationFontSize: String?
    var pageFontFamily: String?
    var pageFontSize: String?
    var elementsFontFamily: String?
    
    var errorHighlighter: UIColor?
    
    init() {
        
    }
    
    init(themeColors: ThemeColors) {
        
        mainColor = UIColor.colorFromHexString(themeColors.mainColor)
        textFieldBackgroundColor = UIColor.colorFromHexString(themeColors.textFieldBackgroundColor)
        uiButtonBackgroundColor = UIColor.colorFromHexString(themeColors.uiButtonBackgroundColor)
        uiBarButtonBackgroundColor = UIColor.colorFromHexString(themeColors.uiBarButtonBackgroundColor)
        uiButtonTintColor = UIColor.colorFromHexString(themeColors.uiButtonTintColor)
        uiButtonTextColor = UIColor.colorFromHexString(themeColors.uiButtonTextColor)
        textFieldTextColor = UIColor.colorFromHexString(themeColors.textFieldTextColor)
        labelTextColor = UIColor.colorFromHexString(themeColors.labelTextColor)
        navigationTintColor = UIColor.colorFromHexString(themeColors.navigationTintColor)
        navigationBarTintColor = UIColor.colorFromHexString(themeColors.navigationBarTintColor)
        statusBarColr = UIColor.colorFromHexString(themeColors.statusBarColor)
        
        tableCellColor = UIColor.colorFromHexString(themeColors.tableCellColor)
        tableBGColor = UIColor.colorFromHexString(themeColors.tableBGColor)
        tableHeaderColor = tableBGColor
        
        circleMenuColor = UIColor.colorFromHexString(themeColors.circleMenuColor)
        header2Color = UIColor.colorFromHexString(themeColors.header2Color)
        header1Color = UIColor.colorFromHexString(themeColors.header1Color)
        subheader1Color = UIColor.colorFromHexString(themeColors.subheader1Color)
        navigationTitleColor = UIColor.colorFromHexString(themeColors.navigationTitleColor)
        titleColor = UIColor.colorFromHexString(themeColors.titleColor)
        tabBarBackgroundColor = UIColor.colorFromHexString(themeColors.tabBarBackgroundColor)
        tabBarTextColor = UIColor.colorFromHexString(themeColors.tabBarTextColor)
        tabBarHighlightTextColor = UIColor.colorFromHexString(themeColors.tabBarHighlightTextColor)
        
        tabBarIconColor = UIColor.colorFromHexString(themeColors.tabBarIconColor)
        tabBarHighlightIconColor = UIColor.colorFromHexString(themeColors.tabBarHighlightIconColor)
        tabBarBackdropColor = UIColor.colorFromHexString(themeColors.tabBarBackdropColor)
        tabBarHighlightBackdropColor = UIColor.colorFromHexString(themeColors.tabBarHighlightBackdropColor)
        datePickerTextfieldColor = UIColor.colorFromHexString(themeColors.datePickerTextfieldColor)
        
        polylineStartColor = UIColor.colorFromHexString(themeColors.polylineStartColor)
        polylineEndColor = UIColor.colorFromHexString(themeColors.polylineEndColor)
        redHightlightColor = UIColor.colorFromHexString(themeColors.redHightlightColor)
        yellowHightlightColor = UIColor.colorFromHexString(themeColors.yellowHightlightColor)
        
        swipeGreenColor = UIColor.colorFromHexString(themeColors.swipeGreenColor)
        swipeRedColor = UIColor.colorFromHexString(themeColors.swipeRedColor)
        
        headerFontColor = UIColor.colorFromHexString(themeColors.headerFontColor)
        headerFontFamily = themeColors.headerFontFamily
        headerFontSize = themeColors.headerFontSize
        menuFontColor = UIColor.colorFromHexString(themeColors.menuFontColor)
        menuFontFamily = themeColors.menuFontFamily
        menuFontSize = themeColors.menuFontSize
        menuFontFamily2 = themeColors.menuFontFamily2
        menuFontSize2 = themeColors.menuFontSize2
        menuFontFamily3 = themeColors.menuFontFamily3
        menuFontSize3 = themeColors.menuFontSize3
        
        buttonFontFamily = themeColors.buttonFontFamily
        buttonFontSize = themeColors.buttonFontSize
        navigationFontFamily = themeColors.navigationFontFamily
        navigationFontSize = themeColors.navigationFontSize
        pageFontFamily = themeColors.pageFontFamily
        pageFontSize = themeColors.pageFontSize
        elementsFontFamily = themeColors.elementsFontFamily
        
        errorHighlighter = UIColor.colorFromHexString(themeColors.errorHighlighter)
        
        ThemeColors.saveCurrentThemeColorsToUserDefaults(modal: themeColors)
    }
    
}

//// Enum declaration
//let SelectedThemeKey = "SelectedTheme"

// This will let you use a theme in the app.
class ThemeManager {
    
    static let shared = ThemeManager()
    private var theme: Theme?
    
    var currentTheme: Theme? {
        get{
            if theme != nil {
                return theme
            } else {
                return ThemeManager.currentTheme()
            }
        }
        set {
            theme = newValue
        }
    }
    
    // ThemeManager
    static func currentTheme() -> Theme {
        if let storedThemeColors = ThemeColors.getCurrentThemeColorsFromDefaults() {
            let theme = Theme(themeColors: storedThemeColors)
            ThemeManager.shared.currentTheme = theme
            return theme
        } else {
            let theme = Theme()
            ThemeManager.shared.currentTheme = theme
            return theme
        }
    }
    
    static func applyTheme(theme: Theme) {
        
        let sharedApplication = UIApplication.shared
        sharedApplication.delegate?.window??.tintColor = theme.mainColor
        
        if let statusBar = UIApplication.shared.statusBarUIView{
            statusBar.backgroundColor = theme.statusBarColr
        }
            UINavigationBar.appearance().barTintColor = theme.navigationBarTintColor
            UINavigationBar.appearance().tintColor = theme.navigationTintColor
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
            UINavigationBar.appearance().isTranslucent = false
            UINavigationBar.appearance().barStyle = .blackTranslucent
        
            ThemeManager.shared.currentTheme = theme
    }
    
    
}

//Prevent the crash while using xcode 11 & iOS 13
extension UIApplication {
    var statusBarUIView: UIView? {
        if #available(iOS 13.0, *) {
            let tag = 123
            if let statusBar = self.keyWindow?.viewWithTag(tag) {
                return statusBar
            } else {
                let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
                statusBarView.tag = tag

                self.keyWindow?.addSubview(statusBarView)
                return statusBarView
            }
        } else {
            if responds(to: Selector(("statusBar"))) {
                return value(forKey: "statusBar") as? UIView
            }
        }
        return nil
    }
}
