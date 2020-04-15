//
//  MyCustomView.swift
//  RideApp
//
//  Created by Kuldeep Singh on 7/17/18.
//  Copyright © 2018 Kuldeep Singh. All rights reserved.
//

import UIKit
private var __maxLengths = [UITextField: Int]()

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        get {
            return layer.borderColor as! UIColor
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
          layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
          layer.shadowRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var shadowColor: UIColor {
        get {
            return layer.shadowColor as! UIColor
        }
        set {
           
            layer.shadowColor = newValue.cgColor
            
        }
    }
   
    @IBInspectable var shadowOffset: CGFloat {
        get {
            return layer.shadowOffset.width
        }
        set {
            
            layer.shadowOffset = CGSize(width: newValue,height: newValue)
            layer.masksToBounds = false
            
        }
    }
    
}
