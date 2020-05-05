//
//  NewsLetterTableCell.swift
//  ISMS
//
//  Created by Navalpreet Kaur on 12/2/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class NewsLetterTableCell: UITableViewCell {

    @IBOutlet weak var lblNews: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func btnDownload(_ sender: Any) {
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
