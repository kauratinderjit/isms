//
//  ClassListTableViewCell.swift
//  ISMS
//
//  Created by Taranjeet Singh on 6/18/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit
import SDWebImage

class ClassListTableViewCell: UITableViewCell {

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
    
    func setCellUI(data :[GetClassListResultData]?,indexPath: IndexPath){
        
        let rsltData = data?[indexPath.row]
        lblTitle.text = ""
        
        
        //Set buttons tag
        btnEdit.tag = indexPath.row
        btnDelete.tag = indexPath.row
        
        imgViewLogo.createCircleImage()
        
        if let strTitle = rsltData?.name{
            lblTitle.text = strTitle
        }
       
        if let imgProfileUrl = rsltData?.logoUrl{
            imgViewLogo.sd_imageIndicator = SDWebImageActivityIndicator.gray

            imgViewLogo.sd_setImage(with: URL.init(string: imgProfileUrl)) { (img, error, cacheType, url) in
                
                if error == nil{
                    print("error is NilLiteralConvertible")
                    self.imgViewLogo.contentMode = .scaleAspectFill
                    self.imgViewLogo.image = img
                }else{
                    if let nameStr = rsltData?.name{
                        CommonFunctions.sharedmanagerCommon.addLabelOnTheImgeViewWithFirstCharacter(string: nameStr, imgView: self.imgViewLogo)
                        CommonFunctions.sharedmanagerCommon.println(object: "Image is nil in list.")
                    }
                }
            }
        }else{
            if let nameStr = rsltData?.name{
                CommonFunctions.sharedmanagerCommon.addLabelOnTheImgeViewWithFirstCharacter(string: nameStr, imgView: self.imgViewLogo)
                CommonFunctions.sharedmanagerCommon.println(object: "Image is nil in list.")
            }
        }
        
       
    }
    
}
