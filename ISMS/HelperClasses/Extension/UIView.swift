//
//  UIView.swift
//  LatestArchitechtureDemo
//
//  Created by Atinder Kaur on 5/23/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
//MARK: UIView Extension Method

extension UIView{
    /*
     Create Shadow of the View
     */
    func CreateBoundryShadowOfView(shadowOpacity:Float,shadowColor: CGColor)
    {
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowRadius = 8.0
        self.layer.shadowColor = shadowColor
        self.clipsToBounds = false
    }
    
    /*
     Circle the image
     */
    func createCircleImage(){
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
    }
    
    /*
     Create round corner and set shadow
     */
    func addViewCornerShadow(radius: Int,view:UIView){
        let opacity = 0.2
        view.layer.masksToBounds = false;
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.layer.cornerRadius = 8;
        view.layer.shadowRadius = 8;
        view.layer.shadowOpacity = Float(opacity);
    }
    
    
    /*
     Set string first character on the image in ios swift
     */
    func setFirstCharacterCenterTheImage(text: String,imgView:UIImageView,imgColour:UIColor,ishide : Bool){
        
        let label = UILabel()
        label.frame = CGRect.init(x: imgView.frame.width/2, y: imgView.frame.height/2, width: 60, height: 40)
        label.text = text.first?.description
        imgView.image = nil
        imgView.backgroundColor = imgColour
        label.textColor = UIColor.white
        imgView.addSubview(label)
        
        if ishide == true{
            label.isHidden = true
            label.removeFromSuperview()
        }else{
            label.isHidden = false
        }
    }
    
}
