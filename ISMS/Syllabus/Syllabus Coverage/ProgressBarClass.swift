//
//  ProgressBarClass.swift
//  ISMS
//
//  Created by Kuldeep Singh on 11/15/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit



    
    public class ProgressView: UIProgressView {
        var height: CGFloat = 30.0
        public override func sizeThatFits(_ size: CGSize) -> CGSize {
            return CGSize(width: size.width, height: height) // We can set the required height
        }
    }
    
    
    
    
    
    
    
    
    
    

