//
//  StudentRatingTableViewCell.swift
//  ISMS
//
//  Created by Kuldeep Singh on 11/27/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class StudentRatingTableViewCell: UITableViewCell {

    @IBOutlet var imgStudent: UIImageView!
    
    @IBOutlet var lblStudentName: UILabel!
    
    @IBOutlet var lblPercentage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
