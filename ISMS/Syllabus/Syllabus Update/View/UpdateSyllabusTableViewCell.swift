//
//  UpdateSyllabusTableViewCell.swift
//  ISMS
//
//  Created by Kuldeep Singh on 11/18/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

protocol UpdateSyllabusTableViewCellDelegate {
    
   func didPressButton(_ tag: Int)
    
}
typealias checkboxButtonBlock = () -> Void

class UpdateSyllabusTableViewCell: UITableViewCell {

    @IBOutlet var lblTopic: UILabel!
     @IBOutlet var btnCheckBox: UIButton!
    var cellDelegate: UpdateSyllabusTableViewCellDelegate?
    var checkboxbuttonTapped : checkboxButtonBlock?
   var array = [UpdateSyllabusResultData]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        if let userName = UserDefaultExtensionModel.shared.currentHODRoleName  as?  String{
                        if userName == KConstants.kHod{
                            btnCheckBox.isHidden = true
                        }
    }
    }
    
  

    @IBAction func ActionCheckBox(_ sender: UIButton) {
       
         cellDelegate?.didPressButton(sender.tag)
        
    }
    

}
