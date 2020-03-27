//
//  SignUpViewController.swift
//  ISMS
//
//  Created by Atinder Kaur on 5/29/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetView()
        SetpickerView(self.view)
        setDatePickerView(self.view, type: .date)
        hitCountryListApi()
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
            self.lblGender.SetLabelFont(textSize: KTextSize.KFourteen)
            self.lblFemale.SetLabelFont(textSize: KTextSize.KFourteen)
            self.lblMale.SetLabelFont(textSize: KTextSize.KFourteen)
            self.btnSave.SetButtonFont(textSize: KTextSize.KSeventeen)
            //Set Corner of button and image
            self.cornerButton(btn: self.btnSave,radius: KTextSize.KEight)
            self.cornerButton(btn: self.btnAddImage,radius: KTextSize.KEight)
            self.cornerImage(image: self.imgViewProfile)
            //Add Shadow and corner of the view
            self.addViewCornerShadow(radius: 8, view: self.viewTop)
            self.addViewCornerShadow(radius: 8, view: self.viewGender)
            self.addViewCornerShadow(radius: 8, view: self.viewMail)
            self.addViewCornerShadow(radius: 8, view: self.viewCity)
            self.addViewCornerShadow(radius: 8, view: self.viewCountry)
            self.addViewCornerShadow(radius: 8, view: self.viewAddress)
            self.addViewCornerShadow(radius: 8, view: self.viewState)
            self.addViewCornerShadow(radius: 8, view: self.txtViewDescription)
            self.addViewCornerShadow(radius: 8, view: self.viewDOB)
            //Set default string in gender
            self.gender = KConstants.KMale
            //Set placeholder in text view
            self.txtViewDescription.placeholder = KConstants.kWriteDescription
            self.txtViewDescription.placeholderColor = UIColor.darkGray
            //Set Title
            self.title = KStoryBoards.KSignUpIdentifiers.kSignUpTitle
            //Set shadow of text view
            self.txtViewDescription.addViewCornerShadow(radius: 8, view: self.txtViewDescription)
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
