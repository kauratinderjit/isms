//
//  StudentCollectionViewCell.swift
//  ISMS
//
//  Created by Poonam Sharma on 30/4/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import Foundation
import SDWebImage

class StudentCollectionViewCell : UICollectionViewCell{
    
    @IBOutlet weak var lblStudentName: UILabel!
    @IBOutlet weak var imageViewStudent: UIImageView!
    
    func setCellUI(data :[StudentResultData]?,indexPath: IndexPath){
        
        let rsltData = data?[indexPath.row]
        lblStudentName.text = rsltData?.studentName
        
        
        //Set buttons tag
    
        
        imageViewStudent.createCircleImage()
        
     
        if let imgProfileUrl = rsltData?.studentImageUrl{
            imageViewStudent.sd_imageIndicator = SDWebImageActivityIndicator.gray
            
            imageViewStudent.sd_setImage(with: URL.init(string: imgProfileUrl)) { (img, error, cacheType, url) in
                
                if error == nil{
                    print("error is NilLiteralConvertible")
                    self.imageViewStudent.contentMode = .scaleAspectFill
                
                    self.imageViewStudent.image =  img
                }else{
                    if let nameStr = rsltData?.studentImageUrl{
                        CommonFunctions.sharedmanagerCommon.addLabelOnTheImgeViewWithFirstCharacter(string: nameStr, imgView: self.imageViewStudent)
                        CommonFunctions.sharedmanagerCommon.println(object: "Image is nil in list.")
                    }
                }
            }
        }else{
            if let nameStr = rsltData?.studentName{
                CommonFunctions.sharedmanagerCommon.addLabelOnTheImgeViewWithFirstCharacter(string: nameStr, imgView: self.imageViewStudent)
                CommonFunctions.sharedmanagerCommon.println(object: "Image is nil in list.")
            }
        }
        
        
    }
    
    
    func setCellUIDept(data :[departmentList]?,indexPath: IndexPath){
        let rsltData = data?[indexPath.row]
        lblStudentName.text = rsltData?.departmentName
        //Set buttons tag
        imageViewStudent.createCircleImage()
        
        if let imgProfileUrl = rsltData?.deptImage{
            imageViewStudent.sd_imageIndicator = SDWebImageActivityIndicator.gray
            
            imageViewStudent.sd_setImage(with: URL.init(string: imgProfileUrl)) { (img, error, cacheType, url) in
                
                if error == nil{
                    print("error is NilLiteralConvertible")
                    self.imageViewStudent.contentMode = .scaleAspectFill
                    
                    self.imageViewStudent.image =  img
                }else{
                    if let nameStr = rsltData?.deptImage{
                        CommonFunctions.sharedmanagerCommon.addLabelOnTheImgeViewWithFirstCharacter(string: nameStr, imgView: self.imageViewStudent)
                        CommonFunctions.sharedmanagerCommon.println(object: "Image is nil in list.")
                    }
                }
            }
        }else{
            if let nameStr = rsltData?.deptImage{
                CommonFunctions.sharedmanagerCommon.addLabelOnTheImgeViewWithFirstCharacter(string: nameStr, imgView: self.imageViewStudent)
                CommonFunctions.sharedmanagerCommon.println(object: "Image is nil in list.")
            }
        }
    }
}
