//
//  SubjectChapterViewModel.swift
//  ISMS
//
//  Created by Kuldeep Singh on 11/15/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
protocol SubjectChapterDelegate: class {
    func unauthorizedUser()
    //    func SubjectListDidSuccess(data: [GetSubjectResultData]?)
    //    func SubjectListDidFailed()
    func SubjectDeleteSuccess(data: DeleteSubjectModel)
    func GetChapterList()
    //    func SubjectDetailDidSuccess(Data: GetSubjectDetail)
    //    func SubjectDetailDidFailed()
    func chapterList(data: [ChaptersData])
}
class SubjectChapterViewModel{
    
    var isSearching : Bool?
    //Global ViewDelegate weak object
    private weak var ChapterView : ViewDelegate?
    
    //StudentListDelegate weak object
    private weak var ChapterDelegate : SubjectChapterDelegate?
    
    //Initiallize the ViewModel StudentList using delegates
    init(delegate:SubjectChapterDelegate) {
        ChapterDelegate = delegate
    }
    
    //Attach GlobalViewDelegate
    func attachView(viewDelegate : ViewDelegate){
        ChapterView = viewDelegate
    }
    
    //Deattach View for free the memory from instances
    func deattachView(){
        ChapterView = nil
        ChapterDelegate = nil
    }
    
    
}
//MARK :- Web Services
extension SubjectChapterViewModel {
    
    func chapterList(search : String?,skip : Int?,pageSize: Int?,sortColumnDir: String?,sortColumn: String?, particularId : Int) {
       
        if isSearching == false
        {
            self.ChapterView?.showLoader()
        }
        
        let paramDict = [KApiParameters.SubjectListApi.subjectSearch: search ?? "",KApiParameters.SubjectListApi.PageSkip:skip ?? 0,KApiParameters.SubjectListApi.PageSize: pageSize ?? 0,KApiParameters.SubjectListApi.sortColumnDir: sortColumnDir ?? "", KApiParameters.SubjectListApi.sortColumn: sortColumn ?? "", KApiParameters.kUpdateSyllabusApiParameter.kParticularId :particularId ] as [String : Any]
        
        SubjectChapterApi.sharedInstance.getChapterList(url: ApiEndpoints.KChapterListApi, parameters: paramDict as [String : Any], completionResponse: { (SubjectListModel) in
            self.ChapterView?.hideLoader()
            if SubjectListModel.statusCode == KStatusCode.kStatusCode200{
                if let resltdata = SubjectListModel.resultData {
                    self.ChapterDelegate?.chapterList(data: resltdata)
                }
            }else if SubjectListModel.statusCode == KStatusCode.kStatusCode401{
                self.ChapterDelegate?.unauthorizedUser()
                self.ChapterView?.showAlert(alert: SubjectListModel.message ?? "")
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "student APi status change")
            }
            
        }, completionnilResponse: { (nilResponseError) in
            self.ChapterView?.hideLoader()
            self.ChapterView?.showAlert(alert: nilResponseError ?? "")
        }) { (error) in
            self.ChapterView?.hideLoader()
            self.ChapterView?.showAlert(alert: error?.localizedDescription ?? "")
        }
    }
    
    func addChapter( ChapterId: Int,ChapterName: String,ClassSubjectId: Int) {
        self.ChapterView?.showLoader()
        let paramDict = [KApiParameters.AddSubjectApi.chapterId:ChapterId,KApiParameters.AddSubjectApi.chapterName:ChapterName, KApiParameters.AddSubjectApi.kclassSubjectId :ClassSubjectId ,"IsCover": false,
                         "CoveredBy": 0] as [String : Any]
        
        SubjectApi.sharedInstance.AddSubject(url: ApiEndpoints.KAddChapterApi, parameters: paramDict, completionResponse: { (responseModel) in
            print(responseModel)
            self.ChapterView?.hideLoader()
            self.ChapterView?.showAlert(alert: responseModel.message ?? "")
            self.ChapterDelegate?.GetChapterList()
            
        }, completionnilResponse: { (nilResponse) in
            self.ChapterView?.hideLoader()
            self.ChapterView?.showAlert(alert: nilResponse ?? "")
            // self.SubjectListVC?.showAlert(alert: nilResponse ?? Alerts.kMapperModelError)
        }) { (error) in
            self.ChapterView?.hideLoader()
            self.ChapterView?.showAlert(alert: error?.localizedDescription ?? "")
            
        }
    }
    
    func chapterDetail(chapterId: Int?) {
        self.ChapterView?.showLoader()
        
        SubjectApi.sharedInstance.getSubjectDetail(url: ApiEndpoints.KChapterDetailApi + "\(chapterId ?? 0)", parameters: nil, completionResponse: { (GetSubjectDetail) in
            
            if GetSubjectDetail.statusCode == KStatusCode.kStatusCode200{
                self.ChapterView?.hideLoader()
                //self.SubjectListDelegate?.SubjectDetailDidSuccess(Data: GetSubjectDetail)
            }else if GetSubjectDetail.statusCode == KStatusCode.kStatusCode401{
                self.ChapterView?.showAlert(alert: GetSubjectDetail.message ?? "")
                self.ChapterDelegate?.unauthorizedUser()
            }else{
                self.ChapterView?.hideLoader()
                CommonFunctions.sharedmanagerCommon.println(object: kPrintErrorMsg.kServiceError.kStatusError)
            }
        }, completionnilResponse: { (nilResponseError) in
            
            self.ChapterView?.hideLoader()
            // self.SubjectListDelegate?.SubjectDetailDidFailed()
            if let error = nilResponseError{
                self.ChapterView?.showAlert(alert: error)
            }
        }) { (error) in
            self.ChapterView?.hideLoader()
            //  self.SubjectListDelegate?.SubjectDetailDidFailed()
            if let err = error?.localizedDescription{
                self.ChapterView?.showAlert(alert: err)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: kPrintErrorMsg.kServiceError.kResponseError)
            }
        }
    }
    
    func deletechapter(chapterId: Int){
        let url = ApiEndpoints.KDeleteChapterApi +  "\(chapterId)"
        let param = [ChapterVC.chapterParam.kChapterId : chapterId ]
        self.ChapterView?.showLoader()
        SubjectApi.sharedInstance.deleteSubjectApi(url: url,completionResponse: {DeleteSubjectModel in
            self.ChapterView?.hideLoader()
            if DeleteSubjectModel.statusCode == KStatusCode.kStatusCode200{
                if DeleteSubjectModel.status == true{
                    self.ChapterView?.hideLoader()
                    self.ChapterDelegate?.SubjectDeleteSuccess(data: DeleteSubjectModel)
                }else{
                    self.ChapterView?.hideLoader()
                    self.ChapterView?.showAlert(alert: DeleteSubjectModel.message ?? Alerts.kServerErrorAlert)
                }
            }
        }, completionnilResponse: { (nilResponse) in
            self.ChapterView?.hideLoader()
            if let res = nilResponse{
                self.ChapterView?.showAlert(alert: res)
            }
        }) { (error) in
            self.ChapterView?.hideLoader()
            if let err = error{
                self.ChapterView?.showAlert(alert: err.localizedDescription)
            }
        }
    }
}

