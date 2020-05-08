//
//  UploadPostViewModel.swift
//  ISMS
//
//  Created by Atinder Kaur on 5/7/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import Foundation

import UIKit

protocol AddPostDelegate: class {
   
    func addedSuccessfully ()
    func attachmentDeletedSuccessfully ()
    
}


class UploadPostViewModel {

    
    //Global ViewDelegate weak object
    private weak var uploadPostViewDelegate : ViewDelegate?
    
    //registerCustomerDelegate weak object
    private weak var UploadPostDelegate : AddPostDelegate?
    
    //Initiallize the presenter class using delegates
    init(delegate: AddPostDelegate) {
        UploadPostDelegate = delegate
    }
    
    //Attach GlobalViewDelegate
    func attachView(viewDelegate : ViewDelegate){
        uploadPostViewDelegate = viewDelegate
    }
    
    
    
 
   
    func addPost(Title : String ,Description : String,  DeleteIds : Int , Links : String ,NewsLetterId:Int, ParticularId : Int,TypeId: Int, lstAssignHomeAttachmentMapping : NSMutableArray) {
        
         uploadPostViewDelegate?.showLoader()
        
        let url = "api/Social/AddUpdateNewsLetter"
      
        let param = [
                     "Title" : Title,
                     "Description" : Description ,
                     "DeleteIds": DeleteIds,
                     "Links" : Links ,
                     "NewsLetterId" : NewsLetterId,
                     "TypeId" :TypeId ,
                     "ParticularId" : ParticularId,
                     "lstAssignHomeAttachmentMapping":lstAssignHomeAttachmentMapping] as [String : Any]
        
        
        HomeworkApi.sharedManager.multipartPostApi(postDict: param, url: url, completionResponse: { (response) in
            
            self.uploadPostViewDelegate?.hideLoader()
            
            switch response["StatusCode"] as? Int{
            case 200:
                self.uploadPostViewDelegate?.showAlert(alert: response["Message"]  as? String ?? "")
                self.UploadPostDelegate?.addedSuccessfully()
            case 401:
                self.uploadPostViewDelegate?.showAlert(alert: response["Message"] as? String ?? "")
                //self.AddHomeWorkDelegate?.unauthorizedUser()
            default:
                self.uploadPostViewDelegate?.showAlert(alert: response["Message"] as? String ?? "")
            }

            
        }) { (error) in
                        self.uploadPostViewDelegate?.hideLoader()
            if let err = error?.localizedDescription{
                self.uploadPostViewDelegate?.showAlert(alert: err)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: SyllabusCoverage.kSyllabusResponseError)
            }

        }
    }
    
   
          
      }
    


