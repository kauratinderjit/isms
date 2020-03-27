//
//  ExamResultTableCell.swift
//  ISMS
//
//  Created by Navalpreet Kaur on 12/3/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class ExamResultTableCell: UITableViewCell {
    
    //MARK:- Outlet and Variables
    @IBOutlet weak var lblResultDetail: UILabel!
    @IBOutlet weak var btnDownload: UIButton!
    @IBOutlet weak var lblClass: UILabel!
    public var examResultDelegate : ExamResultDelegate?
    var selectedIndex:Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK:- btnAction
    @IBAction func btnDownloadAction(_ sender: Any)
    {
       examResultDelegate?.downLoadResult(index: selectedIndex)
    }
    
    //MARK:- Other function
    func SetUI(index:Int) {
      
        selectedIndex = index
        btnDownload.tag = index
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
