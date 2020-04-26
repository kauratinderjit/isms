//
//  ViewRatingCell.swift
//  ISMS
//
//  Created by Poonam Sharma on 14/4/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import Foundation
import SDWebImage

class ViewRatingCell : UITableViewCell{
    
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var lblSubject: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblClass: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgStudent: UIImageView!
    
    func setCellUI(data : [GetViewTeacherRatingResult]?,indexPath: IndexPath){
        
        if data?.count ?? 0 > 0 {
            let rsltData = data![indexPath.row]
            lblName.text = ""
            
            imgStudent.createCircleImage()
            
            
            if let studentname = rsltData.studentName{
                lblName.text = studentname
            }
            
            if let subjectName = rsltData.subjectName{
                lblSubject.text = subjectName
            }
            
//            if let date = rsltData.date{
//                
//                let finalDate = self.dateFromISOString(string: rsltData.date)
//                lblDate.text = finalDate
//            }
            if let className = rsltData.className{
                lblClass.text = className
            }
            
            if let comment = rsltData.comment{
                lblComment.text = comment
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
