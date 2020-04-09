//
//  SubjectWiseRatingViewModel.swift
//  ISMS
//
//  Created by Kuldeep Singh on 12/4/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation


protocol SubjectWiseRatingDelegate : class {
    func SubjectWiseRatingDidSucceed(data : [SubjectWiseRatingResultData])
    func SubjectWiseRatingDidFailour()


}

class SubjectWiseRatingViewModel {
    
    var isSearching : Bool?
    private weak var subjectWiseRatingView : ViewDelegate?
    private  weak var subjectWiseRatingDelegate: SubjectWiseRatingDelegate?
    
    
    init(delegate : SubjectWiseRatingDelegate) {
        self.subjectWiseRatingDelegate = delegate
    }
    
    func attachView(viewDelegate : ViewDelegate){
        subjectWiseRatingView = viewDelegate
    }
    
//    func createLabel(x: CGFloat, y: CGFloat, text: String) {
//        let label = UILabel(frame: CGRectMake(x, y, 100, 25))
//        label.text = text
//        view.addSubview(label)
//    }
//
    
    
    //MARK:- SUBJECT LIST
    func getSubjectWiseRating(enrollmentsId : Int?,classId: Int?){
        self.subjectWiseRatingView?.showLoader()
       
        let paramDict = [ "EnrollmentId": enrollmentsId!,
                           "ClassId" : classId!
                         ] as [String : Any]
        
        AddStudentRatingApi.sharedInstance.SubmitApiList(url: ApiEndpoints.kGetSubjectWiseRating, parameters: paramDict, completionResponse: { (SubjectListModel) in
            
            if SubjectListModel.statusCode == KStatusCode.kStatusCode200{
                self.subjectWiseRatingView?.hideLoader()
        self.subjectWiseRatingDelegate?.SubjectWiseRatingDidSucceed(data: SubjectListModel.resultData!)
            }else if SubjectListModel.statusCode == KStatusCode.kStatusCode401{
                self.subjectWiseRatingView?.hideLoader()
                self.subjectWiseRatingView?.showAlert(alert: SubjectListModel.message ?? "")
                //  self.SubjectListDelegate?.unauthorizedUser()
            }else{
                self.subjectWiseRatingView?.hideLoader()
                CommonFunctions.sharedmanagerCommon.println(object: "student APi status change")
            }
            
        }, completionnilResponse: { (nilResponseError) in
            
            self.subjectWiseRatingView?.hideLoader()
            //   self.SubjectListDelegate?.SubjectListDidFailed()
            
            if let error = nilResponseError{
                self.subjectWiseRatingView?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "student APi Nil response")
            }
            
        }) { (error) in
            self.subjectWiseRatingView?.hideLoader()
            //   self.SubjectListDelegate?.SubjectListDidFailed()
            //            if let err = error?.localizedDescription{
            //                self.addStudentRatingView?.showAlert(alert: err)
            //            }else{
            //                CommonFunctions.sharedmanagerCommon.println(object: "student APi error response")
            //            }
        }
        
    }
}


