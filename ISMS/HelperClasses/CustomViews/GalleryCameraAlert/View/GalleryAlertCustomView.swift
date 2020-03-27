//
//  GalleryAlertCustomView.swift
//  ISMS
//
//  Created by Taranjeet Singh on 6/28/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
import UIKit

protocol GalleryAlertCustomViewDelegate:class {
    func galleryBtnAction()
    func cameraButtonAction()
    func cancelButtonAction()
}

class GalleryAlertCustomView : UIView{
    
    class func instanceFromNib() -> GalleryAlertCustomView {
        return UINib(nibName: "GalleryAlert", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! GalleryAlertCustomView
    }
    
    weak var delegate : GalleryAlertCustomViewDelegate?
    
    @IBOutlet weak var btnGallery: UIButton!
    
    @IBOutlet weak var lblAlertTitle: UILabel!
    @IBOutlet weak var viewGallery: UIView!
    @IBOutlet weak var viewCamera: UIView!
    @IBOutlet weak var viewCancel: UIView!
    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var imgViewGallery: UIImageView!
    @IBOutlet weak var imgViewCamera: UIImageView!
    @IBOutlet weak var imgViewCancel: UIImageView!
    @IBOutlet weak var backgroundView: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    
   
    @IBAction func btnGalleryAction(_ sender: UIButton) {
        delegate?.galleryBtnAction()
    }
    
    @IBAction func btnCameraAction(_ sender: UIButton) {
        delegate?.cameraButtonAction()
    }
    
    @IBAction func btnActionCancel(_ sender: UIButton) {
        delegate?.cancelButtonAction()
    }
    
}
