//
//  UploadPostViewModel.swift
//  ISMS
//
//  Created by Atinder Kaur on 5/7/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import Foundation

import UIKit

var strlogot = ""

protocol AddPostDelegate: class {
   
    func addedSuccessfully (result : Int)
    func attachmentDeletedSuccessfully ()
    func displayData(data: [NewsListResultData])
    func CommentData(data: [lstgetCommentViewList]?)
    func LikerList(data: [lstgetLikesListViewModels])
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
    

    func addPost(Title : String ,Description : String,  DeleteIds : Int , Links : String ,NewsLetterId:Int, ParticularId : Int,TypeId: Int, lstAssignHomeAttachmentMapping : NSMutableArray,thumbnail: Data?, ColorCode: String) {
        
         uploadPostViewDelegate?.showLoader()
        
        let url = "api/Social/AddUpdateNewsLetter"
        var param = [String : Any]()
        if thumbnail != nil {
      
         param = [
                     "Title" : Title,
                     "Description" : Description ,
                     "DeleteIds": DeleteIds,
                     "Links" : Links ,
                     "NewsLetterIds" : NewsLetterId,
                     "TypeId" :TypeId ,
                     "ParticularId" : ParticularId,
                     "DeletedTagIds" : 0, "lstAssignHomeAttachmentMapping":lstAssignHomeAttachmentMapping,
                     "thumbnail":thumbnail!,
               "ColorCode" : ColorCode] as [String : Any]
                 
        }
        else{
           param = [
            "Title" : Title,
            "Description" : Description ,
            "DeleteIds": DeleteIds,
            "Links" : Links ,
            "NewsLetterIds" : NewsLetterId,
            "TypeId" :TypeId ,
            "ParticularId" : ParticularId,
             "DeletedTagIds" : 0,
             "lstAssignHomeAttachmentMapping":lstAssignHomeAttachmentMapping,
              "ColorCode" : ColorCode
            ] as [String : Any]
        }
        
        
        HomeworkApi.sharedManager.multipartPostApi(postDict: param, url: url, completionResponse: { (response) in
            
            self.uploadPostViewDelegate?.hideLoader()
            
            switch response["StatusCode"] as? Int{
            case 200:
               // self.uploadPostViewDelegate?.showAlert(alert: response["Message"]  as? String ?? "")
                self.UploadPostDelegate?.addedSuccessfully(result: 0)
            case 401:
                self.uploadPostViewDelegate?.showAlert(alert: response["Message"] as? String ?? "")
            case 400:
                self.logout(userId: ParticularId, deviceType: 3)
               // CommonFunctions.sharedmanagerCommon.setRootLogin()
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
    
   
    func getData(Search: String,Skip: Int,PageSize: Int,SortColumnDir : String,SortColumn: String,ParticularId: Int) {
            uploadPostViewDelegate?.showLoader()
        
        //"UserId" : UserDefaultExtensionModel.shared.currentUserId,
        let param = ["Search": Search,"Skip": Skip,"PageSize": PageSize,"SortColumnDir": SortColumnDir,"ParticularId":ParticularId] as [String : Any]
           
           let url = "api/Social/GetNewsLetter"
           
           HomeworkApi.sharedManager.getNewsFeed(url:url , parameters: param, completionResponse: { (responseModel) in
               
               self.uploadPostViewDelegate?.hideLoader()
               if let msg = responseModel.resultData {
               self.UploadPostDelegate?.displayData(data: responseModel.resultData!)
               }
               
           }, completionnilResponse: { (nilResponseError) in
               self.uploadPostViewDelegate?.hideLoader()
               if let error = nilResponseError{
                   self.uploadPostViewDelegate?.showAlert(alert: error.description)
                   
               }else{
                   CommonFunctions.sharedmanagerCommon.println(object: SyllabusCoverage.kSyllabusResponseNotGet)
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
    
    func getDataProfile(UserId:Int, Search: String,Skip: Int,PageSize: Int,SortColumnDir : String,SortColumn: String,ParticularId: Int) {
            uploadPostViewDelegate?.showLoader()
        
      
        let param = [ "UserId" : UserId,"Search": Search,"Skip": Skip,"PageSize": PageSize,"SortColumnDir": SortColumnDir,"ParticularId":ParticularId] as [String : Any]
           
           let url = "api/Social/GetNewsLetter"
           
           HomeworkApi.sharedManager.getNewsFeed(url:url , parameters: param, completionResponse: { (responseModel) in
               
               self.uploadPostViewDelegate?.hideLoader()
               if let msg = responseModel.resultData {
               self.UploadPostDelegate?.displayData(data: responseModel.resultData!)
               }
               
           }, completionnilResponse: { (nilResponseError) in
               self.uploadPostViewDelegate?.hideLoader()
               if let error = nilResponseError{
                   self.uploadPostViewDelegate?.showAlert(alert: error.description)
                   
               }else{
                   CommonFunctions.sharedmanagerCommon.println(object: SyllabusCoverage.kSyllabusResponseNotGet)
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
    
    
    func likePost(PostId : Int,LikedBy: Int, IsLiked: Bool) {
            uploadPostViewDelegate?.showLoader()
        
        let param = [       "PostId" : PostId,
                            "LikedBy" : LikedBy,
                            "IsLiked": IsLiked]
                           as [String : Any]
           
           let url = "api/Social/AddUpdateLike"
           
           HomeworkApi.sharedManager.likePost(url:url , parameters: param, completionResponse: { (response) in
               
               self.uploadPostViewDelegate?.hideLoader()
               switch response["StatusCode"] as? Int{
                          case 200:
                             // self.uploadPostViewDelegate?.showAlert(alert: response["Message"]  as? String ?? "")
                              self.UploadPostDelegate?.addedSuccessfully(result : response["ResultData"] as? Int ?? 0)
               case 401: break
                              //self.uploadPostViewDelegate?.showAlert(alert: response["Message"] as? String ?? "")
                              //self.AddHomeWorkDelegate?.unauthorizedUser()
               default: break
                             // self.uploadPostViewDelegate?.showAlert(alert: response["Message"] as? String ?? "")
                          }

               
           }, completionnilResponse: { (nilResponseError) in
               self.uploadPostViewDelegate?.hideLoader()
               if let error = nilResponseError{
                   self.uploadPostViewDelegate?.showAlert(alert: error.description)
                   
               }else{
                   CommonFunctions.sharedmanagerCommon.println(object: SyllabusCoverage.kSyllabusResponseNotGet)
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
    
    func sendComment(AllFiles : String,Comment: String, CommentId: Int, CommentedBy: Int, PostId : Int, tagIds : [Int]) {
            uploadPostViewDelegate?.showLoader()
        
        let param = [       "AllFiles" : AllFiles,
                            "Comment" : Comment,
                            "CommentId": CommentId,
                            "CommentedBy" : CommentedBy,
                            "PostId" : PostId,
                            "TagIds" : tagIds,
                            "DeletedTagIds" : 0
                
            
            ] as [String : Any]
           
           let url = "api/Social/AddUpdateComment"
           
           HomeworkApi.sharedManager.multipartPostApi(postDict: param, url: url, completionResponse: { (response) in
               
               self.uploadPostViewDelegate?.hideLoader()
               switch response["StatusCode"] as? Int{
                          case 200:
                              self.uploadPostViewDelegate?.showAlert(alert: response["Message"]  as? String ?? "")
                              self.UploadPostDelegate?.addedSuccessfully(result: 0)
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
    
    func getComment(postId: Int) {
                     uploadPostViewDelegate?.showLoader()

                    let url = "api/Social/GetCommentNewsFeed?postId=\(postId)"
                    
                    HomeworkApi.sharedManager.getComments(url:url , parameters: nil, completionResponse: { (response) in
                        
                        self.uploadPostViewDelegate?.hideLoader()
                        
                        switch response.statusCode{
                                                 case 200:
                                                    self.UploadPostDelegate?.CommentData(data: (response.resultData?.list))
                                                 case 401:
                                                    self.uploadPostViewDelegate?.showAlert(alert: response.message ?? "" )
                                                     //self.AddHomeWorkDelegate?.unauthorizedUser()
                                                 default:
                                                     self.uploadPostViewDelegate?.showAlert(alert: response.message ?? "" )
                                                 }
                    
                        
                    }, completionnilResponse: { (nilResponseError) in
                        self.uploadPostViewDelegate?.hideLoader()
                        if let error = nilResponseError{
                            self.uploadPostViewDelegate?.showAlert(alert: error.description)
                            
                        }else{
                            CommonFunctions.sharedmanagerCommon.println(object: SyllabusCoverage.kSyllabusResponseNotGet)
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
    
    
    func deleteComment(UserId:Int, PostId: Int,  CommentId: Int){
        
        self.uploadPostViewDelegate?.showLoader()
        
        
        let param = [       "UserId" : UserId,
                            "PostId" : PostId,
                             "CommentId": CommentId,
                   ] as [String : Any]
        
       HomeworkApi.sharedManager.likePost(url:"api/Social/DeleteComment" , parameters: param, completionResponse: { (response) in
            
            if response["StatusCode"] as? Int == KStatusCode.kStatusCode200 {
                
                    self.uploadPostViewDelegate?.hideLoader()
                   self.uploadPostViewDelegate?.showAlert(alert: "Comment has been deleted successfully")
                   self.UploadPostDelegate?.attachmentDeletedSuccessfully()

            }else{
                self.uploadPostViewDelegate?.hideLoader()
                if let msg = response["Message"] as? String{
                    self.uploadPostViewDelegate?.showAlert(alert: msg)
                    
                }
                CommonFunctions.sharedmanagerCommon.println(object: "Status code is diffrent.")
            }
            
        }, completionnilResponse: { (nilResponse) in
            
            self.uploadPostViewDelegate?.hideLoader()
            if let res = nilResponse{
                self.uploadPostViewDelegate?.showAlert(alert: res)
            }
            
        }) { (error) in
            self.uploadPostViewDelegate?.hideLoader()
            if let err = error{
                self.uploadPostViewDelegate?.showAlert(alert: err.localizedDescription)
            }
        }
        
    }
    
    
    func getlikerList(postId: Int) {
                       uploadPostViewDelegate?.showLoader()

                      let url = "api/Social/GetLikesNewsFeed?postId=\(postId)"
                      
                      HomeworkApi.sharedManager.getLikerList(url:url , parameters: nil, completionResponse: { (response) in
                          
                          self.uploadPostViewDelegate?.hideLoader()
                          
                          switch response.statusCode {
                                                   case 200:
                                                    if response.resultData?.list?.count ?? 0 > 0 {
                                                     self.UploadPostDelegate?.LikerList(data: ((response.resultData?.list)!))
                                                    }
                                                   case 401:
                                                      self.uploadPostViewDelegate?.showAlert(alert: response.message ?? "" )
                                                       //self.AddHomeWorkDelegate?.unauthorizedUser()
                                                   default:
                                                       self.uploadPostViewDelegate?.showAlert(alert: response.message ?? "" )
                                                   }
                      
                          
                      }, completionnilResponse: { (nilResponseError) in
                          self.uploadPostViewDelegate?.hideLoader()
                          if let error = nilResponseError{
                              self.uploadPostViewDelegate?.showAlert(alert: error.description)
                              
                          }else{
                              CommonFunctions.sharedmanagerCommon.println(object: SyllabusCoverage.kSyllabusResponseNotGet)
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
    
    func reportApi(IssueReportedId: Int,ReportId: Int,NewsletterId:Int,UserId:Int ) {
                          uploadPostViewDelegate?.showLoader()

                         
                         
               let param = [       "IssueReportedId" : IssueReportedId,
                                    "ReportId" : ReportId,
                                    "NewsletterId": NewsletterId,
                                    "UserId" : UserId
                                        
                                    
                                    ] as [String : Any]
                                   
                                let url = "api/Social/AddUpdateIssueReported"
                                   HomeworkApi.sharedManager.multipartPostApi(postDict: param, url: url, completionResponse: { (response) in
                                       
                                       self.uploadPostViewDelegate?.hideLoader()
                                       switch response["StatusCode"] as? Int{
                                                  case 200:
                                                      self.uploadPostViewDelegate?.showAlert(alert: response["Message"]  as? String ?? "")
                                        
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
    
    func deviceTokenApi(DeviceType: String,DeviceToken: String,UserId:Int) {
                            uploadPostViewDelegate?.showLoader()
                 let param = [       "DeviceType" : DeviceType,
                                      "DeviceToken" : DeviceToken,
                                      "UserId": UserId
                                     
                                      ] as [String : Any]
                                     
                                  let url = "api/User/AddUpdateDeviceDetail"
                            HomeworkApi.sharedManager.likePost(url:url , parameters: param, completionResponse: { (response) in
                                         
                                         self.uploadPostViewDelegate?.hideLoader()
                                         switch response["StatusCode"] as? Int{
                                         case 200: break
                                                       // self.uploadPostViewDelegate?.showAlert(alert: response["Message"]  as? String ?? "")
                                                      //  self.UploadPostDelegate?.addedSuccessfully()
                                                    case 401: break
                                                       // self.uploadPostViewDelegate?.showAlert(alert: response["Message"] as? String ?? "")
                                                        //self.AddHomeWorkDelegate?.unauthorizedUser()
                                                    default: break
                                                       // self.uploadPostViewDelegate?.showAlert(alert: response["Message"] as? String ?? "")
                                                    }

                                         
                                     }, completionnilResponse: { (nilResponseError) in
                                         self.uploadPostViewDelegate?.hideLoader()
                                         if let error = nilResponseError{
                                            // self.uploadPostViewDelegate?.showAlert(alert: error.description)
                                             
                                         }else{
                                             CommonFunctions.sharedmanagerCommon.println(object: SyllabusCoverage.kSyllabusResponseNotGet)
                                         }
                                     }) { (error) in
                                         self.uploadPostViewDelegate?.hideLoader()
                                         if let err = error?.localizedDescription{
                                           //  self.uploadPostViewDelegate?.showAlert(alert: err)
                                         }else{
                                             CommonFunctions.sharedmanagerCommon.println(object: SyllabusCoverage.kSyllabusResponseError)
                                         }
                                     }
                      
                       }
    
    func logout(userId: Int, deviceType: Int) {
        
        self.uploadPostViewDelegate?.showLoader()
           
          HomeworkApi.sharedManager.likePost(url:"api/User/Logout?userId=\(userId)&deviceType=\(deviceType)" , parameters: nil, completionResponse: { (response) in
            strlogot = "logout"
                 CommonFunctions.sharedmanagerCommon.setRootLogin()
                        self.uploadPostViewDelegate?.hideLoader()
               
           }, completionnilResponse: { (nilResponse) in
            strlogot = "logout"
               CommonFunctions.sharedmanagerCommon.setRootLogin()
                self.uploadPostViewDelegate?.hideLoader()
               
           }) { (error) in
            strlogot = "logout"
              CommonFunctions.sharedmanagerCommon.setRootLogin()
                 self.uploadPostViewDelegate?.hideLoader()
               }
           }
           
       
    
    func deletePost(UserId: Int, NewsLetterId: Int) {
        
        self.uploadPostViewDelegate?.showLoader()
        
        
             let param = [       "UserId" : UserId,
                                  "NewsLetterId" : NewsLetterId
                                 
                                 
                                  ] as [String : Any]
           
          HomeworkApi.sharedManager.likePost(url:"api/Social/DeleteNewsLetter" , parameters: param, completionResponse: { (response) in
               
               if response["StatusCode"] as? Int == KStatusCode.kStatusCode200 {
                    if let msg = response["Message"] as? String{
                       self.uploadPostViewDelegate?.showAlert(alert: msg)
                         }
                     self.uploadPostViewDelegate?.hideLoader()
                     self.UploadPostDelegate?.attachmentDeletedSuccessfully()

               }else{
                   self.uploadPostViewDelegate?.hideLoader()
                if (response["Message"] as? String) != nil{
                    
                        CommonFunctions.sharedmanagerCommon.setRootLogin()
                   }
                   CommonFunctions.sharedmanagerCommon.println(object: "Status code is diffrent.")
               }
               
           }, completionnilResponse: { (nilResponse) in
               
               self.uploadPostViewDelegate?.hideLoader()
               if let res = nilResponse{
                   self.uploadPostViewDelegate?.showAlert(alert: res)
               }
               
           }) { (error) in
               self.uploadPostViewDelegate?.hideLoader()
               if let err = error{
                   self.uploadPostViewDelegate?.showAlert(alert: err.localizedDescription)
               }
           }
           
        
        
        
    }
             
      }
    


