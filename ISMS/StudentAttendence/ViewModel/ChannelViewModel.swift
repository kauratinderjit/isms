//
//  MarkAttendenceVC.swift
//  ISMS
//
//  Created by Poonam Sharma on 11/29/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class ChannelViewModel {
    var channel: Channel
    var channelNumberText: String
    var nameText: String
    var image: UIImage?
    
    init(channel: Channel) {
        self.channel = channel
        self.channelNumberText = "Ch \(channel.number)"
        self.nameText = channel.name
        print("number ",self.channelNumberText)
        print(" text ",self.nameText )
        self.image = UIImage(named: channel.name.lowercased())
    }
}
