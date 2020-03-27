//
//  SimpleOkAlert.swift
//  ISMS
//
//  Created by Taranjeet Singh on 6/28/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
import UIKit

protocol OKAlertViewDelegate:class {
    func okBtnAction()
}

class OKAlertView : UIView{
    
    class func instanceFromNib() -> OKAlertView {
        return UINib(nibName: "OkAlert", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! OKAlertView
    }
    
    weak var delegate : OKAlertViewDelegate?
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var btnOK: UIButton!
    
    @IBOutlet weak var lblAlertTitle: UILabel!
    @IBOutlet weak var lblResponseDetailMessage: UILabel!
    @IBOutlet weak var contentView: UIView!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @IBAction func btnOkAction(_ sender: UIButton) {
        
        delegate?.okBtnAction()
        
    }
    
    func responseMessage(text: String){
        lblResponseDetailMessage.text = text
    }
    
}
