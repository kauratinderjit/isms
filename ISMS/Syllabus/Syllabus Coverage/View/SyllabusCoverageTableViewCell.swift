//
//  SyllabusCoverageTableViewCell.swift
//  ISMS
//
//  Created by Kuldeep Singh on 11/15/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class SyllabusCoverageTableViewCell: UITableViewCell {

    @IBOutlet var lblSubjectName: UILabel!
    
    @IBOutlet var progressBar: UIProgressView!
    
    @IBOutlet var lblprogressPercentage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
