//
//  LikerListCell.swift
//  ISMS
//
//  Created by Atinder Kaur on 5/19/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import UIKit

class LikerListCell: UITableViewCell {
    
    @IBOutlet weak var imgViewProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
