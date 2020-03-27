//
//  PopUpTableViewCell.swift
//  ISMS
//
//  Created by Taranjeet Singh on 11/29/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class PopUpTableViewCell: UITableViewCell {

    @IBOutlet weak var reasonLabel: UILabel!
    @IBOutlet weak var classNameLbl: UILabel!
    @IBOutlet weak var teacherNameLabel: UILabel!
    @IBOutlet weak var subjectNameLabel: UILabel!
    @IBOutlet weak var dayNameLabel: UILabel!
    @IBOutlet weak var periodStartTimeLabel: UILabel!
    @IBOutlet weak var periodEndTimeLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    //Set cell Data
    func setCellData(_ data: AddUpdateTimeTableResponseModel.ResultData,_ indexPath: IndexPath){
        reasonLabel.text = data.reason
        classNameLbl.text = data.className
        teacherNameLabel.text = data.teacher
        subjectNameLabel.text = data.subject
        dayNameLabel.text = data.strDay
        periodStartTimeLabel.text = data.startTime
        periodEndTimeLbl.text = data.endTime
    }
    
}
