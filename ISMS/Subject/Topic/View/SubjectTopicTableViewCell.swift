//
//  SubjectTopicTableViewCell.swift
//  ISMS
//
//  Created by Kuldeep Singh on 11/25/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

protocol  SubjectTopicTableViewDelegate {
    
    func didPressDeleteButton(_ tag: Int)
    func didPressEditButton(_ tag: Int)
    
}


class SubjectTopicTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTxt: UILabel!
    
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    
      var cellDelegate: SubjectTopicTableViewDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

    func setCellUI(data : GetTopicResultData,indexPath: IndexPath){
        
        //Set buttons tag
        editBtn.tag = indexPath.row
        deleteBtn.tag = indexPath.row
        if let txt = data.topicName {
        lblTxt.text = txt
        }
        //imgView.layer.cornerRadius = imgView.frame.height / 2
        imgView.createCircleImage()
          if let txt = data.topicName {
            CommonFunctions.sharedmanagerCommon.addLabelOnTheImgeViewWithFirstCharacter(string: txt , imgView: imgView)
        }
    }
    
    @IBAction func ActionDelete(_ sender: UIButton) {
        cellDelegate?.didPressDeleteButton(sender.tag)
        
        
    }
    
    @IBAction func ActionEdit(_ sender: Any) {
        
        cellDelegate?.didPressEditButton((sender as AnyObject).tag)
    }
    
}
