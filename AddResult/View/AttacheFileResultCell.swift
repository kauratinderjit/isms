//
//  AttacheFileResultCell.swift
//  ISMS
//
//  Created by Poonam  on 26/06/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import Foundation
import SDWebImage

class AttacheFileResultCell: UICollectionViewCell {
    
    @IBOutlet weak var btn_cross: UIButton!
    @IBOutlet weak var imageview_attachedFiles: UIImageView!
    //MARK:- Functions
    
    func setDataCell(){
            imageview_attachedFiles.image = UIImage(named: "pdf")
}

}
