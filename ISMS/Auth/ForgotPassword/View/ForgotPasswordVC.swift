//
//  ForgotPasswordVC.swift
//  ISMS
//
//  Created by Navalpreet Kaur on 5/29/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class ForgotPasswordVC: BaseUIViewController
{
     //MARK:-  Properties
    
    @IBOutlet weak var imgForgotIcon: UIImageView!
    @IBOutlet weak var viewConfirePassword: UIView!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnNext: UIButton!
    
    //MARK:-Variables
    var viewModel:ForgotPasswordViewModel?
    
    //MARK:- life cycle method
    override func viewDidLoad(){
        super.viewDidLoad()
        SetView()
    }
    //MARK:- Actions
    @IBAction func NextAction(_ sender: Any){
        navigateToForgotPass()
    }
    //MARK:- Navigate to forgot password
    func navigateToForgotPass(){
        self.viewModel?.forgotPasswordValidations(password: txtPassword.text, confirmPassword: txtConfirmPassword.text)
    }
    //MARK:- Other functions
    func SetView(){
        //Initialize memory for view model
        self.viewModel = ForgotPasswordViewModel.init(delegate: self)
        self.viewModel?.attachView(view: self)
        //Set text field password
        txtPassword.SetTextFont(textSize: KTextSize.KSixteen, placeholderText: KPlaceholder.kPassword)
        txtConfirmPassword.SetTextFont(textSize: KTextSize.KSixteen, placeholderText: KPlaceholder.kConfirmPassword)
        btnNext.SetButtonFont(textSize: KTextSize.KSeventeen)
        self.navigationController?.SetNavigationFont(textSize: KTextSize.KSeventeen)
        self.title = KStoryBoards.KForgotPassIdentifiers.kForgotTitle
        let backButton =  UIBarButtonItem(image: UIImage(named: kImages.KBackIcon), style: .plain, target: self, action: #selector(BackAction))
        self.navigationItem.leftBarButtonItem  = backButton
        //Corner the view and button
        //cornerButton(btn: btnNext,radius: KTextSize.KEight)
        cornerView(radius: KTextSize.KEight, view: viewPassword)
        cornerView(radius: KTextSize.KEight, view: viewConfirePassword)
        //Add shadow
       // addShadow(view: viewConfirePassword)
       // addShadow(view: viewPassword)
        
       
    }
    
    //back button action
    @objc func BackAction(){
      self.navigationController?.popViewController(animated: false)
    }
   
}
//MARK:- textFieldDelegate Method
extension ForgotPasswordVC : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        if textField == txtPassword {
            txtConfirmPassword.becomeFirstResponder()
        }
        else if(textField == txtConfirmPassword){
            self.view.endEditing(true)
        }
        return true
    }
}
//MARK:- presenter Delegate
extension ForgotPasswordVC:ForgotPasswordDelegate{
    func Success(msg:String?)
    {
      showAlert(Message: msg ?? "")
      CommonFunctions.sharedmanagerCommon.setRootLogin()
    }
    func Falied(message: String) {
        showAlert(Message: message)
    }
}
//MARK:- view delegate
extension ForgotPasswordVC : ViewDelegate{
    func showAlert(alert: String){
        initializeCustomOkAlert(self.view, isHideBlurView: true)
        okAlertView.delegate = self
        okAlertView.lblResponseDetailMessage.text = alert
    }
    func showLoader() {
        ShowLoader()
    }
    func hideLoader() {
        HideLoader()
    }
}
//MARK:- Custom Ok Alert
extension ForgotPasswordVC : OKAlertViewDelegate{
    //Ok Button Clicked
    func okBtnAction() {
        okAlertView.removeFromSuperview()
    }
}
