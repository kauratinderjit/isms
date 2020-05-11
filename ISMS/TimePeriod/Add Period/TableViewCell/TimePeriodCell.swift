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
    @IBOutlet weak var btnAddMorePeriod: UIButton!
    
    
    
    func setUI () {
        viewPeriod.addViewCornerShadow(radius: 8, view: viewPeriod)
        txtFieldPeriodTitle.addViewCornerShadow(radius: 8, view: txtFieldPeriodTitle)
        txtFieldPeriodEndTime.addViewCornerShadow(radius: 8, view: txtFieldPeriodEndTime)
        txtFieldPeriodStartTime.addViewCornerShadow(radius: 8, view: txtFieldPeriodStartTime)
        //setCellUIArray(indexPath: indexPath, PeriodListArray: items)
    }
    func setData(PeriodListArray:[PeriodsListData],indexPath:IndexPath) {
        
        btnPlusMinus.tag = indexPath.row
        StartTime.tag = indexPath.row
        btnEndTime.tag = indexPath.row
        btnAddMorePeriod.tag = indexPath.row
        
        if PeriodListArray.count == 0 {
            btnPlusMinus.isHidden = true
             btnAddMorePeriod.isHidden = false
            btnPlusMinus.setImage(UIImage(named: "MinusIcon"), for: UIControl.State.normal)
            self.txtFieldPeriodTitle.text  = "Period 1"
            self.txtFieldPeriodEndTime.text = ""
            self.txtFieldPeriodStartTime.text = ""
        }
        else{
            btnPlusMinus.isHidden = false
            if let endTime = PeriodListArray[indexPath.row].strEndTime {
                if endTime != "" {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "HH:mm"
                    dateFormatter.locale = Locale.current
                    
                    if let endtime = dateFormatter.date(from: endTime) {
                        print(endtime)
                        dateFormatter.dateFormat = KConstants.kTime
                        let eendtime = dateFormatter.string(from: endtime)
                        print(eendtime)
                        txtFieldPeriodEndTime.text = eendtime
                    }
                    else{
                        txtFieldPeriodEndTime.text = endTime
                    }
                }
                else{
                    txtFieldPeriodEndTime.text = endTime
                }
            }
            if let startTime = PeriodListArray[indexPath.row].strStartTime {
                
                let dateFormatter1 = DateFormatter()
                dateFormatter1.dateFormat = "HH:mm"
                dateFormatter1.locale = Locale.current
                
                if let starttime = dateFormatter1.date(from: startTime){
                    
                    print(starttime)
                    dateFormatter1.dateFormat = KConstants.kTime
                    let sstarttime = dateFormatter1.string(from: starttime)
                    print(sstarttime)
                    txtFieldPeriodStartTime.text = sstarttime
                }
                else {
                    txtFieldPeriodStartTime.text = startTime
                }
            }
            
            
            if indexPath.row == PeriodListArray.count-1{
                //                btnPlusMinus.setImage(UIImage(named: "addIcon"), for: UIControl.State.normal)
                btnAddMorePeriod.isHidden = false
            }else {
                btnPlusMinus.setImage(UIImage(named: kImages.kMinusIcon), for: UIControl.State.normal)
                btnAddMorePeriod.isHidden = true
            }
            //            setData
            //Gurleen
            // if let title = PeriodListArray[indexPath.row].title{
            //txtFieldPeriodTitle.text = title
            //}
            var dd = PeriodListArray[indexPath.row]
            dd.title = "Period" + " " +  "\(indexPath.row + 1)"
            
            txtFieldPeriodTitle.text =  dd.title
            
        }
        
        
    }
}
