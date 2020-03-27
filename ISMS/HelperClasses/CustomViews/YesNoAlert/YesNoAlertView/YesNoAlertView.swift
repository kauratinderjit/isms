//
//  YesNoAlertView.swift
//  ISMS
//
//  Created by Taranjeet Singh on 6/28/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
import UIKit

protocol YesNoAlertViewDelegate:class {
    func yesBtnAction()
    func noBtnAction()
}

class YesNoAlertView : UIView{
    
    class func instanceFromNib() -> YesNoAlertView {
        return UINib(nibName: "YesNoAlert", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! YesNoAlertView
    }
    
    weak var delegate : YesNoAlertViewDelegate?
    @IBOutlet weak var yesBtn: UIButton!
    @IBOutlet weak var noBtn: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    
    
    @IBOutlet weak var lblAlertTitle: UILabel!
    @IBOutlet weak var lblResponseDetailMessage: UILabel!
    @IBOutlet weak var contentView: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @IBAction func btnYesAction(_ sender: UIButton) {
        delegate?.yesBtnAction()
    }
    
    @IBAction func btnNoAction(_ sender: UIButton) {
        delegate?.noBtnAction()
    }
    
}
