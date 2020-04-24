//
//  SubjectListTableCell.swift
//  ISMS
//
//  Created by Poonam Sharma on 7/1/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation

class SubjectListTableCell : UITableViewCell{
    
    @IBOutlet weak var subjectNamelbl: UILabel!
    
    
    @IBOutlet weak var deleteBtn: UIButton!
    
    @IBOutlet weak var editBtn: UIButton!
    
    func setCellUI(data : [GetSubjectResultData]?,indexPath: IndexPath){
        
        if data?.count ?? 0 > 0 {
        
        let rsltData = data![indexPath.row]
        subjectNamelbl.text = ""
        
        //Set buttons tag
        editBtn.tag = indexPath.row
        deleteBtn.tag = indexPath.row
        
        if let userName = UserDefaults.standard.value(forKey: UserDefaultKeys.userRoleName.rawValue)  as?  String{
            if userName == KConstants.kHod{
                deleteBtn.isHidden = true
                editBtn.isHidden = true
            }
        }
        
        if let subjectName = rsltData.subjectName{
            subjectNamelbl.text = subjectName
        }
    }
    }
}
