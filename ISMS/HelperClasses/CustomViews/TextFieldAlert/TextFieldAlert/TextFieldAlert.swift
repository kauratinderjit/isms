//
//  TextFieldAlert.swift
//  ISMS
//
//  Created by Poonam Sharma on 7/3/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation

protocol TextFieldAlertDelegate:class {
    func BtnTxt()
    func btnCancel()
}

class TextFieldAlert : UIView {
    class func instanceFromNib() -> TextFieldAlert {
        return UINib(nibName: "CommonTextFieldAlert", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! TextFieldAlert
    }
    weak var delegate : TextFieldAlertDelegate?
    
    
    @IBOutlet weak var txtFieldVal: UITextField!
    @IBOutlet weak var BtnTxt: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var contentView: UIView!
    
   
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var parentContentView: UIView!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @IBAction func SubmitBtnAct(_ sender: Any) {
        delegate?.BtnTxt()
    }
    
    @IBAction func BtnCancel(_ sender: Any) {
        delegate?.btnCancel()
        self.removeFromSuperview()
    }
    
    
}
