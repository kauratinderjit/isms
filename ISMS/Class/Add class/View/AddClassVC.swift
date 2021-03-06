//
//  AddClassVC.swift
//  ISMS
//
//  Created by Taranjeet Singh on 6/18/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

class AddClassVC: BaseUIViewController {
    //Outlets
    @IBOutlet weak var imgViewClass: UIImageView!
    @IBOutlet weak var btnAddimage: UIButton!
    @IBOutlet weak var txtfieldOthers: UITextField!
    @IBOutlet weak var txtFieldClass: UITextField!
    @IBOutlet weak var txtFieldDepartment: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var txtViewDescription: KMPlaceholderTextView!
    @IBOutlet weak var btnDepartment: UIButton!
    @IBOutlet weak var btnClass: UIButton!
    @IBOutlet weak var viewGalleryCustomAlert: GalleryAlertCustomView!

    //Variables
    var isClassAddUpdateSuccess = false
    var isUnauthorizedUser = false
    var viewModel : AddClassViewModel?
    var selectedImageUrl : URL?
    var classId : Int = 0
  let departmentId = UserDefaultExtensionModel.shared.HODDepartmentId
    var departmentData : GetCommonDropdownModel!
    var selectedDepartmentId : Int?
    var selectedDepartmentIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.viewModel = AddClassViewModel.init(delegate : self as AddClassDelegate)
        self.viewModel?.attachView(viewDelegate: self as ViewDelegate)
        setUI()
        SetpickerView(self.view)
        //Check add a new class or update existing class on the basis of classID
        if checkInternetConnection(){
            if classId != 0{
                self.viewModel?.getClassDetail(classId: classId)
                self.title = KStoryBoards.KAddClassIdentifiers.kAddClassTitle
            }else{
                 self.viewModel?.getDepartments(selectedDepartmentId: 0, enumtype: CountryStateCity.department.rawValue)
                self.title = KStoryBoards.KAddClassIdentifiers.kAddClassTitle
            }
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
        
    }
    
    //MARK:- Action Add Class
    @IBAction func btnAddDepartment(_ sender: UIButton) {
        if classId == 0{
            self.viewModel?.addUpdateClass(classid: 0, className: txtFieldClass.text, selectedDepartmentId: departmentId, departmentName: txtFieldDepartment.text, description: txtViewDescription.text, others: txtfieldOthers.text, imageUrl: selectedImageUrl)
        }
        if classId != 0{
            if selectedImageUrl != nil{
                if (selectedImageUrl?.absoluteString.hasPrefix("http:"))!{
                    CommonFunctions.sharedmanagerCommon.println(object: "Image from detail department.")
                    selectedImageUrl = URL(string: "")
                }
            }
            self.viewModel?.addUpdateClass(classid: classId, className: txtFieldClass.text, selectedDepartmentId: departmentId, departmentName: txtFieldDepartment.text, description: txtViewDescription.text, others: txtfieldOthers.text, imageUrl: selectedImageUrl)
        }
    }
    
    //MARK:- Button Action Add Image
    @IBAction func btnAddImage(_ sender: UIButton) {
        view.endEditing(true)
        initializeGalleryAlert(self.view, isHideBlurView: true)
        galleryAlertView.delegate = self
    }
    
    //MARK:- Button action open UIPicker
    @IBAction func btnActionClassDepartmentPicker(_ sender: UIButton) {
       view.endEditing(true)
//        if checkInternetConnection(){
//            self.viewModel?.getDepartments(selectedDepartmentId: 0, enumtype: CountryStateCity.department.rawValue)
//        }else{
//            self.showAlert(alert: Alerts.kNoInternetConnection)
//        }
    }
}

//MARK:- Add Class View
extension AddClassVC : ViewDelegate{
    
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
    
    //MARK:- Set Ui
    func setUI(){
        
        guard let theme = ThemeManager.shared.currentTheme else {return}
        
        setBackButton()
        
        txtfieldOthers.SetTextFont(textSize: KTextSize.KFourteen, placeholderText: KPlaceholder.kOthers)
        txtViewDescription.SetTextFont(textSize:KTextSize.KFourteen)
        txtFieldClass.SetTextFont(textSize: KTextSize.KFourteen, placeholderText: KPlaceholder.kClass)
        txtFieldDepartment.SetTextFont(textSize: KTextSize.KFourteen, placeholderText: KPlaceholder.kDepartment)
//        txtfieldOthers.addViewCornerShadow(radius: 8, view: txtfieldOthers)
//        txtfieldOthers.addViewCornerShadow(radius: 8, view: txtViewDescription)
//        txtfieldOthers.addViewCornerShadow(radius: 8, view: txtFieldClass)
//        txtfieldOthers.addViewCornerShadow(radius: 8, view: txtFieldDepartment)
        //btnSubmit.SetButtonFont(textSize: KTextSize.KSeventeen)
        txtViewDescription.placeholder = KPlaceholder.kDescription
        txtViewDescription.placeholderColor = UIColor.darkGray
        txtfieldOthers.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        txtFieldClass.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        txtFieldDepartment.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        txtViewDescription.textContainerInset = UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 20)
        
        imgViewClass.createCircleImage()
        cornerButton(btn: btnSubmit, radius: 4)
        
        btnSubmit.backgroundColor = theme.uiButtonBackgroundColor
        btnSubmit.titleLabel?.textColor = theme.uiButtonTextColor
        
        //UnHide Navigation Bar
        UnHideNavigationBar(navigationController: self.navigationController)
        viewEndEditing(view: self.view)
        
    }
    
    //MARK:- Get Details Of Class
    func setDataInTextFields(data: ClassDetailModel){
        
        if let name = data.resultData?.name{
            txtFieldClass.text = name
        }
        
        if let description = data.resultData?.description{
            txtViewDescription.text = description
        }
        
        if let othrs = data.resultData?.others{
            txtfieldOthers.text = othrs
        }
        
        if let departmentName = data.resultData?.depertmentName{
            selectedDepartmentId = data.resultData?.departmentId
            txtFieldDepartment.text = departmentName
        }
        
        if let imageUrl = data.resultData?.logoUrl{
            selectedImageUrl = URL(string: imageUrl)
            imgViewClass.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "profile"))
        }else{
            selectedImageUrl = nil
            CommonFunctions.sharedmanagerCommon.println(object: "Image is nil in department detail.")
        }
    }
}
//MARK:- UITextField Delegates
extension AddClassVC : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        switch textField {
        case txtFieldClass:
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
extension AddClassVC : UITextViewDelegate{
    
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
extension AddClassVC:UIImagePickerDelegate
{
    func selectedImageUrl(url: URL) {
        selectedImageUrl = url
    }
    func SelectedMedia(image: UIImage?, videoURL: URL?)
    {
        self.imgViewClass.contentMode = .scaleAspectFill
        self.imgViewClass.image = image
    }
}


//MARK:- Custom Gallery Alert
extension AddClassVC : GalleryAlertCustomViewDelegate{
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
extension AddClassVC : OKAlertViewDelegate{
    
    //Ok Button Clicked
    func okBtnAction() {
        okAlertView.removeFromSuperview()
        if isClassAddUpdateSuccess == true{
            self.navigationController?.popViewController(animated: true)
        }
        else if isUnauthorizedUser == true{
            isUnauthorizedUser = false
            CommonFunctions.sharedmanagerCommon.setRootLogin()
        }
    }
}

//MARK:- Add Class Delegate
extension AddClassVC : AddClassDelegate{
    
    //MARK:- Unathorized User
    func unauthorizedUser() {
        isUnauthorizedUser = true
    }
    
    //MARK:- Class Detail Success
    func getClassDetailDidSucceed(data: ClassDetailModel) {
        self.setDataInTextFields(data: data)
    }
    
    //MARK:- Add Class Succeed
    func addClassDataDidSucceed(data : CommonSuccessResponseModel) {
        isClassAddUpdateSuccess = true
    }
    
    //MARK:- Get Department Dropdown success
    func getDepartmentdropdownDidSucceed(data: GetCommonDropdownModel) {
        departmentData = data
        if let count = data.resultData?.count{
            if count > 0 {
                
                for i in 0..<count{
                    if data.resultData?[i].id == UserDefaultExtensionModel.shared.HODDepartmentId {
                        self.txtFieldDepartment.text = data.resultData?[i].name
                    }
                }
                //                UpdatePickerModel(count: departmentData?.resultData?.count ?? 0, sharedPickerDelegate: self, View: self.view)
            }else{
                print("City Count is zero.")
            }
        }
    }
}

//MARK:- Picker View Delegates
extension AddClassVC:SharedUIPickerDelegate{
    func DoneBtnClicked() {
        
        if let count = departmentData.resultData?.count{
            if count > 0{
                if selectedDepartmentIndex == 0{
                    self.txtFieldDepartment.text = self.departmentData?.resultData?[0].name
                    self.selectedDepartmentId = self.departmentData?.resultData?[0].id ?? 0
                }else{
                    self.txtFieldDepartment.text = self.departmentData?.resultData?[selectedDepartmentIndex].name
                    self.selectedDepartmentId = self.departmentData?.resultData?[selectedDepartmentIndex].id ?? 0
                }
            }
        }
    }
    
    func GetTitleForRow(index: Int) -> String {
        if let count = departmentData.resultData?.count{
            if count > 0{
                //                txtFieldDepartment.text = departmentData?.resultData?[0].name
                return departmentData?.resultData?[index].name ?? ""
            }
        }
        return ""
    }
    
    func SelectedRow(index: Int) {
        //Using Exist Method of collection prevent from indexoutof range error
        if let count = departmentData.resultData?.count{
            if count > 0{
                if (self.departmentData.resultData?[exist: index]?.name) != nil{
                    //                    self.txtFieldDepartment.text = self.departmentData?.resultData?[index].name
                    //                    self.selectedDepartmentId = self.departmentData?.resultData?[index].id ?? 0
                    self.selectedDepartmentIndex = index
                    print("Selected Country:- \(String(describing: self.departmentData?.resultData?[index].name))")
                }
            }
        }
    }
}
