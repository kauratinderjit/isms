//
//  AddTeacherPresenter.swift
//  ISMS
//
//  Created by Taranjeet Singh on 6/7/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation

protocol AddTeacherDelegate: class {
    func unauthorizedUser()
    func addUpdateTeacherDidSuccess(data : CommonSuccessResponseModel)
    func detailTeacherDidSucceed(data : TeacherDetailModel)
    func getAssignHODdropdownDidSucceed(data : GetCommonDropdownModel)
    func getTeacherDetailFailed()
}


class AddTeacherViewModel{
    
 
    //Global ViewDelegate weak object
    private weak var addTeacherView : ViewDelegate?
    
    //AddTeacherDelegate weak object
    private weak var addTeacherDelegate : AddTeacherDelegate?

    //Initiallize the presenter class using delegates
    init(delegate: AddTeacherDelegate) {
        addTeacherDelegate = delegate
    }
    
    //Attach GlobalViewDelegate
    func attachView(viewDelegate : ViewDelegate){
        addTeacherView = viewDelegate
    }
    
    //Deattach View for free the memory from instances
    func deattachView(){
        addTeacherView = nil
        addTeacherDelegate = nil
    }
    
    //MARK:- Add/Update Teacher
    func addUpdateTeacher(teacherId:Int?,profileImageUrl:URL?,firstName: String?,lastName: String?,address: String?,dateOfBirth: String?,others: String?,gender: String?,email:String?,phoneNumber: String?,idProofImgUrl: URL?,idProofName : String?,assignDepartmentId : String?,qualification: String?,workExperience: String?,additionalSkills:String?,userID: Int?){
        do {
            try validationsAddTeacher(teacherId:teacherId,profileImageUrl:profileImageUrl,firstName: firstName,lastName: lastName,address: address,dateOfBirth: dateOfBirth,others: others,gender: gender,email:email,phoneNumber: phoneNumber,idProofImgUrl: idProofImgUrl,idProofName : idProofName,assignDepartmentId : assignDepartmentId, qualification: qualification,workExperience: workExperience,additionalSkills:additionalSkills,userID: userID)
            self.addTeacherView?.showLoader()
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
            postDict[KApiParameters.KAddTeacherApiParameters.kTeacherId] = teacherId ?? 0
            postDict[KApiParameters.KAddTeacherApiParameters.kImageUrl] = profileImageUrl ?? ""
            postDict[KApiParameters.KAddTeacherApiParameters.kFirstName] = firstName ?? ""
            postDict[KApiParameters.KAddTeacherApiParameters.kLastName] = lastName ?? ""
            postDict[KApiParameters.KAddTeacherApiParameters.kAddress] = address ?? ""
            postDict[KApiParameters.KAddTeacherApiParameters.kDOB] = dateOfBirth ?? ""
            postDict[KApiParameters.KAddTeacherApiParameters.kGender] = gender ?? ""
            postDict[KApiParameters.KAddTeacherApiParameters.kEmail] = email ?? ""
            postDict[KApiParameters.KAddTeacherApiParameters.kPhoneNo] = phoneNumber ?? ""
            postDict[KApiParameters.KAddTeacherApiParameters.kIDProof] = idProofImgUrl ?? ""
            postDict[KApiParameters.KAddTeacherApiParameters.kIDProofTitle] = idProofName ?? ""
            postDict[KApiParameters.KAddTeacherApiParameters.kQualification] = qualification ?? ""
            postDict[KApiParameters.KAddTeacherApiParameters.kWorkExperience] = workExperience ?? ""
            postDict[KApiParameters.KAddTeacherApiParameters.kAdditionalSkills] = addSkills ?? ""
            postDict[KApiParameters.KAddTeacherApiParameters.kOthers] = othrs ?? ""
            postDict[KApiParameters.KAddTeacherApiParameters.kStrDepartmentId] = assignDepartmentId ?? ""
            
            TeacherApi.sharedManager.addUpdateTeacher(url: ApiEndpoints.kAddTeacher, parameters: postDict, completionResponse: { (responseModel) in
                self.addTeacherView?.hideLoader()
                CommonFunctions.sharedmanagerCommon.println(object: "Response Model of addUpdateTeacher:- \(responseModel) ")
                self.addTeacherView?.hideLoader()
                switch responseModel.statusCode{
                case KStatusCode.kStatusCode200:
                    self.addTeacherView?.showAlert(alert: responseModel.message ?? "")
                    self.addTeacherDelegate?.addUpdateTeacherDidSuccess(data: responseModel)
                case KStatusCode.kStatusCode401:
                    self.addTeacherView?.showAlert(alert: responseModel.message ?? "")
                    self.addTeacherDelegate?.unauthorizedUser()
                default:
                    self.addTeacherView?.showAlert(alert: responseModel.message ?? "")
                }
                
            }, completionnilResponse: { (nilResponse) in
                self.addTeacherView?.hideLoader()
                self.addTeacherView?.showAlert(alert: nilResponse ?? Alerts.kMapperModelError)
            }) { (error) in
                self.addTeacherView?.hideLoader()
                self.addTeacherView?.showAlert(alert: error?.localizedDescription ?? Alerts.kMapperModelError)
            }
        } catch let error {
            switch  error {
            case ValidationError.emptyFirstName:
                addTeacherView?.showAlert(alert: Alerts.kEmptyFirstName)
            case ValidationError.emptyLastName:
                addTeacherView?.showAlert(alert: Alerts.kEmptyLastName)
            case ValidationError.emptyAddress:
                addTeacherView?.showAlert(alert: Alerts.kEmptyAddress)
            case ValidationError.emptyDateOfBith:
                addTeacherView?.showAlert(alert: Alerts.kEmptyDOB)
            case ValidationError.emptyGender:
                addTeacherView?.showAlert(alert: Alerts.kEmptyGender)
            case ValidationError.emptyEmailAddress:
                addTeacherView?.showAlert(alert: Alerts.kEmptyEmail)
            case ValidationError.invalidEmail:
                addTeacherView?.showAlert(alert: Alerts.kInvalidEmail)
            case ValidationError.phoneOrEmailIsEmpty:
                addTeacherView?.showAlert(alert: "Please enter atleast Phone number or email.")
            case ValidationError.emptyPhoneNumber:
                addTeacherView?.showAlert(alert: Alerts.kEmptyPhoneNumber)
            case ValidationError.emptyIDProofName:
                addTeacherView?.showAlert(alert: Alerts.kEmptyIdProof)
            case ValidationError.emptyIdProofImage:
                addTeacherView?.showAlert(alert: Alerts.kSelectIdProofImage)
            case ValidationError.emptyDepartmentID:
                addTeacherView?.showAlert(alert: Alerts.kEmptyAssignDepartment)
                
            case ValidationError.emptyWorkExperience:
                addTeacherView?.showAlert(alert: Alerts.kEmptyWorkExperience)
            case ValidationError.minCharactersPhoneNumber:
                addTeacherView?.showAlert(alert: Alerts.kMinPhoneNumberCharacter)
                
            case ValidationError.emptyQualification:
                addTeacherView?.showAlert(alert: Alerts.kEmptyQualifications)
                
            default:
                break
            }
        }
    }
    
    
    //MARK:- Validations Add Teacher
    func validationsAddTeacher(teacherId:Int?,profileImageUrl:URL?,firstName: String?,lastName: String?,address: String?,dateOfBirth: String?,others: String?,gender: String?,email:String?,phoneNumber: String?,idProofImgUrl: URL?,idProofName : String?,assignDepartmentId : String?,qualification: String?,workExperience: String?,additionalSkills:String?,userID: Int?) throws
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
        
        
        /*guard let emailAddress  = email, !emailAddress.isEmpty, !emailAddress.trimmingCharacters(in: .whitespaces).isEmpty
            else{
            throw ValidationError.emptyEmailAddress
        }
        if(!emailAddress.isValidEmail()){
         throw ValidationError.invalidEmail
        }
        guard let phoneNumber  = phoneNumber, !phoneNumber.isEmpty, !phoneNumber.trimmingCharacters(in: .whitespaces).isEmpty else{
            throw ValidationError.emptyPhoneNumber
        }
        if phoneNumber.count < 10||phoneNumber.count > 12{
            throw ValidationError.minCharactersPhoneNumber
        }*/
        guard let idProofName  = idProofName, !idProofName.isEmpty, !idProofName.trimmingCharacters(in: .whitespaces).isEmpty else{
            throw ValidationError.emptyIDProofName
        }
        if teacherId == 0{
            guard let idProofImgUrl  = idProofImgUrl?.absoluteString,!idProofImgUrl.isEmpty , !idProofImgUrl.trimmingCharacters(in: .whitespaces).isEmpty
                else{
                throw ValidationError.emptyIdProofImage
            }
        }
        
        
        guard let departmentID = assignDepartmentId,!departmentID.isEmpty,!departmentID.trimmingCharacters(in: .whitespaces).isEmpty else{
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
//            else{
//            throw ValidationError.emptyQualification
//        }
//        guard let workExperience  = workExperience, !workExperience.isEmpty, !workExperience.trimmingCharacters(in: .whitespaces).isEmpty
//            else{
//            throw ValidationError.emptyWorkExperience
//        }
    }
    
    //MARk:- Get Departments dropdown data
    func getAssignDepartmentDropdown(selectedDepartmentId: Int?,enumtype: Int?){
        
        guard let selectId = selectedDepartmentId else{ return }
        guard let enumType = enumtype else { return }
        
        self.addTeacherView?.showLoader()
        
        TeacherApi.sharedManager.getAssignDepartmentDropdownList(selectedDepartmentId: selectId, enumType: enumType, completionResponse: { (responseModel) in
            
            self.addTeacherDelegate?.getAssignHODdropdownDidSucceed(data : responseModel)
            self.addTeacherView?.hideLoader()
            
            
        }, completionnilResponse: { (nilResponse) in
            self.addTeacherView?.hideLoader()
            if let nilRes = nilResponse{
                self.addTeacherView?.showAlert(alert: nilRes)
            }
        }) { (error) in
            self.addTeacherView?.hideLoader()
            if let err = error{
                self.addTeacherView?.showAlert(alert: err.localizedDescription)
            }
        }
    }
    
    
    //MARK:- Teacher Detail
    func getTeacherDetail(teacherId : Int){
        
        let getUrl = ApiEndpoints.kGetTeacherDetail + "?teacherId=\(teacherId)"
        
        self.addTeacherView?.showLoader()
        TeacherApi.sharedManager.getTeacherDetail(url: getUrl, completionResponse: { (teacherDetailresponse) in
            
            self.addTeacherView?.hideLoader()
            switch teacherDetailresponse.statusCode{
            case KStatusCode.kStatusCode200:
                self.addTeacherDelegate?.detailTeacherDidSucceed(data: teacherDetailresponse)
            case KStatusCode.kStatusCode401:
                self.addTeacherView?.showAlert(alert: teacherDetailresponse.message ?? "")
                self.addTeacherDelegate?.unauthorizedUser()
            default :
                CommonFunctions.sharedmanagerCommon.println(object: "default in detail")
                self.addTeacherView?.showAlert(alert: teacherDetailresponse.message ?? "Status Code is change.")
            }
            
        }, completionnilResponse: { (error) in
            self.addTeacherView?.hideLoader()
            self.addTeacherView?.showAlert(alert: error ?? "Something went wrong")
        }) { (error) in
            self.addTeacherView?.hideLoader()
            self.addTeacherView?.showAlert(alert: error?.localizedDescription ?? "Something went wrong")
        }
    }
    
    //MARK:- Get Teacher Detail By Phone Email
    func getTeacherDetailByPhoneEmail(phone: String?,email: String?){
        var postdict = [String:Any]()
        postdict[KApiParameters.KGetDetailByPhoneEmail.kPhone] = phone
        postdict[KApiParameters.KGetDetailByPhoneEmail.kEmail] = email
        
        self.addTeacherView?.showLoader()
        print("params teacher: ",postdict)
        TeacherApi.sharedManager.getTeacherDetailPhoneEmail(url: ApiEndpoints.kTeacherDetailByPhoneEmail, parameters: postdict, completionResponse: { (responseTeacherModel) in
            self.addTeacherView?.hideLoader()

            switch responseTeacherModel.statusCode{
            case KStatusCode.kStatusCode200:
                print("response: ",responseTeacherModel.resultData)
                break
//                CommonFunctions.sharedmanagerCommon.println(object: responseTeacherModel.message ?? "Something went wrong")
            case KStatusCode.kStatusCode302:
                self.addTeacherDelegate?.detailTeacherDidSucceed(data: responseTeacherModel)
            case KStatusCode.kStatusCode401:
                self.addTeacherDelegate?.unauthorizedUser()
            case KStatusCode.kStatusCode404:
               // self.addTeacherView?.showAlert(alert: responseTeacherModel.message ?? "Something went wrong.")
                self.addTeacherDelegate?.getTeacherDetailFailed()

                case KStatusCode.kStatusCode409:
                 self.addTeacherView?.showAlert(alert: responseTeacherModel.message ?? "Something went wrong.")
                self.addTeacherDelegate?.getTeacherDetailFailed()
                CommonFunctions.sharedmanagerCommon.println(object: responseTeacherModel.message ?? "")
            default:
                self.addTeacherView?.showAlert(alert: responseTeacherModel.message ?? "Something went wrong.")
            }
            
        }, completionnilResponse: { (nilResponseError) in
            self.addTeacherView?.showAlert(alert: nilResponseError ?? "Something went wrong.")
        }) { (error) in
            self.addTeacherView?.showAlert(alert: error?.localizedDescription ?? "")
        }
    }
}

//MARK:- AddTeacher Delegate
extension AddTeacherVC : AddTeacherDelegate{
    func getTeacherDetailFailed() {
        teacherID = 0
        teacherUserId = 0
    }
    
    //MARK:- Unathorized User
    func unauthorizedUser() {
        isUnauthorizedUser = true
    }
    
    //MARK:- Add/Update Teacher Success
    func addUpdateTeacherDidSuccess(data: CommonSuccessResponseModel) {
        isTeacherAddUpdateSuccess = true
    }
    
    func detailTeacherDidSucceed(data: TeacherDetailModel) {
        self.setDataInTextFields(data: data)
    }
    
    func getAssignHODdropdownDidSucceed(data: GetCommonDropdownModel) {
        assignDepartmentData = data
        if let count = data.resultData?.count{
            if count > 0 {
                tblViewpopUp.isHidden = false
                tblViewpopUp.tblView.reloadData()
            }else{
                print("Assign Hod Count is zero.")
            }
        }
    }
}

//MARK:- Shared UIDatePicker Delegate
extension AddTeacherVC : SharedUIDatePickerDelegate{
    func doneButtonClicked(datePicker: UIDatePicker) {
        let strDate = CommonFunctions.sharedmanagerCommon.convertDateIntoStringWithDDMMYYYY(date: datePicker.date)
        dateOfBirth = "\(datePicker.date)"
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

//MARK:- UIImagePickerView Delegate
extension AddTeacherVC:UIImagePickerDelegate{
    
    func selectedImageUrl(url: URL) {
        if selectIdProof == false{
            selectedProfileImageUrl = url
        }else{
            selectedIdProofImageURL = url
        }
    }
    
    func SelectedMedia(image: UIImage?, videoURL: URL?){
        if selectIdProof == false{
            self.imgViewTeacher.contentMode = .scaleAspectFill
            self.imgViewTeacher.image = image
        }else{
            self.imgViewIdProof.contentMode = .scaleAspectFill
            self.imgViewIdProof.image = image
        }
    }
}

extension AddTeacherVC : UITextFieldDelegate{
    /*func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
//        case txtFieldPhoneNumber:
//            txtFieldEmail.becomeFirstResponder()
        case txtFieldEmail:
            txtFieldFirstName.becomeFirstResponder()
        case txtFieldFirstName:
            txtFieldLastName.becomeFirstResponder()
        case txtFieldLastName:
            txtFieldAddress.becomeFirstResponder()
        case txtFieldAddress:
            txtFieldIdProofName.becomeFirstResponder()
        case txtFieldIdProofName:
            txtFieldQualification.becomeFirstResponder()
        case txtFieldQualification:
            txtFieldWorkExperience.becomeFirstResponder()
        case txtFieldWorkExperience:
            txtFieldAdditionalSkills.becomeFirstResponder()
        case txtFieldAdditionalSkills:
            txtFieldOthers.resignFirstResponder()
        default: break
        }
        return true
    }*/
   
//
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//
//        switch textField {
//        case txtFieldEmail:
//            if txtFieldPhoneNumber.text?.count ?? 0 > 0{
//                txtFieldPhoneNumber.resignFirstResponder()
//                txtFieldEmail.resignFirstResponder()
//            }
//            break
//        case txtFieldFirstName:
//            if txtFieldEmail.text?.count ?? 0 > 0{
//                txtFieldEmail.resignFirstResponder()
//                txtFieldFirstName.resignFirstResponder()
//            }
//            break
//        default:
//            break
//        }
//
//        return true
//    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let rawString = string
        let range = rawString.rangeOfCharacter(from: .whitespaces)
        
        if ((textField.text?.count)! == 0 && range  != nil)
        || ((textField.text?.count)! > 0 && textField.text?.last  == " " && range != nil)
        {
            return false
        }
        return true
    }
    
     
    func textFieldDidEndEditing(_ textField: UITextField) {
        view.endEditing(true)
        
        if textField == txtFieldPhoneNumber {
            //When User start entering phone but less then 10 digits then this check is continue
            if txtFieldPhoneNumber.text?.count ?? 0 > 0 && txtFieldPhoneNumber.text?.count ?? 0 < 10 {
                DispatchQueue.main.async {
                   self.resignAllTextfields(txtFieldArr: [self.txtFieldEmail,self.txtFieldFirstName,self.txtFieldLastName,self.txtFieldAddress,self.txtFieldIdProofName,self.txtFieldQualification,self.txtFieldWorkExperience,self.txtFieldAdditionalSkills,self.txtFieldOthers])
                    
                }
                showAlert(alert: Alerts.kMinPhoneNumberCharacter)
                return
            }else if txtFieldPhoneNumber.text?.count ?? 0 == 10{
                selectedPreviousTextField = txtFieldPhoneNumber
                self.viewModel?.getTeacherDetailByPhoneEmail(phone: txtFieldPhoneNumber.text, email: txtFieldEmail.text)
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
                    self.viewModel?.getTeacherDetailByPhoneEmail(phone: txtFieldPhoneNumber.text, email: txtFieldEmail.text)
                }
            }
        }
    }
    
}
