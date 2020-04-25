//
//  MenuTableViewCell.swift
//  ISMS
//
//  Created by Taranjeet Singh on 6/19/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var lblRowTitle: UILabel!
    @IBOutlet weak var imgViewRow: UIImageView!
    @IBOutlet weak var viewBG: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       // imgViewRow.createCircleImage()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setData(_ menuArr: GetMenuFromRoleIdModel.ResultData?,_ indexPath: IndexPath){
        
        if let data = menuArr{
            let title = data.pageName
            lblRowTitle.text = title
            lblRowTitle.numberOfLines = 0
            if let theme = ThemeManager.shared.currentTheme{
                viewBG.backgroundColor = theme.mainColor
            }
            imgViewRow.sd_setImage(with: URL.init(string: data.ImageUrl ?? "")) { (img, error, cacheType, url) in
                 if error == nil{
                    self.imgViewRow.contentMode = .scaleAspectFit
                     self.imgViewRow.image = img
                }
                 else{
                 CommonFunctions.sharedmanagerCommon.addLabelOnTheImgeViewWithFirstCharacter(string: title ?? "", imgView: self.imgViewRow)
                }
            }
            
                       
            
           
            
        }else{
            debugPrint("There is no data.")
        }
    }
    
}
