//
//  ConfirmPassPresenter.swift
//  ISMS
//
//  Created by Navalpreet Kaur on 6/4/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

protocol ConfirmPasswordDelegate:class
{
    func confirmPasswordDidSuccess()
    func Falied(message:String)
}

class ConfirmPasswordViewModel
{
    //ConfirmPasswordDelegatedelegate
    weak var delegate : ConfirmPasswordDelegate?
    
    //Confirm Password delegate View
    weak var confirmView : ViewDelegate?
    
    //Initialize the Presenter class
    init(delegate:ConfirmPasswordDelegate) {
        self.delegate = delegate
    }
    
    //Attaching login view
    func attachView(view: ViewDelegate) {
        confirmView = view
    }
    
    //Detaching login view
    func detachView() {
        confirmView = nil
    }
   
    //MARK:- ConfirmPassword
    func ConfirmPassword(password: String?,confirm_password: String?){
        do {
            //check validations
             ConfirmPasswordValidations(password: password,confirmPassword: confirm_password)
        }
    }
    
    //ConfirmPassword Validations
    func ConfirmPasswordValidations(password: String?,confirmPassword: String?)
    {
        guard  let password = password  else {
            return
        }
        guard let confirmPassword = confirmPassword else {
            return
        }
        
        if(password.trimmingCharacters(in: .whitespaces).isEmpty)
        {
            self.confirmView?.showAlert(alert: k_EmptyPassword)
        }
        else if(confirmPassword.trimmingCharacters(in: .whitespaces).isEmpty)
        {
            self.confirmView?.showAlert(alert: k_EmptyConfirmPassword)
        }
        /*else if (password.trimmingCharacters(in: .whitespacesAndNewlines).count < 8 || password.count > 16)
        {
            self.confirmView?.showAlert(alert: k_MinPasswordLength)
        }
        else if !password.isPasswordValid() {
              self.confirmView?.showAlert(alert:"Password must have one alphabet, one special character and password length should be  8 to 16")
        }*/
        else if(password.trimmingCharacters(in: .whitespacesAndNewlines).elementsEqual(confirmPassword.trimmingCharacters(in: .whitespacesAndNewlines))) != true
        {
            self.confirmView?.showAlert(alert: k_ConfirmPasswordNotMatch)
        }
        else{
            self.delegate?.confirmPasswordDidSuccess()
        }
    
    }
    
}
