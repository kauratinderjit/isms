//
//  RatingToTeacherTableViewCell.swift
//  ISMS
//
//  Created by Kuldeep Singh on 12/2/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit
protocol RatingToTeacherTableViewCellDelegate {
    
    func didPressButton(_ tag: Int)
    
}



class RatingToTeacherTableViewCell: UITableViewCell {
    
    
    @IBOutlet var lblSkill: UILabel!
    @IBOutlet var lblRating: UILabel!
    
    @IBOutlet var btnPicker: UIButton!
    var cellDelegate : RatingToTeacherTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    @IBAction func ActionRatingPicker(_ sender: Any) {
        cellDelegate?.didPressButton((sender as AnyObject).tag)
    }
    
}
