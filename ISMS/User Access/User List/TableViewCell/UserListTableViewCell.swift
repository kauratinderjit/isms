//
//  UserListTableViewCell.swift
//  ISMS
//
//  Created by Taranjeet Singh on 6/25/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation

class UserListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var btnMoveToAction: UIButton!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblUserRole: UILabel!
    @IBOutlet weak var imgViewUser: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setCellUI(data :[GetAllUserByRoleIdResultData]?,indexPath: IndexPath){
        
        let rsltdata = data?[indexPath.row]
        
        lblUserName.text = ""
        lblUserRole.text = ""
        
        
        //Set buttons tag
        btnMoveToAction.tag = indexPath.row
        
        imgViewUser.createCircleImage()
        
        if let strUsername = rsltdata?.userName{
            lblUserName.text = strUsername
        }
        
        if let strUserRoleId = rsltdata?.roleName{
            lblUserRole.text = strUserRoleId
        }
        
        
        if let imgProfileUrl = rsltdata?.imageUrl{
            
            imgViewUser.sd_setImage(with: URL.init(string: imgProfileUrl)) { (img, error, cacheType, url) in
                
                if error == nil{
                    print("error is NilLiteralConvertible")
                    self.imgViewUser.contentMode = .scaleAspectFill
                    self.imgViewUser.image = img
                }else{
                    if let strUsername = rsltdata?.userName{
                        CommonFunctions.sharedmanagerCommon.addLabelOnTheImgeViewWithFirstCharacter(string: strUsername, imgView: self.imgViewUser)
                        CommonFunctions.sharedmanagerCommon.println(object: "Image is nil in list.")
                    }
                }
            }
        }else{
            if let userName = rsltdata?.userName{
                CommonFunctions.sharedmanagerCommon.addLabelOnTheImgeViewWithFirstCharacter(string: userName, imgView: self.imgViewUser)
                CommonFunctions.sharedmanagerCommon.println(object: "Image is nil in list.")
            }
        }
        
        
    }
    
}
