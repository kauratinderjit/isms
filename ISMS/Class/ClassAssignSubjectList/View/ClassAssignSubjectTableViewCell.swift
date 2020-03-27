//
//  ClassAssignSubjectTableViewCell.swift
//  ISMS
//
//  Created by Taranjeet Singh on 7/5/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class ClassAssignSubjectTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblClassName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setUpCell(arrClassList:[GetClassListResultData],indexPath: IndexPath){
        let rsltData = arrClassList[indexPath.row]
        lblClassName.text = ""
        if let strTitle = rsltData.name{
            lblClassName.text = strTitle
        }
    }
}
