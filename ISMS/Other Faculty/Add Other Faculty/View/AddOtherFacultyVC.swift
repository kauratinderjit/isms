//
//  AddOtherFacultyVC.swift
//  DemoProjectScreens
//
//  Created by Taranjeet Singh on 6/5/19.
//  Copyright © 2019 Taranjeet Singh. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

protocol AddOtherFacultyView:class{
    func showLoader()
    func hideLoader()
    func show_Alert(message : String)
    
}

class AddOtherFacultyVC: BaseUIViewController {

    //MARK:- Outlets
    @IBOutlet weak var txtField_FirstName: UITextField!
    @IBOutlet weak var txtField_LastName: UITextField!
    @IBOutlet weak var txtField_Address: UITextField!
    @IBOutlet weak var txtField_DOB: UITextField!
    @IBOutlet weak var txtField_AssignDepartments: UITextField!
    @IBOutlet weak var txtField_Email: UITextField!
    @IBOutlet weak var txtField_PhoneNumber: UITextField!
    @IBOutlet weak var txtField_IdProof: UITextField!
    @IBOutlet weak var txtField_Others: UITextField!
    @IBOutlet weak var imgView_Profile: UIImageView!
    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var btnFemale: UIButton!
    @IBOutlet weak var btnNA: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    
    //Id prrof design changes veriables
    @IBOutlet weak var imgViewIDProof: UIImageView!
    @IBOutlet weak var txtFieldIdProofType: UITextField!
    
    
    //MARK:- Veriables
    var selectedGender : String?
    var selectIdProof : Bool?
    var imageViewIdProof : UIImageView?
    var ageYears : Int?
    
    //Create Object of AddOtherFacultyPresenter
    var presenter : AddOtherFacultyPresenter?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.presenter = AddOtherFacultyPresenter.init(delegate : self as AddOtherFacultyDelegate)
        self.presenter?.attachView(viewDelegate: self as ViewDelegate)
        setupView()
        setDatePickerView(self.view, type: .date)
        self.title = KNavigationTitle.kAddOtherFacultyTitle
    }
    
    //MARK:- Submit Button Action
    @IBAction func btn_ActionSubmitDetail(_ sender: UIButton) {
        view.endEditing(true)
        self.presenter?.submitAddFacultyData(firstName: txtField_FirstName.text, lastName: txtField_LastName.text, address: txtField_Address.text, dateOfBirth: txtField_DOB.text, gender: selectedGender, assignDepartment: txtField_AssignDepartments.text, email: txtField_Email.text, phoneNumber: txtField_PhoneNumber.text, idProof: txtField_IdProof.text, others: txtField_Others.text)
        
    }
    
    //MARK:- Date Of Birth Button Action
    @IBAction func btnDateOfBirthAction(_ sender: UIButton) {
        showDatePicker(datePickerDelegate: self)
    }
    
    
    //MARK:- Gender Action
    @IBAction func btnSelectGender(_ sender: UIButton)
    {
        if(sender.tag == 0)
        {
            btnMale.setImage(UIImage(named:kImages.kRadioSelected), for: UIControl.State.normal)
            btnFemale.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
            btnNA.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
            selectedGender = KConstants.KMale
        }
        else if (sender.tag == 1)
        {
            btnMale.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
            btnFemale.setImage(UIImage(named: kImages.kRadioSelected), for: UIControl.State.normal)
            btnNA.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
            selectedGender = KConstants.KFemale
        }
        else
        {
            btnMale.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
            btnFemale.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
            btnNA.setImage(UIImage(named: kImages.kRadioSelected), for: UIControl.State.normal)
            selectedGender = KConstants.KNA
        }
    }
    
    
    
    //MARK:- Add Image Button Action
    @IBAction func addImageButtonTapped(_ sender: UIButton) {

        //Photos
    }
    
    @IBAction func btnSelectPicForIdProof(_ sender: UIButton) {
        selectIdProof = true
    }
}

//MARK:- AddOtherFaculty View
extension AddOtherFacultyVC : ViewDelegate{
    
    func showLoader() {
        ShowLoader()
    }
    
    func hideLoader() {
        HideLoader()
    }
    
    func showAlert(alert: String) {
        showAlert(Message: alert)
    }
    
    
    func setupView() {
        //Set Shadow Under TextFields
        txtField_FirstName.CreateBoundryShadowOfTxtfield(shadowOpacity: KShadow.KShadowOpacity, shadowColor: KShadow.KShadowBlackColour)
        txtField_LastName.CreateBoundryShadowOfTxtfield(shadowOpacity: KShadow.KShadowOpacity, shadowColor: KShadow.KShadowBlackColour)
        txtField_DOB.CreateBoundryShadowOfTxtfield(shadowOpacity: KShadow.KShadowOpacity, shadowColor: KShadow.KShadowBlackColour)
        txtField_Email.CreateBoundryShadowOfTxtfield(shadowOpacity: KShadow.KShadowOpacity, shadowColor: KShadow.KShadowBlackColour)
        txtField_Others.CreateBoundryShadowOfTxtfield(shadowOpacity: KShadow.KShadowOpacity, shadowColor: KShadow.KShadowBlackColour)
        txtField_Address.CreateBoundryShadowOfTxtfield(shadowOpacity: KShadow.KShadowOpacity, shadowColor: KShadow.KShadowBlackColour)
        txtField_IdProof.CreateBoundryShadowOfTxtfield(shadowOpacity: KShadow.KShadowOpacity, shadowColor: KShadow.KShadowBlackColour)
        txtField_PhoneNumber.CreateBoundryShadowOfTxtfield(shadowOpacity: KShadow.KShadowOpacity, shadowColor: KShadow.KShadowBlackColour)
        txtField_AssignDepartments.CreateBoundryShadowOfTxtfield(shadowOpacity: KShadow.KShadowOpacity, shadowColor: KShadow.KShadowBlackColour)

        //Set Font
        txtField_FirstName.SetTextFont(textSize: KTextSize.KSixteen, placeholderText: KPlaceholder.kFirstName)
        txtField_LastName.SetTextFont(textSize: KTextSize.KSixteen, placeholderText: KPlaceholder.kLastName)
        txtField_DOB.SetTextFont(textSize: KTextSize.KSixteen, placeholderText: KPlaceholder.kDOB)
        txtField_Email.SetTextFont(textSize: KTextSize.KSixteen, placeholderText: KPlaceholder.kEmail)
        txtField_Others.SetTextFont(textSize: KTextSize.KSixteen, placeholderText: KPlaceholder.kOthers)
        txtField_Address.SetTextFont(textSize: KTextSize.KSixteen, placeholderText: KPlaceholder.kAddress)
        txtField_IdProof.SetTextFont(textSize: KTextSize.KSixteen, placeholderText: KPlaceholder.kIdProof)
        txtField_PhoneNumber.SetTextFont(textSize: KTextSize.KSixteen, placeholderText: KPlaceholder.kPhoneNumber)
        txtField_AssignDepartments.SetTextFont(textSize: KTextSize.KSixteen, placeholderText: KPlaceholder.kAssignDepartment)
        
        //Set Padding in textfields
        txtField_FirstName.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        txtField_LastName.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        txtField_DOB.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        txtField_Email.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        txtField_Others.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        txtField_Address.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        txtField_IdProof.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        txtField_PhoneNumber.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        txtField_AssignDepartments.txtfieldPadding(leftpadding: 20, rightPadding: 0)

        //Round Image view
        cornerImage(image: imgView_Profile)

        //Set False when IdProof is not selected
        selectIdProof = false
    }
    
    func createImageViewUnderIdProof(imageIdProof: UIImage?){
        
        imageViewIdProof = UIImageView()
        
        imageViewIdProof?.frame = CGRect.init(x: txtField_IdProof.center.x-30, y: txtField_IdProof.center.y+16, width: 60, height: 60)
        imageViewIdProof?.topAnchor.constraint(equalTo: (imageViewIdProof?.topAnchor)!, constant: 16).isActive = true
        imageViewIdProof?.heightAnchor.constraint(equalToConstant: 80).isActive = true
        imageViewIdProof?.widthAnchor.constraint(equalToConstant: 80).isActive = true
        if imageIdProof != nil{
            imageViewIdProof?.image = imageIdProof
        }
        cornerImage(image: imageViewIdProof!)
//        imageViewIdProof?.layer.zPosition = 1
//        self.stackView.addArrangedSubview(imageViewIdProof!)
        stackView.insertArrangedSubview(imageViewIdProof!, at: 9)
//        self.view.addSubview(imageViewIdProof!)
        
        
    }
    
    
    
}

//MARK:- AddOtherFaculty Delegate
extension AddOtherFacultyVC : AddOtherFacultyDelegate{
    
    //Do what ever you want When API response is success
    func AddOtherFacultyDataDidSucceed() {
        
    }
    
    //Do what ever you want When API response is unsuccess
    func AddOtherFacultyDataDidFailed() {
        
    }
    
    
}


//MARK:- UIImagePickerView Delegate
extension AddOtherFacultyVC:UIImagePickerDelegate
{
    func selectedImageUrl(url: URL) {
        
    }
    
    func SelectedMedia(image: UIImage?, videoURL: URL?)
    {
        if selectIdProof == false{
            self.imgView_Profile.contentMode = .scaleAspectFill
            self.imgView_Profile.image = image
        }else{
            createImageViewUnderIdProof(imageIdProof: image)
        }
       
    }
    
    
    
}

extension AddOtherFacultyVC: SharedUIDatePickerDelegate{
    
    func doneButtonClicked(datePicker: UIDatePicker) {
        print("Selected Date:- \(datePicker.date)")
        
        let strDate = CommonFunctions.sharedmanagerCommon.convertDateIntoStringWithDDMMYYYY(date: datePicker.date)
        print("String Converted Date:- \(strDate)")
        
        let years = CommonFunctions.sharedmanagerCommon.getYearsBetweenDates(startDate: datePicker.date, endDate: Date())
        
        if let intYear = years{
            
            if intYear < 18{
                self.showAlert(alert: Alerts.kUnderAge)
                return
            }else{
                txtField_DOB.text = strDate
                ageYears = intYear
            }
        }
    }
    
}

//MARK:- UITextField Delegates
extension AddOtherFacultyVC : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == txtField_Address {
            txtField_Email.becomeFirstResponder()
        }
        
        
        return true
    }
    
    
}


//let status = PHPhotoLibrary.authorizationStatus()

//        switch status {
//        case .authorized:
//
//            print("Authorized")
//
//            break
//        case .denied:
//
//            print("Denied")
//
//            break
//        case .notDetermined:
//
//            PHPhotoLibrary.requestAuthorization({status in
//                if status == .authorized{
//
//                    print("Permission Success.")
//
//                } else {
//
//                    print("Again permission cancel.")
//
//                }
//            })
//
//            break
//        case .restricted:
//
//            print("Resticted")
//
//            break
//        default:
//            break
//        }

