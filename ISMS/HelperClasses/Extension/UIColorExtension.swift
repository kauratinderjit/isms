//
//  UIColorExtension.swift
//  ISMS
//
//  Created by Taranjeet Singh on 6/21/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation

extension UIColor{
    
    static var random: UIColor {
        return UIColor(red: .random(in: 0...1),
                       green: .random(in: 0...1),
                       blue: .random(in: 0...1),
                       alpha: 1.0)
    }
    
    func as1ptImage() -> UIImage {
           UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
           setFill()
           UIGraphicsGetCurrentContext()?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
           let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
           UIGraphicsEndImageContext()
           return image
       }
}

