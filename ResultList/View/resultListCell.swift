//
//  resultListCell.swift
//  ISMS
//
//  Created by Poonam  on 30/06/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import UIKit
import SDWebImage

class resultListCell: UITableViewCell {

    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgViewLogo: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setCellUI(data :[GetListResultData]?,indexPath: IndexPath){
        
        let rsltData = data?[indexPath.row]
        lblTitle.text = ""
        
        
        //Set buttons tag
        btnEdit.tag = indexPath.row
        btnDelete.tag = indexPath.row
        
         if UserDefaultExtensionModel.shared.currentUserRoleId == 2 || UserDefaultExtensionModel.shared.currentUserRoleId == 4 || UserDefaultExtensionModel.shared.currentUserRoleId == 5 || UserDefaultExtensionModel.shared.currentUserRoleId == 6{
            btnDelete.isHidden = true
        }
        
        imgViewLogo.createCircleImage()
        
        if let strTitle = rsltData?.Title{
            lblTitle.text = strTitle
        }
            if let nameStr = rsltData?.Title{
                CommonFunctions.sharedmanagerCommon.addLabelOnTheImgeViewWithFirstCharacter(string: nameStr, imgView: self.imgViewLogo)
                CommonFunctions.sharedmanagerCommon.println(object: "Image is nil in list.")
            }
    }
    
}
