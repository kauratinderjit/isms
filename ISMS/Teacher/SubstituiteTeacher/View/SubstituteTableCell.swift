//
//  SubstituteTableCell.swift
//  ISMS
//
//  Created by Poonam  on 01/07/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import Foundation
import SDWebImage

class SubstituteTableCell: UITableViewCell {


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
    
    func setCellUI(data :[GetSubstituteTeacherData]?,indexPath: IndexPath,isEdit:Bool,isDelete:Bool){
        
        let rsltData = data?[indexPath.row]
        lblTitle.text = ""
        imgViewLogo.createCircleImage()
        
//        if isEdit == true
//        {
//            btnEdit.isHidden = false
//        }
//        else
//        {
//            btnEdit.isHidden = true
//        }
//        if(isDelete == true){
//            btnDelete.isHidden = false
//            kDeleteButtonWidth.constant = 35
//        }else{
//            btnDelete.isHidden = true
//            kDeleteButtonWidth.constant = 0
//        }
        
        //Set buttons tag
        btnDelete.tag = indexPath.row
        
        if let firstname = rsltData?.teacherName{
            lblTitle.text = firstname
        }
        
   
            if let nameStr = rsltData?.teacherName{
                CommonFunctions.sharedmanagerCommon.addLabelOnTheImgeViewWithFirstCharacter(string: nameStr, imgView: self.imgViewLogo)
                CommonFunctions.sharedmanagerCommon.println(object: "Image is nil in list.")
            }
    }
}

