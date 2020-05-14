//
//  AddDepartmentVC.swift
//  ISMS
//
//  Created by Atinder Kaur on 6/5/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

class AddDepartmentVC: BaseUIViewController {
    
    //Mark:- Properties
    @IBOutlet weak var imgViewDepartment: UIImageView!
    @IBOutlet weak var btnAddimage: UIButton!
    @IBOutlet weak var viewBehindTitle: UIView!
    @IBOutlet weak var viewBehindDescription: UIView!
    @IBOutlet weak var viewBehindOthers: UIView!
    @IBOutlet weak var txtfieldTitle: UITextField!
    @IBOutlet weak var txtfieldOthers: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var txtViewDescription: KMPlaceholderTextView!
    //Mark:-Variables
    var viewModel : AddDepartmentViewModel?
    var selectedImageUrl : URL?
    var departmentId : Int = 0
    var departmentDetailFetchTimeImgUrl : URL?
    var isDepartmentAddUpdateSuccess = false
    var isUnauthorizedUser = false
   var descriptionText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
         
        setUI()
    }
    
    //MARK:- Action
    @IBAction func btnAddDepartment(_ sender: UIButton) {
        btnAddUpdateDepartment()
    }
    
    
    @IBAction func btnAddImage(_ sender: UIButton) {
         view.endEditing(true)
        if self.txtViewDescription.text != nil{
            descriptionText = self.txtViewDescription.text
        }
       
        initializeGalleryAlert(self.view, isHideBlurView: true)
        galleryAlertView.delegate = self
        
    }
    
    
    
    //MARK:- Set UI
    func setUI(){
        //Initiallize memory for viewModel
        self.viewModel = AddDepartmentViewModel.init(delegate : self as AddDepartmentDelegate)
        self.viewModel?.attachView(viewDelegate: self as ViewDelegate)
        //Hit Add/Detail Department Api
        departmentAddOrGetdetailApi()
        //Set placeholders
        txtfieldTitle.SetTextFont(textSize: KTextSize.KFourteen, placeholderText: KPlaceholder.kTitle)
        txtfieldOthers.SetTextFont(textSize: KTextSize.KFourteen, placeholderText: KPlaceholder.kOthers)
        txtViewDescription.SetTextFont(textSize:KTextSize.KFourteen)
        txtViewDescription.placeholder = KPlaceholder.kDescription
        txtViewDescription.placeholderColor = UIColor.darkGray
        //Set corner and shadow of the textfields
        //MARK:-Naval
        
       // addViewCornerShadow(radius: 8, view: txtfieldTitle)
       // addViewCornerShadow(radius: 8, view: txtfieldOthers)
        //addViewCornerShadow(radius: 8, view: txtViewDescription)
        
        //btnSubmit.SetButtonFont(textSize: KTextSize.KSeventeen)
        //Set textfield padding
        txtfieldTitle.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        txtfieldOthers.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        txtViewDescription.textContainerInset = UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 20)

        //Set navigation back button
        setBackButton()
        //Set the circle image
        cornerImage(image: imgViewDepartment)
        //cornerButton(btn: btnSubmit, radius: 4)
        //Unhide Navigation comtroller
        UnHideNavigationBar(navigationController: self.navigationController)
        viewEndEditing(view: self.view)
        
     //   guard let theme = ThemeManager.shared.currentTheme else {return}
        addbtnShadow(radius: 4, btn: btnSubmit, shadowColor: KAPPContentRelatedConstants.kThemeColour)
        btnSubmit.backgroundColor = KAPPContentRelatedConstants.kThemeColour
        btnSubmit.titleLabel?.textColor = UIColor.white
//        btnAddimage.tintColor = theme.uiButtonTintColor
        
    }

    //Get Department Detail And Add Department Api
    func departmentAddOrGetdetailApi(){
        if departmentId != 0{
            if checkInternetConnection(){
                self.viewModel?.getDepartmentDetail(departmentId: departmentId)
                self.title = KStoryBoards.KAddDepartMentIdentifiers.kUpdateDepartmentTitle
            }else{
                self.showAlert(alert: Alerts.kNoInternetConnection)
            }
        }else{
            self.title = KStoryBoards.KAddDepartMentIdentifiers.kAddDepartmentTitle
        }
    }
    
    //Button Add/Update department Api
    func btnAddUpdateDepartment(){
        if checkInternetConnection(){
            //For Add Department
            if departmentId == 0{
                self.viewModel?.addUpdateDepartment(departmentId: departmentId, title: txtfieldTitle.text, description: txtViewDescription.text, others: txtfieldOthers.text, imageUrl: selectedImageUrl)
            }
            //For Update Department
            if departmentId != 0{
                if selectedImageUrl != nil{
                    if (selectedImageUrl?.absoluteString.hasPrefix("http:"))!{
                        CommonFunctions.sharedmanagerCommon.println(object: "Image from detail department.")
                        selectedImageUrl = URL(string: "")
                    }
                }
                self.viewModel?.addUpdateDepartment(departmentId: departmentId, title: txtfieldTitle.text, description: txtViewDescription.text, others: txtfieldOthers.text, imageUrl: selectedImageUrl)
            }
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
    }
}
//MARK:- Add Department Delegate
extension AddDepartmentVC : AddDepartmentDelegate{
    //MARK:- Unathorized User
    func unauthorizedUser() {
        isUnauthorizedUser = true
    }
    func departmentdetailDidSucceed(data: DepartmentDetailModel) {
        self.setDataInTextFields(data: data)
    }
    func addDepartmentDataDidSucceed(data: AddDepartmentModel) {
        isDepartmentAddUpdateSuccess = true
        initializeCustomOkAlert(self.view, isHideBlurView: true)
        okAlertView.delegate = self
        okAlertView.lblResponseDetailMessage.text = data.message
    }
}
//MARK:- Add Department View
extension AddDepartmentVC : ViewDelegate{
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
    func setDataInTextFields(data: DepartmentDetailModel){
        if let title = data.resultData?.title{
            txtfieldTitle.text = title
        }
        if let description = data.resultData?.description{
            txtViewDescription.text = description
        }
        if let othrs = data.resultData?.others{
            txtfieldOthers.text = othrs
        }
        if let imageUrl = data.resultData?.logoUrl{
          //mohit  selectedImageUrl = URL(string: imageUrl)
            imgViewDepartment.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: kImages.kProfileImage))
        }else{
            selectedImageUrl = nil
            CommonFunctions.sharedmanagerCommon.println(object: "Image is nil in department detail.")
        }
    }
}
//MARK:- UITextFieldDelegates
extension AddDepartmentVC:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        switch textField {
        case txtfieldTitle:
            txtViewDescription.becomeFirstResponder()
        case txtfieldOthers:
            txtfieldOthers.resignFirstResponder()
        default:
            break
        }
        return true
    }
}
//MARK:- UITextViewDelegates
extension AddDepartmentVC : UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //Remove keyboard when clicking Done on keyboard
        if(text == "\n") {
            textView.resignFirstResponder()
            txtfieldOthers.becomeFirstResponder()
            return false
        }
        return true
    }
}
//MARK:- UIImagePickerView Delegate
extension AddDepartmentVC:UIImagePickerDelegate{
    func selectedImageUrl(url: URL) {
        CommonFunctions.sharedmanagerCommon.println(object: "Url:- \(url)")
        selectedImageUrl = url
    }
    func SelectedMedia(image: UIImage?, videoURL: URL?){
        self.imgViewDepartment.contentMode = .scaleAspectFill
        self.imgViewDepartment.image = image
    }
}

//MARK:- Custom Gallery Alert
extension AddDepartmentVC : GalleryAlertCustomViewDelegate{
    func galleryBtnAction() {
        self.view.endEditing(true)
        self.OpenGalleryCamera(camera: false, imagePickerDelegate: self)
//        CommonFunctions.sharedmanagerCommon.println(object: "Gallery")
        galleryAlertView.removeFromSuperview()
        
    }
    func cameraButtonAction() {
        self.view.endEditing(true)
        self.OpenGalleryCamera(camera: true, imagePickerDelegate: self)
//        CommonFunctions.sharedmanagerCommon.println(object: "Camera")
        galleryAlertView.removeFromSuperview()
    }
    func cancelButtonAction() {
        galleryAlertView.removeFromSuperview()
    }
}

//MARK:- Custom Ok Alert
extension AddDepartmentVC : OKAlertViewDelegate{
    //Ok Button Clicked
    func okBtnAction() {
        okAlertView.removeFromSuperview()
        if isDepartmentAddUpdateSuccess == true{
            self.navigationController?.popViewController(animated: true)
        }else if isUnauthorizedUser == true{
            isUnauthorizedUser = false
            CommonFunctions.sharedmanagerCommon.setRootLogin()
        }
    }
}

