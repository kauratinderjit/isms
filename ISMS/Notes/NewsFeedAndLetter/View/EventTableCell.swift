//
//  EventTableCell.swift
//  ISMS
//
//  Created by Navalpreet Kaur on 12/2/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class EventTableCell: UITableViewCell {
    
    //MARK:- Outlet and Variables
    @IBOutlet weak var viewCellBack: UIView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblEventName: UILabel!
    @IBOutlet weak var imgViewEvent: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK:- other functions
    func setUI ()
    {
       // viewCellBack.addViewCornerShadow(radius: 8, view: viewCellBack)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
