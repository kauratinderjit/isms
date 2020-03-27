//
//  TeacherSkillRatingTableViewCell.swift
//  ISMS
//
//  Created by Kuldeep Singh on 12/5/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class TeacherSubjectSkillRatingTableViewCell: UITableViewCell {
    
    
    @IBOutlet var lblSkillName: UILabel!
    
    @IBOutlet var lblRating: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
