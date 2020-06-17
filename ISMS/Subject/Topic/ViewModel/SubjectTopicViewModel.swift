//
//  SubjectTopicViewModel.swift
//  ISMS
//
//  Created by Gurleen Osahan on 11/18/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation

//MARK: PROTOCOL SUBJECT CHAPTER
protocol SubjectChapterTopicDelegate: class {
        func unauthorizedUser()
        func SubjectListDidSuccess(data: [GetTopicResultData]?)
        func  getTopicList()
//        func SubjectListDidFailed()
      func SubjectDeleteSuccess(data: DeleteTopicModel)
//       func SubjectDetailDidSuccess(Data: TopicListModel)
//        func SubjectDetailDidFailed()
}


class SubjectChapterTopicViewModel{
    
    var isSearching : Bool?
    //Global ViewDelegate weak object
    private weak var TopicView : ViewDelegate?
    
    //StudentListDelegate weak object
    private weak var TopicDelegate : SubjectChapterTopicDelegate?
    
    //Initiallize the ViewModel StudentList using delegates
    init(delegate:SubjectChapterTopicDelegate) {
        TopicDelegate = delegate
    }
    
    //Attach GlobalViewDelegate
    func attachView(viewDelegate : ViewDelegate){
        TopicView = viewDelegate
    }
    
    //Deattach View for free the memory from instances
    func deattachView(){
        TopicView = nil
        TopicDelegate = nil
    }
    
  

    //MARK:- GET TOPIC LIST
    func TopicList(search : String?,skip : Int?,pageSize: Int?,sortColumnDir: String?,sortColumn: String? , particularID : Int ){
        
        if isSearching == false{
                 self.TopicView?.showLoader()
              }
        
        let paramDict = ["Search": search ?? "",
                         "Skip":skip ?? 0,
                         "PageSize": pageSize ?? 0,
                         "SortColumnDir": sortColumnDir ?? "",
                         "SortColumn" : sortColumn ?? "",
                         "ParticularId" : particularID] as [String : Any]
 
        
        SubjectTopicApi.sharedInstance.getTopicList(url: ApiEndpoints.KTopicListApi, parameters: paramDict as [String : Any], completionResponse: { (SubjectListModel) in
            
            self.TopicView?.hideLoader()
            if SubjectListModel.statusCode == KStatusCode.kStatusCode200{
                let data = SubjectListModel.resultData
                 self.TopicDelegate?.SubjectListDidSuccess(data: data)
            }else if SubjectListModel.statusCode == KStatusCode.kStatusCode401{
                self.TopicView?.showAlert(alert: SubjectListModel.message ?? "")
                //    self.ChapterDelegate?.unauthorizedUser()
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "student APi status change")
            }
            
        }, completionnilResponse: { (nilResponseError) in
            self.TopicView?.hideLoader()
            self.TopicView?.showAlert(alert: nilResponseError ?? "")
        }) { (error) in
            self.TopicView?.hideLoader()
            self.TopicView?.showAlert(alert: error?.localizedDescription ?? "")
        }
    }
    //MARK:- GET ADD TOPIC LIST
    func addTopic(TopicId: Int,TopicName: String,ChapterId: Int){
        self.TopicView?.showLoader()
        let paramDict = [KApiParameters.AddSubjectApi.kTopicId:TopicId,KApiParameters.AddSubjectApi.kTopicName:TopicName, KApiParameters.AddSubjectApi.chapterId :ChapterId,"Comment" : "","UserId": UserDefaultExtensionModel.shared.currentUserId] as [String : Any]
        print("value of param: ",paramDict)
        SubjectApi.sharedInstance.AddSubject(url: ApiEndpoints.KAddTopicApi, parameters: paramDict, completionResponse: { (responseModel) in
            print(responseModel)
            self.TopicView?.hideLoader()
            self.TopicView?.showAlert(alert: responseModel.message ?? "")
            self.TopicDelegate?.getTopicList()
        }, completionnilResponse: { (nilResponse) in
            self.TopicView?.hideLoader()
            self.TopicView?.showAlert(alert: nilResponse ?? "")
        }) { (error) in
            self.TopicView?.hideLoader()
            self.TopicView?.showAlert(alert: error?.localizedDescription ?? "")
        }
}
    
    func topicDetail(topicId: Int?) {
        self.TopicView?.showLoader()
        SubjectApi.sharedInstance.getSubjectDetail(url: ApiEndpoints.KChapterDetailApi + "\(topicId ?? 0)", parameters: nil, completionResponse: { (GetSubjectDetail) in
            if GetSubjectDetail.statusCode == KStatusCode.kStatusCode200{
                self.TopicView?.hideLoader()
            //   self.SubjectListDelegate?.SubjectDetailDidSuccess(Data: GetSubjectDetail)
            }else if GetSubjectDetail.statusCode == KStatusCode.kStatusCode401{
                self.TopicView?.showAlert(alert: GetSubjectDetail.message ?? "")
                //  self.SubjectListDelegate?.unauthorizedUser()
            }else{
                self.TopicView?.hideLoader()
                CommonFunctions.sharedmanagerCommon.println(object: "student APi status change")
            }
        }, completionnilResponse: { (nilResponseError) in
            self.TopicView?.hideLoader()
            if let error = nilResponseError{
                self.TopicView?.showAlert(alert: error)
            }
        }) { (error) in
            self.TopicView?.hideLoader()
            //  self.SubjectListDelegate?.SubjectDetailDidFailed()
            if let err = error?.localizedDescription{
                self.TopicView?.showAlert(alert: err)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "student APi error response")
            }
        }
    }
    
    func deletechapter(topicId: Int){
        
        self.TopicView?.showLoader()
        SubjectTopicApi.sharedInstance.deleteTopicApi(url: ApiEndpoints.KDeleteTopicApi + "\(topicId)", completionResponse: {DeleteSubjectModel in
            
            if DeleteSubjectModel.statusCode == KStatusCode.kStatusCode200{
                
                if DeleteSubjectModel.status == true{
                    CommonFunctions.sharedmanagerCommon.println(object: "delete student true")
                    self.TopicView?.hideLoader()
            self.TopicDelegate?.SubjectDeleteSuccess(data: DeleteSubjectModel)
                }else{
                    CommonFunctions.sharedmanagerCommon.println(object: "delete student false")
                    self.TopicView?.hideLoader()
                    //                    self.SubjectListVC?.showAlert(alert: DeleteSubjectModel.message ?? Alerts.kServerErrorAlert)
                }
                
            }
            
        }, completionnilResponse: { (nilResponse) in
            self.TopicView?.hideLoader()
            if let res = nilResponse{
                self.TopicView?.showAlert(alert: res)
            }
        }) { (error) in
            self.TopicView?.hideLoader()
            if let err = error{
                self.TopicView?.showAlert(alert: err.localizedDescription)
            }
        }
        
    }
    
    
    func add_Topic(TopicId : Int ,UserId : Int , TopicName : String ,ChapterId:Int, Comment : String, IsTopicAttachmentMapping : [URL], lstdeleteattachmentModel : NSMutableArray) {
        
         self.TopicView?.showLoader()
        
        let url = "api/Institute/AddTopic"
      
        let param = [
                     "TopicId" : TopicId,
                     "UserId" :UserId ,
                     "TopicName" : TopicName,
                     "ChapterId" : ChapterId,
                     "Comment": Comment,
                     "IsTopicAttachmentMapping" : IsTopicAttachmentMapping,
                     "lstdeleteattachmentModel" :  lstdeleteattachmentModel
            ] as [String : Any]
        
        
        HomeworkApi.sharedManager.multipartApiTopic(postDict: param, url: url, completionResponse: { (response) in
            
            self.TopicView?.hideLoader()
            
            switch response["StatusCode"] as? Int{
            case 200:
                print("success")
                // self.TopicDelegate?.showAlert(alert: response["Message"]  as? String ?? "")
              self.TopicDelegate?.getTopicList()
            case 401:
                 self.TopicView?.showAlert(alert: response["Message"] as? String ?? "")
                //self.AddHomeWorkDelegate?.unauthorizedUser()
            default:
                self.TopicView?.showAlert(alert: response["Message"] as? String ?? "")
            }

            
        }) { (error) in
           self.TopicView?.hideLoader()
            if let err = error?.localizedDescription{
                self.TopicView?.showAlert(alert: err)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: SyllabusCoverage.kSyllabusResponseError)
            }

        }
    }
    

  
}
