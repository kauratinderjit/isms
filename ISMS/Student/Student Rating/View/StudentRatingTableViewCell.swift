//
//  StudentRatingTableViewCell.swift
//  ISMS
//
//  Created by Kuldeep Singh on 11/27/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit
import SDWebImage

class StudentRatingTableViewCell: UITableViewCell {

    @IBOutlet var imgStudent: UIImageView!
    
    @IBOutlet var lblStudentName: UILabel!
    
    @IBOutlet var lblPercentage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCellUI(data : [StudentRatingResultData]?,indexPath: IndexPath){
        
        if data?.count ?? 0 > 0 {
            let rsltData = data![indexPath.row]
            lblStudentName.text = ""
            
            imgStudent.createCircleImage()
            
            
            if let studentname = rsltData.studentName{
                lblStudentName.text = studentname
            }
            
            if let studentRating = rsltData.studentRating{
                lblPercentage.text = studentRating
            }
            
                    if var imgProfileUrl = rsltData.imageUrl{
                        imgStudent.sd_imageIndicator = SDWebImageActivityIndicator.gray
                        imgStudent.sd_setImage(with: URL.init(string: imgProfileUrl)) { (img, error, cacheType, url) in
            
                            if error == nil{
                                print("error is NilLiteralConvertible")
                                self.imgStudent.contentMode = .scaleAspectFill
                                self.imgStudent.image = img
                            }else{
                                if let nameStr = rsltData.studentName{
                                    CommonFunctions.sharedmanagerCommon.addLabelOnTheImgeViewWithFirstCharacter(string: nameStr, imgView: self.imgStudent)
                                    CommonFunctions.sharedmanagerCommon.println(object: "Image is nil in list.")
                                }
                            }
                        }
                    }else{
                        if let nameStr = rsltData.studentName{
                            CommonFunctions.sharedmanagerCommon.addLabelOnTheImgeViewWithFirstCharacter(string: nameStr, imgView: self.imgStudent)
                            CommonFunctions.sharedmanagerCommon.println(object: "Image is nil in list.")
                        }
            }
        }
        
      
    }

}
