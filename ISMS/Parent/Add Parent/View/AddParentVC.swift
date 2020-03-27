//
//  AddParentVC.swift
//  ISMS
//
//  Created by Taranjeet Singh on 6/12/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class AddParentVC: BaseUIViewController {

    //Outlets
    @IBOutlet weak var imgViewProfileParent: UIImageView!
    @IBOutlet weak var txtFieldFirstName: UITextField!
    @IBOutlet weak var txtFieldLastName: UITextField!
    @IBOutlet weak var txtFieldRelation: UITextField!

    @IBOutlet weak var txtFieldAddress: UITextField!
    @IBOutlet weak var txtFieldDOB: UITextField!
    @IBOutlet weak var txtFieldEmail: UITextField!
    @IBOutlet weak var txtFieldPhoneNumber: UITextField!
    @IBOutlet weak var txtFieldIdProof: UITextField!
    @IBOutlet weak var txtFieldOthers: UITextField!
    
    @IBOutlet weak var btnAddProfileImage: UIButton!
    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var btnFemale: UIButton!
    @IBOutlet weak var btnNA: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnDOB: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var btnIdProof: UIButton!
    
    //Veriables
    var presenter : AddParentPresenter?
    var selectIdProof : Bool?
    var imageViewIdProof : UIImageView!
    var gender = String()
    var ageYears : Int?
    
    //MARK:- Life Cycle of VC
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.presenter = AddParentPresenter.init(delegate : self as AddParentDelegate)
        self.presenter?.attachView(viewDelegate: self as ViewDelegate)
        setupUI()
         setDatePickerView(self.view, type: .date)
        self.title = KNavigationTitle.kAddParentTitle
        gender = KConstants.KMale
    }
    
    //MARK:- Submit Action
    @IBAction func btnSubmitAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.presenter?.addParent(firstName: txtFieldFirstName.text, lastName: txtFieldLastName.text,relation: txtFieldRelation.text, address: txtFieldAddress.text, dateOfBirth: txtFieldDOB.text, gender: gender, email: txtFieldEmail.text, idProof: txtFieldIdProof.text, phoneNumber: txtFieldPhoneNumber.text, others: txtFieldOthers.text)
        
        
    }
    
    
    //MARK:-Gender Button Action
    @IBAction func selectGenderButton(_ sender: UIButton)
    {
        if(sender.tag == 0)
        {
            btnMale.setImage(UIImage(named:kImages.kRadioSelected), for: UIControl.State.normal)
            btnFemale.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
            btnNA.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
            gender = KConstants.KMale
        }
        else if (sender.tag == 1)
        {
            btnMale.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
            btnFemale.setImage(UIImage(named: kImages.kRadioSelected), for: UIControl.State.normal)
            btnNA.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
            gender = KConstants.KFemale
        }
        else
        {
            btnMale.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
            btnFemale.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
            btnNA.setImage(UIImage(named: kImages.kRadioSelected), for: UIControl.State.normal)
            gender = KConstants.KNA
        }
    }
    
    //MARK:- Date Of Birth Button Action
    
    @IBAction func btnDateOfBirth(_ sender: UIButton) {
        showDatePicker(datePickerDelegate: self)
    }
    
    //MARK:- Select Pic From Gallery
    
    @IBAction func btnSelectImage(_ sender: UIButton) {
        selectIdProof = true
        
        let alert = UIAlertController(title: KAlertTitle.KChooseImage, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: KAlertTitle.KCamera, style: .default, handler: { _ in
            self.OpenGalleryCamera(camera: true, imagePickerDelegate: self)
        }))
        
        alert.addAction(UIAlertAction(title: KAlertTitle.KGallery, style: .default, handler: { _ in
            self.OpenGalleryCamera(camera: false, imagePickerDelegate: self)
            
        }))
        
        alert.addAction(UIAlertAction.init(title: KAlertTitle.KCancel, style: .cancel, handler: { _ in
            self.selectIdProof = false
        }))
        
        /*If you want work actionsheet on ipad
         then you have to use popoverPresentationController to present the actionsheet,
         otherwise app will crash on iPad */
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = sender as? UIView
            alert.popoverPresentationController?.sourceRect = (sender as AnyObject).bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
}

//MARK:- View Delegate
extension AddParentVC : ViewDelegate{
    
    func showLoader() {
        ShowLoader()
    }
    
    func hideLoader() {
        HideLoader()
    }
    
    func showAlert(alert: String){
        showAlert(Message: alert)
    }
    
    func setupUI(){
        
        //Set Fonts in TextFields
        txtFieldFirstName.SetTextFont(textSize: KTextSize.KSixteen, placeholderText: KPlaceholder.kFirstName)
        txtFieldLastName.SetTextFont(textSize: KTextSize.KSixteen, placeholderText: KPlaceholder.kLastName)
        txtFieldAddress.SetTextFont(textSize: KTextSize.KSixteen, placeholderText: KPlaceholder.kAddress)
        txtFieldDOB.SetTextFont(textSize: KTextSize.KSixteen, placeholderText: KPlaceholder.kDOB)
        txtFieldIdProof.SetTextFont(textSize: KTextSize.KSixteen, placeholderText: KPlaceholder.kIdProof)
        txtFieldEmail.SetTextFont(textSize: KTextSize.KSixteen, placeholderText: KPlaceholder.kEmail)
        txtFieldRelation.SetTextFont(textSize: KTextSize.KSixteen, placeholderText: KPlaceholder.kRelation)
        txtFieldPhoneNumber.SetTextFont(textSize: KTextSize.KSixteen, placeholderText: KPlaceholder.kPhoneNumber)
        txtFieldOthers.SetTextFont(textSize: KTextSize.KSixteen, placeholderText: KPlaceholder.kOthers)
        
        //Set Shadow of textfields
        txtFieldFirstName.CreateBoundryShadowOfTxtfield(shadowOpacity: KShadow.KShadowOpacity, shadowColor: KShadow.KShadowBlackColour)
        txtFieldLastName.CreateBoundryShadowOfTxtfield(shadowOpacity: KShadow.KShadowOpacity, shadowColor: KShadow.KShadowBlackColour)
        txtFieldDOB.CreateBoundryShadowOfTxtfield(shadowOpacity: KShadow.KShadowOpacity, shadowColor: KShadow.KShadowBlackColour)
        txtFieldIdProof.CreateBoundryShadowOfTxtfield(shadowOpacity: KShadow.KShadowOpacity, shadowColor: KShadow.KShadowBlackColour)
        txtFieldEmail.CreateBoundryShadowOfTxtfield(shadowOpacity: KShadow.KShadowOpacity, shadowColor: KShadow.KShadowBlackColour)
        txtFieldRelation.CreateBoundryShadowOfTxtfield(shadowOpacity: KShadow.KShadowOpacity, shadowColor: KShadow.KShadowBlackColour)

        txtFieldAddress.CreateBoundryShadowOfTxtfield(shadowOpacity: KShadow.KShadowOpacity, shadowColor: KShadow.KShadowBlackColour)
    
        txtFieldPhoneNumber.CreateBoundryShadowOfTxtfield(shadowOpacity: KShadow.KShadowOpacity, shadowColor: KShadow.KShadowBlackColour)
        txtFieldOthers.CreateBoundryShadowOfTxtfield(shadowOpacity: KShadow.KShadowOpacity, shadowColor: KShadow.KShadowBlackColour)
        
        //Set padding
        txtFieldFirstName.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        txtFieldLastName.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        txtFieldDOB.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        txtFieldEmail.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        txtFieldAddress.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        txtFieldIdProof.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        txtFieldPhoneNumber.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        txtFieldRelation.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        txtFieldOthers.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        
        //Round Image
        cornerImage(image: imgViewProfileParent)
    }
    
    //Create ImageView
    func createImageViewUnderIdProof(imageIdProof: UIImage?){
        
        imageViewIdProof = UIImageView()
        
        imageViewIdProof?.frame = CGRect.init(x: txtFieldIdProof.center.x-30, y: txtFieldIdProof.center.y+16, width: 80, height: 80)
        imageViewIdProof?.topAnchor.constraint(equalTo: (imageViewIdProof?.topAnchor)!, constant: 16).isActive = true
        imageViewIdProof?.heightAnchor.constraint(equalToConstant: 80).isActive = true
        imageViewIdProof?.widthAnchor.constraint(equalToConstant: 80).isActive = true
        if imageIdProof != nil{
            imageViewIdProof?.image = imageIdProof
        }
        cornerImage(image: imageViewIdProof!)
        stackView.insertArrangedSubview(imageViewIdProof!, at: 8)
        
        
    }
}


//MARK:- AddHOD Delegate
extension AddParentVC : AddParentDelegate{
    //Do what ever you want When API response is success
    func AddParentDidSuccess() {
        
    }
    
    //Do what ever you want When API response is unsuccess
    func AddParentDidFailed() {
        
    }
    
}

//MARK:- Shared UIDatePicker Delegate
extension AddParentVC : SharedUIDatePickerDelegate{
    
    func doneButtonClicked(datePicker: UIDatePicker) {
        
        let strDate = CommonFunctions.sharedmanagerCommon.convertDateIntoStringWithDDMMYYYY(date: datePicker.date)
        print("String Converted Date:- \(strDate)")
        
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

//MARK:- SharedImage Picker Delegates
//MARK:- UIImagePickerView Delegate
extension AddParentVC:UIImagePickerDelegate
{
    func selectedImageUrl(url: URL) {
        
    }
    
    func SelectedMedia(image: UIImage?, videoURL: URL?)
    {
        if selectIdProof == false{
            self.imgViewProfileParent.contentMode = .scaleAspectFill
            self.imgViewProfileParent.image = image
        }else{
            createImageViewUnderIdProof(imageIdProof: image)
        }
        
    }
    
}
