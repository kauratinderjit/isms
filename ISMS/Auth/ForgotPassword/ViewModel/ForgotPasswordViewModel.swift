//
//  ForgotPresenter.swift
//  ISMS
//
//  Created by Navalpreet Kaur on 6/5/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

protocol ForgotPasswordDelegate:class{
   func Success()
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
            delegate?.Success()
        }
    }
}
