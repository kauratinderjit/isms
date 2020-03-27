//
//  LoginVC.swift
//  LatestArchitechtureDemo
//
//  Created by Navaldeep on 5/23/19.
//  Copyright © 2019 Navaldeep Kaur. All rights reserved.
//

import UIKit

class LoginVC: BaseUIViewController {
    
    //MARK:-  Properties
    @IBOutlet weak var txtFieldPhoneNumber: UITextField!
    @IBOutlet weak var txtFieldPassword: UITextField!
    @IBOutlet weak var viewPhnNo: UIView!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var lblForgot: UILabel!
    @IBOutlet weak var btnForgot: UIButton!
    @IBOutlet weak var kPhoneNoTop: NSLayoutConstraint!
    @IBOutlet weak var kConstantBtnLoginTop: NSLayoutConstraint!
    
    //MARK:-  Variables
    var viewModel:LoginViewModel?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        setView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        unHidingNavigationBar()
    }
    
    //MARK:-  UIButton Actions
    @IBAction func LoginAction(_ sender: Any){
        actionLoginButton()
    }
    
    @IBAction func ForgotPassAction(_ sender: Any){
        pushToNextVC(storyboardName: KStoryBoards.kMain, viewControllerName: KStoryBoards.KForgotPassIdentifiers.kForgotPassVC)
    }
    //MARK:- Other function
    func setView() {
        
        //SetUp Delegates and view
        self.viewModel = LoginViewModel.init(delegate: self )
        self.viewModel?.attachView(view: self )
        
        //Set textfield fonts sizes and its placeholders
        txtFieldPassword.SetTextFont(textSize: KTextSize.KSixteen, placeholderText: KPlaceholder.kPassword)
        txtFieldPhoneNumber.SetTextFont(textSize: KTextSize.KSixteen, placeholderText: KPlaceholder.kPhoneEmail)
        
        //Set text size of label and button
        lblForgot.SetLabelFont(textSize: KTextSize.KFourteen)
        btnLogin.SetButtonFont(textSize: KTextSize.KSeventeen)
        
        //Set navigation controller font size
        self.navigationController?.SetNavigationFont(textSize: KTextSize.KSeventeen)
        
        //Set Title
        self.title = KStoryBoards.KLoginIdentifiers.kTitle
        
        //Set navigation back button
        self.setBackButton()
        
        txtFieldPhoneNumber.addTarget(self, action: #selector(txtFieldPhoneNumberDidchange), for: .editingChanged)
        
        //Set corner of the buttons and views and add shadow to view
        cornerButton(btn: btnLogin,radius: KTextSize.KEight)
        cornerView(radius:KTextSize.KEight, view: viewPhnNo)
        cornerView(radius: KTextSize.KEight, view: viewPassword)
        addShadow(view: viewPhnNo)
        addShadow(view: viewPassword)
        
        //Set phone number top constant when phone number top is 100
        kPhoneNoTop.constant = 100
        viewPassword.isHidden = true
        btnLogin.isHidden = true
        btnForgot.isUserInteractionEnabled = false
        lblForgot.isHidden = true
    }
    
    //Unhide Navigation Controller
    func unHidingNavigationBar(){
        UnHideNavigationBar(navigationController: self.navigationController)
    }
    
    //On Login Button
    func actionLoginButton(){
        if let btnTitle = btnLogin.titleLabel?.text{
            switch btnTitle{
            case KConstants.kBtnDoneTitle:
                self.viewModel?.verifyPhNumber(phoneOrEmail: txtFieldPhoneNumber.text)
            case KConstants.kBtnLoginTitle:
                self.viewModel?.logInUser(phoneEmail:txtFieldPhoneNumber.text, password: txtFieldPassword.text)
            default:break
            }
        }
    }
    
    @objc func txtFieldPhoneNumberDidchange(_ textField: UITextField){
       
        if textField.text?.isNumber == true{
            if textField.text?.isPhoneNumber == true{
                if textField.text?.count == 10{
                    txtFieldPhoneNumber.resignFirstResponder()
                    self.viewModel?.verifyPhNumber(phoneOrEmail: textField.text)
                }else{
                    viewPassword.isHidden = true
                    btnLogin.isHidden = true
                    btnForgot.isUserInteractionEnabled = false
                    lblForgot.isHidden = true
                    CommonFunctions.sharedmanagerCommon.println(object: "Phone number is less then 10.")
                }
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Phone number false.")
            }
        }else{
            if textField.text?.isValidEmail() == true{
                btnLogin.setTitle(KConstants.kBtnDoneTitle, for: .normal)
                kConstantBtnLoginTop.constant = -38
                btnLogin.isHidden = false
            }else{
                viewPassword.isHidden = true
                btnLogin.isHidden = true
                btnForgot.isUserInteractionEnabled = false
                lblForgot.isHidden = true
                CommonFunctions.sharedmanagerCommon.println(object: "Email is not valid.")
            }
        }
    }
}


