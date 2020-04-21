//
//  CollapsibleTableViewCell.swift
//  ios-swift-collapsible-table-section
//
//  Created by Yong Su on 7/17/17.
//  Copyright © 2017 Yong Su. All rights reserved.
//

import UIKit

class CollapsibleTableViewCell: UITableViewCell {
    
    let nameLabel = UILabel()
    let checkBox = UIButton()
    
    // MARK: Initalizers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let marginGuide = contentView.layoutMarginsGuide
        
        // configure nameLabel
        contentView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: 10).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor, constant: 70).isActive = true
        nameLabel.numberOfLines = 0
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        
        // configure detailLabel
        contentView.addSubview(checkBox)
        checkBox.frame = CGRect(x: 320 , y: 5, width: 50, height: 50)
              checkBox.setImage(UIImage(named: kImages.kUncheck), for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
