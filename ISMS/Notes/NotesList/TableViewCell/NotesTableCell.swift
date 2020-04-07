//
//  NotesTableCell.swift
//  ISMS
//
//  Created by Poonam Sharma on 27/3/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import Foundation

class NotesTableCell : UITableViewCell{
    
    @IBOutlet weak var lblNotesName: UILabel!
    
    func setCellUI(data : [String]?,indexPath: IndexPath){
        
        let rsltData = data![indexPath.row]
        lblNotesName.text = rsltData
        
        //Set buttons tag
//        editBtn.tag = indexPath.row
//        deleteBtn.tag = indexPath.row
        
//        if let userName = UserDefaults.standard.value(forKey: UserDefaultKeys.userRoleName.rawValue)  as?  String{
//            if userName == KConstants.kHod{
//                deleteBtn.isHidden = true
//                editBtn.isHidden = true
//            }
//        }
        
//        if let notesName = rsltData{
//            lblNotesName.text = notesName
//        }
    }
}
