//
//  OnlinePaymentCell.swift
//  ISMS
//
//  Created by Navalpreet Kaur on 11/28/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class OnlinePaymentCell: UITableViewCell {
    //MARK:- outlet
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblItemName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK:- Actions
    @IBAction func btnPayNow(_ sender: Any) {
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
