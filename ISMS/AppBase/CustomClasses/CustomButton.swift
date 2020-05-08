//
//  CustomButton.swift
//  BidJones
//
//  Created by Rakesh Kumar on 3/22/18.
//  Copyright © 2018 Seasia. All rights reserved.
//

import Foundation
import UIKit


@IBDesignable public class CustomButton: UIButton
{
    
    var corRadius = CGFloat()
    
    @IBInspectable var border_Color: UIColor = UIColor.white
        {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var border_Width: CGFloat = 2.0
        {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var corner_Radius: CGFloat = 0
        {
        didSet{
            self.layer.cornerRadius = cornerRadius
            corRadius = cornerRadius
        }
    }

    override public func layoutSubviews()
    {
        super.layoutSubviews()

        updateCornerRadius()
    }
    

    @IBInspectable var rounded: Bool = false
        {
        didSet {
            updateCornerRadius()
        }
    }

    func updateCornerRadius()
    {
        layer.cornerRadius = rounded ? frame.size.height / 2 : corRadius
    }
    
    @IBInspectable var addShadow: Bool = false
        {
        didSet
        {
            addshadow()
        }
    }
    
    func addshadow()
    {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 1.0
        self.layer.shadowOpacity = 0.5
    }
   
}
extension UITextView {
    
    func addDoneButton(title: String, target: Any, selector: Selector) {
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                              y: 0.0,
                                              width: UIScreen.main.bounds.size.width,
                                              height: 44.0))//1
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)//2
        let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)//3
        toolBar.setItems([flexible, barButton], animated: false)//4
        self.inputAccessoryView = toolBar//5
    }
}
