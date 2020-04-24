//
//  AddHODVC.swift
//  ISMS
//
//  Created by Taranjeet Singh on 6/12/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit
import SDWebImage

class AddHODVC: BaseUIViewController {

    //Outlets
    @IBOutlet weak var imgViewProfileHOD: UIImageView!
    @IBOutlet weak var txtFieldFirstName: UITextField!
    @IBOutlet weak var txtFieldLastName: UITextField!
    @IBOutlet weak var txtFieldAddress: UITextField!
    @IBOutlet weak var txtFieldDOB: UITextField!
    @IBOutlet weak var txtFieldIdProof: UITextField!
    @IBOutlet weak var txtFieldQualification: UITextField!
    @IBOutlet weak var txtFieldEmail: UITextField!
    @IBOutlet weak var txtFieldPhoneNumber: UITextField!
    @IBOutlet weak var txtFieldWorkExperience: UITextField!
    @IBOutlet weak var txtFieldAdditionalSkills: UITextField!
    @IBOutlet weak var txtFieldAssignDepartment: UITextField!
    @IBOutlet weak var txtFieldOthers: UITextField!
    @IBOutlet weak var btnAddProfileImage: UIButton!
    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var btnFemale: UIButton!
    @IBOutlet weak var btnNA: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnDOB: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var btnIdProof: UIButton!
    @IBOutlet weak var imgViewIdProof: UIImageView!
    @IBOutlet weak var viewGender: UIView!
    @IBOutlet weak var btnIdProofAttachment: UIButton!
    //Veriables
    var viewModel : AddHODViewModel?
    var departmentData : GetCommonDropdownModel!
    var hodID : Int?
    var userId : Int?
    var ForUpdateHodUserId : Int?
    var selectIdProof : Bool?
    var selectedDepartmentID : Int?
    var selectedDepartmentIndex = 0
    var selectedProfileImageUrl : URL?
    var selectedIdProofImageURL: URL?
    var ageYears : Int?
    var gender = String()
    var dateOfBirth : String?
    var isHODAddUpdateSuccess = false
    var isUnauthorizedUser = false
    var hodDetail : GetDetailByPhoneEmailModel?
    var selectedPreviousTextField : UITextField?
    
    //MARK:- Life Cycle of VC
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.viewModel = AddHODViewModel.init(delegate : self as AddHODDelegate)
        self.viewModel?.attachView(viewDelegate: self as ViewDelegate)
        txtFieldEmail.delegate = self
        txtFieldPhoneNumber.delegate = self
        DispatchQueue.main.async{
            self.setupUI()
        }
        if checkInternetConnection(){
            if hodID != 0{
                self.title = KStoryBoards.KAddHODIdentifiers.kUpdateHodTitle
                self.viewModel?.getHODDetail(hodId: hodID ?? 0)
            }else{
                self.title = KNavigationTitle.kAddHodTitle
                gender = KConstants.KMale
            }
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
        
    }
    
    //MARK:- Submit Action
    @IBAction func btnSubmitAction(_ sender: UIButton) {
        view.endEditing(true)

        //For Add Hod
        if hodID == 0
        {
            self.viewModel?.addUpdateHOD(hodId: hodID, firstName: txtFieldFirstName.text, lastName: txtFieldLastName.text, address: txtFieldAddress.text, dateOfBirth: dateOfBirth, gender: gender, profileImageUrl: selectedProfileImageUrl, idProofName: txtFieldIdProof.text, idProofImgUrl: selectedIdProofImageURL, email: txtFieldEmail.text, departmentId: selectedDepartmentID, departmentName: txtFieldAssignDepartment.text, phoneNumber: txtFieldPhoneNumber.text, qualification: txtFieldQualification.text, workExperience: txtFieldWorkExperience.text, additionalSkills: txtFieldAdditionalSkills.text, others: txtFieldOthers.text, userId: userId)
        }
        
        //For Update Hod
        if hodID != 0
        {
            //For set the nil value to Profile Image Url/Id Proof Image Url
            if selectedProfileImageUrl != nil||selectedIdProofImageURL != nil
            {
                if (selectedProfileImageUrl?.absoluteString.hasPrefix("http:") ?? false)
                {
                    selectedProfileImageUrl = nil
                }
                if selectedIdProofImageURL?.absoluteString.hasPrefix("http:") ?? false
                {
                    selectedIdProofImageURL = nil
                }
            }
            self.viewModel?.addUpdateHOD(hodId: hodID, firstName: txtFieldFirstName.text, lastName: txtFieldLastName.text, address: txtFieldAddress.text, dateOfBirth: dateOfBirth, gender: gender, profileImageUrl: selectedProfileImageUrl, idProofName: txtFieldIdProof.text, idProofImgUrl: selectedIdProofImageURL, email: txtFieldEmail.text, departmentId: selectedDepartmentID, departmentName: txtFieldAssignDepartment.text, phoneNumber: txtFieldPhoneNumber.text, qualification: txtFieldQualification.text, workExperience: txtFieldWorkExperience.text, additionalSkills: txtFieldAdditionalSkills.text, others: txtFieldOthers.text, userId: userId)

        }

    }
    
    
    //MARK:-Gender Button Action
    @IBAction func selectGenderButton(_ sender: UIButton)
    {
        view.endEditing(true)

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
        view.endEditing(true)

        showDatePicker(datePickerDelegate: self)
    }
    
    //MARK:- Select Pic From Gallery
    
    @IBAction func btnSelectImage(_ sender: UIButton) {
        view.endEditing(true)
        initializeGalleryAlert(self.view, isHideBlurView: true)
        galleryAlertView.delegate = self
        if sender.tag == 0{
            selectIdProof = false
        }
        if sender.tag == 1{
            selectIdProof = true
        }
    }
    
    //MARK:- Action Open Departmrnt Picker
    @IBAction func btnDepartmentsAction(_ sender: UIButton) {
        view.endEditing(true)
        if checkInternetConnection(){
            self.viewModel?.getDepartments(selectedDepartmentId: 0, enumtype: CountryStateCity.department.rawValue)
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
    }
}

//MARK:- View Delegate
extension AddHODVC : ViewDelegate{
    
    func showLoader() {
        ShowLoader()
    }
    
    func hideLoader() {
        HideLoader()
    }
    
    func showAlert(alert: String){
        
        initializeCustomOkAlert(self.view, isHideBlurView: true)
        okAlertView.delegate = self
        okAlertView.lblResponseDetailMessage.text = alert
    }

    func setupUI(){
        //Picker View
        SetpickerView(self.view)
        //Date Picker View
        setDatePickerView(self.view, type: .date)
        
        setBackButton()
        
        connectFields(fields: [txtFieldEmail,txtFieldFirstName,txtFieldLastName,txtFieldAddress,txtFieldIdProof,txtFieldQualification,txtFieldWorkExperience,txtFieldAdditionalSkills,txtFieldOthers])
        
        //UnHide Navigation Bar
        UnHideNavigationBar(navigationController: self.navigationController)
        
        //Set Fonts in TextFields
        txtFieldFirstName.SetTextFont(textSize: KTextSize.KFourteen, placeholderText: KPlaceholder.kFirstName)
        txtFieldLastName.SetTextFont(textSize: KTextSize.KFourteen, placeholderText: KPlaceholder.kLastName)
        txtFieldAddress.SetTextFont(textSize: KTextSize.KFourteen, placeholderText: KPlaceholder.kAddress)
        txtFieldDOB.SetTextFont(textSize: KTextSize.KFourteen, placeholderText: KPlaceholder.kDOB)
        txtFieldIdProof.SetTextFont(textSize: KTextSize.KFourteen, placeholderText: KPlaceholder.kIdProof)
        txtFieldEmail.SetTextFont(textSize: KTextSize.KFourteen, placeholderText: KPlaceholder.kEmail)
        txtFieldAssignDepartment.SetTextFont(textSize: KTextSize.KFourteen, placeholderText: KPlaceholder.kAssignDepartment)
        txtFieldWorkExperience.SetTextFont(textSize: KTextSize.KFourteen, placeholderText: KPlaceholder.kWorkExperience)
        txtFieldAdditionalSkills.SetTextFont(textSize: KTextSize.KFourteen, placeholderText: KPlaceholder.kAdditionalSkills)
        txtFieldQualification.SetTextFont(textSize: KTextSize.KFourteen, placeholderText: KPlaceholder.kQualification)
        txtFieldPhoneNumber.SetTextFont(textSize: KTextSize.KFourteen, placeholderText: KPlaceholder.kPhoneNumber)
        txtFieldOthers.SetTextFont(textSize: KTextSize.KFourteen, placeholderText: KPlaceholder.kOthers)
        
        //Set Shadow of textfields
      //  createMultipleViewsCornerShadow(views: [txtFieldFirstName,txtFieldLastName,txtFieldAddress,txtFieldDOB,txtFieldEmail,txtFieldPhoneNumber,txtFieldIdProof,txtFieldAssignDepartment,txtFieldQualification,txtFieldWorkExperience,txtFieldAdditionalSkills,txtFieldOthers,viewGender], radius: 8)

        //Set padding
        txtFieldFirstName.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        txtFieldLastName.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        txtFieldDOB.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        txtFieldEmail.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        txtFieldAssignDepartment.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        txtFieldAddress.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        txtFieldIdProof.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        txtFieldPhoneNumber.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        txtFieldWorkExperience.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        txtFieldQualification.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        txtFieldAdditionalSkills.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        txtFieldOthers.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        
        //Round Image
        imgViewIdProof.createCircleImage()
        imgViewProfileHOD.createCircleImage()
        
        //cornerButton(btn: btnSubmit, radius: 8)
        
        //Set Color According to theme
        guard let theme = ThemeManager.shared.currentTheme else {return}
//        btnAddProfileImage.tintColor = theme.uiButtonBackgroundColor
        btnSubmit.backgroundColor = theme.uiButtonBackgroundColor
        btnSubmit.titleLabel?.textColor = theme.uiButtonTextColor
    }

    
    //Set Detail In text fields
    func setDataInTextFields(data: HODDetailModel)
    {
        
        
        if let imgProfileUrl = data.resultData?.imageUrl
        {
           //mohit selectedProfileImageUrl = URL.init(string: imgProfileUrl)
            imgViewProfileHOD.contentMode = .scaleAspectFill
            imgViewProfileHOD.sd_setImage(with: URL(string: imgProfileUrl), placeholderImage: UIImage(named: kImages.kProfileImage))
        }
        else
        {
            selectedProfileImageUrl = nil
            imgViewProfileHOD.image = UIImage.init(named: kImages.kProfileImage)
        }
        
        if let userId = data.resultData?.userId{
            self.userId = userId
            self.ForUpdateHodUserId = userId
        }else{
            userId = ForUpdateHodUserId
        }
        
        if let firstName = data.resultData?.firstName{
            txtFieldFirstName.text = firstName
        }
        
        if let lastName = data.resultData?.lastName{
            txtFieldLastName.text = lastName
        }
        
        if let address = data.resultData?.address{
            txtFieldAddress.text = address
        }
        
        if let dob = data.resultData?.dob{
            dateOfBirth = dob
            let date = CommonFunctions.sharedmanagerCommon.convertBackendDateFormatToLocalDate(serverSideDate: dob)
            txtFieldDOB.text = date
        }
        if let gender = data.resultData?.gender{
            
            if(gender == KConstants.KMale)
            {
                btnMale.setImage(UIImage(named:kImages.kRadioSelected), for: UIControl.State.normal)
                btnFemale.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
                btnNA.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
                self.gender = KConstants.KMale
            }
            else if (gender == KConstants.KFemale)
            {
                btnMale.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
                btnFemale.setImage(UIImage(named: kImages.kRadioSelected), for: UIControl.State.normal)
                btnNA.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
                self.gender = KConstants.KFemale
            }
            else if (gender == KConstants.KNA)
            {
                btnMale.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
                btnFemale.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
                btnNA.setImage(UIImage(named: kImages.kRadioSelected), for: UIControl.State.normal)
                self.gender = KConstants.KNA
            }
        }
        
        if let email = data.resultData?.email{
            txtFieldEmail.text = email
        }
        if let phoneNumber = data.resultData?.phoneNo{
            txtFieldPhoneNumber.text = String(describing: phoneNumber)
        }
        
        if let idProofName = data.resultData?.idProofTitle{
            txtFieldIdProof.text = idProofName
        }
        
        if let address = data.resultData?.address{
            txtFieldAddress.text = address
        }
        
        if let imgIDproofUrl = data.resultData?.idProof,imgIDproofUrl != ""
        {
            imgViewIdProof.sd_imageIndicator = SDWebImageActivityIndicator.gray
           //mohit selectedIdProofImageURL = URL(string: imgIDproofUrl)
            imgViewIdProof.contentMode = .scaleAspectFill
            imgViewIdProof.sd_setImage(with: URL(string: imgIDproofUrl), placeholderImage: UIImage(named: kImages.kAttachmentImage))
        }
        else
        {
            imgViewIdProof.contentMode = .center
            selectedIdProofImageURL = nil
            imgViewIdProof.image = UIImage.init(named: kImages.kAttachmentImage)
        }
        
        if let departmentName = data.resultData?.departmentName{
            selectedDepartmentID = data.resultData?.departmentId
            txtFieldAssignDepartment.text = departmentName
        }
        if let qualification = data.resultData?.qualification{
            txtFieldQualification.text = qualification
        }
        
        if let workExperience = data.resultData?.workExperience{
            txtFieldWorkExperience.text = workExperience
        }

        if let additionalSkills = data.resultData?.additionalSkills{
            txtFieldAdditionalSkills.text = additionalSkills
        }
        
        if let others = data.resultData?.others{
            txtFieldOthers.text = others
        }
    }
    
}


//MARK:- Custom Gallery Alert
extension AddHODVC : GalleryAlertCustomViewDelegate{
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

//MARK:- Custom Ok Alert
extension AddHODVC : OKAlertViewDelegate{
    
    //Ok Button Clicked
    func okBtnAction() {
        okAlertView.removeFromSuperview()
        if isHODAddUpdateSuccess == true{
            self.navigationController?.popViewController(animated: true)
        }
        else if isUnauthorizedUser == true{
            isUnauthorizedUser = false
            CommonFunctions.sharedmanagerCommon.setRootLogin()
        }
    }
}

