//
//  BulletinsTableCell.swift
//  ISMS
//
//  Created by Navalpreet Kaur on 12/2/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class BulletinsTableCell: UITableViewCell {

    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblBulletinName: UILabel!
    @IBOutlet weak var imgViewBulletin: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK:- Other functions
    func SetUI()
    {
        imgViewBulletin.createCircleImage()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
