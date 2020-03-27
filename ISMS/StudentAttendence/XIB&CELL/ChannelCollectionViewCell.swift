//
//  ChannelCollectionViewCell.swift
//  EPG
//
//  Created by Jerald Abille on 3/22/18.
//  Copyright © 2018 Jerald Abille. All rights reserved.
//

import UIKit

class ChannelCollectionViewCell: UICollectionViewCell {


    @IBOutlet weak var lbl_Day: UILabel!
    
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.setup()
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setup()
  }

  func setup() {
    self.backgroundColor = UIColor.white
    self.layer.borderWidth = 0.5
    self.layer.borderColor = UIColor.white.cgColor
  }

  func configureWith(channel: Channel) {
    let viewModel = ChannelViewModel(channel: channel)
   
      self.lbl_Day.text = viewModel.nameText
    
  }
}
