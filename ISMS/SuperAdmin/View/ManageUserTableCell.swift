//
//  ManageUserTableCell.swift
//  ISMS
//
//  Created by Navalpreet Kaur on 11/29/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class ManageUserTableCell: UITableViewCell {
    //MARK:- Outlet and Variables
    @IBOutlet weak var imgViewUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblClassName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK:- Other functions
    func SetUI()
    {
       imgViewUser.createCircleImage()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
