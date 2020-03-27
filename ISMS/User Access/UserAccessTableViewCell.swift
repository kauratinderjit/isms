//
//  UserAccessTableViewCell.swift
//  ISMS
//
//  Created by Gurleen Osahan on 6/21/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit
//h/
class UserAccessTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbl_text: UILabel!
    @IBOutlet weak var btnCheckUncheck: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code here
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setUpCell(indexPath: IndexPath,sectionItems: [UserAccesstModel.lstActionAccessData],arrActionId: [String]){
        let section = sectionItems[indexPath.row]
        DispatchQueue.main.async {
            self.lbl_text.textColor = UIColor.black
            self.lbl_text.text = section.actionName
            self.btnCheckUncheck.tag  = indexPath.row
            if let actionID = section.actionId{
                print(actionID)
            }
        }
    }
}
