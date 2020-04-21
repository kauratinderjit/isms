//
//  UITextField.swift
//  LatestArchitechtureDemo
//
//  Created by Atinder Kaur on 5/23/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
import UIKit

//MARK: UITextField Class Method
private var __maxLengths = [UITextField: Int]()

extension UITextField
{
    
    func txtfieldPadding(leftpadding: Int,rightPadding: Int) {
    
        if leftpadding != 0{
            let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: leftpadding, height: Int(self.frame.size.height)))
            self.leftView = paddingView
            self.leftViewMode = .always
        }
        
        if rightPadding != 0{
            let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: rightPadding, height: Int(self.frame.size.height)))
            self.rightView = paddingView
            self.rightViewMode = .always
        }
        
        
    }
    
    func CreateBoundryShadowOfTxtfield(shadowOpacity:Float,shadowColor: CGColor)
    {
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowRadius = 8.0
        self.layer.shadowColor = shadowColor
        self.clipsToBounds = false
    }
   
    //Set font for textField
    func SetTextFont(textSize:Int,placeholderText:String)
    {
        self.font = UIFont(name:KFontNames.KOpenSans, size: CGFloat(textSize))
        let attributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor: UIColor.darkGray,NSAttributedString.Key.font: UIFont(name: KFontNames.KOpenSans, size: CGFloat(textSize)) ?? UIFont.systemFont(ofSize: CGFloat(textSize)) ]
        self.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
    }
    
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
                return 150 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    @objc func fix(textField: UITextField) {
        let t = textField.text
        textField.text = t?.safelyLimitedTo(length: maxLength)
    }
    
    
   
}

extension UILabel
{
    //Set font for label
    func SetLabelFont(textSize:Int)
    {
        self.font = UIFont(name:KFontNames.KOpenSans, size: CGFloat(textSize))
    }
    
    func SetRalewayFontForLabel(textSize:Int)
    {
        self.font = UIFont(name:KFontNames.KRalewaySemiBold,size:CGFloat(textSize))
    }
}
extension UIButton
{
    //Set font for button
    func  SetButtonFont(textSize:Int)
    {
        self.titleLabel?.font = UIFont(name: KFontNames.KOpenSans, size: CGFloat(textSize))
    }
}

extension UINavigationController
{
    //Set NavFont
    func SetNavigationFont(textSize:Int)
    {
        //NAVAL
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: KFontNames.KOpenSans, size: CGFloat(textSize))!, NSAttributedString.Key.foregroundColor: UIColor.black]
    }
}
extension UITextView
{
    //Set textView Font
    func SetTextViewFont(textSize:Int){
        self.font = UIFont(name: KFontNames.KOpenSans, size: CGFloat(textSize))
    }
    
    //Set font for textView
    func SetTextFont(textSize:Int)
    {
        self.font = UIFont(name:KFontNames.KOpenSans, size: CGFloat(textSize))
        let attributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor: UIColor.darkGray,NSAttributedString.Key.font: UIFont(name: KFontNames.KOpenSans, size: CGFloat(textSize)) ?? UIFont.systemFont(ofSize: CGFloat(textSize)) ]
        
        let regularAttributedString = NSAttributedString(string: "" , attributes: attributes)

       self.attributedText = regularAttributedString
        
    }
}

class UITextViewPadding : UITextView {
     required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
       textContainerInset = UIEdgeInsets(top: 14, left: 20, bottom: 14, right: 14)
     }
   }
//UIImage Extension
extension UIImage{
        public func changeImageColour(withTintColor color: UIColor) -> UIImage{
            UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
            let context: CGContext = UIGraphicsGetCurrentContext()!
            context.translateBy(x: 0, y: self.size.height)
            context.scaleBy(x: 1.0, y: -1.0)
            context.setBlendMode(CGBlendMode.normal)
            let rect: CGRect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
            context.clip(to: rect, mask: self.cgImage!)
            color.setFill()
            context.fill(rect)
            if let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext(){
                UIGraphicsEndImageContext()
                return newImage
            }
            return self
        }
}
