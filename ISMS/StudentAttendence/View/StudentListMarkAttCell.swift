//
//  StudentListMarkAttCell.swift
//  ISMS
//
//  Created by Poonam Sharma on 12/3/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
import SDWebImage

protocol StudentListMarkAttCellDelegate : class {
    func didPressBtnPresent(_ tag: Int)
    func didPressBtnAbsent(_ tag: Int)
    
}


class StudentListMarkAttCell: UITableViewCell{
    var cellDelegate: StudentListMarkAttCellDelegate?
    
    @IBOutlet weak var StudentPresent: UIButton!
    @IBOutlet weak var studentAbsent: UIButton!
    @IBOutlet weak var nameStudent: UILabel!
    @IBOutlet weak var imgStudent: UIImageView!
    
    var studentData  = [GetStudentListForAttResultData]()
    
    func setCellUI(data : [GetStudentListForAttResultData]?,indexPath: IndexPath, isFromHODVal: Bool?){
        studentData = data!
        let rsltData = data![indexPath.row]
        nameStudent.text = ""
        
        imgStudent.createCircleImage()
        
        //Set buttons tag
        StudentPresent.tag = indexPath.row
        studentAbsent.tag = indexPath.row
        
        if rsltData.isSelected == 1{
            StudentPresent.backgroundColor = KAPPContentRelatedConstants.kGreenColor
            studentAbsent.backgroundColor = .clear
        }else if rsltData.isSelected == 2{
            StudentPresent.backgroundColor = .clear
            studentAbsent.backgroundColor = KAPPContentRelatedConstants.kRedColor
        }else{
            if rsltData.status == "P"{
                StudentPresent.backgroundColor = KAPPContentRelatedConstants.kGreenColor
                studentAbsent.backgroundColor = .clear
            }else if rsltData.status == "A"{
                StudentPresent.backgroundColor = .clear
                studentAbsent.backgroundColor = KAPPContentRelatedConstants.kRedColor
            }else{
                StudentPresent.backgroundColor = .clear
                studentAbsent.backgroundColor = .clear
            }
        }
        
        
        if let studentName = rsltData.studentName{
            nameStudent.text = studentName
        }
        
        if let imgProfileUrl = rsltData.imageUrl{
            imgStudent.sd_imageIndicator = SDWebImageActivityIndicator.gray
            imgStudent.sd_setImage(with: URL.init(string: imgProfileUrl)) { (img, error, cacheType, url) in
                
                if error == nil{
                    print("error is NilLiteralConvertible")
                    self.imgStudent.contentMode = .scaleAspectFill
                    self.imgStudent.image = img
                }else{
                    if let nameStr = rsltData.studentName{
                        CommonFunctions.sharedmanagerCommon.addLabelOnTheImgeViewWithFirstCharacter(string: nameStr, imgView: self.imgStudent)
                        //                        CommonFunctions.sharedmanagerCommon.println(object: "Image is nil in list.")
                    }
                }
            }
        }else{
            if let nameStr = rsltData.studentName{
                CommonFunctions.sharedmanagerCommon.addLabelOnTheImgeViewWithFirstCharacter(string: nameStr, imgView: self.imgStudent)
                //                CommonFunctions.sharedmanagerCommon.println(object: "Image is nil in list.")
            }
        }
    }
    
    @IBAction func actionPresent(_ sender: Any) {
        
        cellDelegate?.didPressBtnPresent((sender as AnyObject).tag)
    }
    
    
    @IBAction func actionAbsent(_ sender: Any) {
        cellDelegate?.didPressBtnAbsent((sender as AnyObject).tag)
    }
    
}
