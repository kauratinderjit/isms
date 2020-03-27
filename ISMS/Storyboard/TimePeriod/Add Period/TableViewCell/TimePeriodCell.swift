//
//  TimePeriodCell.swift
//  ISMS
//
//  Created by Poonam Sharma on 7/8/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
class TimePeriodCell: UITableViewCell {
    
    @IBOutlet weak var viewPeriod: UIView!
    
    @IBOutlet weak var txtFieldPeriodTitle: UITextField!
    
    @IBOutlet weak var txtFieldPeriodStartTime: UITextField!
    @IBOutlet weak var btnEndTime: UIButton!
    @IBOutlet weak var StartTime: UIButton!
    @IBOutlet weak var btnPlusMinus: UIButton!
    @IBOutlet weak var txtFieldPeriodEndTime: UITextField!
    @IBOutlet weak var btnCancelPeriod: UIButton!
    
    func setCellUI(indexPath: IndexPath, startTime: String, time: String, PeriodListArray: [[String:Any]]){
        
  txtFieldPeriodStartTime?.text = ""
        txtFieldPeriodEndTime.text = ""
        //Set buttons tag
        btnPlusMinus.tag = indexPath.row
        btnCancelPeriod.tag = indexPath.row
      
//            if time == KConstants.kstartTime{
//                txtFieldPeriodStartTime?.text = startTime
//            }else if time == KConstants.kendTime{
//                txtFieldPeriodEndTime.text = startTime
//            }
        
        
        if PeriodListArray.count > indexPath.row{
            if let endTime = PeriodListArray[indexPath.row][KConstants.kendTime]{
                txtFieldPeriodEndTime.text = endTime as? String
            }
            if let startTime = PeriodListArray[indexPath.row][KConstants.kstartTime]{
                txtFieldPeriodStartTime.text = startTime as? String
            }
        }else{
            btnPlusMinus.setImage(UIImage(named: "addIcon"), for: UIControl.State.normal)
            btnCancelPeriod.isHidden = false
        }
    }
    
    func setCellUIArray(indexPath: IndexPath, PeriodListArray: [[String:Any]]){
        btnPlusMinus.tag = indexPath.row
        btnCancelPeriod.tag = indexPath.row
        if let title = PeriodListArray[indexPath.row][KConstants.kPeriodTitle]{
            txtFieldPeriodTitle.text = title as? String
        }
        if let endTime = PeriodListArray[indexPath.row][KConstants.kendTime]{
            txtFieldPeriodEndTime.text = endTime as? String
        }
        if let startTime = PeriodListArray[indexPath.row][KConstants.kstartTime]{
            txtFieldPeriodStartTime.text = startTime as? String
        }
        if indexPath.row == PeriodListArray.count-1{
            btnPlusMinus.setImage(UIImage(named: "addIcon"), for: UIControl.State.normal)
            btnCancelPeriod.isHidden = false
        }else{
              btnPlusMinus.setImage(UIImage(named: kImages.kMinusIcon), for: UIControl.State.normal)
              btnCancelPeriod.isHidden = true
        }
       
    }
}
