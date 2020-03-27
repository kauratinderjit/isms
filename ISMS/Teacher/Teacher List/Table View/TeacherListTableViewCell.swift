//
//  TeacherListTableViewCell.swift
//  ISMS
//
//  Created by Taranjeet Singh on 6/20/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit
import SDWebImage

class TeacherListTableViewCell: UITableViewCell {


    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgViewLogo: UIImageView!
    
    @IBOutlet weak var kDeleteButtonWidth: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setCellUI(data :[GetTeacherListResultData]?,indexPath: IndexPath,isEdit:Bool,isDelete:Bool){
        
        let rsltData = data?[indexPath.row]
        lblTitle.text = ""
        imgViewLogo.createCircleImage()
        
        if isEdit == true
        {
            btnEdit.isHidden = false
        }
        else
        {
            btnEdit.isHidden = true
        }
        if(isDelete == true){
            btnDelete.isHidden = false
            kDeleteButtonWidth.constant = 35
        }else{
            btnDelete.isHidden = true
            kDeleteButtonWidth.constant = 0
        }
        
        //Set buttons tag
        btnEdit.tag = indexPath.row
        btnDelete.tag = indexPath.row
        
        if let firstname = rsltData?.firstName{
            lblTitle.text = firstname
        }
        
        if let lastname = rsltData?.lastName{
            lblTitle.text?.append(" " + lastname)
        }
        
        
        
        
        if let imgProfileUrl = rsltData?.imageUrl{
            imgViewLogo.sd_imageIndicator = SDWebImageActivityIndicator.gray
            imgViewLogo.sd_setImage(with: URL.init(string: imgProfileUrl)) { (img, error, cacheType, url) in
                
                if error == nil{
                    print("error is NilLiteralConvertible")
                    self.imgViewLogo.contentMode = .scaleAspectFill
                    self.imgViewLogo.image = img
                }else{
                    if let nameStr = rsltData?.firstName{
                    CommonFunctions.sharedmanagerCommon.addLabelOnTheImgeViewWithFirstCharacter(string: nameStr, imgView: self.imgViewLogo)
                        CommonFunctions.sharedmanagerCommon.println(object: "Image is nil in list.")
                    }
                }
            }
        }else{
            if let nameStr = rsltData?.firstName{
                CommonFunctions.sharedmanagerCommon.addLabelOnTheImgeViewWithFirstCharacter(string: nameStr, imgView: self.imgViewLogo)
                CommonFunctions.sharedmanagerCommon.println(object: "Image is nil in list.")
            }
        }
    }
}

