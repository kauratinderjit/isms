//
//  PerformanceTrackingTableCell.swift
//  ISMS
//
//  Created by Navalpreet Kaur on 11/27/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class PerformanceTrackingTableCell: UITableViewCell {
    
    //MARK:- Outlet
    @IBOutlet weak var lblPercentage: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
