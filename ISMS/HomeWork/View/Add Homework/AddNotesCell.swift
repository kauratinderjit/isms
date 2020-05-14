//
//  AddNotesCell.swift
//  ISMS
//
//  Created by Atinder Kaur on 4/7/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import UIKit

class AddNotesCell: UITableViewCell {
    
    
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblFirstLetter: UILabel!
    @IBOutlet weak var btnDel: UIButton!
    @IBOutlet weak var lblAttachment: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
