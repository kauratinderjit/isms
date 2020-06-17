//
//  AssignSubjectTeacherCell.swift
//  ISMS
//
//  Created by Gagan on 09/06/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import Foundation
import SDWebImage

class AssignSubjectTeacherCell: UITableViewCell{
    
    @IBOutlet weak var SubjectName: UILabel!
    
    
    @IBOutlet weak var checkBtn: UIButton!
    
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
    
    func setCellUI(data : [GetSubjectListResultData]?,indexPath: IndexPath){
        
//        if let userName = UserDefaults.standard.value(forKey: UserDefaultKeys.userRoleName.rawValue)  as?  String{
//            if userName == KConstants.kHod{
//                deleteBtn.isHidden = true
//                editBtn.isHidden = true
//            }
//        }
        
        guard let rsltData = data?[indexPath.row] else{return}
        
        SubjectName.text = ""
        
        studentImg.createCircleImage()
        
        //Set buttons tag
        self.checkBtn.tag = indexPath.row
        
        if let subjectname = rsltData.subjectName{
            SubjectName.text = subjectname
        }
        
        if let nameStr = rsltData.subjectName{
            CommonFunctions.sharedmanagerCommon.addLabelOnTheImgeViewWithFirstCharacter(string: nameStr, imgView: self.studentImg)
            CommonFunctions.sharedmanagerCommon.println(object: "Image is nil in list.")
        }
        
        
//        if let imgProfileUrl = rsltData.studentImageURL{
//            studentImg.sd_imageIndicator = SDWebImageActivityIndicator.gray
//            studentImg.sd_setImage(with: URL.init(string: imgProfileUrl)) { (img, error, cacheType, url) in
//
//                if error == nil{
//                    print("error is NilLiteralConvertible")
//                    self.studentImg.contentMode = .scaleAspectFill
//                    self.studentImg.image = img
//                }else{
//                    if let nameStr = rsltData.studentFirstName{
//                        CommonFunctions.sharedmanagerCommon.addLabelOnTheImgeViewWithFirstCharacter(string: nameStr, imgView: self.studentImg)
//                        CommonFunctions.sharedmanagerCommon.println(object: "Image is nil in list.")
//                    }
//                }
//            }
//        }else{

//        }
    }
}
