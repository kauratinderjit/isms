//
//  ConfirmPasswordVC.swift
//  ISMS
//
//  Created by Navalpreet Kaur on 5/29/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class ConfirmPasswordVC: BaseUIViewController {

    //MARK:- Properties
    @IBOutlet weak var viewConfirmPass: UIView!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var txtConfirmPass: UITextField!
    @IBOutlet weak var btnNext: UIButton!
    //MARK:- Variables
    var viewModel:ConfirmPasswordViewModel?
    var phoneNumber: String?
    var verifyPhoneResponseModel : VerifyPhoneNumberModel?
    
    //MARK:- life cycle method
    override func viewDidLoad(){
        super.viewDidLoad()
        setView()
    }
    
    //MARK:- Action
    @IBAction func NextAction(_ sender: Any){
        nxtBtnAction()
    }
    //MARK:- Next Button Action
    func nxtBtnAction(){
        self.viewModel?.ConfirmPasswordValidations(password: txtPassword.text, confirmPassword: txtConfirmPass.text)
    }
    //MARK:- Other function
    func setView(){
        //Initialize memory for view model
        self.viewModel = ConfirmPasswordViewModel.init(delegate: self)
        self.viewModel?.attachView(view: self)
        //Textfield font set
        txtPassword.SetTextFont(textSize: KTextSize.KSixteen, placeholderText: KPlaceholder.kEnterPassword)
        txtConfirmPass.SetTextFont(textSize: KTextSize.KSixteen, placeholderText: KPlaceholder.kConfirmPassword)
        btnNext.SetButtonFont(textSize: KTextSize.KSeventeen)
        self.navigationController?.SetNavigationFont(textSize: KTextSize.KSeventeen)
        self.title = KStoryBoards.KForgotPassIdentifiers.kCreatePassTitle
        //Corner,Shadow of button,view
        cornerButton(btn: btnNext,radius: KTextSize.KEight)
        cornerView(radius: KTextSize.KEight, view: viewConfirmPass)
        cornerView(radius: KTextSize.KEight, view: viewPassword)
        addShadow(view: viewConfirmPass)
        addShadow(view: viewPassword)
    }
}

//MARK:- textFieldDelegate Method
extension ConfirmPasswordVC : UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if textField == txtPassword {
            
            txtConfirmPass.becomeFirstResponder()
        }
        else if(textField == txtConfirmPass){
            
            txtConfirmPass.resignFirstResponder()
        }
        return true
    }
}
//MARK:-
extension ConfirmPasswordVC:ConfirmPasswordDelegate
{
    func confirmPasswordDidSuccess()
    {
        self.view.endEditing(true)
        let signUpVc = self.storyboard?.instantiateViewController(withIdentifier: KStoryBoards.KSignUpIdentifiers.kSignUpViewController) as! SignUpViewController
        signUpVc.phNo = phoneNumber
        signUpVc.password = txtConfirmPass.text
        signUpVc.varifyPhnResponseModel = verifyPhoneResponseModel
        self.navigationController?.pushViewController(signUpVc, animated: true)
    }
    
    func Falied(message: String)
    {
        self.showAlert(alert: message)
    }
    
}

extension ConfirmPasswordVC : ViewDelegate
{
    func showAlert(alert: String)
    {
        self.view.endEditing(true)
        initializeCustomOkAlert(self.view, isHideBlurView: true)
        okAlertView.delegate = self
        okAlertView.lblResponseDetailMessage.text = alert
    }
    func showLoader()
    {
       
       ShowLoader()
    }
    func hideLoader()
    {
        HideLoader()
    }
}
//MARK:- Custom Ok Alert
extension ConfirmPasswordVC : OKAlertViewDelegate{
    //Ok Button Clicked
    func okBtnAction() {
        okAlertView.removeFromSuperview()
    }
}
