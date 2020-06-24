//
//  Model.swift
//  ISMS
//  CusomModel
//  Created by Gurleen Osahan on 6/19/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
struct UploadItems {

    var uRL:URL?
    var filetype: String?
    
    init(uRL:URL,filetype:String) {
        self.uRL = uRL
       self.filetype = filetype
   
    }
}
struct AttachedFiles{
    var instituteFileName:String?
    var instituteAttachmentName: String?
    var instituteAttachmentId : Int?
    var type:String?
    
    init(type:String,instituteAttachmentName:String, instituteFileName:String ,instituteAttachmentId: Int ) {
        self.type = type
        self.instituteAttachmentName = instituteAttachmentName
        self.instituteFileName = instituteFileName
        self.instituteAttachmentId = instituteAttachmentId
    }
}

