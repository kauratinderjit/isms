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
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgViewProfile: UIImageView!
    @IBOutlet weak var customCollectionView: UICollectionView!
    @IBOutlet weak var btnComments: UIButton!
    @IBOutlet weak var btnLikes: UIButton!
    @IBOutlet weak var btnShare: UIImageView!
    @IBOutlet weak var btnReport: UIButton!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var lblDescription: UILabel!
        @IBOutlet weak var btnLikerList: UIButton!
    
    
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
