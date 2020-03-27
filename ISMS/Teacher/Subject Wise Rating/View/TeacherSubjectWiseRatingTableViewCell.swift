//
//  TeacherSubjectWiseRatingTableViewCell.swift
//  ISMS
//
//  Created by Kuldeep Singh on 12/5/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class TeacherSubjectWiseRatingTableViewCell: UITableViewCell {

    
    @IBOutlet var lblSubjectName: UILabel!
    
    @IBOutlet var lblPercentage: UILabel!
    
    @IBOutlet var lblFirstChar: UILabel!
    
    @IBOutlet var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // imgView.layer.borderWidth = 1
        imgView.layer.masksToBounds = false
        // imgView.layer.borderColor = UIColor.black.cgColor
        imgView.layer.cornerRadius = imgView.frame.height/2
        imgView.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
