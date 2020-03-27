//
//  Checkbox.swift
//  EventManager
//
//  Created by Gurleen Kaur on 10/24/18.
//  Copyright © 2018 Gurleen Kaur. All rights reserved.
//


import UIKit

class CheckBox: UIButton {
    // Images
    let checkedImage = UIImage(named: "selectedRadio")! as UIImage
    let uncheckedImage = UIImage(named: "unselectedRadio")! as UIImage
    
    // Bool property
    var isChecked: Bool = false {
        didSet{
            if isChecked == true
            {
                self.setImage(checkedImage, for: UIControl.State.normal)
            } else
            {
                self.setImage(uncheckedImage, for: UIControl.State.normal)
            }
        }
    }
    
    override func awakeFromNib()
    {
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
        self.isChecked = false
    }
    
    @objc func buttonClicked(sender: UIButton) {
        if sender == self
        {
            isChecked = !isChecked
        }
    }
}
