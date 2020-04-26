//
//  ViewTeacherRatingViewModel.swift
//  ISMS
//
//  Created by Poonam Sharma on 14/4/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import Foundation

protocol ViewTeacherRatingDelegate: class {
    func TeacherListDidSuccess(data : [ViewTeacherRatingResult]?)
    func GetTeacherRatingDidSuccess(data: [GetViewTeacherRatingResult]?)
    
}
class ViewTeacherRatingViewModel {
    //Global ViewDelegate weak object
    private weak var ViewTeacherRatingVC : ViewDelegate?
    
    //StudentListDelegate weak object
    private weak var ViewTeacherRatingDelegate : ViewTeacherRatingDelegate?
    
    //Initiallize the presenter StudentList using delegates
    init(delegate:ViewTeacherRatingDelegate) {
        ViewTeacherRatingDelegate = delegate
    }
    
    //Attach GlobalViewDelegate
    func attachView(viewDelegate : ViewDelegate){
        ViewTeacherRatingVC = viewDelegate
    }
    
    //Deattach View for free the memory from instances
    func deattachView(){
        ViewTeacherRatingVC = nil
        ViewTeacherRatingDelegate = nil
    }
    
    func TeacherList(HodId : Int,enumType: Int){
            self.ViewTeacherRatingVC?.showLoader()
            
        let paramDict = ["id": HodId,"enumType" : enumType ] as [String : Any]
          let url = ApiEndpoints.kSkillList + "?id=" + "\(HodId)" + "&enumType=" + "\(enumType)"
        print("url: ",url)
          TeacherRatingListAPI.sharedInstance.ViewTeacherRating(url: url, parameters: paramDict as [String : Any], completionResponse: { (ViewTeacherRatingModel) in
                print("teacher list: ",ViewTeacherRatingModel.resultData)
                if ViewTeacherRatingModel.statusCode == KStatusCode.kStatusCode200{
                    self.ViewTeacherRatingVC?.hideLoader()
                    self.ViewTeacherRatingDelegate?.TeacherListDidSuccess(data: ViewTeacherRatingModel.resultData)
                }else if ViewTeacherRatingModel.statusCode == KStatusCode.kStatusCode401{
                    self.ViewTeacherRatingVC?.hideLoader()
                    self.ViewTeacherRatingVC?.showAlert(alert: ViewTeacherRatingModel.message ?? "")
//                    self.ViewTeacherRatingDelegate?.unauthorizedUser()
                }else{
                    self.ViewTeacherRatingVC?.hideLoader()
                    CommonFunctions.sharedmanagerCommon.println(object: "student APi status change")
                }
                
            }, completionnilResponse: { (nilResponseError) in
                
                self.ViewTeacherRatingVC?.hideLoader()
                
                if let error = nilResponseError{
                    self.ViewTeacherRatingVC?.showAlert(alert: error)
                    
                }else{
                    CommonFunctions.sharedmanagerCommon.println(object: "student APi Nil response")
                }
                
            }) { (error) in
                
            }
            
        }
    
    func GetTeacherRating(teacherId : Int, ParticularId: Int){
        self.ViewTeacherRatingVC?.showLoader()
        
        let paramDict = ["teacherId": teacherId] as [String : Any]
        let url = "api/Institute/GetTeacherRatingByHOD" + "?teacherId=" + "\(teacherId)" + "&particularId=" + "\(ParticularId)"
        print("url: ",url)
        TeacherRatingListAPI.sharedInstance.GetTeacherRating(url: url, parameters: paramDict as [String : Any], completionResponse: { (GetStudentTeacherRatingModel) in
            print("teacher list: ",GetStudentTeacherRatingModel.resultData)
            if GetStudentTeacherRatingModel.statusCode == KStatusCode.kStatusCode200{
                self.ViewTeacherRatingVC?.hideLoader()
                self.ViewTeacherRatingDelegate?.GetTeacherRatingDidSuccess(data: GetStudentTeacherRatingModel.resultData)
            }else if GetStudentTeacherRatingModel.statusCode == KStatusCode.kStatusCode401{
                self.ViewTeacherRatingVC?.hideLoader()
                self.ViewTeacherRatingVC?.showAlert(alert: GetStudentTeacherRatingModel.message ?? "")
                //                    self.ViewTeacherRatingDelegate?.unauthorizedUser()
            }else{
                self.ViewTeacherRatingVC?.hideLoader()
                CommonFunctions.sharedmanagerCommon.println(object: "student APi status change")
            }
            
        }, completionnilResponse: { (nilResponseError) in
            
            self.ViewTeacherRatingVC?.hideLoader()
            
            if let error = nilResponseError{
                self.ViewTeacherRatingVC?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "student APi Nil response")
            }
            
        }) { (error) in
            
        }
        
    }
}
