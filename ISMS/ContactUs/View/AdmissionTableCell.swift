//
//  AdmissionTableCell.swift
//  ISMS
//
//  Created by Poonam  on 09/06/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import Foundation
class AdmissionTableCell : UITableViewCell{
    
    @IBOutlet weak var btnMinus: UIButton!
    @IBOutlet weak var addMoreBtn: UIButton!
    @IBOutlet weak var txtFieldEmail: UITextField!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var txtFieldPhoneNum: UITextField!
    @IBOutlet weak var lblPhoneNum: UILabel!
    
    func setCellUI(data :[[String:Any]]?,indexPath: IndexPath){
       
//       let rsltData = data?[indexPath.row]
      
       
       
       //Set buttons tag
       btnMinus.tag = indexPath.row
        addMoreBtn.tag = indexPath.row
      
        if data?.count ?? 0 > 0{
            if data?.count == indexPath.row{
                txtFieldPhoneNum.text = ""
                txtFieldEmail.text = ""
                btnMinus.isHidden = true
                addMoreBtn.isHidden = false
            }else{
                if let phoneNum = (data?[indexPath.row] as! NSDictionary).value(forKey: "AdmissionNumber") as? String{
                          txtFieldPhoneNum.text = phoneNum
                      }
                if let email = (data?[indexPath.row] as! NSDictionary).value(forKey: "AdmissionEmail") as? String{
                    txtFieldEmail.text = email
                }
                btnMinus.isHidden = false
                addMoreBtn.isHidden = true
            }
        }
   }
}
