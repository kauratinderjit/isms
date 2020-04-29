//
//  SignUpPresenter.swift
//  ISMS
//
//  Created by Navalpreet Kaur on 6/3/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

protocol SignUpDelegate:class{
    func GetAllCountryData(data:GetCommonDropdownModel)
    func getAllStateData(data: GetCommonDropdownModel)
    func getAllCityData(data: GetCommonDropdownModel)
    func getDataFalied(message:String)
    func signUpSuccess(message: String)
    func DidSuccedRole(data: UserRoleIdModel)
    func DidFailedRole()
    func DidSuccedRoleMenu(data: GetMenuFromRoleIdModel)
    func GetUserDetailSuccess(data: GetUserDetailByPhoneEmail )
    func DidFailedRoleMenu()
}

class SignUpViewModel{
    weak var delegate:SignUpDelegate?
    weak var signUpView: ViewDelegate?
    init(delegate:SignUpDelegate){
        self.delegate = delegate
    }
    //Attaching view
    func attachView(view: ViewDelegate) {
        signUpView = view
    }
    //Detaching view
    func detachView() {
        signUpView = nil
    }
    
    func getUserByPhoneNumber(Phone: String, Email:String){
        self.signUpView?.showLoader()
        var postDict = [String:Any]()
        postDict["Phone"] = Phone
        postDict["Email"] = Email
        
        print("our params: ",postDict)
        
        SignUpApi.sharedInstance.getUserDetailByPhoneEmail(url: ApiEndpoints.kGetUserDetailByPhoneEmail, parameters: postDict, completionResponse: { (GetUserDetailByPhoneEmail) in
            if GetUserDetailByPhoneEmail.statusCode == KStatusCode.kStatusCode302{
                self.signUpView?.hideLoader()
                self.delegate?.GetUserDetailSuccess(data: GetUserDetailByPhoneEmail)
            }else{
                self.signUpView?.hideLoader()
                CommonFunctions.sharedmanagerCommon.println(object: "status change")
            }
        }, completionnilResponse: { (nilResponseError) in
            
            self.signUpView?.hideLoader()
            self.delegate?.DidFailedRoleMenu()
            
            if let error = nilResponseError{
                self.signUpView?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Class APi Nil response")
            }
            
        }) { (error) in
            self.signUpView?.hideLoader()
            self.delegate?.DidFailedRoleMenu()
            if let err = error?.localizedDescription{
                self.signUpView?.showAlert(alert: err)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Class APi error response")
            }
        }
    }
    //Api to fetch Country list
    func GetCountryList(selectedCountryId: Int,enumType: Int)
    {
        self.signUpView?.showLoader()
        let url = ApiEndpoints.kGetCommonDropdownApi+"?id=\(selectedCountryId)&enumType=\(enumType)"
//        print("Get Country Url:- \(url)")
        SignUpApi.sharedInstance.getCommonDropdownApi(url: url, parameter: nil, completionResponse: { (data) in
            self.signUpView?.hideLoader()
            self.delegate?.GetAllCountryData(data: data)
        }, completionnilResponse:
            {(nilErr) in
            self.signUpView?.hideLoader()
            self.signUpView?.showAlert(alert: nilErr ?? "")
        }) { (error) in
            self.signUpView?.hideLoader()
            self.signUpView?.showAlert(alert: error?.localizedDescription ?? "")
        }
    }
    //Fetch State List
    func getStateList(selectedStateId : Int,enumType: Int){
        self.signUpView?.showLoader()
        let url = ApiEndpoints.kGetCommonDropdownApi+"?id=\(selectedStateId)&enumType=\(enumType)"
//        print("Get Country Url:- \(url)")
        SignUpApi.sharedInstance.getCommonDropdownApi(url: url, parameter: nil, completionResponse: { (data) in
            self.signUpView?.hideLoader()
            self.delegate?.getAllStateData(data: data)
        }, completionnilResponse:
            {(nilErr) in
                self.signUpView?.hideLoader()
                self.signUpView?.showAlert(alert: nilErr ?? "")
        }) { (error) in
            self.signUpView?.hideLoader()
            self.signUpView?.showAlert(alert: error?.localizedDescription ?? "")
        }
    }
    //Fetch State List
    func getCityList(selectedCityId : Int,enumType: Int){
        self.signUpView?.showLoader()
        let url = ApiEndpoints.kGetCommonDropdownApi+"?id=\(selectedCityId)&enumType=\(enumType)"
//        print("Get Country Url:- \(url)")
        SignUpApi.sharedInstance.getCommonDropdownApi(url: url, parameter: nil, completionResponse: { (data) in
            self.signUpView?.hideLoader()
            self.delegate?.getAllCityData(data: data)
        }, completionnilResponse:
            {(nilError) in
                self.signUpView?.hideLoader()
                self.signUpView?.showAlert(alert: nilError ?? "")
        }) { (error) in
            self.signUpView?.hideLoader()
            self.signUpView?.showAlert(alert: error?.localizedDescription ?? "")
        }
    }
    //MARK:- SignUp of User
    func signUpUser(firstName: String?,lastName: String?,gender: String?,country: String?,state: String?,city: String?,address: String?,email: String?,phoneNo:String?,password:String?,imgUrl: URL?,selectedCityId: Int?,dob: String?,description: String?,userId:Int?)
    {
        //MARk:-Check Validations
        if(firstName!.trimmingCharacters(in: .whitespaces).isEmpty)
        {
            self.signUpView?.showAlert(alert: Alerts.kEmptyFirstName)
        }
        else if(lastName!.trimmingCharacters(in: .whitespaces).isEmpty)
        {
            self.signUpView?.showAlert(alert: Alerts.kEmptyLastName)
        }
        else if gender!.trimmingCharacters(in: .whitespaces).isEmpty
        {
            self.signUpView?.showAlert(alert: Alerts.kEmptyGender)
        }
        else if dob!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        {
            self.signUpView?.showAlert(alert: Alerts.kEmptyDOB)
        }
        else if(country!.trimmingCharacters(in: .whitespaces).isEmpty)
        {
            self.signUpView?.showAlert(alert: Alerts.kSelectCountry)
        }
        else if(state!.trimmingCharacters(in: .whitespaces).isEmpty)
        {
            self.signUpView?.showAlert(alert: Alerts.kSelectState)
        }
        else if(city!.trimmingCharacters(in: .whitespaces).isEmpty)
        {
            self.signUpView?.showAlert(alert: Alerts.kEmptyCity)
        }
        else if selectedCityId == nil{
            self.signUpView?.showAlert(alert: Alerts.kEmptyCity)
        }
        else if(address!.trimmingCharacters(in: .whitespaces).isEmpty)
        {
            self.signUpView?.showAlert(alert: Alerts.kEmptyAddress)
        }
        else if(email!.trimmingCharacters(in: .whitespaces).isEmpty)
        {
            self.signUpView?.showAlert(alert: Alerts.kEmptyEmail)
        }
        else if (!(email?.isValidEmail())!){
            self.signUpView?.showAlert(alert: Alerts.kInvalidEmail)
        }
        else
        {
            //MARK:- Post SignUp Api
            guard let firstname = firstName else {return}
            guard let lastname = lastName else {return}
            guard let phoneNumber = phoneNo else {return}
            guard let gender = gender else {return}
            guard let password = password else {return}
            guard let address = address else {return}
            guard let email = email else {return}
            guard let selectedCityId = selectedCityId else {return}
            guard let dob = dob else {return}
            let paramDict = [KApiParameters.SignUpApiPerameters.kUserId:userId ?? 0,KApiParameters.SignUpApiPerameters.kFirstName:firstname,KApiParameters.SignUpApiPerameters.kLastName:lastname,KApiParameters.SignUpApiPerameters.kPhoneNumber:phoneNumber,KApiParameters.SignUpApiPerameters.kGender:gender,KApiParameters.SignUpApiPerameters.kPassword: password,KApiParameters.SignUpApiPerameters.kAddress:address,KApiParameters.SignUpApiPerameters.kEmail:email,KApiParameters.SignUpApiPerameters.kImageUrl: imgUrl ?? "",KApiParameters.SignUpApiPerameters.kCityId:selectedCityId,KApiParameters.SignUpApiPerameters.kDOB:dob] as [String : Any]

            self.signUpView?.showLoader()
            SignUpApi.sharedInstance.multipartApi(postDict: paramDict as [String : Any], url: ApiEndpoints.kSignUpApi, completionResponse: { (response) in
                print(response)
                self.signUpResponseJson(data: response, completionResponse: { (responseModel) in
               
                    self.signUpView?.hideLoader()
                    switch responseModel.statusCode {
                    case KStatusCode.kStatusCode200:
                        guard let msg = responseModel.message else {
                            return
                        }
                        self.delegate?.signUpSuccess(message: msg)
                    case KStatusCode.kStatusCode202:
                        guard let msg = responseModel.message else {
                            return
                        }
                       self.delegate?.signUpSuccess(message:msg)
                    case KStatusCode.kStatusCode400:
                        if let msg = responseModel.message{
                            self.signUpView?.showAlert(alert: msg)
                        }
                        //It is came when i updated the hod 
                    case KStatusCode.kStatusCode408:
                        guard let msg = responseModel.message else {return}
                        self.delegate?.signUpSuccess(message:msg)
                    default:
                        if let msg = responseModel.message{
                            self.signUpView?.showAlert(alert: msg)
                        }
                    }
                }, completionError: { (err) in
                    self.signUpView?.showAlert(alert: err ?? "")
                })
                
            }) { (error) in
                self.signUpView?.showAlert(alert: error?.localizedDescription ?? "")
            }
        }
    }
    
    private func signUpResponseJson(data: [String : Any],completionResponse:  @escaping (SignUpResponseModel) -> Void,completionError: @escaping (String?) -> Void)  {
        let signUpData = SignUpResponseModel(JSON: data)
        if signUpData != nil{
            completionResponse(signUpData!)
        }else{
            completionError(Alerts.kMapperModelError)
        }
    }
    
    func getRoleId(userID: Int?){
        self.signUpView?.showLoader()
        
        SignUpApi.sharedInstance.getUserRoleId(url: ApiEndpoints.kUserRole + "\(userID ?? 0)", parameters: nil, completionResponse: { (UserRoleIdModel) in
            
            if UserRoleIdModel.statusCode == KStatusCode.kStatusCode200{
                self.signUpView?.hideLoader()
                self.delegate?.DidSuccedRole(data: UserRoleIdModel)
            }else{
                self.signUpView?.hideLoader()
                CommonFunctions.sharedmanagerCommon.println(object: "Role Id APi status change")
            }
        }, completionnilResponse: { (nilResponseError) in
            self.signUpView?.hideLoader()
            self.delegate?.DidFailedRole()
            if let error = nilResponseError{
                self.signUpView?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Role ID APi Nil response")
            }
        }) { (error) in
            self.signUpView?.hideLoader()
            self.delegate?.DidFailedRole()
            if let err = error?.localizedDescription{
                self.signUpView?.showAlert(alert: err)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Role Id APi error response")
            }
        }
    }
    
    func getMenuFromUserRoleId(userId: Int?,roleId:Int?){
        self.signUpView?.showLoader()
        var postDict = [String:Any]()
        postDict[KApiParameters.KGetPagesByUserIdIdintifier.kUserId] = userId
        postDict[KApiParameters.KGetPagesByUserIdIdintifier.kRoleId] = roleId

        SignUpApi.sharedInstance.getUserMenuFromRoleId(url: ApiEndpoints.kUserRoleMenu, parameters: postDict, completionResponse: { (GetMenuFromRoleIdModel) in
            if GetMenuFromRoleIdModel.statusCode == KStatusCode.kStatusCode200{
                self.signUpView?.hideLoader()
                self.delegate?.DidSuccedRoleMenu(data: GetMenuFromRoleIdModel)
            }else{
                self.signUpView?.hideLoader()
                CommonFunctions.sharedmanagerCommon.println(object: "Class APi status change")
            }
        }, completionnilResponse: { (nilResponseError) in
            
            self.signUpView?.hideLoader()
            self.delegate?.DidFailedRoleMenu()
            
            if let error = nilResponseError{
                self.signUpView?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Class APi Nil response")
            }
            
        }) { (error) in
            self.signUpView?.hideLoader()
            self.delegate?.DidFailedRoleMenu()
            if let err = error?.localizedDescription{
                self.signUpView?.showAlert(alert: err)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Class APi error response")
            }
        }
    }
}

