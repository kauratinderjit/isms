//
//  StudentListTableCell.swift
//  ISMS
//
//  Created by Poonam Sharma on 6/26/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
import SDWebImage

class StudentListTableCell: UITableViewCell{
    
    @IBOutlet weak var StudentName: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var studentImg: UIImageView!
    
    @IBOutlet weak var classNamelbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setCellUI(data : [GetStudentResultData]?,indexPath: IndexPath){
        
//        if let userName = UserDefaults.standard.value(forKey: UserDefaultKeys.userRoleName.rawValue)  as?  String{
//            if userName == KConstants.kHod{
//                deleteBtn.isHidden = true
//                editBtn.isHidden = true
//            }
//        }
        
        let rsltData = data![indexPath.row]
        StudentName.text = ""
        
        studentImg.createCircleImage()
        
        //Set buttons tag
        editBtn.tag = indexPath.row
        deleteBtn.tag = indexPath.row
        
        if let className = rsltData.className{
            classNamelbl.text = className
        }
        
        if let firstname = rsltData.studentFirstName{
            StudentName.text = firstname
        }
        
        if let lastname = rsltData.studentLastName{
            StudentName.text?.append(" " + lastname)
        }
        
        if let imgProfileUrl = rsltData.studentImageURL{
            studentImg.sd_imageIndicator = SDWebImageActivityIndicator.gray
            studentImg.sd_setImage(with: URL.init(string: imgProfileUrl)) { (img, error, cacheType, url) in
                
                if error == nil{
                    print("error is NilLiteralConvertible")
                    self.studentImg.contentMode = .scaleAspectFill
                    self.studentImg.image = img
                }else{
                    if let nameStr = rsltData.studentFirstName{
                        CommonFunctions.sharedmanagerCommon.addLabelOnTheImgeViewWithFirstCharacter(string: nameStr, imgView: self.studentImg)
                        CommonFunctions.sharedmanagerCommon.println(object: "Image is nil in list.")
                    }
                }
            }
        }else{
            if let nameStr = rsltData.studentFirstName{
                CommonFunctions.sharedmanagerCommon.addLabelOnTheImgeViewWithFirstCharacter(string: nameStr, imgView: self.studentImg)
                CommonFunctions.sharedmanagerCommon.println(object: "Image is nil in list.")
            }
        }
    }
}
