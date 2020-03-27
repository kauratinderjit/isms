//
//  UserRoleTableCell.swift
//  ISMS
//
//  Created by Poonam Sharma on 7/4/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation

typealias selectUserRoleFromCellBlock = () -> Void?

class UserRoleTableCell: UITableViewCell{
    
    @IBOutlet weak var viewCell: UIView!
    @IBOutlet weak var BtnRoleName: UIButton!
    
    //For Home Multi Role PopUp
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var btnRole: UIButton!

    var selectUserRoleCellBlock : selectUserRoleFromCellBlock?
    
    var allUserRoles : UserRoleIdModel.ResultData?{
        didSet{
            btnRole.setTitle(allUserRoles?.roleName, for: .normal)
            viewBg.addViewCornerShadow(radius: 12, view: viewBg)

        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setCellUI(data : UserRoleIdModel?,indexPath: IndexPath){
        guard let theme = ThemeManager.shared.currentTheme else {return}

        BtnRoleName.addViewCornerShadow(radius: 8, view: BtnRoleName)
        BtnRoleName.backgroundColor = theme.uiButtonBackgroundColor
        BtnRoleName.titleLabel?.textColor = theme.uiButtonTextColor
        let rsltData = data?.resultData?[indexPath.row]
        //Set buttons tag
        BtnRoleName.tag = indexPath.row
        
        if let roleName = rsltData?.roleName{
           BtnRoleName.setTitle(roleName, for: .normal)
        }
   
    }
    
    
    func setHomeCellData(data: UserRoleIdModel?,indexPath: IndexPath){
        
    }
    
    @IBAction func tapOnSelectRoleBtnAction(_ sender: Any) {
        selectUserRoleCellBlock?()
    }
    
}
