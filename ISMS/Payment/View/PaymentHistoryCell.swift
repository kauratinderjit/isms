//
//  PaymentHistoryCell.swift
//  ISMS
//
//  Created by Navalpreet Kaur on 11/28/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class PaymentHistoryCell: UITableViewCell {

    //MARK :- Outlat and Variables
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblCustomName: UILabel!
    @IBOutlet weak var lblBalance: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var viewCellBack: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    //MARK:- other functions
    func setUI ()
    {
        viewCellBack.addViewCornerShadow(radius: 8, view: viewCellBack)
        imgView.cornerRadius = imgView.frame.height/2
        imgView.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
