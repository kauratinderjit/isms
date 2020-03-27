//
//  SelectionTblViewCustomCell.swift
//  ISMS
//
//  Created by Taranjeet Singh on 7/4/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class SelectionTblViewCell: UITableViewCell {

    @IBOutlet weak var lblRowTitle: UILabel!
    @IBOutlet weak var btnIsSelected: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func btnActionSelectedUnselected(_ sender: UIButton) {
        
        
    }
    
}
