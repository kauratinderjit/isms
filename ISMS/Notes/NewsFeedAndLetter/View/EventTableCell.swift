//
//  EventTableCell.swift
//  ISMS
//
//  Created by Navalpreet Kaur on 12/2/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit
import PaddingLabel

class EventTableCell: UITableViewCell {
    
    //MARK:- Outlet and Variables
    @IBOutlet weak var viewCellBack: UIView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgViewProfile: UIImageView!
    @IBOutlet weak var customCollectionView: UICollectionView!
    @IBOutlet weak var btnComments: UIButton!
    @IBOutlet weak var btnLikes: UIButton!
    @IBOutlet weak var btnShare: UIImageView!
    @IBOutlet weak var btnReport: UIButton!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var lblDescription: PaddingLabel!
    @IBOutlet weak var btnLikerList: UIButton!
    @IBOutlet weak var heightCollectionView: NSLayoutConstraint!
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var imgReport: UIImageView!
    @IBOutlet weak var heightCollectionViewTag: NSLayoutConstraint!
    @IBOutlet weak var collectionViewTag: UICollectionView!
    
    @IBOutlet weak var imgComment: UIImageView!
    @IBOutlet weak var btnCorr: UIButton!
    @IBOutlet weak var topSpaceCollImages: NSLayoutConstraint!
    @IBOutlet weak var viewTypeMem: UIView!
    @IBOutlet weak var heightBGGView: NSLayoutConstraint!
    @IBOutlet weak var viewBGG: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
         self.customCollectionView.isPagingEnabled = true
        setUI ()
    }
    
    //MARK:- other functions
    func setUI ()
    {
        viewCellBack.layer.shadowOffset = CGSize(width: 0, height: 0)
         viewCellBack.layer.shadowColor = UIColor.black.cgColor
         viewCellBack.layer.shadowRadius = 5
         viewCellBack.layer.shadowOpacity = 0.40
         viewCellBack.layer.masksToBounds = false;
         viewCellBack.clipsToBounds = false;
        if collectionViewTag != nil {
       collectionViewTag.clipsToBounds = true;
            
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
