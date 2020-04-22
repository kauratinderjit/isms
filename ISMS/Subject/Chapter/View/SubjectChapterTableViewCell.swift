//
//  SubjectChapterTableViewCell.swift
//  ISMS
//
//  Created by Kuldeep Singh on 11/18/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

protocol  SubjectChapterTableViewDelegate {
    func didPressDeleteButton(_ tag: Int)
    func didPressEditButton(_ tag: Int)
}

class SubjectChapterTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTxt: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    
    var cellDelegate: SubjectChapterTableViewDelegate?
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setCellUI(data : ChaptersData,indexPath: IndexPath){
            //Set buttons tag
        editBtn.tag = indexPath.row
        deleteBtn.tag = indexPath.row
         lblTxt.text = data.ChapterName
        //imgView.layer.cornerRadius = imgView.frame.height / 2
        imgView.createCircleImage()
        CommonFunctions.sharedmanagerCommon.addLabelOnTheImgeViewWithFirstCharacter(string: data.ChapterName ?? "" , imgView: imgView)
    }
 
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
       // Configure the view for the selected state
    }
    //MARK:- DELETE ACTION
    @IBAction func ActionDelete(_ sender: UIButton) {
        cellDelegate?.didPressDeleteButton(sender.tag)
     }
    //MARK:- EDIT ACTION
    @IBAction func ActionEdit(_ sender: Any) {
        cellDelegate?.didPressEditButton((sender as AnyObject).tag)
      }
    
    

}
