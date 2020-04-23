//
//  ForgotPresenter.swift
//  ISMS
//
//  Created by Navalpreet Kaur on 6/5/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

protocol ForgotPasswordDelegate:class{
    func Success(msg:String?)
   func Falied(message:String)
}
class ForgotPasswordViewModel{
    //ForgotDelegate
    weak var delegate : ForgotPasswordDelegate?
    
    //fogotPasswordView
    weak var fogotPasswordView : ViewDelegate?
    //Initialize the Presenter class
    init(delegate:ForgotPasswordDelegate) {
        self.delegate = delegate
    }
    //Attaching login view
    func attachView(view: ViewDelegate) {
        fogotPasswordView = view
    }
    //Detaching login view
    func detachView() {
        fogotPasswordView = nil
    }
    
    func forgotPasswordApi(userID: Int?,password:String?){
           self.fogotPasswordView?.showLoader()
        ForgotApi.sharedmanagerAuth.forgotPasswordApi(url: ApiEndpoints.forgotPassword + "\(userID ?? 0)" + ApiEndpoints.NewPassword + (password ?? ""), parameters: nil, completionResponse: { (VerifyPhoneNumberModel) in
               if VerifyPhoneNumberModel.statusCode == KStatusCode.kStatusCode200{
                   self.fogotPasswordView?.hideLoader()
                self.delegate?.Success(msg: VerifyPhoneNumberModel.message)
               }else{
                   self.fogotPasswordView?.hideLoader()
                   CommonFunctions.sharedmanagerCommon.println(object: "Class APi status change")
               }
           }, completionnilResponse: { (nilResponseError) in
               self.fogotPasswordView?.hideLoader()
            self.delegate?.Falied(message: nilResponseError ?? "")
               if let error = nilResponseError{
                   self.fogotPasswordView?.showAlert(alert: error)
               }else{
                   CommonFunctions.sharedmanagerCommon.println(object: "Class APi Nil response")
               }
           }) { (error) in
               self.fogotPasswordView?.hideLoader()
            self.delegate?.Falied(message: error as! String)
               if let err = error?.localizedDescription{
                   self.fogotPasswordView?.showAlert(alert: err)
               }else{
                   CommonFunctions.sharedmanagerCommon.println(object: "Class APi error response")
               }
           }
    }
    //MARK:- ConfirmPassword
    func ForgotPassword(password: String?,confirm_password: String?){
        do {
            //check validations
            forgotPasswordValidations(password: password,confirmPassword: confirm_password)
        }
    }
    //ConfirmPassword Validations
    func forgotPasswordValidations(password: String?,confirmPassword: String?){
        if(password!.trimmingCharacters(in: .whitespaces).isEmpty){
            self.fogotPasswordView?.showAlert(alert: k_EmptyPassword)
        }
        else if(confirmPassword!.trimmingCharacters(in: .whitespaces).isEmpty){
            self.fogotPasswordView?.showAlert(alert: k_EmptyConfirmPassword)
        }
        else if (password!.trimmingCharacters(in: .whitespacesAndNewlines).count < 4 || password!.count > 16){
            self.fogotPasswordView?.showAlert(alert: k_MinPasswordLength)
        }
            
        else if(password!.trimmingCharacters(in: .whitespacesAndNewlines).elementsEqual(confirmPassword!.trimmingCharacters(in: .whitespacesAndNewlines))) != true{
            self.fogotPasswordView?.showAlert(alert: k_ConfirmPasswordNotMatch)
        }
        else{
           // delegate?.Success()
            forgotPasswordApi(userID: UserDefaultExtensionModel.shared.forgotUserId, password: password)
        }
    }
}
