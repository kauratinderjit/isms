//
//  CreateQuizTableViewCell.swift
//  ISMS
//
//  Created by Gurleen Osahan on 11/27/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class CreateQuizTableViewCell: UITableViewCell {

    @IBOutlet weak var txtfieldOption1: UITextField!
    @IBOutlet weak var txtfieldOption2: UITextField!
    @IBOutlet weak var txtfieldOption3: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
