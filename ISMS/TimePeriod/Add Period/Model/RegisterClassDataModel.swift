//
//  RegisterClassDataModel.swift
//  ISMS
//
//  Created by Poonam Sharma on 7/4/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import Foundation
class RegisterClassDataModel
{
    static let sharedInstance:RegisterClassDataModel? = RegisterClassDataModel()
    var classID:Int?
    var subjectID:Int?
    
    
    private init()
    {
    }
    deinit
    {
        print("Dealloc")
    }
    func Reinitilize()
    {
        
        RegisterClassDataModel.sharedInstance?.classID = 0
        RegisterClassDataModel.sharedInstance?.subjectID = 0
     
        
    }
}


