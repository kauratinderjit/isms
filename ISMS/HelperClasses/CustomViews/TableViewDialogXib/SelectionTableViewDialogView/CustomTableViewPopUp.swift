//
//  CustomTableViewPopUp.swift
//  ISMS
//
//  Created by Taranjeet Singh on 7/4/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

protocol CustomTableViewPopUpDelegate: class{
    func submitButton()
}

class CustomTableViewPopUp: UIView {

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var labelTableViewTitle: UILabel!
    
    weak var delegate : CustomTableViewPopUpDelegate?

    @IBOutlet weak var contentView: UIView!
    class func instanceFromNib() -> CustomTableViewPopUp {
        return UINib(nibName: "CustomTableViewPopUp", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomTableViewPopUp
    }
    
    @IBAction func btnActionSubmit(_ sender: UIButton) {
        delegate?.submitButton()
    }
    
}
