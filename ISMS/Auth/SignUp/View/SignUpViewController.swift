//
//  SignUpViewController.swift
//  ISMS
//
//  Created by Atinder Kaur on 5/29/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit
import KMPlaceholderTextView
import SDWebImage

class SignUpViewController: BaseUIViewController {
    
      //MARK:-  Properties
    @IBOutlet weak var viewMail: UIView!
    @IBOutlet weak var viewAddress: UIView!
    @IBOutlet weak var viewCity: UIView!
    @IBOutlet weak var viewState: UIView!
    @IBOutlet weak var viewDistrict: UIView!
    @IBOutlet weak var viewCountry: UIView!
    @IBOutlet weak var viewGender: UIView!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var viewDOB: UIView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var txtMail: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var lblMale: UILabel!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var lblFemale: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtMiddleName: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtFieldDOB: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnAddImage: UIButton!
    @IBOutlet weak var btnDOB: UIButton!
    @IBOutlet weak var txtViewDescription: KMPlaceholderTextView!
    @IBOutlet weak var btnNA: UIButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var imgViewProfile: UIImageView!
    @IBOutlet weak var btnFemale: UIButton!
    @IBOutlet weak var btnmale: UIButton!
    @IBOutlet weak var btnCountry: UIButton!
    @IBOutlet weak var btnState: UIButton!
    @IBOutlet weak var btnCity: UIButton!
    @IBOutlet weak var blurrView: UIView!
    
    //MARK:- Variables
    var viewModel:SignUpViewModel?
    var countryData:GetCommonDropdownModel!
    var stateData : GetCommonDropdownModel!
    var cityData : GetCommonDropdownModel!
    var firstTimeLoad = false
    var selectCountry = false
    var selectState = false
    var againSelectState = false
    var selectCity = false
    var selectedPickerIndex:Int?
    var selectedCityId : Int?
    var selectedCityIndex = 0
    var selectedStateIndex = 0
    var selectedCountryIndex = 0
    var gender : String?
    var password : String?
    var phNo : String?
    var byteArrayofImages = Data()
    var selectedImageURl : URL?
    var selectedDOB : String?
    var ageYears : Int?
    var varifyPhnResponseModel : VerifyPhoneNumberModel?
    var blurView = UIView()
//    var getUserDetail = GetUserDetailByPhoneEmail
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetView()
        SetpickerView(self.view)
        setDatePickerView(self.view, type: .date)
        hitCountryListApi()
        getUserByPhoneNumber()
    }
    
    //MARK:- Actions
    @IBAction func GenderAction(_ sender: UIButton){
        view.endEditing(true)
        selectGender(btn : sender)
    }
    @IBAction func SaveAction(_ sender: Any){
        view.endEditing(true)
        submitButtonAction()
    }
    
    //MARK:- date of birth
    @IBAction func btnDateOfBirth(_ sender: UIButton) {
        view.endEditing(true)
        //showDatePicker(datePickerDelegate: self)
        showDatePicker(datePickerDelegate: self)
    }
    
    @IBAction func SelectCountryAction(_ sender: Any){
        selectCountryButtonAction()
    }
    
    @IBAction func btnSelectStateAction(_ sender: UIButton) {
        selectStateButtonAction()
    }
    
    @IBAction func btnSelectCityAction(_ sender: UIButton) {
        selectCityButtonAction()
    }
    
    @IBAction func AddImageAction(_ sender: Any){
        initializeGalleryAlert(self.view, isHideBlurView: true)
        galleryAlertView.delegate = self
    }
    
    //Save Button Action
    func submitButtonAction(){
        if checkInternetConnection(){
            self.viewModel?.signUpUser(firstName: txtFirstName.text, lastName: txtLastName.text, gender: gender, country: txtCountry.text, state: txtState.text, city: txtCity.text, address: txtAddress.text, email: txtMail.text, phoneNo: phNo, password: password, imgUrl: selectedImageURl, selectedCityId: selectedCityId, dob: selectedDOB, description: txtViewDescription.text, userId: varifyPhnResponseModel?.resultData?.userId)
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
    }
//    get user Detail
    func getUserByPhoneNumber(){
        if checkInternetConnection(){
            self.viewModel?.getUserByPhoneNumber(Phone: varifyPhnResponseModel?.resultData?.PhoneNo ?? "", Email:"")
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
    }
    //Select Country Button action
    func selectCountryButtonAction(){
        selectCountry = true
        selectCity = false
        selectState = false
        let index = CommonFunctions.sharedmanagerCommon.getIndexOfPickerModelObject(data: countryData, pickerTextfieldString: txtCountry.text)
            UpdatePickerModel2(count: countryData?.resultData?.count ?? 0, sharedPickerDelegate: self, View: self.view, index: index)
    }
    
    //Select State Button Action
    func selectStateButtonAction(){
        selectState = true
        selectCity = false
        selectCountry = false
        let index = CommonFunctions.sharedmanagerCommon.getIndexOfPickerModelObject(data: stateData, pickerTextfieldString: txtState.text)
            UpdatePickerModel2(count: stateData?.resultData?.count ?? 0, sharedPickerDelegate: self, View: self.view, index: index)
    }
    
    //Select City Button Action
    func selectCityButtonAction(){
        selectCity = true
        selectState = false
        selectCountry = false
        if let count = cityData?.resultData?.count{
            if count > 0 {
                let index = CommonFunctions.sharedmanagerCommon.getIndexOfPickerModelObject(data: cityData, pickerTextfieldString: txtCity.text)
                    UpdatePickerModel2(count: cityData?.resultData?.count ?? 0, sharedPickerDelegate: self, View: self.view, index: index)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "City Count is zero.")
                txtCity.text = ""
            }
        }
    }
    
    //Select gender
    func selectGender(btn : UIButton){
        if(btn.tag == 0){
            btnmale.setImage(UIImage(named:kImages.kRadioSelected), for: UIControl.State.normal)
            btnFemale.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
            btnNA.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
            gender = KConstants.KMale
        }
        else if (btn.tag == 1){
            btnmale.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
            btnFemale.setImage(UIImage(named: kImages.kRadioSelected), for: UIControl.State.normal)
            btnNA.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
            gender = KConstants.KFemale
        }
        else{
            btnmale.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
            btnFemale.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
            btnNA.setImage(UIImage(named: kImages.kRadioSelected), for: UIControl.State.normal)
            gender = KConstants.KNA
        }
    }
    
    //Get Country
    func hitCountryListApi(){
        if checkInternetConnection(){
            firstTimeLoad = true
            //Get Country List Using Enum Type
            self.viewModel?.GetCountryList(selectedCountryId: 0, enumType: CountryStateCity.country.rawValue)
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
    }
    
    //MARK:- other functions
    func SetView(){
        //Set View Model Delegates and view
        self.viewModel = SignUpViewModel.init(delegate: self)
        self.viewModel?.attachView(view: self)
        DispatchQueue.main.async {
         
            //Set textfields fonts and placeholder text
            self.txtCity.SetTextFont(textSize: KTextSize.KSixteen, placeholderText: KPlaceholder.kCity)
            self.txtMail.SetTextFont(textSize: KTextSize.KSixteen, placeholderText: KPlaceholder.kEmail)
            self.txtAddress.SetTextFont(textSize: KTextSize.KSixteen, placeholderText: KPlaceholder.kAddress)
            self.txtCity.SetTextFont(textSize: KTextSize.KSixteen, placeholderText: KPlaceholder.kCity)
            self.txtState.SetTextFont(textSize: KTextSize.KSixteen, placeholderText: KPlaceholder.kState)
            self.txtCountry.SetTextFont(textSize: KTextSize.KSixteen, placeholderText: KPlaceholder.kCountry)
            self.txtLastName.SetTextFont(textSize: KTextSize.KSixteen, placeholderText: KPlaceholder.kLastName)
            self.txtFirstName.SetTextFont(textSize: KTextSize.KSixteen, placeholderText: KPlaceholder.kFirstName)
            //Set text sizes
           // self.lblGender.SetLabelFont(textSize: KTextSize.KFourteen)
            self.lblFemale.SetLabelFont(textSize: KTextSize.KFourteen)
            self.lblMale.SetLabelFont(textSize: KTextSize.KFourteen)
            self.btnSave.SetButtonFont(textSize: KTextSize.KSeventeen)
            self.txtFirstName.txtfieldPadding(leftpadding: 10, rightPadding: 0)
             self.txtLastName.txtfieldPadding(leftpadding: 10, rightPadding: 0)
            //Set Corner of button and image
          //  self.cornerButton(btn: self.btnSave,radius: KTextSize.KEight)
            self.cornerButton(btn: self.btnAddImage,radius: KTextSize.KEight)
            self.cornerImage(image: self.imgViewProfile)
            //Add Shadow and corner of the view
//            self.addViewCornerShadow(radius: 8, view: self.viewTop)
//            self.addViewCornerShadow(radius: 8, view: self.viewGender)
//            self.addViewCornerShadow(radius: 8, view: self.viewMail)
//            self.addViewCornerShadow(radius: 8, view: self.viewCity)
//            self.addViewCornerShadow(radius: 8, view: self.viewCountry)
//            self.addViewCornerShadow(radius: 8, view: self.viewAddress)
//            self.addViewCornerShadow(radius: 8, view: self.viewState)
//            self.addViewCornerShadow(radius: 8, view: self.txtViewDescription)
//            self.addViewCornerShadow(radius: 8, view: self.viewDOB)
            //Set default string in gender
            self.gender = KConstants.KMale
            //Set placeholder in text view
            self.txtViewDescription.placeholder = KConstants.kWriteDescription
            self.txtViewDescription.placeholderColor = UIColor.darkGray
            //Set Title
            self.title = KStoryBoards.KSignUpIdentifiers.kSignUpTitle
            //Set shadow of text view
           // self.txtViewDescription.addViewCornerShadow(radius: 8, view: self.txtViewDescription)
        }
    }
    
    func AutoTextDataTextField(data: GetUserDetailByPhoneEmail)
    {
        let userDetail = data
        
//        Show Pic Of User
        if let imgProfileUrl = userDetail.resultData?.imageUrl{
            
            imgViewProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
            //mohit  studentImgUrl = URL(string: imgProfileUrl)
            imgViewProfile.contentMode = .scaleAspectFill

            imgViewProfile.sd_setImage(with: URL(string: imgProfileUrl), placeholderImage: UIImage(named: kImages.kProfileImage))
        }else{
            selectedImageURl = URL(string: "")
            imgViewProfile.image = UIImage.init(named: kImages.kProfileImage)
        }

        if let userDob = userDetail.resultData?.DOB{
            var DOB = userDob
             let date = CommonFunctions.sharedmanagerCommon.convertBackendDateFormatToLocalDate(serverSideDate: DOB)
            selectedDOB = DOB
            txtFieldDOB.text = date
        }

        if let gender = userDetail.resultData?.gender{
            if(gender == KConstants.KMale)
            {
                btnmale.setImage(UIImage(named:kImages.kRadioSelected), for: UIControl.State.normal)
                btnFemale.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
                btnNA.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
                self.gender = KConstants.KMale
            }
            else if (gender == KConstants.KFemale)
            {
                btnmale.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
                btnFemale.setImage(UIImage(named: kImages.kRadioSelected), for: UIControl.State.normal)
                btnNA.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
                self.gender = KConstants.KFemale
            }
            else if (gender == KConstants.KNA)
            {
                btnmale.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
                btnFemale.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
                btnNA.setImage(UIImage(named: kImages.kRadioSelected), for: UIControl.State.normal)
                self.gender = KConstants.KNA
            }
        }

        
        
        if let email = userDetail.resultData?.email{
            txtMail.text = email
        }
        if let firstName = userDetail.resultData?.firstName{
           txtFirstName.text = firstName
        }

        if let lastName = userDetail.resultData?.lastName{
            txtLastName.text = lastName
        }
        
        if let address = userDetail.resultData?.address{
            txtAddress.text = address
        }
       
    }
}
extension SignUpViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtFirstName || textField == txtLastName {
        if string == " " {
            return false
        }
        }
        return true
    }

}

extension SignUpViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 150    // 10 Limit Value
    }
}
///MARK:- View Delegate
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
    func GetUserDetailSuccess(data: GetUserDetailByPhoneEmail) {
        AutoTextDataTextField(data: data)
    }
    
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
//                    txtState.text = stateData?.resultData?[0].name
                    txtState.text = "Select state"
                    self.viewModel?.getCityList(selectedCityId: stateData?.resultData?[0].id ?? 0, enumType: CountryStateCity.city.rawValue)
                }else{
                    //Set the data in the textfield from 0 index when api hit
                    if stateData?.resultData?[0].name != nil||stateData?.resultData?[0].id != nil{
//                        txtState.text = stateData?.resultData?[0].name
                         txtState.text = "Select state"
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
//                    txtCity.text = cityData?.resultData?[0].name
                    txtCity.text = "Select city"
                    selectedCityId = cityData?.resultData?[0].id
                }else{
                    if cityData?.resultData?[0].name != nil{
//                        txtCity.text = cityData?.resultData?[0].name
                         txtCity.text = "Select city"
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
//                txtCountry.text = countryData?.resultData?[0].name
                 txtCountry.text = "Select country"
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
