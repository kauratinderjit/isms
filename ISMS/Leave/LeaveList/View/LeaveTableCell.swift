//
//  LeaveTableCell.swift
//  ISMS
//
//  Created by Poonam  on 08/06/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//
//LeaveTableCell
import Foundation

class LeaveTableCell : UITableViewCell{
    
    @IBOutlet weak var imgLeave: UIImageView!
    @IBOutlet weak var lbldecLeave: UILabel!
    @IBOutlet weak var lblLeaveStatus: UILabel!
    
    @IBOutlet weak var btnEdit: UIButton!
    
    func setCellUI(data :[GetLeaveListResultData]?,indexPath: IndexPath){
           
           let rsltData = data?[indexPath.row]
           lblLeaveStatus.text = ""
           
           
           //Set buttons tag
           btnEdit.tag = indexPath.row
           
           imgLeave.createCircleImage()
           
        if let leaveType = rsltData?.leaveAppType{
               lblLeaveStatus.text = leaveType
           }
        
        if let leaveStatus = rsltData?.status{
                lbldecLeave.text = leaveStatus
            }
     
               if let nameStr = rsltData?.leaveAppType{
    CommonFunctions.sharedmanagerCommon.addLabelOnTheImgeViewWithFirstCharacter(string: nameStr, imgView: self.imgLeave)
                   CommonFunctions.sharedmanagerCommon.println(object: "Image is nil in list.")
               }
       }
    
}
