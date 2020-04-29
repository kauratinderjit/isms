//
//  AddHODViewModel.swift
//  ISMS
//
//  Created by Taranjeet Singh on 6/12/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
import SDWebImage

protocol AddHODDelegate: class {
    func unauthorizedUser()
    func addUpdateHodDidSuccess(data : CommonSuccessResponseModel)
    func detailHODDidSucceed(data : HODDetailModel)
    func getDepartmentdropdownDidSucceed(data : GetCommonDropdownModel)
    func PhoneEmailVerifyDidSuccess(data : GetDetailByPhoneEmailModel)
    func phoneEmailVerifyDidFailed()
    
}

class AddHODViewModel{
    
    //Global ViewDelegate weak object
    private weak var addHODView : ViewDelegate?
    
    //AddTeacherDelegate weak object
    private weak var addHodDelegate : AddHODDelegate?
    
    //Initiallize the presenter class using delegates
    init(delegate: AddHODDelegate) {
        addHodDelegate = delegate
    }
    
    //Attach GlobalViewDelegate
    func attachView(viewDelegate : ViewDelegate){
        addHODView = viewDelegate
    }
    
    //Deattach View for free the memory from instances
    func deattachView(){
        addHODView = nil
        addHodDelegate = nil
    }
    
    //MARK:- Add/Update HOD
    func addUpdateHOD(hodId : Int?,firstName: String?,lastName: String?,address: String?,dateOfBirth: String?,gender: String?,profileImageUrl : URL?,idProofName : String?,idProofImgUrl: URL?,email:String?,departmentId: Int?,departmentName: String?,phoneNumber: String?,qualification: String?,workExperience: String?,additionalSkills:String?,others: String?,userId:Int?){
        
        
        do {
            try validationsAddHOD(hodId: hodId, firstName: firstName,lastName: lastName,address: address,dateOfBirth: dateOfBirth, gender: gender, profileImageUrl: profileImageUrl, idProofName: idProofName ,idProofImgUrl: idProofImgUrl,email:email,phoneNumber: phoneNumber, departmentId: departmentId, departmentName: departmentName,qualification: qualification,workExperience: workExperience,additionalSkills:additionalSkills,others: others)
            
            self.addHODView?.showLoader()
            
            var othrs : String?
            var addSkills : String?
         
            
            if others == ""{
                othrs = nil
            }else{
                othrs = others
            }
            
            if additionalSkills == ""{
                addSkills = nil
            }else{
                addSkills = additionalSkills
            }
           
            var postDict = [String: Any]()

            postDict[KApiParameters.KAddHODApiParameters.kHODId] = hodId ?? 0
            postDict[KApiParameters.KAddHODApiParameters.kImageUrl] = profileImageUrl ?? ""
            postDict[KApiParameters.KAddHODApiParameters.kFirstName] = firstName ?? ""
            postDict[KApiParameters.KAddHODApiParameters.kLastName] = lastName ?? ""
            postDict[KApiParameters.KAddHODApiParameters.kAddress] = address ?? ""
            postDict[KApiParameters.KAddHODApiParameters.kDOB] = dateOfBirth ?? ""
            postDict[KApiParameters.KAddHODApiParameters.kGender] = gender ?? ""
            postDict[KApiParameters.KAddHODApiParameters.kEmail] = email ?? ""
            postDict[KApiParameters.KAddHODApiParameters.kPhoneNo] = phoneNumber ?? ""
            postDict[KApiParameters.KAddHODApiParameters.kIDProof] = idProofImgUrl ?? ""
            postDict[KApiParameters.KAddHODApiParameters.kIDProofTitle] = idProofName ?? ""
            postDict[KApiParameters.KAddHODApiParameters.kDepartmentId] = departmentId ?? 0
            postDict[KApiParameters.KAddHODApiParameters.kDepartmentName] = departmentName ?? ""
            postDict[KApiParameters.KAddHODApiParameters.kQualification] = qualification ?? ""
            postDict[KApiParameters.KAddHODApiParameters.kWorkExperience] = workExperience ?? ""
            postDict[KApiParameters.KAddHODApiParameters.kAdditionalSkills] = addSkills ?? ""
            postDict[KApiParameters.KAddHODApiParameters.kOthers] = othrs ?? ""
            postDict[KApiParameters.KAddHODApiParameters.kCityId] = 1
            postDict[KApiParameters.KAddHODApiParameters.kuserId] = userId ?? 0

            
                HODApi.sharedManager.addUpdateHod(url: ApiEndpoints.kAddHod, parameters: postDict, completionResponse: {[weak self] (responseModel) in
                    self?.addHODView?.hideLoader()
                    
                    switch responseModel.statusCode{
                    case KStatusCode.kStatusCode200:
                        self?.addHODView?.showAlert(alert: responseModel.message ?? "")
                        self?.addHodDelegate?.addUpdateHodDidSuccess(data: responseModel)
                    case KStatusCode.kStatusCode404:
                        self?.addHODView?.showAlert(alert: responseModel.message ?? "")
                    case KStatusCode.kStatusCode401:
                        self?.addHODView?.showAlert(alert: responseModel.message ?? "")
                        self?.addHodDelegate?.unauthorizedUser()
                    default :
                        self?.addHODView?.showAlert(alert: responseModel.message ?? "")
                        CommonFunctions.sharedmanagerCommon.println(object: "default in add/update")
                    }
                    
                }, completionnilResponse: {[weak self] (nilResponse) in
                    self?.addHODView?.hideLoader()
                    self?.addHODView?.showAlert(alert: nilResponse ?? Alerts.kMapperModelError)
                }) {[weak self] (error) in
                    self?.addHODView?.hideLoader()
                    self?.addHODView?.showAlert(alert: error?.localizedDescription ?? Alerts.kMapperModelError)
                }

            
        } catch let error {
            
            switch  error {
                
            case ValidationError.emptyPhoneNumber:
                addHODView?.showAlert(alert: Alerts.kEmptyPhoneNumber)
                
            case ValidationError.minCharactersPhoneNumber:
                addHODView?.showAlert(alert: Alerts.kMinPhoneNumberCharacter)
                
            case ValidationError.emptyEmailAddress:
                addHODView?.showAlert(alert: Alerts.kEmptyEmail)
                
            case ValidationError.invalidEmail:
                addHODView?.showAlert(alert: Alerts.kInvalidEmail)

            case ValidationError.emptyFirstName:
                addHODView?.showAlert(alert: Alerts.kEmptyFirstName)
                
            case ValidationError.emptyLastName:
                addHODView?.showAlert(alert: Alerts.kEmptyLastName)
                
            case ValidationError.emptyAddress:
                addHODView?.showAlert(alert: Alerts.kEmptyAddress)
                
            case ValidationError.emptyDateOfBith:
                addHODView?.showAlert(alert: Alerts.kEmptyDOB)
                
            case ValidationError.emptyGender:
                addHODView?.showAlert(alert: Alerts.kEmptyGender)
                
            case ValidationError.emptyDepartmentID:
                addHODView?.showAlert(alert: Alerts.kEmptyDepartment)
                
            case ValidationError.emptyIDProofName:
                addHODView?.showAlert(alert: Alerts.kEmptyIdProof)
                
            case ValidationError.emptyIdProofImage:
                addHODView?.showAlert(alert: Alerts.kSelectIdProofImage)
                
            case ValidationError.emptyIdProof:
                addHODView?.showAlert(alert: Alerts.kEmptyIdProof)
                
            case ValidationError.emptyWorkExperience:
                addHODView?.showAlert(alert: Alerts.kEmptyWorkExperience)
                
            case ValidationError.emptyQualification:
                addHODView?.showAlert(alert: Alerts.kEmptyQualifications)
                
                
                
            case ValidationError.emptyFatherName:
                addHODView?.showAlert(alert: Alerts.kEmptyOthers)
                
            default:
                break
          
            }
            
        }
        
    }
   
    //MARK:- HOD Detail
    func getHODDetail(hodId : Int){
        
            let getUrl = ApiEndpoints.kGetHodDetail + "?hodId=\(hodId)"
            
            self.addHODView?.showLoader()
            HODApi.sharedManager.getHODDetail(url: getUrl, completionResponse: {[weak self] (hodDetailresponse) in
                
                self?.addHODView?.hideLoader()
                
                switch hodDetailresponse.statusCode{
                    case KStatusCode.kStatusCode200:
//                        self.addHODView?.showAlert(alert: hodDetailresponse.message ?? "")
                        self?.addHodDelegate?.detailHODDidSucceed(data: hodDetailresponse)
                    case KStatusCode.kStatusCode401:
                        self?.addHODView?.showAlert(alert: hodDetailresponse.message ?? "")
                        self?.addHodDelegate?.unauthorizedUser()
                    default :
                        CommonFunctions.sharedmanagerCommon.println(object: "default in detail")
                        self?.addHODView?.showAlert(alert: hodDetailresponse.message ?? "")
                }
            }, completionnilResponse: {[weak self] (error) in
                self?.addHODView?.hideLoader()
                if let nilResponse = error{
                    self?.addHODView?.showAlert(alert: nilResponse)
                }
            }) { [weak self] (error) in
                self?.addHODView?.hideLoader()
                if let err = error{
                    self?.addHODView?.showAlert(alert: err.localizedDescription)
                }
            }
    }
    //MARK:- Validations Add HOD
    func validationsAddHOD(hodId:Int?,firstName: String?,lastName: String?,address: String?,dateOfBirth: String?,gender: String?,profileImageUrl: URL? ,idProofName: String? ,idProofImgUrl: URL?,email:String?,phoneNumber: String?,departmentId: Int?,departmentName: String?,qualification: String?,workExperience: String?,additionalSkills:String?,others: String?) throws
    {
        if email == nil&&phoneNumber == nil||email == ""&&phoneNumber == ""{
            throw ValidationError.phoneOrEmailIsEmpty
        }else{
            if let emailAdd = email,!emailAdd.isEmpty,!emailAdd.trimmingCharacters(in: .whitespaces).isEmpty&&phoneNumber == "",!emailAdd.isValidEmail(){
                //                if !emailAdd.isValidEmail(){
                throw ValidationError.invalidEmail
                //                }
            }else if let phNo = phoneNumber,!phNo.isEmpty,!phNo.trimmingCharacters(in: .whitespaces).isEmpty&&email == ""{
                if let phNo = phoneNumber,phNo.count < 10{
                    throw ValidationError.minCharactersPhoneNumber
                }
            }else if let phNo = phoneNumber,!phNo.isEmpty,!phNo.trimmingCharacters(in: .whitespaces).isEmpty,let emailAdd = email,!emailAdd.isEmpty,!emailAdd.trimmingCharacters(in: .whitespaces).isEmpty{
                if phNo.count < 10{
                    throw ValidationError.minCharactersPhoneNumber
                }
                else if !emailAdd.isValidEmail(){
                    throw ValidationError.invalidEmail
                }
            }
        }
        

        guard let firstName = firstName,  !firstName.isEmpty, !firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else
        {
            throw ValidationError.emptyFirstName
        }
        
        guard let lastName  = lastName, !lastName.isEmpty, !lastName.trimmingCharacters(in: .whitespaces).isEmpty else
        {
            throw ValidationError.emptyLastName
        }
        
        guard let address = address,!address.isEmpty,!address.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            else
        {
            throw ValidationError.emptyAddress
        }
        
        guard let dob = dateOfBirth,!dob.isEmpty,!dob.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            else{
                throw ValidationError.emptyDateOfBith
        }
        
        guard let gender = gender,!gender.isEmpty,!gender.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else{
            throw ValidationError.emptyGender
        }
        
        
        
        guard let idProofName = idProofName, !idProofName.isEmpty, !idProofName.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw ValidationError.emptyIDProofName
        }
        
        if hodId == 0{
            
            guard let idProofImgUrl  = idProofImgUrl?.absoluteString,!idProofImgUrl.isEmpty , !idProofImgUrl.trimmingCharacters(in: .whitespaces).isEmpty
                else
            {
                throw ValidationError.emptyIdProofImage
            }
            
        }
        
  
        if departmentId == nil
        {
            throw ValidationError.emptyDepartmentID
        }
        
        if (qualification?.count == 0)
        {
            throw ValidationError.emptyQualification
        }
        
        if (workExperience?.count == 0)
        {
            throw ValidationError.emptyWorkExperience
        }
        
//        guard let qualification  = qualification, !qualification.isEmpty, !qualification.trimmingCharacters(in: .whitespaces).isEmpty
//            else
//        {
//            throw ValidationError.emptyQualification
//        }
        
//        guard let workExperience  = workExperience, !workExperience.isEmpty, !workExperience.trimmingCharacters(in: .whitespaces).isEmpty
//            else
//        {
//            throw ValidationError.emptyWorkExperience
//        }
    }
    
    //MARk:- Get departments dropdown data
    func getDepartments(selectedDepartmentId: Int?,enumtype: Int?){
        
        guard let selectId = selectedDepartmentId else{ return }
        guard let enumType = enumtype else { return }
        
        self.addHODView?.showLoader()
        
        HODApi.sharedManager.getDepartmentsDropdownData(selectedDepartmentId: selectId, enumType: enumType, completionResponse: {[weak self] (responseModel) in
            self?.addHODView?.hideLoader()

            switch responseModel.statusCode{
            case KStatusCode.kStatusCode200:
                self?.addHodDelegate?.getDepartmentdropdownDidSucceed(data: responseModel)
                self?.addHODView?.hideLoader()
            case KStatusCode.kStatusCode401:
                self?.addHODView?.showAlert(alert: responseModel.message ?? "")
                self?.addHodDelegate?.unauthorizedUser()
            default:
                self?.addHODView?.showAlert(alert: responseModel.message ?? "")
            }
            
        }, completionnilResponse: {[weak self] (nilResponse) in
            self?.addHODView?.hideLoader()
            if let nilRes = nilResponse{
                self?.addHODView?.showAlert(alert: nilRes)
            }
        }) {[weak self] (error) in
            self?.addHODView?.hideLoader()
            if let err = error{
                self?.addHODView?.showAlert(alert: err.localizedDescription)
            }
        }
    }
    
    func verifyPhoneAndEmail(phoneNum: String?, email: String?){
        self.addHODView?.showLoader()
        
        let paramDict = [KApiParameters.KGetDetailByPhoneEmail.kPhone: phoneNum ?? "",KApiParameters.KGetDetailByPhoneEmail.kEmail:email ?? ""] as [String : Any]
        
         HODApi.sharedManager.PhoneEmailVerify(url: ApiEndpoints.KHODPhoneEmailVerifyApi, parameters: paramDict as [String : Any], completionResponse: {[weak self] (GetDetailByPhoneEmailModel) in
            self?.addHODView?.hideLoader()
            switch GetDetailByPhoneEmailModel.statusCode{
            case KStatusCode.kStatusCode302:
                self?.addHodDelegate?.PhoneEmailVerifyDidSuccess(data : GetDetailByPhoneEmailModel)
            case KStatusCode.kStatusCode401:
                self?.addHODView?.showAlert(alert: GetDetailByPhoneEmailModel.message ?? "Something went wrong")
                self?.addHodDelegate?.unauthorizedUser()
            case KStatusCode.kStatusCode404:
               // self?.addHODView?.showAlert(alert: GetDetailByPhoneEmailModel.message ?? "Something went wrong")
                self?.addHodDelegate?.phoneEmailVerifyDidFailed()
            default:
                self?.addHODView?.showAlert(alert: GetDetailByPhoneEmailModel.message ?? "Something went wrong")
            }
            
        }, completionnilResponse: {[weak self] (nilResponseError) in
            
            self?.addHODView?.hideLoader()
//            self?.addHodDelegate?.phoneEmailVerifyDidFailed()
            
            if let error = nilResponseError{
                self?.addHODView?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "verifyPhoneAndEmail APi Nil response")
            }
            
        }) {[weak self] (error) in
            self?.addHODView?.hideLoader()
//            self?.addHodDelegate?.phoneEmailVerifyDidFailed()
            if let err = error?.localizedDescription{
                self?.addHODView?.showAlert(alert: err)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "verifyPhoneAndEmail APi error response")
            }
        }
        
    }
    
}

//MARK:- AddHOD Delegate
extension AddHODVC : AddHODDelegate{
    func PhoneEmailVerifyDidSuccess(data: GetDetailByPhoneEmailModel) {
        hodDetail = data
        if hodDetail?.message == KConstants.kHODExist{
            guard let userDetail = hodDetail?.resultData else {return}
            
            if let imgProfileUrl = userDetail.imageURL{
                imgViewProfileHOD.contentMode = .scaleAspectFill
                imgViewProfileHOD.sd_imageIndicator = SDWebImageActivityIndicator.gray
                imgViewProfileHOD.sd_setImage(with: URL(string: imgProfileUrl), placeholderImage: UIImage(named: kImages.kProfileImage))
            }else{
                imgViewProfileHOD.image = UIImage.init(named: kImages.kProfileImage)
            }
            
            if let dob = data.resultData?.dob{
                dateOfBirth = dob
                let date = CommonFunctions.sharedmanagerCommon.convertBackendDateFormatToLocalDate(serverSideDate: dob)
                txtFieldDOB.text = date
            }
            
            if let gender = userDetail.gender{
                
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
            
            txtFieldFirstName.text = userDetail.firstName
            txtFieldLastName.text = userDetail.lastName
            txtFieldAddress.text = userDetail.address
            
            if let imgIDproofUrl = userDetail.iDProof,imgIDproofUrl != ""{
                imgViewIdProof.sd_imageIndicator = SDWebImageActivityIndicator.gray
                selectedIdProofImageURL = URL(string: imgIDproofUrl)
                imgViewIdProof.contentMode = .scaleAspectFill
                imgViewIdProof.sd_setImage(with: URL(string: imgIDproofUrl), placeholderImage: UIImage(named: kImages.kAttachmentImage))
            }else{
                imgViewIdProof.contentMode = .center
                selectedIdProofImageURL = nil
                imgViewIdProof.image = UIImage.init(named: kImages.kAttachmentImage)
            }
            
            //When user did focus out then set the previous textfield then text of Phone/Email
            if selectedPreviousTextField == txtFieldPhoneNumber&&selectedPreviousTextField != txtFieldEmail{
                txtFieldEmail.text = userDetail.email
            }else if selectedPreviousTextField == txtFieldEmail && selectedPreviousTextField != txtFieldPhoneNumber{
                txtFieldPhoneNumber.text = userDetail.phoneNo
            }
            
            txtFieldAssignDepartment.text = userDetail.departmentName
            txtFieldQualification.text = userDetail.qualification
            txtFieldWorkExperience.text = userDetail.workExperience
            txtFieldAdditionalSkills.text = userDetail.additionalSkills
            txtFieldOthers.text = userDetail.others
            txtFieldIdProof.text = userDetail.iDProofTitle
            selectedDepartmentID = userDetail.departmentId
            hodID = userDetail.hodId
            userId = userDetail.userId
        }
    }
    
    func phoneEmailVerifyDidFailed() {
        hodID = 0
        userId = 0
    }
    
    //MARK:- Unathorized User
    func unauthorizedUser() {
        isUnauthorizedUser = true
    }
    func addUpdateHodDidSuccess(data: CommonSuccessResponseModel) {
        isHODAddUpdateSuccess = true
    }
    func getDepartmentdropdownDidSucceed(data: GetCommonDropdownModel) {
        departmentData = data
        if let count = data.resultData?.count{
            if count > 0 {
                UpdatePickerModel(count: departmentData?.resultData?.count ?? 0, sharedPickerDelegate: self, View: self.view)
            }else{
                print("Department Count is zero.")
            }
        }
    }
    func detailHODDidSucceed(data: HODDetailModel) {
        self.setDataInTextFields(data: data)
    }
}
//MARK:- UiTextField Delegates
extension AddHODVC : UITextFieldDelegate{
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        view.endEditing(true)
        //Validations for phone number and email student
            view.endEditing(true)
            if textField == txtFieldPhoneNumber {
                //When User start entering phone but less then 10 digits then this check is continue
                if txtFieldPhoneNumber.text?.count ?? 0 > 0 && txtFieldPhoneNumber.text?.count ?? 0 < 10 {
                    DispatchQueue.main.async {
                        self.resignAllTextfields(txtFieldArr: [self.txtFieldPhoneNumber,self.txtFieldEmail,self.txtFieldFirstName,self.txtFieldLastName,self.txtFieldAddress,self.txtFieldQualification,self.txtFieldWorkExperience,self.txtFieldAdditionalSkills,self.txtFieldOthers])

                    }
                    showAlert(alert: Alerts.kMinPhoneNumberCharacter)
                    return
                }else if txtFieldPhoneNumber.text?.count ?? 0 == 10{
                    selectedPreviousTextField = txtFieldPhoneNumber
                    viewModel?.verifyPhoneAndEmail(phoneNum: txtFieldPhoneNumber.text, email: txtFieldEmail.text)
                }
                //We are not handle here empty because Email Or Phone is optional
                
            }
            if textField == txtFieldEmail{
                if txtFieldEmail.text?.count ?? 0 > 0{
                    if let email = txtFieldEmail.text, !email.isValidEmail(){
                        DispatchQueue.main.async {
                            self.resignAllTextfields(txtFieldArr: [self.txtFieldPhoneNumber,self.txtFieldEmail,self.txtFieldFirstName,self.txtFieldLastName,self.txtFieldAddress,self.txtFieldQualification,self.txtFieldWorkExperience,self.txtFieldAdditionalSkills,self.txtFieldOthers])
                        }
                        self.showAlert(alert: Alerts.kInvalidEmail)
                        return
                    }else{
                        selectedPreviousTextField = txtFieldEmail
                        viewModel?.verifyPhoneAndEmail(phoneNum: txtFieldPhoneNumber.text, email: txtFieldEmail.text)
                    }
                }
            }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField == txtFieldFirstName || textField == txtFieldLastName
        {
            if let _  = string.rangeOfCharacter(from: NSCharacterSet.decimalDigits)
            {
               return false
            }
            else
            {
               return true
            }
        }
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool{
        return true
    }
    
    
}
//MARK:- Shared UIDatePicker Delegate
extension AddHODVC : SharedUIDatePickerDelegate{
    
    func doneButtonClicked(datePicker: UIDatePicker) {
        
        let strDate = CommonFunctions.sharedmanagerCommon.convertDateIntoStringWithDDMMYYYY(date: datePicker.date)
        print("String Converted Date:- \(strDate)")
        
        dateOfBirth = "\(datePicker.date)"
        
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

//MARK:- UIImagePickerView Delegate
extension AddHODVC:UIImagePickerDelegate
{
    func selectedImageUrl(url: URL) {
        if selectIdProof == false{
            selectedProfileImageUrl = url
        }else{
            selectedIdProofImageURL = url
        }
    }
    
    func SelectedMedia(image: UIImage?, videoURL: URL?)
    {
        if selectIdProof == false{
            self.imgViewProfileHOD.contentMode = .scaleAspectFill
            self.imgViewProfileHOD.image = image
        }else{
            self.imgViewIdProof.contentMode = .scaleAspectFill
            self.imgViewIdProof.image = image
        }
        
    }
    
}


//MARK:- Picker View Delegates
extension AddHODVC:SharedUIPickerDelegate
{
    func DoneBtnClicked() {
        
        if let count = departmentData.resultData?.count{
            if count > 0{
                
                if selectedDepartmentIndex == 0{
                    self.txtFieldAssignDepartment.text = self.departmentData?.resultData?[0].name
                    self.selectedDepartmentID = self.departmentData?.resultData?[0].id ?? 0
                }else{
                    self.txtFieldAssignDepartment.text = self.departmentData?.resultData?[selectedDepartmentIndex].name
                    self.selectedDepartmentID = self.departmentData?.resultData?[selectedDepartmentIndex].id ?? 0
                }
            }
        }
    }
    
    func GetTitleForRow(index: Int) -> String {
        
        if let count = departmentData.resultData?.count{
            if count > 0{
                txtFieldAssignDepartment.text = departmentData?.resultData?[0].name
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
                    self.txtFieldAssignDepartment.text = self.departmentData?.resultData?[index].name
                    self.selectedDepartmentID = self.departmentData?.resultData?[index].id ?? 0
                    self.selectedDepartmentIndex = index
                    print("Selected Department:- \(String(describing: self.departmentData?.resultData?[index].name))")
                }
            }
        }
    }
    
}
