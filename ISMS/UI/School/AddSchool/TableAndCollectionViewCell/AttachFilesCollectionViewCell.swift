//
//  AttachFilesCollectionViewCell.swift
//  ISMS
//  Cell
//  Created by Gurleen Osahan on 6/17/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit
import SDWebImage

class AttachFilesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var btn_cross: UIButton!
    @IBOutlet weak var imageview_attachedFiles: UIImageView!
    //MARK:- Functions
    
    func setDataCell( data: AttachedFiles){
        
        if data.type == "File"{
            imageview_attachedFiles.image = UIImage(named: "pdf")
        }
        else{
            if let attachment = data.instituteAttachmentName{
            if let imageURL = URL(string: attachment){
       
                imageview_attachedFiles.sd_setImage(with:imageURL , placeholderImage:UIImage(named:"profile"), options: [SDWebImageOptions.continueInBackground, SDWebImageOptions.lowPriority, SDWebImageOptions.refreshCached, SDWebImageOptions.handleCookies, SDWebImageOptions.retryFailed]) { (image, error, cacheType, url) in
                    if error != nil {
                        print("Failed")
                        }
                     else {
                        print("Success")
                    }
                }
        }
    }
    }
}

}
