//
//  TagViewModel.swift
//  SeasiaNoticeBoard
//
//  Created by Atinder Kaur on 6/29/20.
//  Copyright © 2020 Poonam Sharma. All rights reserved.
//

import Foundation

struct LocalPostModel: Decodable
{
    var UserId : Int?
    var Name : String?
    var IsSelected : Bool?
    
    
    init() {
       self.UserId = Int()
        self.Name = String()
        self.IsSelected = Bool()
        
    }
    
}

struct  ColorModel: Decodable
{
    var hexString : String?
    var IsSelected : Bool?
    
    
    init() {
      
        self.hexString = String()
        self.IsSelected = Bool()
        
    }
    
}
