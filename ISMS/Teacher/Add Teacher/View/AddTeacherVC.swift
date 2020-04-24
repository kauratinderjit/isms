//
//  AddTeacherVC.swift
//  ISMS
//
//  Created by Taranjeet Singh on 6/7/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit
import SDWebImage

class AddTeacherVC: BaseUIViewController {
    @IBOutlet weak var imgViewTeacher: UIImageView!
    @IBOutlet weak var btnAddProfileImage: UIButton!
    @IBOutlet weak var txtFieldFirstName: UITextField!
    @IBOutlet weak var txtFieldLastName: UITextField!
    @IBOutlet weak var txtFieldAddress: UITextField!
    @IBOutlet weak var txtFieldDOB: UITextField!
    @IBOutlet weak var txtFieldIdProofName: UITextField!
    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var btnFemale: UIButton!
    @IBOutlet weak var btnNA: UIButton!
    @IBOutlet weak var txtFieldQualification: UITextField!
    @IBOutlet weak var txtFieldEmail: UITextField!
    @IBOutlet weak var txtFieldPhoneNumber: UITextField!
    @IBOutlet weak var txtFieldWorkExperience: UITextField!
    @IBOutlet weak var txtFieldOthers: UITextField!
    @IBOutlet weak var txtFieldAdditionalSkills: UITextField!
    @IBOutlet weak var imgViewIdProof: UIImageView!
    @IBOutlet weak var btnIdProofImage: UIButton!
    @IBOutlet weak var txtFieldAssignDepartments: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnDOB: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var viewGender: UIView!

    //Veriables
    var viewModel : AddTeacherViewModel?
    var assignDepartmentData : GetCommonDropdownModel?
    var selectIdProof : Bool?
    var teacherID  :Int?
    var teacherUserId : Int?
    var imageViewIdProof : UIImageView!
    var selectedProfileImageUrl : URL?
    var selectedIdProofImageURL: URL?
    var gender = String()
    var dateOfBirth : String?
    var ageYears : Int?
    var arrSelectedDepartmentsData = [SelectedDepartmentDataModel]()
    var strDepartmentsIds = String()
    var strDepartmentsNames : String?
    var isTeacherAddUpdateSuccess = false
    var isUnauthorizedUser = false
    var selectedPreviousTextField : UITextField?



    //MARK:- Life Cycle of VC
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.viewModel = AddTeacherViewModel.init(delegate : self as AddTeacherDelegate)
        self.viewModel?.attachView(viewDelegate: self as ViewDelegate)
        
        strDepartmentsIds = "\(UserDefaultExtensionModel.shared.HODDepartmentId)"
        DispatchQueue.main.async {
            self.setupUI()
        }
        setupTableViewPopUp()
        if checkInternetConnection(){
            if teacherID != 0{
                self.title = KStoryBoards.KAddTeacherIdentifiers.kUpdateTeacherTitle
                self.viewModel?.getTeacherDetail(teacherId: teacherID ?? 0)
            }else{
                self.title = KStoryBoards.KAddTeacherIdentifiers.kAddTeacherTitle
                gender = KConstants.KMale
            }
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    //MARK:- Submit Action
    @IBAction func btnSubmitAction(_ sender: UIButton) {
        view.endEditing(true)
        
        //For Add teacher
        if teacherID == 0{
            self.viewModel?.addUpdateTeacher(teacherId: teacherID, profileImageUrl: selectedProfileImageUrl, firstName: txtFieldFirstName.text, lastName: txtFieldLastName.text, address: txtFieldAddress.text, dateOfBirth:dateOfBirth, others: txtFieldOthers.text, gender: gender, email: txtFieldEmail.text, phoneNumber: txtFieldPhoneNumber.text, idProofImgUrl: selectedIdProofImageURL, idProofName: txtFieldIdProofName.text, assignDepartmentId: strDepartmentsIds, qualification: txtFieldQualification.text, workExperience: txtFieldWorkExperience.text, additionalSkills: txtFieldAdditionalSkills.text, userID: 0)
        }
        //For Update teacher
        if teacherID != 0{
            //For set the nil value to Profile Image Url/Id Proof Image Url
            if selectedProfileImageUrl != nil||selectedIdProofImageURL != nil{
                if (selectedProfileImageUrl?.absoluteString.hasPrefix("http:") ?? false){
                    selectedProfileImageUrl = URL(string: "")
                }
                if selectedIdProofImageURL?.absoluteString.hasPrefix("http:") ?? false{
                    selectedIdProofImageURL = URL(string: "")
                }
            }
            self.viewModel?.addUpdateTeacher(teacherId: teacherID, profileImageUrl: selectedProfileImageUrl, firstName: txtFieldFirstName.text, lastName: txtFieldLastName.text, address: txtFieldAddress.text, dateOfBirth:dateOfBirth, others: txtFieldOthers.text, gender: gender, email: txtFieldEmail.text, phoneNumber: txtFieldPhoneNumber.text, idProofImgUrl: selectedIdProofImageURL, idProofName: txtFieldIdProofName.text, assignDepartmentId: strDepartmentsIds, qualification: txtFieldQualification.text, workExperience: txtFieldWorkExperience.text, additionalSkills: txtFieldAdditionalSkills.text, userID: 0)
        }
    }
    
    //MARK:-Gender Button Action
    @IBAction func selectGenderButton(_ sender: UIButton){
        view.endEditing(true)
        if(sender.tag == 0){
            btnMale.setImage(UIImage(named:kImages.kRadioSelected), for: UIControl.State.normal)
            btnFemale.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
            btnNA.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
            gender = KConstants.KMale
        }
        else if (sender.tag == 1){
            btnMale.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
            btnFemale.setImage(UIImage(named: kImages.kRadioSelected), for: UIControl.State.normal)
            btnNA.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
            gender = KConstants.KFemale
        }
        else if sender.tag == 2{
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
    
    //MARK:- Assign Departments Dropdown action
    @IBAction func btnAssignDepartmentsAction(_ sender: UIButton) {
        view.endEditing(true)
        self.viewModel?.getAssignDepartmentDropdown(selectedDepartmentId: 0, enumtype: CountryStateCity.department.rawValue)
    }
    
    //MARK:- Select Pic From Gallery
    @IBAction func btnSelectImage(_ sender: UIButton) {
        view.endEditing(true)
        if sender.tag == 0{
            selectIdProof = false
        }
        if sender.tag == 1{
            selectIdProof = true
        }
        initializeGalleryAlert(self.view, isHideBlurView: true)
        galleryAlertView.delegate = self
    }
}

//MARK:- View Delegate
extension AddTeacherVC : ViewDelegate{
    
    func showLoader() {
        ShowLoader()
    }
    func hideLoader() {
        HideLoader()
    }
    func showAlert(alert: String){
        self.view.endEditing(true)
        initializeCustomOkAlert(self.view, isHideBlurView: true)
        okAlertView.delegate = self
        okAlertView.lblResponseDetailMessage.text = alert
    }
    func setupTableViewPopUp(){
        initializeCustomTableViewPopUp(self.view)
        self.tblViewpopUp.tblView.register(UINib(nibName: "SelectionTblViewCell", bundle: nil), forCellReuseIdentifier: KTableViewCellIdentifier.kSelectionTableViewCell)
        self.tblViewpopUp.delegate = self
        self.tblViewpopUp.tblView.delegate = self
        self.tblViewpopUp.tblView.dataSource = self
    }
    
    func setupUI(){

        //Connect textfields
        connectFields(fields: [txtFieldEmail,txtFieldFirstName,txtFieldLastName,txtFieldAddress,txtFieldIdProofName,txtFieldQualification,txtFieldWorkExperience,txtFieldAdditionalSkills,txtFieldOthers])
        //Set Shadow of textfields
//        createMultipleViewsCornerShadow(views: [txtFieldFirstName,txtFieldLastName,txtFieldDOB,txtFieldEmail,txtFieldAssignDepartments,txtFieldAddress,txtFieldQualification,txtFieldAdditionalSkills,txtFieldWorkExperience,txtFieldOthers,txtFieldPhoneNumber,txtFieldIdProofName], radius: 8)
        //Create back button
        setBackButton()
        //UnHide Navigation Bar
        UnHideNavigationBar(navigationController: self.navigationController)
        //Date Picker View
         setDatePickerView(self.view, type: .date)
        //Set Fonts in TextFields
        txtFieldFirstName.SetTextFont(textSize: KTextSize.KFourteen, placeholderText: KPlaceholder.kFirstName)
        txtFieldLastName.SetTextFont(textSize: KTextSize.KFourteen, placeholderText: KPlaceholder.kLastName)
        txtFieldDOB.SetTextFont(textSize: KTextSize.KFourteen, placeholderText: KPlaceholder.kDOB)
        txtFieldEmail.SetTextFont(textSize: KTextSize.KFourteen, placeholderText: KPlaceholder.kEmail)
        txtFieldAssignDepartments.SetTextFont(textSize: KTextSize.KFourteen, placeholderText: KPlaceholder.kAssignDepartment)
        txtFieldAddress.SetTextFont(textSize: KTextSize.KFourteen, placeholderText: KPlaceholder.kAddress)
        txtFieldWorkExperience.SetTextFont(textSize: KTextSize.KFourteen, placeholderText: KPlaceholder.kWorkExperience)
        txtFieldOthers.SetTextFont(textSize: KTextSize.KFourteen, placeholderText: KPlaceholder.kOthers)
        txtFieldAdditionalSkills.SetTextFont(textSize: KTextSize.KFourteen, placeholderText: KPlaceholder.kAdditionalSkills)
        txtFieldQualification.SetTextFont(textSize: KTextSize.KFourteen, placeholderText: KPlaceholder.kQualification)
        txtFieldPhoneNumber.SetTextFont(textSize: KTextSize.KFourteen, placeholderText: KPlaceholder.kPhoneNumber)
        txtFieldIdProofName.SetTextFont(textSize: KTextSize.KFourteen, placeholderText: KPlaceholder.kIdProof)
        
        //Set padding
        txtFieldFirstName.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        txtFieldLastName.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        txtFieldDOB.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        txtFieldEmail.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        txtFieldAssignDepartments.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        txtFieldAddress.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        txtFieldIdProofName.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        txtFieldPhoneNumber.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        txtFieldWorkExperience.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        txtFieldQualification.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        txtFieldAdditionalSkills.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        txtFieldOthers.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        //Round Image
        imgViewIdProof.createCircleImage()
        imgViewTeacher.createCircleImage()
       // cornerButton(btn: btnSubmit, radius: 8)
        //Set theme Color
        guard let theme = ThemeManager.shared.currentTheme else {return}
//        btnAddProfileImage.tintColor = theme.uiButtonBackgroundColor
        btnSubmit.backgroundColor = theme.uiButtonBackgroundColor
        btnSubmit.titleLabel?.textColor = theme.uiButtonTextColor
    }
    
    //Set Detail In text fields
    func setDataInTextFields(data: TeacherDetailModel){
        DispatchQueue.main.async {
            if let imgProfileUrl = data.resultData?.imageUrl{
                self.imgViewTeacher.contentMode = .scaleAspectFill
                //self.selectedProfileImageUrl = URL.init(string: imgProfileUrl)
                self.imgViewTeacher.sd_setImage(with: URL(string: imgProfileUrl), placeholderImage: UIImage(named: kImages.kProfileImage))
            }else{
                self.selectedProfileImageUrl = nil
                self.imgViewIdProof.image = UIImage.init(named: kImages.kProfileImage)
            }
            if let firstName = data.resultData?.firstName{
                self.txtFieldFirstName.text = firstName
            }
            if let lastName = data.resultData?.lastName{
                self.txtFieldLastName.text = lastName
            }
            if let address = data.resultData?.address{
                self.txtFieldAddress.text = address
            }
            if let dob = data.resultData?.dob{
                self.dateOfBirth = dob
                let date = CommonFunctions.sharedmanagerCommon.convertBackendDateFormatToLocalDate(serverSideDate: dob)
                self.txtFieldDOB.text = date
            }
            if let gender = data.resultData?.gender{
                if(gender == KConstants.KMale){
                    self.btnMale.setImage(UIImage(named:kImages.kRadioSelected), for: UIControl.State.normal)
                    self.btnFemale.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
                    self.btnNA.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
                    self.gender = KConstants.KMale
                }
                else if (gender == KConstants.KFemale){
                    self.btnMale.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
                    self.btnFemale.setImage(UIImage(named: kImages.kRadioSelected), for: UIControl.State.normal)
                    self.btnNA.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
                    self.gender = KConstants.KFemale
                }
                else if (gender == KConstants.KNA){
                    self.btnMale.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
                    self.btnFemale.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
                    self.btnNA.setImage(UIImage(named: kImages.kRadioSelected), for: UIControl.State.normal)
                    self.gender = KConstants.KNA
                }
            }
            
            //When user did focus out then set the previous textfield then text of Phone/Email
            if self.selectedPreviousTextField == self.txtFieldPhoneNumber&&self.selectedPreviousTextField != self.txtFieldEmail{
                self.txtFieldEmail.text = data.resultData?.email
            }else if self.selectedPreviousTextField == self.txtFieldEmail && self.selectedPreviousTextField != self.txtFieldPhoneNumber{
                self.txtFieldPhoneNumber.text = data.resultData?.phoneNo
            }else{
                if let email = data.resultData?.email{
                    self.txtFieldEmail.text = email
                }
                if let phone = data.resultData?.phoneNo{
                    self.txtFieldPhoneNumber.text = String(describing: phone)
                }
            }
//
            if let idProofName = data.resultData?.idProofTitle{
                self.txtFieldIdProofName.text = idProofName
            }
            if let departmentList = data.resultData?.departmentListModel{
                
                if departmentList.count > 0{
                    self.txtFieldAssignDepartments.text = ""
                    self.strDepartmentsIds = ""
                    self.arrSelectedDepartmentsData = departmentList.map({ (departmentDataModel) -> SelectedDepartmentDataModel in
                        let deptId = departmentDataModel.departmentId
                        
                        if let intDeptId = deptId{
                            let strDeptId = String(describing: intDeptId) + ","
                            self.strDepartmentsIds.append(contentsOf: strDeptId)
                        }
                        let deptName = departmentDataModel.departmentName ?? "" + ","
                        self.txtFieldAssignDepartments.text?.append(contentsOf: deptName + ",")
                        
                        var selectedDepartment = SelectedDepartmentDataModel(departmentName: deptName, departmentId: deptId)
                        selectedDepartment.isSelected = 1
                        return selectedDepartment
                    })
                    self.strDepartmentsIds.removeLast()
                    self.txtFieldAssignDepartments.text?.removeLast()
                    //                CommonFunctions.sharedmanagerCommon.println(object: "Department Id's:-\(strDepartmentsIds)  DepartmentNames:- \(txtFieldAssignDepartments.text)")
                }
            }
            if let address = data.resultData?.address{
                self.txtFieldAddress.text = address
            }
            if let imgIDproofUrl = data.resultData?.idProof,imgIDproofUrl != ""{
                self.imgViewIdProof.sd_imageIndicator = SDWebImageActivityIndicator.gray
             //   self.selectedIdProofImageURL = URL(string: imgIDproofUrl)
                self.imgViewIdProof.contentMode = .center
                self.imgViewIdProof.sd_setImage(with: URL(string: imgIDproofUrl), placeholderImage: UIImage(named: kImages.kAttachmentImage))
            }else{
                self.imgViewIdProof.contentMode = .center
                self.selectedIdProofImageURL = nil
                self.imgViewIdProof.image = UIImage.init(named: kImages.kAttachmentImage)
            }
            
            if let qualification = data.resultData?.qualification{
                self.txtFieldQualification.text = qualification
            }
            if let workExperience = data.resultData?.workExperience{
                self.txtFieldWorkExperience.text = workExperience
            }
            if let additionalSkills = data.resultData?.additionalSkills{
                self.txtFieldAdditionalSkills.text = additionalSkills
            }
            if let others = data.resultData?.others{
                self.txtFieldOthers.text = others
            }
            if let teacherId = data.resultData?.teacherId{
                self.teacherID = teacherId
            }
            if let userId = data.resultData?.userId{
                self.teacherUserId = userId
            }
            
        }
        
    }
    
    //Mark:- Select/Unselect Department
    @objc func btnActionSelectDeselectDepartment(_ sender: UIButton){
        
        if sender.currentImage == UIImage(named: kImages.kUncheck){
            sender.setImage(UIImage(named: kImages.kCheck), for: .normal)
            if let selectedDepartmentID = self.assignDepartmentData?.resultData?[sender.tag].id,let departmentName = self.assignDepartmentData?.resultData?[sender.tag].name{
                var selectedDepartment = SelectedDepartmentDataModel(departmentName: departmentName, departmentId: selectedDepartmentID)
                let containSameVale = arrSelectedDepartmentsData.contains(where: {$0.departmentId == selectedDepartment.departmentId})
                if containSameVale == false{
                    selectedDepartment.isSelected = 1
                    arrSelectedDepartmentsData.append(selectedDepartment)
                }
            }
        }else{
            sender.setImage(UIImage(named: kImages.kUncheck), for: .normal)
            //remove action ids
            if let selectedDepartmentId = self.assignDepartmentData?.resultData?[sender.tag].id,let selectedDepartmentName = self.assignDepartmentData?.resultData?[sender.tag].name{
                    var selectedDepartment = SelectedDepartmentDataModel(departmentName: selectedDepartmentName, departmentId: selectedDepartmentId)
                    selectedDepartment.isSelected = 0
                    arrSelectedDepartmentsData = arrSelectedDepartmentsData.filter(){$0.departmentId != selectedDepartment.departmentId}
            }
        }
    }
}


//MARK:- Custom Gallery Alert
extension AddTeacherVC : GalleryAlertCustomViewDelegate{
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
extension AddTeacherVC : OKAlertViewDelegate{
    //Ok Button Clicked
    func okBtnAction() {
        okAlertView.removeFromSuperview()
        if isTeacherAddUpdateSuccess == true{
            self.navigationController?.popViewController(animated: true)
        }
        else if isUnauthorizedUser == true{
            isUnauthorizedUser = false
            CommonFunctions.sharedmanagerCommon.setRootLogin()
        }
    }
}
//MARK:- Table View Delegate
extension AddTeacherVC : UITableViewDelegate{
    
}
//MARK:- Table View data source
extension AddTeacherVC : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = assignDepartmentData?.resultData{
            if data.count > 0{
                return (data.count)
            }
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: KTableViewCellIdentifier.kSelectionTableViewCell, for: indexPath) as! SelectionTblViewCell
        
        if let departmentName = assignDepartmentData?.resultData?[indexPath.row].name,let departmentId = assignDepartmentData?.resultData?[indexPath.row].id{
            
            cell.lblRowTitle.text = departmentName
            
            //For Show already selected or not
            if arrSelectedDepartmentsData.count > 0{
                let containId = arrSelectedDepartmentsData.contains(where: {$0.departmentId == departmentId})
                CommonFunctions.sharedmanagerCommon.println(object: "Contain Id or not:- \(containId)")
                if containId == false{
                    cell.btnIsSelected.setImage(UIImage.init(named: kImages.kUncheck), for: .normal)
                }else{
                    cell.btnIsSelected.setImage(UIImage.init(named: kImages.kCheck), for: .normal)
                }
            }else{
                cell.btnIsSelected.setImage(UIImage.init(named: kImages.kUncheck), for: .normal)
            }
        }
        
        cell.btnIsSelected.addTarget(self, action: #selector(btnActionSelectDeselectDepartment(_:)), for: .touchUpInside)
        cell.btnIsSelected.tag = indexPath.row
        
        return cell
    }
}
//MARK:- Custom Table Popup View delegate
extension AddTeacherVC : CustomTableViewPopUpDelegate{
    func submitButton() {
      if arrSelectedDepartmentsData.count > 0{
        let arrSelectedDepartmentsNames = arrSelectedDepartmentsData.map({ (model) -> String in
                if arrSelectedDepartmentsData.count > 0{
                    return model.departmentName!
                }else{
                    return ""
                }
            })
        let arrDepartmentIds = arrSelectedDepartmentsData.map({ (model) -> Int in
            if arrSelectedDepartmentsData.count > 0{
                return model.departmentId!
            }else{
                return 0
            }
        })
        txtFieldAssignDepartments.text = arrSelectedDepartmentsNames.joined(separator: ",")
        strDepartmentsIds = arrDepartmentIds.map { String($0) }.joined(separator: ", ")
      }else{
            txtFieldAssignDepartments.text = ""
            strDepartmentsIds = ""
        }
        tblViewpopUp.isHidden = true
    }
}

