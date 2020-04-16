//
//  AttachFilesTableViewCell.swift
//  ISMS
//  Cell
//  Created by Gurleen Osahan on 6/17/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class AttachFilesTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_text: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func setData(model:GetCommonDropdownModel.ResultData){
        lbl_text.text = model.name
        
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
