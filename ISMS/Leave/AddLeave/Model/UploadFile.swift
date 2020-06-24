//
//  UploadFile.swift
//  ISMS
//
//  Created by Poonam  on 23/06/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import Foundation
struct UploadFile {

    var LeaveAppId: Int?
    var LeaveAppAttachmentId: Int?
    var AttachmentUrl : URL?
    var IFile : String?
    var FileType : String?
    
    init(LeaveAppId:Int,LeaveAppAttachmentId:Int,AttachmentUrl: URL,IFile: String,FileType: String) {
        self.LeaveAppId = LeaveAppId
        self.LeaveAppAttachmentId = LeaveAppAttachmentId
        self.AttachmentUrl = AttachmentUrl
        self.IFile = IFile
        self.FileType  = FileType
   
    }
    
}
