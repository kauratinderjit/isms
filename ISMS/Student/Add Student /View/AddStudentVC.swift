//
//  AddStudentVC.swift
//  ISMS
//
//  Created by Taranjeet Singh on 6/7/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit
import SDWebImage


class AddStudentVC: BaseUIViewController {
    
    @IBOutlet weak var lblGardienDetail: UILabel!
    @IBOutlet weak var lblStudentDetail: UILabel!
    @IBOutlet weak var imgViewStudent: UIImageView!
    @IBOutlet weak var btnAddProfileImage: UIButton!
    @IBOutlet weak var txtFieldFirstName: UITextField!
    @IBOutlet weak var txtFieldLastName: UITextField!
    @IBOutlet weak var txtFieldAddress: UITextField!
    @IBOutlet weak var txtFieldDOB: UITextField!
    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var btnFemale: UIButton!
    @IBOutlet weak var btnNA: UIButton!
    @IBOutlet weak var txtFieldRollnoOrAddmissionId: UITextField!
    @IBOutlet weak var txtFieldEmail: UITextField!
    @IBOutlet weak var txtFieldPhoneNumber: UITextField!
    @IBOutlet weak var txtFieldAllocatedBus: UITextField!
    @IBOutlet weak var txtFieldOthers: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnIdProof: UIButton!
    @IBOutlet weak var parentImg: UIButton!
    @IBOutlet weak var txtParentFirstName: UITextField!
    @IBOutlet weak var txtParentLastName: UITextField!
    @IBOutlet weak var txtParentRelation: UITextField!
    @IBOutlet weak var txtParentDOB: UITextField!
    @IBOutlet weak var btnParentMale: UIButton!
    @IBOutlet weak var btnParentFemale: UIButton!
    @IBOutlet weak var btnParentNA: UIButton!
    @IBOutlet weak var txtParentEmail: UITextField!
    @IBOutlet weak var txtParentPhoneNo: UITextField!
    @IBOutlet weak var parentGenderView: UIView!
    @IBOutlet weak var txtParentOthers: UITextField!
    @IBOutlet weak var btnParentIdProof: UITextField!
    @IBOutlet weak var parentDOBView: UIView!
    @IBOutlet weak var IdProofView: UIView!
    @IBOutlet weak var txtparentAddress: UITextField!
    @IBOutlet weak var parentImgView: UIImageView!
    @IBOutlet weak var studentGenderView: UIView!
    @IBOutlet weak var studentIdProofImgView: UIImageView!
    @IBOutlet weak var parentIdProofImgView: UIImageView!
    @IBOutlet weak var relationBtn: UIButton!
    @IBOutlet weak var textFieldIDProof: UITextField!
    @IBOutlet weak var btnIdProofParent: UIButton!
    @IBOutlet weak var ViewStudentIdProof: UIView!
    @IBOutlet weak var txtFieldStudentIdProof: UITextField!
    @IBOutlet weak var txtFieldDepartment: UITextField!
    @IBOutlet weak var viewDepartment: UIView!
    @IBOutlet weak var ViewClass: UIView!
    @IBOutlet weak var txtFieldClassDropDown: UITextField!
    
    
    
    //Variables
    var selectStudentIdProof : Bool?
    var selectParentIdProof : Bool?
    var selectStudentImg:Bool?
    var selectParentImg:Bool?
    var ViewModel : AddStudentViewModel?
    var imageViewIdProof : UIImageView!
    var gender = String()
    var parentGender = String()
    var ageYears : Int?
    var DateVal:String?
    var parentAgeYear: Int?
    var studentImgUrl:URL?
    var parentImgUrl:URL?
    var studentIdUrl:URL?
    var parentIdUrl :URL?
    var userVerifyDetail: VerifyEmailPhoneUserModel?
    var GardianDetail: GetDetailByPhoneEmailGardianModel?
    var enrollmentId:Int?
    var studentDetailArr: GetStudentDetail?
    var relationData : GetCommonDropdownModel!
    var selectedRelationIndex = 0
    var selectedRelationID : Int?
    var studentUserId:Int?
    var studentId:Int?
    var gardianId:Int?
    var gardianUserId : Int?
    var isUnauthorizedUser = false
    var isStudentAdd = false
    var departmentData = [ResultData]()
    var relationDropDown = false
    var departmentDropDown = false
    var classDropDown = false
    var selectedDepartmentID:Int?
    var selectedDepartmentIndex:Int?
    var selectedClassID:Int?
    var selectedClassIndex:Int?
    var classData = [ResultData]()
    var studentDOB : String?
    var parentDOB : String?
    var isCameFromImagePickerController : Bool?
    var selectedPreviousTextField : UITextField?//For Phone and Email of Student and Parents
    var isGuardianDOBSelected:Bool?
    var selectedStudentDOB:Date?
    var approach = "AddNew"
    
    
    
    //MARK:- Life Cycle of VC
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.ViewModel = AddStudentViewModel.init(delegate : self as AddStudentDelegate)
        self.ViewModel?.attachView(viewDelegate: self as ViewDelegate)
        DispatchQueue.main.async {
            self.setupUI()
        }
        selectedDepartmentID = UserDefaultExtensionModel.shared.HODDepartmentId
        hitGetStudentDetailApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        if isCameFromImagePickerController != true{
            //            ViewModel?.deattachView()
        }else{
            isCameFromImagePickerController = true
        }
    }
    
    
    
    @IBAction func selectParentGender(_ sender: Any) {
        
        self.view.endEditing(true)
        if((sender as AnyObject).tag == 0)
        {
            btnParentMale.setImage(UIImage(named:kImages.kRadioSelected), for: UIControl.State.normal)
            btnParentFemale.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
            btnParentNA.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
            parentGender = KConstants.KMale
            
        }
        else if ((sender as AnyObject).tag == 1)
        {
            btnParentMale.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
            btnParentFemale.setImage(UIImage(named: kImages.kRadioSelected), for: UIControl.State.normal)
            btnParentNA.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
            parentGender = KConstants.KFemale
            
        }
        else if (sender as AnyObject).tag == 2
        {
            btnParentMale.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
            btnParentFemale.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
            btnParentNA.setImage(UIImage(named: kImages.kRadioSelected), for: UIControl.State.normal)
            parentGender = KConstants.KNA
            
        }
    }
    
    //MARK:-Gender Button Action
    @IBAction func selectGenderButton(_ sender: UIButton)
    {
        self.view.endEditing(true)
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
        else if sender.tag == 2
        {
            btnMale.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
            btnFemale.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
            btnNA.setImage(UIImage(named: kImages.kRadioSelected), for: UIControl.State.normal)
            gender = KConstants.KNA
            
        }
    }
    
    //MARK:- Date Of Birth Parent Button Action
    @IBAction func btnParentDOBAction(_ sender: Any) {
        DateVal = KConstants.kIsParentDOB
        view.endEditing(true)
        showDatePicker(datePickerDelegate: self)
    }
    
    //MARK:- Submit Action
    @IBAction func btnSubmitAction(_ sender: UIButton)
    {
        view.endEditing(true)
        
        if (self.approach == "AddNew")
        {
            self.studentId = 0
            self.studentUserId = 0
        }
        
        
        if studentId == 0
        {
            //For Add Student
            self.ViewModel?.addStudent(studentId: self.studentId, studentUserId: studentUserId, studentImg: studentImgUrl,firstName: txtFieldFirstName.text, lastName: txtFieldLastName.text, address: txtFieldAddress.text, dateOfBirth: studentDOB,  gender: gender, rollNoOrAddmissionId: txtFieldRollnoOrAddmissionId.text, email: txtFieldEmail.text, phoneNumber: txtFieldPhoneNumber.text,studentIdProof: studentIdUrl, others: txtFieldOthers.text,parentImg: parentImgUrl, parentFirstName: txtParentFirstName.text, parentLastName: txtParentLastName.text,parentAddress: txtparentAddress.text,parentDOB: parentDOB,parentGender: parentGender,parentEmail: txtParentEmail.text,parentPhoneNo: txtParentPhoneNo.text,parentIdProof:parentIdUrl,parentOthers: txtParentOthers.text,relationID: selectedRelationID, studentIdProofTile: txtFieldStudentIdProof.text, parentIdProofTitle:textFieldIDProof.text, classId: selectedClassID, guardianId: gardianId, guardianUserId: gardianUserId, idProofName: txtFieldStudentIdProof.text, parentIdProofName: textFieldIDProof.text)
        }
        else if studentId != 0
        {
            //For set the nil value to Profile Image Url/Id Proof Image Url
            if studentImgUrl != nil||parentImgUrl != nil || parentIdUrl != nil || studentIdUrl != nil
            {
                if (studentImgUrl?.absoluteString.hasPrefix("http:") ?? false)
                {
                    studentImgUrl = nil
                }
                if parentImgUrl?.absoluteString.hasPrefix("http:") ?? false{
                    parentImgUrl = nil
                }
                if parentIdUrl?.absoluteString.hasPrefix("http:") ?? false{
                    parentIdUrl = nil
                }
                if studentIdUrl?.absoluteString.hasPrefix("http:") ?? false{
                    studentIdUrl = nil
                }
            }
            
            //For Update Student
            self.ViewModel?.addStudent(studentId: self.studentId, studentUserId: studentUserId, studentImg: studentImgUrl,firstName: txtFieldFirstName.text, lastName: txtFieldLastName.text, address: txtFieldAddress.text, dateOfBirth: studentDOB,  gender: gender, rollNoOrAddmissionId: txtFieldRollnoOrAddmissionId.text, email: txtFieldEmail.text, phoneNumber: txtFieldPhoneNumber.text,studentIdProof: studentIdUrl,others: txtFieldOthers.text,parentImg: parentImgUrl, parentFirstName: txtParentFirstName.text, parentLastName: txtParentLastName.text,parentAddress: txtparentAddress.text,parentDOB: parentDOB,parentGender: parentGender,parentEmail: txtParentEmail.text,parentPhoneNo: txtParentPhoneNo.text,parentIdProof:parentIdUrl,parentOthers: txtParentOthers.text,relationID: selectedRelationID,studentIdProofTile: txtFieldStudentIdProof.text,parentIdProofTitle:textFieldIDProof.text, classId: selectedClassID, guardianId: gardianId, guardianUserId: gardianUserId,idProofName: txtFieldStudentIdProof.text, parentIdProofName: textFieldIDProof.text)
        }
        
    }
    
    //MARK:- Date Of Birth Button Action
    @IBAction func btnDateOfBirth(_ sender: UIButton) {
        DateVal = KConstants.kIsStudentDOB
        view.endEditing(true)
        showDatePicker(datePickerDelegate: self)
    }
    
    
    //MARK:- Select Pic From Gallery
    
    @IBAction func btnSelectImage(_ sender: UIButton) {
        view.endEditing(true)
        //        selectIdProof = true
        if sender.tag == 0 {
            selectStudentImg = true
            selectParentImg = false
        }else if sender.tag == 1 {
            selectStudentImg = false
            selectParentImg = true
        }else if sender.tag == 2{
            selectStudentIdProof = true
            selectParentIdProof = false
        }else if sender.tag == 3{
            selectStudentIdProof = false
            selectParentIdProof = true
        }
        
        
        initializeGalleryAlert(self.view, isHideBlurView: true)
        galleryAlertView.delegate = self
        
    }
    
    //MARK:- Hit Student Api
    func hitGetStudentDetailApi(){
        if checkInternetConnection(){
            self.ViewModel?.getDepartmentId(id: 0, enumtype: 5)
            if enrollmentId != 0{
                self.title = KStoryBoards.KAddStudentIdentifiers.kUpdateTitle
                self.ViewModel?.getStudentDetail(enrollmentId: enrollmentId ?? 0)
            }else{
                self.title = KStoryBoards.KAddStudentIdentifiers.kAddTitle
                gender = KConstants.KMale
                parentGender = KConstants.KMale
            }
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
    }
    
    //Set Detail of Student in textfields
    func setDataInTextField(Data: GetStudentDetail){
        
        //Student Details
        
        if let classId = Data.resultData?.classId{
            selectedClassID = classId
        }
        if let className = Data.resultData?.className{
            txtFieldClassDropDown.text = className
        }
        if let departmentId = Data.resultData?.departmentId{
            selectedDepartmentID = departmentId
        }
        if let departmentName = Data.resultData?.departmentName{
            txtFieldDepartment.text = departmentName
        }
        
        if let imgProfileUrl = Data.resultData?.studentImageUrl{
            imgViewStudent.sd_imageIndicator = SDWebImageActivityIndicator.gray
            //mohit studentImgUrl = URL(string: imgProfileUrl)
            imgViewStudent.contentMode = .scaleAspectFill
            imgViewStudent.sd_setImage(with: URL(string: imgProfileUrl), placeholderImage: UIImage(named: kImages.kProfileImage))
        }else{
            studentImgUrl = URL(string: "")
            imgViewStudent.image = UIImage.init(named: kImages.kProfileImage)
        }
        
        if let firstName = Data.resultData?.studentFirstName{
            txtFieldFirstName.text = firstName
        }
        
        if let lastName = Data.resultData?.studentLastName{
            txtFieldLastName.text = lastName
        }
        
        if let address = Data.resultData?.studentAddress{
            txtFieldAddress.text = address
        }
        
        if let email = Data.resultData?.studentEmail{
            txtFieldEmail.text = email
        }
        
        if let phone = Data.resultData?.studentPhoneNo{
            txtFieldPhoneNumber.text = phone
        }
        
        if let DOB = Data.resultData?.studentDOB{
            studentDOB = DOB
            let date = CommonFunctions.sharedmanagerCommon.convertBackendDateFormatToLocalDate(serverSideDate: DOB)
            txtFieldDOB.text = date
        }
        
        if let others = Data.resultData?.studentOthers{
            txtFieldOthers.text = others
        }
        
        if let rollNo = Data.resultData?.studentRollNo{
            txtFieldRollnoOrAddmissionId.text = "\(rollNo)"
        }
        
        if let studentIdProofTitle = Data.resultData?.studentIDProofTitle{
            txtFieldStudentIdProof.text = studentIdProofTitle
        }
        
        if let studentIdProofImg = Data.resultData?.studentIDProof,studentIdProofImg != ""{
            //mohit  studentIdUrl = URL(string: studentIdProofImg)
            studentIdProofImgView.contentMode = .scaleAspectFill
            studentIdProofImgView.sd_setImage(with: URL(string: studentIdProofImg), placeholderImage: UIImage(named: kImages.kAttachmentImage))
        }else{
            studentImgUrl = URL(string: "")
            studentIdProofImgView.contentMode = .center
            studentIdProofImgView.image = UIImage.init(named: kImages.kAttachmentImage)
        }
        
        if let studentOthers = Data.resultData?.studentOthers{
            txtFieldOthers.text = studentOthers
        }
        
        if let gender = Data.resultData?.studentGender{
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
        
        if let imgProfileUrl = Data.resultData?.guardianImageUrl{
            parentImgView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            //mohit   parentImgUrl = URL(string: imgProfileUrl)
            parentImgView.contentMode = .scaleAspectFill
            parentImgView.sd_setImage(with: URL(string: imgProfileUrl), placeholderImage: UIImage(named: kImages.kProfileImage))
        }else{
            parentImgUrl = nil
            parentImgView.image = UIImage.init(named: kImages.kProfileImage)
        }
        
        //Guardian Details
        if let firstName = Data.resultData?.guardianFirstName{
            txtParentFirstName.text = firstName
        }
        
        if let lastName = Data.resultData?.guardianLastName{
            txtParentLastName.text = lastName
        }
        
        if let address = Data.resultData?.guardianAddress{
            txtparentAddress.text = address
        }
        
        if let email = Data.resultData?.guardianEmail{
            txtParentEmail.text = email
        }
        
        if let phone = Data.resultData?.guardianPhoneNo{
            txtParentPhoneNo.text = phone
        }
        
        if let DOB = Data.resultData?.guardianDOB{
            parentDOB = DOB
            let date = CommonFunctions.sharedmanagerCommon.convertBackendDateFormatToLocalDate(serverSideDate: DOB)
            txtParentDOB.text = date
        }
        
        if let guardianIdProofTitle = Data.resultData?.guardianIDProofTitle{
            textFieldIDProof.text = guardianIdProofTitle
        }
        
        if let guardianIdProofImgUrl = Data.resultData?.guardianIDProof, guardianIdProofImgUrl != ""{
            //mohit  parentIdUrl = URL(string: guardianIdProofImgUrl)
            parentIdProofImgView.contentMode = .scaleAspectFill
            parentIdProofImgView.sd_setImage(with: URL(string: guardianIdProofImgUrl), placeholderImage: UIImage(named: kImages.kAttachmentImage))
        }else{
            parentIdUrl = nil
            parentIdProofImgView.contentMode = .center
            parentIdProofImgView.image = UIImage.init(named: kImages.kAttachmentImage)
        }
        
        if let relation = Data.resultData?.relationName{
            selectedRelationID = Data.resultData?.relationId
            txtParentRelation.text = "\(relation)"
        }
        
        if let others = Data.resultData?.guardianOthers{
            txtParentOthers.text = others
        }
        
        if let gender = Data.resultData?.guardianGender{
            if(gender == KConstants.KMale)
            {
                btnParentMale.setImage(UIImage(named:kImages.kRadioSelected), for: UIControl.State.normal)
                btnParentFemale.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
                btnParentNA.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
                self.parentGender = KConstants.KMale
            }
            else if (gender == KConstants.KFemale)
            {
                btnParentMale.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
                btnParentFemale.setImage(UIImage(named: kImages.kRadioSelected), for: UIControl.State.normal)
                btnParentNA.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
                self.parentGender = KConstants.KFemale
            }
            else if (gender == KConstants.KNA)
            {
                btnParentMale.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
                btnParentFemale.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
                btnParentNA.setImage(UIImage(named: kImages.kRadioSelected), for: UIControl.State.normal)
                self.parentGender = KConstants.KNA
            }
        }
        
        if let wrappedStudentUserId = Data.resultData?.studentUserId
        {
            self.studentUserId = wrappedStudentUserId
        }
        if let wrappedStudentId = Data.resultData?.studentId{
            self.studentId = wrappedStudentId
        }
        if let wrappedGardianUserId = Data.resultData?.guardianUserId{
            self.gardianUserId = wrappedGardianUserId
        }
        if let wrappedGardianId = Data.resultData?.guardianId
        {
            self.gardianId = wrappedGardianId
        }
    }
    
    
    @IBAction func relationBtnAction(_ sender: Any) {
        relationDropDown = true
        self.ViewModel?.getRelationId(id: 0, enumtype: 9)
        
    }
    
    
    @IBAction func btnDepartmentDropDown(_ sender: Any) {
        //        departmentDropDown = true
        //        if departmentData.count > 0{
        //            self.txtFieldDepartment.text = self.departmentData[0].name
        //            self.selectedDepartmentID = self.departmentData[0].id ?? 0
        //            self.selectedDepartmentIndex = 0
        //            print("Selected Department:- \(String(describing: self.departmentData[0].name))")
        //            UpdatePickerModel(count: departmentData.count , sharedPickerDelegate: self, View:  self.view)
        //        }
    }
    
    
    
    @IBAction func btnClassDropDown(_ sender: Any) {
        classDropDown = true
        if classData.count > 0{
            //  self.txtFieldClassDropDown.text = self.classData[0].name
            //   self.selectedClassID = self.classData[0].id ?? 0
            self.selectedDepartmentIndex = 0
            print("Selected Department:- \(String(describing: self.classData[0].name))")
            UpdatePickerModel(count: classData.count , sharedPickerDelegate: self, View:  self.view)
        }
    }
    
    
    
}

extension AddStudentVC : OKAlertViewDelegate{
    
    //Ok Button Clicked
    func okBtnAction() {
        if isUnauthorizedUser == true{
            isUnauthorizedUser = false
            CommonFunctions.sharedmanagerCommon.setRootLogin()
        }else if isStudentAdd == true{
            isStudentAdd = false
            okAlertView.removeFromSuperview()
            self.navigationController?.popViewController(animated: true)
        }
        okAlertView.removeFromSuperview()
    }
}

extension AddStudentVC : GalleryAlertCustomViewDelegate{
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

//MARK:- UITextField Delegates
extension AddStudentVC : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtFieldAddress {
            txtFieldRollnoOrAddmissionId.becomeFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        //Validations for phone number and email student
        if textField == txtFieldPhoneNumber || textField == txtFieldEmail{
            view.endEditing(true)
            
            if textField == txtFieldPhoneNumber {
                //When User start entering phone but less then 10 digits then this check is continue
                if txtFieldPhoneNumber.text?.count ?? 0 > 0 && txtFieldPhoneNumber.text?.count ?? 0 < 10 {
                    DispatchQueue.main.async {
                        self.resignAllTextfields(txtFieldArr: [self.txtFieldPhoneNumber,self.txtFieldEmail,self.txtFieldFirstName,self.txtFieldLastName,self.txtFieldAddress,self.txtFieldRollnoOrAddmissionId,self.txtFieldStudentIdProof,self.txtFieldOthers,])
                        self.resignAllTextfields(txtFieldArr: [self.txtParentPhoneNo,self.txtParentEmail,self.txtParentFirstName,self.txtParentLastName,self.txtparentAddress,self.textFieldIDProof,self.txtParentOthers])
                    }
                    showAlert(alert: Alerts.kMinPhoneNumberCharacter)
                    return
                }else if txtFieldPhoneNumber.text?.count ?? 0 == 10{
                    selectedPreviousTextField = txtFieldPhoneNumber
                    ViewModel?.verifyPhoneAndEmail(phoneNum: txtFieldPhoneNumber.text, email: txtFieldEmail.text)
                }
                //We are not handle here empty because Email Or Phone is optional
                
            }
            if textField == txtFieldEmail{
                if txtFieldEmail.text?.count ?? 0 > 0{
                    if let email = txtFieldEmail.text, !email.isValidEmail(){
                        DispatchQueue.main.async {
                            self.resignAllTextfields(txtFieldArr: [self.txtFieldPhoneNumber,self.txtFieldEmail,self.txtFieldFirstName,self.txtFieldLastName,self.txtFieldAddress,self.txtFieldRollnoOrAddmissionId,self.txtFieldStudentIdProof,self.txtFieldOthers,])
                            self.resignAllTextfields(txtFieldArr: [self.txtParentPhoneNo,self.txtParentEmail,self.txtParentFirstName,self.txtParentLastName,self.txtparentAddress,self.textFieldIDProof,self.txtParentOthers])
                        }
                        self.showAlert(alert: Alerts.kInvalidEmail)
                        return
                    }else{
                        selectedPreviousTextField = txtFieldEmail
                        ViewModel?.verifyPhoneAndEmail(phoneNum: txtFieldPhoneNumber.text, email: txtFieldEmail.text)
                    }
                }
            }
            
        }else if textField == txtParentPhoneNo || textField == txtParentEmail{//For Parent
            if textField == txtParentPhoneNo {
                if txtParentPhoneNo.text?.count ?? 0 > 0 && txtParentPhoneNo.text?.count ?? 0 < 10 {
                    DispatchQueue.main.async {
                        self.resignAllTextfields(txtFieldArr: [self.txtFieldPhoneNumber,self.txtFieldEmail,self.txtFieldFirstName,self.txtFieldLastName,self.txtFieldAddress,self.txtFieldRollnoOrAddmissionId,self.txtFieldStudentIdProof,self.txtFieldOthers,])
                        self.resignAllTextfields(txtFieldArr: [self.txtParentPhoneNo,self.txtParentEmail,self.txtParentFirstName,self.txtParentLastName,self.txtparentAddress,self.textFieldIDProof,self.txtParentOthers])
                    }
                    showAlert(alert: Alerts.kMinPhoneNumberCharacter)
                    return
                }else if  txtParentPhoneNo.text?.count ?? 0 == 10
                {
                    selectedPreviousTextField = txtParentPhoneNo
                    ViewModel?.verifyPhoneAndEmailGardian(phoneNum: txtParentPhoneNo.text, email: txtParentEmail.text)
                }
            }
            if textField == txtParentEmail{
                if txtParentEmail.text?.count ?? 0 > 0{
                    if let email = txtParentEmail.text, !email.isValidEmail(){
                        DispatchQueue.main.async {
                            self.resignAllTextfields(txtFieldArr: [self.txtFieldPhoneNumber,self.txtFieldEmail,self.txtFieldFirstName,self.txtFieldLastName,self.txtFieldAddress,self.txtFieldRollnoOrAddmissionId,self.txtFieldStudentIdProof,self.txtFieldOthers,])
                            self.resignAllTextfields(txtFieldArr: [self.txtParentPhoneNo,self.txtParentEmail,self.txtParentFirstName,self.txtParentLastName,self.txtparentAddress,self.textFieldIDProof,self.txtParentOthers])
                        }
                        self.showAlert(alert: Alerts.kInvalidEmail)
                        return
                    }else{
                        selectedPreviousTextField = txtParentEmail
                        ViewModel?.verifyPhoneAndEmailGardian(phoneNum: txtParentPhoneNo.text, email: txtParentEmail.text)
                    }
                }
            }
        }else{
            debugPrint("Another text field.")
        }
        
        // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
        //        return true
    }
}
//MARK:- UIImagePickerView Delegate
extension AddStudentVC:UIImagePickerDelegate
{
    func cancelSelectionOfImg() {
        isCameFromImagePickerController = true
    }
    
    func selectedImageUrl(url: URL) {
        isCameFromImagePickerController = true
        if selectStudentImg == true{
            studentImgUrl = url
        }else if (selectParentImg == true){
            parentImgUrl = url
        }else if selectStudentIdProof == true {
            //            selectStudentIdProof = false
            studentIdUrl = url
        }else if selectParentIdProof == true{
            //            selectParentIdProof = false
            parentIdUrl = url
        }
    }
    
    func SelectedMedia(image: UIImage?, videoURL: URL?)
    {
        if  selectStudentImg == true{
            selectStudentImg = false
            self.imgViewStudent.contentMode = .scaleAspectFill
            self.imgViewStudent.image = image
        }else if selectStudentIdProof == true{
            selectStudentIdProof = false
            studentIdProofImgView.contentMode = .scaleAspectFill
            studentIdProofImgView.image = image
        }else if selectParentImg == true{
            selectParentImg = false
            self.parentImgView.contentMode = .scaleAspectFill
            self.parentImgView.image = image
        }else if selectParentIdProof == true{
            selectParentIdProof = false
            parentIdProofImgView.contentMode = .scaleAspectFill
            parentIdProofImgView.image = image
        }
        
    }
    
    
}

extension AddStudentVC: SharedUIDatePickerDelegate{
    
    func doneButtonClicked(datePicker: UIDatePicker) {
        print("Selected Date:- \(datePicker.date)")
        
        let strDate = CommonFunctions.sharedmanagerCommon.convertDateIntoStringWithDDMMYYYY(date: datePicker.date)
        
        let years = CommonFunctions.sharedmanagerCommon.getYearsBetweenDates(startDate: datePicker.date, endDate: Date())
        
        if let intYear = years{
            
            if intYear < 18
            {
                self.showAlert(alert: Alerts.kUnderAge)
                return
            }
            else
            {
                if DateVal == KConstants.kIsStudentDOB
                {
                    studentDOB = "\(datePicker.date)"
                    selectedStudentDOB = datePicker.date
                    txtFieldDOB.text = strDate
                    ageYears = intYear
                }
                else if DateVal == KConstants.kIsParentDOB
                {
                    if let studentDOB = selectedStudentDOB
                    {
                        let studentYears = CommonFunctions.sharedmanagerCommon.getYearsBetweenDates(startDate: studentDOB , endDate: Date())
                        if  let studentDOB = studentYears
                        {
                            if intYear < studentDOB
                            {
                                showAlert(alert: "Guardian age must be greater than student.")
                            }
                            else
                            {
                                parentDOB = "\(datePicker.date)"
                                txtParentDOB.text = strDate
                                parentAgeYear = intYear
                            }
                        }
                    }
                    else
                    {
                        //mohit showAlert(alert: "Fill student detail first.")
                    }
                }
            }
        }
    }
    
}



extension AddStudentVC: SharedUIPickerDelegate{
    func DoneBtnClicked() {
        if(relationDropDown == true){
            relationDropDown = false
            if let count = relationData.resultData?.count{
                if count > 0{
                    
                    if selectedRelationIndex == 0{
                        self.txtParentRelation.text = self.relationData?.resultData?[0].name
                        self.selectedRelationID = self.relationData?.resultData?[0].id ?? 0
                    }else{
                        self.txtParentRelation.text = self.relationData?.resultData?[selectedRelationIndex].name
                        self.selectedRelationID = self.relationData?.resultData?[selectedRelationIndex].id ?? 0
                    }
                }
            }
        }else if(departmentDropDown == true){
            departmentDropDown = false
            if checkInternetConnection(){
                self.ViewModel?.getClassId(id: 31, enumtype: 6)
            }else{
                
                self.showAlert(alert: Alerts.kNoInternetConnection)
                
            }
        }else if(classDropDown == true){
            if checkInternetConnection(){
                self.selectedClassID = classData[selectedClassIndex ?? 0].id
                self.txtFieldClassDropDown.text = classData[selectedClassIndex ?? 0].name
            }else{
                
                self.showAlert(alert: Alerts.kNoInternetConnection)
                
            }
        }
    }
    
    
    func GetTitleForRow(index: Int) -> String {
        if(relationDropDown == true){
            if let count = relationData.resultData?.count{
                if count > 0{
                    // txtParentRelation.text = relationData?.resultData?[0].name
                    return relationData?.resultData?[index].name ?? ""
                }
                return ""
            }
        }else if(departmentDropDown == true){
            if departmentData.count > 0{
                self.txtFieldDepartment.text = departmentData[0].name
                if (self.departmentData[exist: index]?.name) != nil{
                    return departmentData[index].name ?? ""
                }
                
                return ""
            }
            return ""
        }else if(classDropDown == true){
            if classData.count > 0{
                selectedClassIndex = 0
                // self.txtFieldClassDropDown.text = classData[0].name
                return classData[index].name ?? ""
            }
            return ""
        }
        
        return ""
    }
    
    
    func SelectedRow(index: Int) {
        if(relationDropDown == true){
            //Using Exist Method of collection prevent from indexoutof range error
            if let count = relationData.resultData?.count{
                if count > 0{
                    if (self.relationData.resultData?[exist: index]?.name) != nil{
                        //                        self.txtParentRelation.text = self.relationData?.resultData?[index].name
                        //                        self.selectedRelationID = self.relationData?.resultData?[index].id ?? 0
                        self.selectedRelationIndex = index
                        //                        print("Selected Department:- \(String(describing: self.relationData?.resultData?[index].id))")
                    }
                }
            }
        }else if(departmentDropDown == true){
            if departmentData.count > 0{
                self.selectedDepartmentID = departmentData[index].id
                self.txtFieldDepartment.text = departmentData[index].name
            }
        }else if(classDropDown == true){
            if classData.count > 0{
                selectedClassIndex = index
                //  self.selectedClassID = classData[index].id
                //   self.txtFieldClassDropDown.text = classData[index].name
            }
        }
    }
    
    func cancelButtonClicked() {
        if relationDropDown == true{
            relationDropDown = false
        }else if departmentDropDown == true{
            departmentDropDown = false
        }else if classDropDown == true{
            classDropDown = false
        }
        
        
    }
}


//MARK:- Global View Delegate
extension AddStudentVC : ViewDelegate{
    func showAlert(alert: String)
    {
        initializeCustomOkAlert(self.view, isHideBlurView: true)
        okAlertView.delegate = self
        okAlertView.lblResponseDetailMessage.text = alert
    }
    
    func showLoader() {
        self.ShowLoader()
    }
    
    func hideLoader() {
        self.HideLoader()
    }
    
    func setupUI(){
        
        isCameFromImagePickerController = false
        self.gender = KConstants.KMale
        SetpickerView(self.view)
        setBackButton()
        setDatePickerView(self.view, type: .date)
        
        if studentId == 0{
            self.title = KNavigationTitle.kAddStudentTitle
        }else{
            self.title = KNavigationTitle.kUpdateStudentTitle
        }
        
        
        parentGender = KConstants.KMale
        cornerImage(image: imgViewStudent)
        cornerImage(image: parentImgView)
        cornerImage(image: studentIdProofImgView)
        cornerImage(image: parentIdProofImgView)
        
        txtFieldPhoneNumber.delegate = self
        txtFieldEmail.delegate = self
        txtParentEmail.delegate = self
        txtParentPhoneNo.delegate = self
        
        UnHideNavigationBar(navigationController: self.navigationController)
        
        //Set Fonts in TextFields
        txtFieldFirstName.SetTextFont(textSize: KTextSize.KFourteen, placeholderText: KPlaceholder.kFirstName)
        txtFieldLastName.SetTextFont(textSize: KTextSize.KFourteen, placeholderText: KPlaceholder.kLastName)
        txtFieldDOB.SetTextFont(textSize: KTextSize.KFourteen, placeholderText: KPlaceholder.kDOB)
        txtFieldEmail.SetTextFont(textSize: KTextSize.KFourteen, placeholderText: KPlaceholder.kEmail)
        txtFieldOthers.SetTextFont(textSize: KTextSize.KFourteen, placeholderText: KPlaceholder.kOthers)
        txtFieldAddress.SetTextFont(textSize: KTextSize.KFourteen, placeholderText: KPlaceholder.kAddress)
        
        txtFieldPhoneNumber.SetTextFont(textSize: KTextSize.KFourteen, placeholderText: KPlaceholder.kPhoneNumber)
        txtFieldRollnoOrAddmissionId.SetTextFont(textSize: KTextSize.KFourteen, placeholderText: KPlaceholder.kRollNoOrAdmissionId)
        //        txtFieldIdProof.SetTextFont(textSize: KTextSize.KSixteen, placeholderText: KPlaceholder.kIdProof)
        txtFieldClassDropDown.SetTextFont(textSize: KTextSize.KFourteen, placeholderText: KPlaceholder.kSelectClass)
        
        txtParentFirstName.SetTextFont(textSize: KTextSize.KFourteen, placeholderText: KPlaceholder.kFirstName)
        txtParentLastName.SetTextFont(textSize: KTextSize.KFourteen, placeholderText: KPlaceholder.kLastName)
        txtParentRelation.SetTextFont(textSize: KTextSize.KFourteen, placeholderText: KPlaceholder.kRelation)
        txtParentDOB.SetTextFont(textSize: KTextSize.KFourteen, placeholderText: KPlaceholder.kDOB)
        txtParentEmail.SetTextFont(textSize: KTextSize.KFourteen, placeholderText: KPlaceholder.kEmail)
        txtParentPhoneNo.SetTextFont(textSize: KTextSize.KFourteen, placeholderText: KPlaceholder.kPhoneNumber)
        txtParentOthers.SetTextFont(textSize: KTextSize.KFourteen, placeholderText: KPlaceholder.kOthers)
        textFieldIDProof.SetTextFont(textSize: KTextSize.KFourteen, placeholderText: KPlaceholder.kIdProof)
        txtparentAddress.SetTextFont(textSize: KTextSize.KFourteen, placeholderText: KPlaceholder.kAddress)
        txtFieldStudentIdProof.SetTextFont(textSize: KTextSize.KFourteen, placeholderText: KPlaceholder.kIdProof)
        txtFieldDepartment.SetTextFont(textSize: KTextSize.KFourteen, placeholderText: KPlaceholder.kSelectDepartment)
        
        
        //Set Shadows
        //        createMultipleViewsCornerShadow(views: [txtFieldFirstName,txtFieldLastName,txtFieldDOB,txtFieldEmail,txtFieldOthers,txtFieldAddress,txtFieldPhoneNumber,txtFieldRollnoOrAddmissionId], radius: 8)
        //        createMultipleViewsCornerShadow(views: [txtParentFirstName,txtParentLastName,txtParentDOB,txtParentEmail,txtParentPhoneNo,txtParentOthers,txtParentRelation,parentGenderView,textFieldIDProof,parentDOBView,txtparentAddress,studentGenderView,txtFieldStudentIdProof,viewDepartment,ViewClass], radius: 8)
        
        //Connect Multiple textfields
        connectFields(fields: [txtFieldEmail,txtFieldFirstName,txtFieldLastName,txtFieldAddress,txtFieldRollnoOrAddmissionId,txtFieldStudentIdProof,txtFieldOthers])
        
        connectFields(fields: [txtParentPhoneNo,txtParentEmail,txtParentFirstName,txtParentLastName,txtparentAddress,textFieldIDProof,txtParentOthers])
        
        
        //Set padding
        txtFieldFirstName.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        txtFieldLastName.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        txtFieldDOB.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        txtFieldEmail.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        txtFieldOthers.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        txtFieldAddress.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        txtFieldRollnoOrAddmissionId.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        txtFieldPhoneNumber.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        txtParentFirstName.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        txtParentLastName.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        txtParentDOB.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        txtParentEmail.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        txtParentPhoneNo.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        txtParentOthers.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        txtParentRelation.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        textFieldIDProof.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        txtparentAddress.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        txtFieldStudentIdProof.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        txtFieldDepartment.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        txtFieldClassDropDown.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        
        
        //Theme Color
        guard let theme = ThemeManager.shared.currentTheme else {return}
        btnSubmit.backgroundColor = theme.uiButtonBackgroundColor
        btnSubmit.titleLabel?.textColor = theme.uiButtonTextColor
        //        btnAddProfileImage.tintColor = theme.uiButtonBackgroundColor
        //        parentImg.tintColor = theme.uiButtonBackgroundColor
    }
    
    func setupCustomView(){
        initializeCustomOkAlert(self.view, isHideBlurView: true)
        okAlertView.delegate = self
    }
}


//MARK:- Add Student Delegates
extension AddStudentVC : AddStudentDelegate
{
    func studentParentNotExist(isStudent: Bool)
    {
        if isStudent == true
        {
            studentId = 0
            //            studentUserId = 0
        }
        else
        {
            gardianId = 0
            //            gardianUserId = 0
        }
    }
    
    func getClassdropdownDidSucceed(data: [ResultData]?) {
        //   self.txtFieldClassDropDown.text = data?.first?.name
        // selectedClassID = data?.first?.id
        if data != nil{
            if data?.count ?? 0 > 0{
                for value in data!{
                    let containsSameValue = classData.contains(where: {$0.id == value.id})
                    if containsSameValue == false{
                        classData.append(value)
                    }
                }
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Zero")
            }
        }else{
            CommonFunctions.sharedmanagerCommon.println(object: "Nil")
        }
    }
    
    func getDepartmentdropdownDidSucceed(data: [ResultData]?) {
        self.txtFieldDepartment.text = data?.first?.name
        selectedDepartmentID = data?.first?.id
        if data != nil{
            if data?.count ?? 0 > 0{
                for value in data!{
                    let containsSameValue = departmentData.contains(where: {$0.id == value.id})
                    if containsSameValue == false{
                        departmentData.append(value)
                        if value.id ==  44{
                            self.txtFieldDepartment.text = value.name
                        }
                    }
                }
                self.ViewModel?.getClassId(id: UserDefaultExtensionModel.shared.HODDepartmentId, enumtype: 6)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Zero")
            }
        }else{
            CommonFunctions.sharedmanagerCommon.println(object: "Nil")
        }
        
    }
    
    //Get Guardian Detail By Phone/Email
    func PhoneEmailVerifyGardianDidSuccess(data: GetDetailByPhoneEmailGardianModel)
    {
        
        GardianDetail = data
        let userDetail = GardianDetail?.resultData
        
        
        
        gardianId = userDetail?.guardianId
        
        gardianUserId = userDetail?.guardianUserId
        studentId = userDetail?.studentID
        txtParentFirstName.text = userDetail?.GuardianFirstName
        txtParentLastName.text = userDetail?.GuardianLastName
        txtparentAddress.text = userDetail?.GuardianAddress
        
        if (userDetail?.GuardianEmail?.count ?? 0 > 0 || userDetail?.GuardianEmail != nil)
        {
            txtParentEmail.text = userDetail?.GuardianEmail
        }
        
        selectedRelationID = userDetail?.relationId
        txtParentRelation.text = userDetail?.relationName
        textFieldIDProof.text = userDetail?.iDProofTitle
        
        
        if let imgProfileUrl = userDetail?.guardianImageUrl
        {
            //mohit   parentImgUrl = URL(string: imgProfileUrl)
            parentImgView.contentMode = .scaleAspectFill
            parentImgView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            parentImgView.sd_setImage(with: URL(string: imgProfileUrl), placeholderImage: UIImage(named: kImages.kProfileImage))
        }
        else
        {
            parentImgUrl = URL(string: "")
            parentImgView.image = UIImage.init(named: kImages.kProfileImage)
        }
        
        if let gardianIdProof = userDetail?.guardianIDProof,gardianIdProof != ""{
            //mohit  parentIdUrl = URL(string: gardianIdProof)
            parentIdProofImgView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            parentIdProofImgView.contentMode = .scaleAspectFit
            parentIdProofImgView.sd_setImage(with: URL(string: gardianIdProof), placeholderImage: UIImage(named: kImages.kAttachmentImage))
        }else{
            parentIdUrl = URL(string: "")
            parentIdProofImgView.contentMode = .center
            parentIdProofImgView.image = UIImage.init(named: kImages.kAttachmentImage)
        }
        
        if let parentDob = userDetail?.GuardianDOB{
            parentDOB = parentDob
            let date = CommonFunctions.sharedmanagerCommon.convertBackendDateFormatToLocalDate(serverSideDate: parentDob)
            txtParentDOB.text = date
        }
        
        if let gender = userDetail?.GuardianGender
        {
            if(gender == KConstants.KMale)
            {
                btnParentMale.setImage(UIImage(named:kImages.kRadioSelected), for: UIControl.State.normal)
                btnParentFemale.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
                btnParentNA.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
                self.gender = KConstants.KMale
            }
            else if (gender == KConstants.KFemale)
            {
                btnParentMale.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
                btnParentFemale.setImage(UIImage(named: kImages.kRadioSelected), for: UIControl.State.normal)
                btnParentNA.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
                self.gender = KConstants.KFemale
            }
            else if (gender == KConstants.KNA)
            {
                btnParentMale.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
                btnParentFemale.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
                btnParentNA.setImage(UIImage(named: kImages.kRadioSelected), for: UIControl.State.normal)
                self.gender = KConstants.KNA
            }
        }
        
        //When user did focus out then set the previous textfield then text of Phone/Email
        if selectedPreviousTextField == txtParentPhoneNo&&selectedPreviousTextField != txtParentEmail{
            txtParentEmail.text = userDetail?.email
        }else if selectedPreviousTextField == txtParentEmail && selectedPreviousTextField != txtParentPhoneNo{
            txtParentPhoneNo.text = userDetail?.phoneNo
        }
        
        
        
    }
    
    func unauthorizedUser() {
        isUnauthorizedUser = true
    }
    
    func StudentDetailDidFailed() {
        
    }
    
    //Student Full Detail using student id
    func StudentDetailDidSuccess(Data: GetStudentDetail)
    {
        setDataInTextField(Data: Data)
    }
    
    //Get Detail Student By Using Phone/Email
    func PhoneEmailVerifyDidSuccess(data : VerifyEmailPhoneUserModel) {
     
        userVerifyDetail = data
        let userDetail = userVerifyDetail?.resultData
        //Show Pic Of User
        if let imgProfileUrl = userDetail?.imageUrl{
            imgViewStudent.sd_imageIndicator = SDWebImageActivityIndicator.gray
            //mohit  studentImgUrl = URL(string: imgProfileUrl)
            imgViewStudent.contentMode = .scaleAspectFill
            
            imgViewStudent.sd_setImage(with: URL(string: imgProfileUrl), placeholderImage: UIImage(named: kImages.kProfileImage))
        }else{
            studentImgUrl = URL(string: "")
            imgViewStudent.image = UIImage.init(named: kImages.kProfileImage)
        }
        
        //Set Id Proof Image of student user
        if let studentIdProofImg = userDetail?.idProof,studentIdProofImg != ""{
            studentIdProofImgView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            //mohit  studentIdUrl = URL(string: studentIdProofImg)
            studentIdProofImgView.contentMode = .scaleAspectFill
            studentIdProofImgView.sd_setImage(with: URL(string: studentIdProofImg), placeholderImage: UIImage(named: kImages.kAttachmentImage))
        }else{
            studentIdProofImgView.contentMode = .center
            studentIdUrl = URL(string: "")
            studentIdProofImgView.image = UIImage.init(named: kImages.kAttachmentImage)
        }
        
        if let studentDob = userDetail?.dob{
            studentDOB = studentDob
            let date = CommonFunctions.sharedmanagerCommon.convertBackendDateFormatToLocalDate(serverSideDate: studentDob)
            txtFieldDOB.text = date
        }
        
        if let gender = userDetail?.gender{
            if(gender == KConstants.KMale)
            {
                btnParentMale.setImage(UIImage(named:kImages.kRadioSelected), for: UIControl.State.normal)
                btnParentFemale.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
                btnParentNA.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
                self.gender = KConstants.KMale
            }
            else if (gender == KConstants.KFemale)
            {
                btnParentMale.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
                btnParentFemale.setImage(UIImage(named: kImages.kRadioSelected), for: UIControl.State.normal)
                btnParentNA.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
                self.gender = KConstants.KFemale
            }
            else if (gender == KConstants.KNA)
            {
                btnParentMale.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
                btnParentFemale.setImage(UIImage(named: kImages.kUnselectedRadio), for: UIControl.State.normal)
                btnParentNA.setImage(UIImage(named: kImages.kRadioSelected), for: UIControl.State.normal)
                self.gender = KConstants.KNA
            }
        }
        
        if selectedPreviousTextField == txtFieldPhoneNumber&&selectedPreviousTextField != txtFieldEmail{
            txtFieldEmail.text = userDetail?.email
            txtFieldEmail.isUserInteractionEnabled = false
        }else if selectedPreviousTextField == txtFieldEmail && selectedPreviousTextField != txtFieldPhoneNumber{
            txtFieldPhoneNumber.text = userDetail?.phoneNo
        }
        
        txtFieldFirstName.text = userDetail?.firstName
        txtFieldLastName.text = userDetail?.lastName
        txtFieldAddress.text = userDetail?.address
        txtFieldStudentIdProof.text = userDetail?.idProofTitle
        selectedClassID = userDetail?.classId
        selectedDepartmentID  = userDetail?.departmentId
        txtFieldClassDropDown.text = userDetail?.className
        txtFieldDepartment.text = userDetail?.departmentName
        txtFieldRollnoOrAddmissionId.text = String(describing: userDetail?.rollnumberOrAddmissionId ?? 0)
        if txtFieldRollnoOrAddmissionId.text != ""{
            txtFieldRollnoOrAddmissionId.isUserInteractionEnabled = false
        }
        gender = userDetail?.gender ?? ""
        studentUserId = userDetail?.userId
        studentId = userDetail?.studentId
        
    }
    
    //Response Success
    func AddStudentDidSuccess(data: AddStudentModel) {
        isStudentAdd = true
        DispatchQueue.main.async {
            self.showAlert(alert: data.message ?? "Something went wrong")
        }
    }
    //Response Failed
    func AddStudentDidFailed() {
        
    }
    
    func getRelationdropdownDidSucceed(data: GetCommonDropdownModel){
        relationData = data
        if let count = data.resultData?.count{
            if count > 0 {
                UpdatePickerModel(count: relationData?.resultData?.count ?? 0, sharedPickerDelegate: self, View:  self.view)
            }else{
                print("relation Count is zero.")
            }
        }
    }
}




