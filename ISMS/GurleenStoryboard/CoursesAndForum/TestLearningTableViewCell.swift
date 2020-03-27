//
//  TestLearningTableViewCell.swift
//  ISMS
//
//  Created by Gurleen Osahan on 11/25/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class TestLearningTableViewCell: UITableViewCell {

    @IBOutlet weak var btnCheckUncheck: UIButton!
    @IBOutlet weak var lblAnswers: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
