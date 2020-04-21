//
//  SubjectListCell.swift
//  ISMS
//
//  Created by Atinder Kaur on 4/20/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import UIKit

class SubjectListCell: UITableViewCell {
    
    @IBOutlet weak var lblImage: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
