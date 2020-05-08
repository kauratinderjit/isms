//
//  UiCollectioViewExtensio.swift
//  ISMS
//
//  Created by Mohit Sharma on 5/6/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView
{
    
    func setEmptyMessage(_ message: String)
    {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 18)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
        // self.separatorStyle = .none;
    }
    
    func restore()
    {
        self.backgroundView = nil
       // self.separatorStyle = .singleLine
    }
}
