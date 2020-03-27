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
//MARK:- View Delegate
extension SignUpViewController : ViewDelegate{
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
//MARK:- SignUp Delegates
extension SignUpViewController:SignUpDelegate{
    func signUpSuccess(message: String) {
        self.showAlert(alert: message)
        CommonFunctions.sharedmanagerCommon.setRootLogin()
    }
    
    func DidSuccedRoleMenu(data: GetMenuFromRoleIdModel) {
        print("menu: ",data.resultData ?? "")
    }
    func DidFailedRoleMenu() {
    }
    func DidSuccedRole(data: UserRoleIdModel) {
        if data.resultData?.count ?? 0 <= 1{
         
            self.viewModel?.getMenuFromUserRoleId(userId: UserDefaultExtensionModel.shared.currentUserId, roleId: data.resultData?.first?.roleId)
            let storyboard = UIStoryboard.init(name: KStoryBoards.kHome, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: KStoryBoards.kSWRevealVC)
            appDelegate.window?.rootViewController = vc
        }else if  data.resultData?.count ?? 0 > 1 {
            let vc = UIStoryboard.init(name: KStoryBoards.kMain, bundle: Bundle.main).instantiateViewController(withIdentifier: KStoryBoards.KUserRoleIdIdentifiers.kUserRoleIdVC) as! UserRoleIdVC
            vc.roleIdArr = data
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func DidFailedRole() {
    }
    func getAllStateData(data: GetCommonDropdownModel) {
        stateData = data
        if let count = stateData?.resultData?.count{
            if count > 0{
                if firstTimeLoad == true{
                    txtState.text = stateData?.resultData?[0].name
                    self.viewModel?.getCityList(selectedCityId: stateData?.resultData?[0].id ?? 0, enumType: CountryStateCity.city.rawValue)
                }else{
                    //Set the data in the textfield from 0 index when api hit
                    if stateData?.resultData?[0].name != nil||stateData?.resultData?[0].id != nil{
                        txtState.text = stateData?.resultData?[0].name
                        self.viewModel?.getCityList(selectedCityId: stateData?.resultData?[0].id ?? 0, enumType: CountryStateCity.city.rawValue)
                    }else{
                        CommonFunctions.sharedmanagerCommon.println(object: "State Value is nil.")
                    }
                }
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "State count is zero.")
            }
        }else{
            CommonFunctions.sharedmanagerCommon.println(object: "Count is nil")
        }
    }
    func getAllCityData(data: GetCommonDropdownModel) {
        cityData = data
        if let count = cityData?.resultData?.count{
            if count > 0{
                if firstTimeLoad == true{
                    firstTimeLoad = false
                    txtCity.text = cityData?.resultData?[0].name
                    selectedCityId = cityData?.resultData?[0].id
                }else{
                    if cityData?.resultData?[0].name != nil{
                        txtCity.text = cityData?.resultData?[0].name
                        selectedCityId = cityData?.resultData?[0].id
                    }else{
                        CommonFunctions.sharedmanagerCommon.println(object: "City is nil.")
                    }
                }
            }else{
                //                txtCity.text = ""
            }
        }else{
            CommonFunctions.sharedmanagerCommon.println(object: "City count is not wrapped")
        }
    }
  
    func GetAllCountryData(data: GetCommonDropdownModel) {
        if firstTimeLoad == true{
            countryData = data
            if countryData?.resultData?[exist: 0]?.name != nil{
                txtCountry.text = countryData?.resultData?[0].name
                self.viewModel?.getStateList(selectedStateId: countryData?.resultData?[0].id ?? 0, enumType: 2)
            }
        }else{
            if countryData.resultData?[exist: selectedCountryIndex]?.name != nil{
                txtCountry.text = countryData?.resultData?[selectedCountryIndex].name
                self.viewModel?.getStateList(selectedStateId: countryData?.resultData?[selectedCountryIndex].id ?? 0, enumType: 2)
            }
        }
    }
    func getDataFalied(message: String){
        self.showAlert(alert: message)
    }
}

//MARK:- Picker View Delegates
extension SignUpViewController:SharedUIPickerDelegate{
    func DoneBtnClicked(){
        if selectCountry == true{
            selectCountry = false
            if let count = countryData?.resultData?.count{
                if count > 0{
                 
//                    if txtCountry.text == countryData?.resultData?[0].name{
//                        self.txtCountry.text = countryData?.resultData?[0].name
//                        if let id = countryData?.resultData?[0].id{
//                            self.viewModel?.getStateList(selectedStateId: id, enumType: 2)
//                        }
//                    }else{
//                        self.txtCountry.text = countryData?.resultData?[selectedCountryIndex].name
//                        if let id = countryData?.resultData?[selectedCountryIndex].id{
//                            self.viewModel?.getStateList(selectedStateId: id, enumType: 2)
//                        }
//                    }
                //gurleen
                 self.txtCountry.text = countryData?.resultData?[selectedCountryIndex].name
                 if let id = countryData?.resultData?[selectedCountryIndex].id {
                       self.viewModel?.getStateList(selectedStateId: id, enumType: 2)
                    }
                }
            }
        }
        if selectState == true{
            selectState = false
            againSelectState = true
//            if txtState.text == stateData?.resultData?[0].name{
//                txtState.text = stateData?.resultData?[0].name
//                if let id = stateData?.resultData?[0].id{
//                    self.viewModel?.getCityList(selectedCityId: id, enumType: 3)
//                }
//            }else{
//                if stateData?.resultData?[exist: selectedStateIndex]?.name != nil{
//                    txtState.text = stateData?.resultData?[selectedStateIndex].name
//                    if let id = stateData?.resultData?[selectedStateIndex].id{
//                        self.viewModel?.getCityList(selectedCityId: id, enumType: 3)
//                    }
//                }
//            }
            //gurleen
            self.txtState.text = stateData?.resultData?[selectedStateIndex].name
            if let id = stateData?.resultData?[selectedStateIndex].id{
            self.viewModel?.getCityList(selectedCityId: id, enumType: 3)
            }
        }
        if selectCity == true{
            selectCity = false
            //For Prevent Index out of range error
            if cityData?.resultData?[exist: selectedCityIndex]?.name != nil{
                self.txtCity.text = cityData?.resultData?[selectedCityIndex].name
                selectedCityId = cityData?.resultData?[selectedCityIndex].id
            }
        }
    }
    func GetTitleForRow(index: Int) -> String{
        //Set the picker country value first time in country field
        if self.selectCountry == true{
            if let count = countryData.resultData?.count{
                if count > 0{
                    txtCountry.text = countryData?.resultData?[0].name
                    return countryData?.resultData?[index].name ?? ""
                }
            }
        }else if self.selectState == true{
            if let count = stateData.resultData?.count{
                if count > 0{
                    txtState.text = stateData?.resultData?[0].name
                    return  self.stateData?.resultData?[index].name ?? ""
                }
            }
        }else if self.selectCity == true{
            if let count = cityData.resultData?.count{
                if count > 0{
                    txtCity.text = cityData?.resultData?[0].name
                    return self.cityData?.resultData?[index].name ?? ""
                }
            }
        }
        return ""
    }
    func SelectedRow(index: Int){
        DispatchQueue.main.async {
            if self.selectCountry == true{
                self.selectedCountryIndex = index
                //Using Exist Method of collection prevent from indexoutof range error
                if (self.countryData.resultData?[exist: index]?.name) != nil{
                    //self.txtCountry.text = self.countryData?.resultData?[index].name
                    CommonFunctions.sharedmanagerCommon.println(object: "Selected Country:- \(String(describing: self.countryData?.resultData?[index].name))")
                }
            }else if self.selectState == true{
                self.selectedStateIndex = index
                if (self.stateData.resultData?[exist: index]?.name) != nil{
                   // self.txtState.text = self.stateData?.resultData?[index].name
                    CommonFunctions.sharedmanagerCommon.println(object: "Selected State:- \(String(describing: self.stateData?.resultData?[index].name))")
                }
            }else if self.selectCity == true{
                self.selectedCityIndex = index
                if (self.cityData.resultData?[exist: index]?.name) != nil{
                  //  self.txtCity.text = self.cityData?.resultData?[index].name
                    CommonFunctions.sharedmanagerCommon.println(object: "Selected City:- \(String(describing: self.cityData?.resultData?[index].name))")
                }
            }
        }
    }
}

//MARK:- UIImagePickerView Delegate
extension SignUpViewController:UIImagePickerDelegate{
    func selectedImageUrl(url: URL) {
        selectedImageURl = url
    }
    func SelectedMedia(image: UIImage?, videoURL: URL?){
        self.imgViewProfile.contentMode = .scaleAspectFill
        self.imgViewProfile.image = image
        CommonFunctions.sharedmanagerCommon.println(object: "Byte Array count:- \(byteArrayofImages)")
    }
}

//MARK:- Custom Gallery Alert
extension SignUpViewController : GalleryAlertCustomViewDelegate{
    func galleryBtnAction() {
        self.OpenGalleryCamera(camera: false, imagePickerDelegate: self)
        CommonFunctions.sharedmanagerCommon.println(object: "Gallery")
        galleryAlertView.removeFromSuperview()
    }
    func cameraButtonAction() {
        self.OpenGalleryCamera(camera: true, imagePickerDelegate: self)
        CommonFunctions.sharedmanagerCommon.println(object: "Camera")
        galleryAlertView.removeFromSuperview()
    }
    func cancelButtonAction() {
        galleryAlertView.removeFromSuperview()
    }
}
//MARK:- UIDatePickerDelegates
extension SignUpViewController : SharedUIDatePickerDelegate{
    func doneButtonClicked(datePicker: UIDatePicker) {
        let strDate = CommonFunctions.sharedmanagerCommon.convertDateIntoStringWithDDMMYYYY(date: datePicker.date)
        CommonFunctions.sharedmanagerCommon.println(object: "String Converted Date:- \(strDate)")
        selectedDOB = "\(datePicker.date)"
        let years = CommonFunctions.sharedmanagerCommon.getYearsBetweenDates(startDate: datePicker.date, endDate: Date())
        if let intYear = years{
            if intYear < 18{
                self.showAlert(alert: Alerts.kUnderAge)
                return
            }else{
                txtFieldDOB.text = strDate
                ageYears = intYear
            }
        }
    }
}

//MARK:- Custom Ok Alert
extension SignUpViewController : OKAlertViewDelegate{
    //Ok Button Clicked
    func okBtnAction() {
        if okAlertView.lblResponseDetailMessage.text == "User updated successfully"{
//            let userId = varifyPhnResponseModel?.resultData?.userId
//            self.viewModel?.getRoleId(userID: userId)
            CommonFunctions.sharedmanagerCommon.setRootLogin()
        }
        okAlertView.removeFromSuperview()
    }
}
