//
//  LoginPresenter.swift
//  ISMS
//
//  Created by Taranjeet Singh on 5/6/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation


protocol LogInDelegate:class {
    func loginDidSucced(data: LoginData)
    func loginDidFalied()
    func userNotExist(phoneNo: String,data : VerifyPhoneNumberModel)
    func userExist(data : VerifyPhoneNumberModel)
    func DidSuccedRole(data: UserRoleIdModel)
    func DidFailedRole()
    func DidSuccedRoleMenu(data: GetMenuFromRoleIdModel)
    func DidFailedRoleMenu()
}

class LoginViewModel {

    //LogIn delegate
    weak var delegate : LogInDelegate?
    
    //LogIn View
    weak var logInView : ViewDelegate?
    
    var loginDidSuccess: (LoginData) -> () = { _ in }
    var loginDidFailed:() -> () = {}
    var userNotExist:(_ phoneno:String,_ data:VerifyPhoneNumberModel) -> () = { _,_  in }
    var userExist:(_ data: VerifyPhoneNumberModel) -> () = { _ in }
    var didSuccedRole:(_ data:UserRoleIdModel) -> () = { _ in }
    var didFailedRole:() -> () = {}
    
    //Initialize the Presenter class
    init(delegate:LogInDelegate) {
        self.delegate = delegate
    }
    
    //Attaching login view
    func attachView(view: ViewDelegate) {
        logInView = view
    }
    
    //Detaching login view
    func detachView() {
        logInView = nil
    }

    
    //MARK:- User Logged In Through Email/Phone number and password and get user token
    func logInUser(phoneEmail: String?,password: String?){
        
        do {
            //check validations
            try LoginValidations(phonenumber: phoneEmail,password: password)
            var parm = [String:Any]()

                if let phoneNoEmail = phoneEmail,let password = password{
                    parm   = [KApiParameters.LoginApiPerameters.kUserId:0,KApiParameters.LoginApiPerameters.kUsername:phoneNoEmail,KApiParameters.LoginApiPerameters.kPassword: password]
                }
            self.logInView?.showLoader()
             print("url param: ",parm)
            print("url login: ",ApiEndpoints.kLogin)
            //Login User Using Email And Password and get token
            LoginApi.sharedmanagerAuth.LogInApi(url: ApiEndpoints.kLogin, parameter: parm, completionResponse: { (response) in

                print(response)
                self.logInView?.hideLoader()
                
                if response.statusCode == KStatusCode.kStatusCode200{
                    UserDefaultExtensionModel.shared.currentUserAccessToken = response.resultData?.token ?? ""
                    UserDefaultExtensionModel.shared.currentUserId = response.resultData?.userId ?? 0
                    UserDefaultExtensionModel.shared.activeSessionId = response.resultData?.sessionId ?? 0
                    self.delegate?.loginDidSucced(data: response)
                }
                else if response.statusCode == KStatusCode.kStatusCode400
                {
                    self.logInView?.showAlert(alert: response.message!)
                }

            }, completionnilResponse: { (String) in
                self.logInView?.hideLoader()
                self.logInView?.showAlert(alert: String)
            }) { (error) in
                self.logInView?.hideLoader()
                self.logInView?.showAlert(alert: error.debugDescription)
            }
    }
        catch let error
        {
            switch  error {
            case ValidationError.emptyPhoneNumber:
                   self.logInView?.showAlert(alert: Alerts.kEmptyPhoneNumber)
            case ValidationError.minCharactersPhoneNumber:
                self.logInView?.showAlert(alert: Alerts.kMinPhoneNumberCharacter)
            case ValidationError.emptyPassword:
                self.logInView?.showAlert(alert: k_EmptyPassword)
            case ValidationError.passwordlengthshouldbe8to16long:
              self.logInView?.showAlert(alert: k_MinPasswordLength)
            default:
                  CommonFunctions.sharedmanagerCommon.println(object:k_DefaultCase)
                break
            }
        }
    }
   
    //MARK:- Login Validations
    func LoginValidations(phonenumber: String?,password: String?) throws
    {
         guard let phonenumber  = phonenumber, !phonenumber.isEmpty, !phonenumber.trimmingCharacters(in: .whitespaces).isEmpty else
        {
            throw ValidationError.emptyPhoneNumber
        }
       
        if phonenumber.count < 10{
            throw ValidationError.minCharactersPhoneNumber
        }
        
        guard let password  = password, !password.isEmpty, !password.trimmingCharacters(in: .whitespaces).isEmpty else
        {
            throw ValidationError.emptyPassword
        }
        
        if (password.trimmingCharacters(in: .whitespacesAndNewlines).count < 4 || password.count > 16)
        {
           throw ValidationError.passwordlengthshouldbe8to16long
        }
        /*if(!password.passwordMinLength)
        {
            throw ValidationError.passwordMinChar
        }*/
    }
    
    //MARK:- Verify Phone Number
    func verifyPhNumber(phoneOrEmail : String?){
        
        self.logInView?.showLoader()
        
        if let phoneEmail = phoneOrEmail{
            let postParameter : [String:Any] = [KApiParameters.LoginApiPerameters.kUsername:phoneEmail]
            
            LoginApi.sharedmanagerAuth.veriFyPhoneNumberApi(url: ApiEndpoints.kVerifyPhoneEmail+"?\(KApiParameters.LoginApiPerameters.kUsername)=\(phoneEmail)", parameter: postParameter, completionResponse:
                { (verifyPhoneModel) in
                self.logInView?.hideLoader()
                switch verifyPhoneModel.statusCode{
                case KStatusCode.kStatusCode200:
                    self.delegate?.userExist(data: verifyPhoneModel)
                case KStatusCode.kStatusCode302:
                    //User Exist in data base if isRegister is fasle but add from admin
                    if verifyPhoneModel.resultData?.isRegister == 0{
                        self.delegate?.userNotExist(phoneNo: phoneEmail,data: verifyPhoneModel)
                    }
                    else if verifyPhoneModel.resultData?.isRegister == 1{
                        //User Exist in data base if isRegister is True but add from admin
                        self.delegate?.userExist(data: verifyPhoneModel)
                    }
                case KStatusCode.kStatusCode404:
                    //User Not exist in database
                    self.delegate?.userNotExist(phoneNo: phoneEmail,data: verifyPhoneModel)
                default:
                    self.logInView?.showAlert(alert: verifyPhoneModel.message ?? "")
                }
            }, completionnilResponse: { (nilResponse) in
                self.logInView?.hideLoader()
                if let nilRspnse = nilResponse{
                    self.logInView?.showAlert(alert: nilRspnse)
                }
            }) { (error) in
                self.logInView?.hideLoader()
                if let err = error{
                    self.logInView?.showAlert(alert: err.localizedDescription)
                }
            }
        }
    }
    
    func deviceTokenApi(DeviceType: String,DeviceToken: String,UserId:Int) {
                                 logInView?.showLoader()
                      let param = [       "DeviceType" : DeviceType,
                                           "DeviceToken" : DeviceToken,
                                           "UserId": UserId
                                          
                                           ] as [String : Any]
        
                                    print("device token: ",param)
                                          
                                       let url = "api/User/AddUpdateDeviceDetail"
                                 HomeworkApi.sharedManager.likePost(url:url , parameters: param, completionResponse: { (response) in
                                              print("device response: ",response)
                                              self.logInView?.hideLoader()
                                              switch response["StatusCode"] as? Int{
                                              case 200: break
                                               
                                                            // self.uploadPostViewDelegate?.showAlert(alert: response["Message"]  as? String ?? "")
                                                           //  self.UploadPostDelegate?.addedSuccessfully()
                                                         case 401: break
                                                            // self.uploadPostViewDelegate?.showAlert(alert: response["Message"] as? String ?? "")
                                                             //self.AddHomeWorkDelegate?.unauthorizedUser()
                                                         default: break
                                                            // self.uploadPostViewDelegate?.showAlert(alert: response["Message"] as? String ?? "")
                                                         }

                                              
                                          }, completionnilResponse: { (nilResponseError) in
                                              self.logInView?.hideLoader()
                                              if let error = nilResponseError{
                                                 // self.uploadPostViewDelegate?.showAlert(alert: error.description)
                                                  
                                              }else{
                                                  CommonFunctions.sharedmanagerCommon.println(object: SyllabusCoverage.kSyllabusResponseNotGet)
                                              }
                                          }) { (error) in
                                              self.logInView?.hideLoader()
                                              if let err = error?.localizedDescription{
                                                //  self.uploadPostViewDelegate?.showAlert(alert: err)
                                              }else{
                                                  CommonFunctions.sharedmanagerCommon.println(object: SyllabusCoverage.kSyllabusResponseError)
                                              }
                                          }
                           
                            }
       
    func getRoleId(userID: Int?){
        self.logInView?.showLoader()
        LoginApi.sharedmanagerAuth.getUserRoleId(url: ApiEndpoints.kUserRole + "\(userID ?? 0)", parameters: nil, completionResponse: { (UserRoleIdModel) in
            if UserRoleIdModel.statusCode == KStatusCode.kStatusCode200{
                self.logInView?.hideLoader()
                self.delegate?.DidSuccedRole(data: UserRoleIdModel)
            }else{
                self.logInView?.hideLoader()
                CommonFunctions.sharedmanagerCommon.println(object: "Class APi status change")
            }
        }, completionnilResponse: { (nilResponseError) in
            self.logInView?.hideLoader()
            self.delegate?.DidFailedRole()
            if let error = nilResponseError{
                self.logInView?.showAlert(alert: error)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Class APi Nil response")
            }
        }) { (error) in
            self.logInView?.hideLoader()
            self.delegate?.DidFailedRole()
            if let err = error?.localizedDescription{
                self.logInView?.showAlert(alert: err)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Class APi error response")
            }
        }
    }
    func getMenuFromUserRoleId(userId: Int?,roleId : Int?){
        self.logInView?.showLoader()
        var postDict = [String:Any]()
        postDict[KApiParameters.KGetPagesByUserIdIdintifier.kUserId] = userId
        postDict[KApiParameters.KGetPagesByUserIdIdintifier.kRoleId] = roleId
        LoginApi.sharedmanagerAuth.getUserMenuFromRoleId(url: ApiEndpoints.kUserRoleMenu , parameters: postDict, completionResponse: { (GetMenuFromRoleIdModel) in
            if GetMenuFromRoleIdModel.statusCode == KStatusCode.kStatusCode200{
                self.logInView?.hideLoader()
                self.delegate?.DidSuccedRoleMenu(data: GetMenuFromRoleIdModel)
            }else{
                self.logInView?.hideLoader()
                CommonFunctions.sharedmanagerCommon.println(object: "Class APi status change")
            }
        }, completionnilResponse: { (nilResponseError) in
            self.logInView?.hideLoader()
            self.delegate?.DidFailedRoleMenu()
            if let error = nilResponseError{
                self.logInView?.showAlert(alert: error)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Class APi Nil response")
            }
        }) { (error) in
            self.logInView?.hideLoader()
            self.delegate?.DidFailedRoleMenu()
            if let err = error?.localizedDescription{
                self.logInView?.showAlert(alert: err)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Class APi error response")
            }
        }
    }
}
//MARK:- Login View Delegates
extension LoginVC : ViewDelegate{
    func showAlert(alert: String){
        initializeCustomOkAlert(self.view, isHideBlurView: true)
        okAlertView.delegate = self
        self.okAlertView.lblResponseDetailMessage.text = alert
    }
    func showLoader() {
        ShowLoader()
    }
    func hideLoader() {
        HideLoader()
    }
}
//MARK:- Login Delegate
extension LoginVC : LogInDelegate{
    func DidSuccedRoleMenu(data: GetMenuFromRoleIdModel) {
        print("data: ",data.resultData ?? "")
    }
    func DidFailedRoleMenu() {
    }
    //Get Role Did succes of user
    func DidSuccedRole(data: UserRoleIdModel) {
        print("RoleId: ",data.resultData?.count ?? "")
        //Save the userrolecount for side menu checks
        UserDefaults.standard.set(data.resultData?.count ?? 0, forKey: UserDefaultKeys.userRolesCount.rawValue)
        if data.resultData?.count ?? 0 == 0{
            //When user have no roles
            let storyboard = UIStoryboard.init(name: KStoryBoards.kHome, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: KStoryBoards.kSWRevealVC)
            appDelegate.window?.rootViewController = vc
            
        }else if data.resultData?.count ?? 0 == 1{
            //When user have only one role then redirect to home screen
            let storyboard = UIStoryboard.init(name: KStoryBoards.kHome, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: KStoryBoards.kSWRevealVC)
            appDelegate.window?.rootViewController = vc
            HomeVC.isCameDirectFromLoginScreen = true
            //Save the user role id in user defaults when user have only one role move to home screen and hit side menu api.
            UserDefaultExtensionModel.shared.currentUserRoleId = data.resultData?.first?.roleId ?? 0
            UserDefaultExtensionModel.shared.userRoleParticularId = data.resultData?.first?.particularId ?? 0
                UserDefaultExtensionModel.shared.currentHODRoleName = data.resultData?.first?.roleName ?? ""
            UserDefaultExtensionModel.shared.HODDepartmentId = data.resultData?.first?.departmentId ?? 0
            UserDefaultExtensionModel.shared.HODDepartmentName = data.resultData?.first?.departmentName ?? ""
            UserDefaultExtensionModel.shared.StudentClassId = data.resultData?.first?.classId ?? 0
            UserDefaultExtensionModel.shared.UserName = data.resultData?.first?.UserName ?? ""
            UserDefaultExtensionModel.shared.enrollmentIdStudent = data.resultData?.first?.enrollmentId ?? 0
            UserDefaultExtensionModel.shared.classNameStudent = data.resultData?.first?.className ?? ""
            UserDefaultExtensionModel.shared.imageUrl = data.resultData?.first?.ImageUrl ?? ""
            
        }else if  data.resultData?.count ?? 0 > 1 {
            //When user have more then one role then it move to multiple user role screen
            let vc = UIStoryboard.init(name: KStoryBoards.kMain, bundle: Bundle.main).instantiateViewController(withIdentifier: KStoryBoards.KUserRoleIdIdentifiers.kUserRoleIdVC) as! UserRoleIdVC
            vc.roleIdArr = data
            vc.isCameFromLoginVC = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func DidFailedRole() {
    }
    //User Not Exist
    func userNotExist(phoneNo: String, data: VerifyPhoneNumberModel) {
        let confirmVC = self.storyboard?.instantiateViewController(withIdentifier: KStoryBoards.KForgotPassIdentifiers.kCreatePassVC) as! ConfirmPasswordVC
        confirmVC.phoneNumber = phoneNo
        confirmVC.verifyPhoneResponseModel = data
        self.navigationController?.pushViewController(confirmVC, animated: true)
    }
    //User Exist
    func userExist(data: VerifyPhoneNumberModel) {
        kPhoneNoTop.constant = 28
        viewPassword.isHidden = false
        btnLogin.setTitle(KConstants.kBtnLoginTitle, for: .normal)
        kConstantBtnLoginTop.constant = 16
        btnLogin.isHidden = false
        btnForgot.isUserInteractionEnabled = true
        lblForgot.isHidden = false
        phoneNumber = data.resultData?.PhoneNo ?? ""
        UserDefaultExtensionModel.shared.forgotUserId = data.resultData?.userId ?? 0
    }
    func loginDidSucced(data: LoginData){
        if let token = UserDefaults.standard.string(forKey: "token") {
                 self.viewModel?.deviceTokenApi(DeviceType: "3",DeviceToken:  token,UserId:UserDefaultExtensionModel.shared.currentUserId)
             }
             
        let userId = data.resultData?.userId
        self.viewModel?.getRoleId(userID: userId)
    }
    func loginDidFalied()
    {
        
    }
}
//MARK:- textFieldDelegate Method
extension LoginVC : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        if textField == txtFieldPhoneNumber {
            txtFieldPassword.becomeFirstResponder()
        }
        else if(textField == txtFieldPassword){
            self.view.endEditing(true)
        }
        return true
    }
}
//MARK:- Custom Ok Alert
extension LoginVC : OKAlertViewDelegate{
    //Ok Button Clicked
    func okBtnAction() {
        okAlertView.removeFromSuperview()
    }
}
