//
//  AddStudentViewModel.swift
//  ISMS
//
//  Created by Taranjeet Singh on 6/7/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation

protocol AddStudentDelegate: class {
    func unauthorizedUser()
    func AddStudentDidSuccess(data: AddStudentModel)
    func AddStudentDidFailed()
    func PhoneEmailVerifyDidSuccess(data : VerifyEmailPhoneUserModel)
    func StudentDetailDidSuccess(Data: GetStudentDetail)
    func studentParentNotExist(isStudent : Bool)
    func getRelationdropdownDidSucceed(data: GetCommonDropdownModel)
    func PhoneEmailVerifyGardianDidSuccess(data : GetDetailByPhoneEmailGardianModel)
    func getDepartmentdropdownDidSucceed(data: [ResultData]?)
    func getClassdropdownDidSucceed(data: [ResultData]?)
}

class AddStudentViewModel{
    
    
    //Global ViewDelegate weak object
    private weak var addStudentView : ViewDelegate?
    
    //AddStudentDelegate weak object
    private weak var addStudentDelegate : AddStudentDelegate?
    
    //Initiallize the presenter class using delegates
    init(delegate: AddStudentDelegate) {
        addStudentDelegate = delegate
    }
    
    //Attach GlobalViewDelegate
    func attachView(viewDelegate : ViewDelegate){
        addStudentView = viewDelegate
    }
    
    //Deattach View for free the memory from instances
    func deattachView(){
        addStudentView = nil
        addStudentDelegate = nil
    }
    
    //MARK:- Add Student
    func addStudent(studentId:Int?,studentUserId: Int?,studentImg: URL?,firstName: String?,lastName: String?,address: String?,dateOfBirth: String?,gender: String?,rollNoOrAddmissionId: String?,email:String?,phoneNumber: String?,studentIdProof:URL?,others:String?,parentImg: URL?, parentFirstName: String?, parentLastName: String?,parentAddress: String?, parentDOB: String?,parentGender: String?,parentEmail: String?,parentPhoneNo: String?,parentIdProof:URL?,parentOthers: String?,relationID: Int?,studentIdProofTile: String?,parentIdProofTitle:String?,classId:Int?,guardianId: Int?,guardianUserId: Int?,idProofName: String?, parentIdProofName: String?){
        
        do {
            try validationsAddStudent(firstName: firstName,lastName: lastName,address: address,dateOfBirth: dateOfBirth,gender: gender,rollNoOrAddmissionId: rollNoOrAddmissionId,email:email,phoneNumber: phoneNumber,parentFirstName: parentFirstName, parentLastName: parentLastName,parentAddress: parentAddress, parentDOB: parentDOB,parentEmail: parentEmail,parentPhoneNo: parentPhoneNo,classId: classId, idProofName: idProofName, parentIdProofName: parentIdProofName,relationId:relationID)
            
            var paramDict = [String: Any]()
            
            
            paramDict[KApiParameters.AddStudentApi.studentImg] = studentImg ?? ""
            paramDict[KApiParameters.AddStudentApi.StudentId] = studentId ?? 0
            paramDict[KApiParameters.AddStudentApi.StudentRollNo] = rollNoOrAddmissionId ?? 0
            paramDict[KApiParameters.AddStudentApi.studentFirstName] = firstName ?? ""
            paramDict[KApiParameters.AddStudentApi.studentLastName] = lastName ?? ""
            paramDict[KApiParameters.AddStudentApi.Studentaddress] = address ?? ""
            paramDict[KApiParameters.AddStudentApi.studentDOB] = dateOfBirth ?? 0
            paramDict[KApiParameters.AddStudentApi.studentGender] = gender ?? ""
            paramDict[KApiParameters.AddStudentApi.studentEmail] = email
            paramDict[KApiParameters.AddStudentApi.studentPhoneNo] =  phoneNumber
            paramDict[KApiParameters.AddStudentApi.studentOthers] = others
            paramDict[KApiParameters.AddStudentApi.parentProfileImg] =  parentImg
            paramDict[KApiParameters.AddStudentApi.parentFirstName] = parentFirstName
            paramDict[KApiParameters.AddStudentApi.parentLastName] = parentLastName
            paramDict[KApiParameters.AddStudentApi.parentAddress] =  parentAddress
            paramDict[KApiParameters.AddStudentApi.parentDOB] =  parentDOB ?? 0
            paramDict[KApiParameters.AddStudentApi.parentGender] = parentGender
            paramDict[KApiParameters.AddStudentApi.parentEmail] = parentEmail
            paramDict[KApiParameters.AddStudentApi.parentPhoneNo] = parentPhoneNo
            paramDict[KApiParameters.AddStudentApi.parentOther] = parentOthers
            paramDict[KApiParameters.AddStudentApi.StudentUserId] =  studentUserId
            paramDict[KApiParameters.AddStudentApi.ClassIdb] = classId ?? 0
            paramDict[KApiParameters.AddStudentApi.GuardianId] = guardianId ?? 0
            paramDict[KApiParameters.AddStudentApi.GuardianUserId] = guardianUserId
            paramDict[KApiParameters.AddStudentApi.RelationId] = relationID
            paramDict[KApiParameters.AddStudentApi.SessionId] =  2
            paramDict[KApiParameters.AddStudentApi.studentIDProofTitle] =  studentIdProofTile ?? ""
            paramDict[KApiParameters.AddStudentApi.guardianIDProofTitle] = parentIdProofTitle ?? ""
            paramDict[KApiParameters.AddStudentApi.studentIDProof] = studentIdProof ?? ""
            paramDict[KApiParameters.AddStudentApi.guardianIDProof] = parentIdProof ?? ""
            paramDict["StudentRoleId"] = "5"
            paramDict["GuardianRoleId"] = "6"
            
            print("value of paramdict : ",paramDict)
            
            self.addStudentView?.showLoader()
            
            AdStudentApi.sharedInstance.addStudent(url: ApiEndpoints.KAddStudentApi, parameters: paramDict, completionResponse: { (responseModel) in
                print("update student: ",responseModel)
                
                self.addStudentView?.hideLoader()
                if responseModel.statusCode == KStatusCode.kStatusCode200{
                    self.addStudentView?.showAlert(alert: responseModel.message ?? "Something went wrong")
                    //                    if responseModel.resultData != nil{
                    self.addStudentDelegate?.AddStudentDidSuccess(data: responseModel)
                    //                    }
                }else if responseModel.statusCode == KStatusCode.kStatusCode401{
                    self.addStudentView?.hideLoader()
                    self.addStudentView?.showAlert(alert: responseModel.message ?? "")
                    self.addStudentDelegate?.unauthorizedUser()
                }else if responseModel.statusCode == KStatusCode.kStatusCode400{
                    self.addStudentView?.showAlert(alert: responseModel.message ?? "")
                }else{
                    self.addStudentView?.hideLoader()
                    self.addStudentView?.showAlert(alert: responseModel.message ?? "")
                }
                
                
                
            }, completionnilResponse: { (nilResponse) in
                self.addStudentView?.hideLoader()
                self.addStudentView?.showAlert(alert: nilResponse ?? Alerts.kMapperModelError)
            }) { (error) in
                self.addStudentView?.hideLoader()
                self.addStudentView?.showAlert(alert: error.debugDescription)
                
                
            }
        }
        catch let error {
            
            switch  error
            {
            case ValidationError.phoneOrEmailIsEmpty:
                self.addStudentView?.showAlert(alert: Alerts.kEmptyStudentPhoneNo)
                
            case ValidationError.emptyFirstName:
                self.addStudentView?.showAlert(alert: Alerts.kEmptyFirstName)
            case ValidationError.emptyLastName:
                self.addStudentView?.showAlert(alert: Alerts.kEmptyLastName)
                
            case ValidationError.emptyAddress:
                self.addStudentView?.showAlert(alert: Alerts.kEmptyAddress)
                
            case ValidationError.emptyDateOfBith:
                self.addStudentView?.showAlert(alert: Alerts.kEmptyDOB)
                
            case ValidationError.emptyGender:
                self.addStudentView?.showAlert(alert: Alerts.kEmptyGender)
                
            case ValidationError.emptyStudentClass:
                self.addStudentView?.showAlert(alert: Alerts.kEmptyClass)
                
            case ValidationError.emptyEmailAddress:
                self.addStudentView?.showAlert(alert: Alerts.kEmptyEmail)
                
            case ValidationError.invalidEmail:
                self.addStudentView?.showAlert(alert: Alerts.kInvalidEmail)
                
            case ValidationError.emptyPhoneNumber:
                self.addStudentView?.showAlert(alert: Alerts.kEmptyPhoneNumber)
                
            case ValidationError.minCharactersPhoneNumber:
                self.addStudentView?.showAlert(alert: Alerts.kMinPhoneNumberCharacter)
                
            case ValidationError.emptyRollNoAdmissionId:
                self.addStudentView?.showAlert(alert: Alerts.kEmptyRollNoAddmissionID)
                
            case ValidationError.emptyIDProofName:
                self.addStudentView?.showAlert(alert: Alerts.kEmptyIdProof)
                
            case ValidationError.emptyParentFirstName:
                self.addStudentView?.showAlert(alert: Alerts.kEmptyParentFName)
                
            case ValidationError.emptyParentLastName:
                self.addStudentView?.showAlert(alert: Alerts.kEmptyParentLName)
            case ValidationError.emptyParentAddress:
                self.addStudentView?.showAlert(alert: Alerts.kEmptyParentAddress)
                
            case ValidationError.emptyParentDOB:
                self.addStudentView?.showAlert(alert: Alerts.kEmptyParentDOB)
                
            case ValidationError.emptyParentEmail:
                self.addStudentView?.showAlert(alert: Alerts.kEmptyParentEmail)
                
            case ValidationError.emptyParentPhoneNo:
                self.addStudentView?.showAlert(alert: Alerts.kEmptyParentPhoneNo)
                
            case ValidationError.emptyParentprofId:
                self.addStudentView?.showAlert(alert: Alerts.kEmptyIdProof)
                
            case ValidationError.emptyClassId:
                self.addStudentView?.showAlert(alert: Alerts.kselectClass)
                
              case ValidationError.emptyRelation:
                self.addStudentView?.showAlert(alert: Alerts.kEmptyRelation)
            default:
                break
                //                self.signUPView?.showAlert(alertMessage: SignUpStrings.Alerts.k_EmptyFirstName)
            }
            
            
        }
    }
    
    
    //MARK:- Validations Add Student
    func validationsAddStudent(firstName: String?,lastName: String?,address: String?,dateOfBirth: String?,gender: String?,rollNoOrAddmissionId: String?,email:String?,phoneNumber: String?,parentFirstName: String?, parentLastName: String?,parentAddress: String?, parentDOB: String?,parentEmail: String?,parentPhoneNo: String?,classId: Int?,idProofName : String?,parentIdProofName : String?,relationId:Int?) throws
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
        
        guard let firstName = firstName,  !firstName.isEmpty, !firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else{
            throw ValidationError.emptyFirstName
        }
        
        guard let lastName  = lastName, !lastName.isEmpty, !lastName.trimmingCharacters(in: .whitespaces).isEmpty else{
            throw ValidationError.emptyLastName
        }
        
        guard let address = address,!address.isEmpty,!address.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            else{
                throw ValidationError.emptyAddress
        }
        guard let relationId = relationId,relationId != 0 else{
                     throw ValidationError.emptyRelation
             }
        guard let dob = dateOfBirth,!dob.isEmpty,!dob.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            else{
                throw ValidationError.emptyDateOfBith
        }
        
        guard let gender = gender,!gender.isEmpty,!gender.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else{
            throw ValidationError.emptyGender
        }
        
        guard let classId = classId,classId != 0 else{
            throw ValidationError.emptyClassId
        }
        
        guard let rollNoAddmissionId = rollNoOrAddmissionId,!rollNoAddmissionId.isEmpty,!rollNoAddmissionId.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw ValidationError.emptyRollNoAdmissionId
        }
        
        guard let idProofName  = idProofName, !idProofName.isEmpty, !idProofName.trimmingCharacters(in: .whitespaces).isEmpty else{
            throw ValidationError.emptyIDProofName
        }
        
        
        
        //Optional Fields Validation
        if parentEmail == nil&&parentPhoneNo == nil||parentEmail == ""&&parentPhoneNo == ""{
            throw ValidationError.emptyParentPhoneNo
        }else{
            if let emailAdd = parentEmail,!emailAdd.isEmpty,!emailAdd.trimmingCharacters(in: .whitespaces).isEmpty&&parentPhoneNo == "",!emailAdd.isValidEmail(){
                //                if !emailAdd.isValidEmail(){
                throw ValidationError.invalidEmail
                //                }
            }else if let phNo = parentPhoneNo,!phNo.isEmpty,!phNo.trimmingCharacters(in: .whitespaces).isEmpty&&parentEmail == ""{
                if phNo.count < 10{
                    throw ValidationError.minCharactersPhoneNumber
                }
            }else if let phNo = parentPhoneNo,!phNo.isEmpty,!phNo.trimmingCharacters(in: .whitespaces).isEmpty,let emailAdd = parentEmail,!emailAdd.isEmpty,!emailAdd.trimmingCharacters(in: .whitespaces).isEmpty{
                if phNo.count < 10{
                    throw ValidationError.minCharactersPhoneNumber
                }
                else if !emailAdd.isValidEmail(){
                    throw ValidationError.invalidEmail
                }
            }
        }
        
        guard let parentFirstName  = parentFirstName, !parentFirstName.isEmpty, !parentFirstName.trimmingCharacters(in: .whitespaces).isEmpty
            else{
                throw ValidationError.emptyParentFirstName
        }
        
        guard let parentLastName  = parentLastName, !parentLastName.isEmpty, !parentLastName.trimmingCharacters(in: .whitespaces).isEmpty
            else{
                throw ValidationError.emptyParentLastName
        }
        
        guard let parentAddress  = parentAddress, !parentAddress.isEmpty, !parentAddress.trimmingCharacters(in: .whitespaces).isEmpty
            else{
                throw ValidationError.emptyParentAddress
        }
        
        guard let parentDOB  = parentDOB, !parentDOB.isEmpty, !parentDOB.trimmingCharacters(in: .whitespaces).isEmpty
            else{
                throw ValidationError.emptyParentDOB
        }
        
        guard let parentIdProofName  = parentIdProofName, !parentIdProofName.isEmpty, !parentIdProofName.trimmingCharacters(in: .whitespaces).isEmpty else{
            throw ValidationError.emptyParentprofId
        }
        /*guard let others = others,!others.isEmpty,!others.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else{
         throw ValidationError.emptyOthers
         }*/
        
    }
    
    //Hit Api for Student
    func verifyPhoneAndEmail(phoneNum: String?, email: String?){
        
        self.addStudentView?.showLoader()
        
        let paramDict = [KApiParameters.AddStudentApi.StudentPhone: phoneNum ?? "",KApiParameters.AddStudentApi.StudentEmail:email ?? ""] as [String : Any]
        debugPrint("Parameters of student:- \(paramDict)")
        AdStudentApi.sharedInstance.PhoneEmailVerify(url: ApiEndpoints.KStudentPhoneEmailVerifyApi, parameters: paramDict as [String : Any], completionResponse: {[weak self] (VerifyEmailPhoneUserModel) in
            self?.addStudentView?.hideLoader()
            switch VerifyEmailPhoneUserModel.statusCode{
            case KStatusCode.kStatusCode302:
                //                self.addStudentView?.hideLoader()
                self?.addStudentDelegate?.PhoneEmailVerifyDidSuccess(data : VerifyEmailPhoneUserModel)
            case KStatusCode.kStatusCode401:
                //                self.addStudentView?.hideLoader()
                self?.addStudentView?.showAlert(alert: VerifyEmailPhoneUserModel.message ?? "Something went wrong[")
                self?.addStudentDelegate?.unauthorizedUser()
            case KStatusCode.kStatusCode404:
                self?.addStudentDelegate?.studentParentNotExist(isStudent: true)
            case KStatusCode.kStatusCode409:
                self?.addStudentView?.showAlert(alert: VerifyEmailPhoneUserModel.message ?? "Something went wrong")
            default:
                CommonFunctions.sharedmanagerCommon.println(object: "verifyPhoneAndEmail APi status change")
                break
            }
            
            }, completionnilResponse: {[weak self] (nilResponseError) in
                
                self?.addStudentView?.hideLoader()
                if let error = nilResponseError{
                    self?.addStudentView?.showAlert(alert: error)
                    
                }else{
                    CommonFunctions.sharedmanagerCommon.println(object: "verifyPhoneAndEmail Student APi Nil response")
                }
                
        }) {[weak self] (error) in
            self?.addStudentView?.hideLoader()
            if let err = error?.localizedDescription{
                self?.addStudentView?.showAlert(alert: err)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "verifyPhoneAndEmail Student APi error response")
            }
        }
        
    }
    
    func verifyPhoneAndEmailGardian(phoneNum: String?, email: String?){
        self.addStudentView?.showLoader()
        
        let paramDict = [KApiParameters.KGetDetailByPhoneEmail.kPhone: phoneNum ?? "",KApiParameters.KGetDetailByPhoneEmail.kEmail:email ?? ""] as [String : Any]
        debugPrint("Parameters of guardian:- \(paramDict)")
        AdStudentApi.sharedInstance.PhoneEmailVerifyGardian(url: ApiEndpoints.KGardianPhoneEmailVerifyApi, parameters: paramDict as [String : Any], completionResponse: { [weak self](GetDetailByPhoneEmailGardianModel) in
            self?.addStudentView?.hideLoader()
            
            switch GetDetailByPhoneEmailGardianModel.statusCode{

                case KStatusCode.kStatusCode302:
//                    self.addStudentView?.hideLoader()
                    self?.addStudentDelegate?.PhoneEmailVerifyGardianDidSuccess(data : GetDetailByPhoneEmailGardianModel)
                case KStatusCode.kStatusCode401:
                    self?.addStudentView?.showAlert(alert: GetDetailByPhoneEmailGardianModel.message ?? "")
                    self?.addStudentDelegate?.unauthorizedUser()
                case KStatusCode.kStatusCode404:
                    self?.addStudentDelegate?.studentParentNotExist(isStudent: false)
                case KStatusCode.kStatusCode409:
                self?.addStudentView?.showAlert(alert: GetDetailByPhoneEmailGardianModel.message ?? "Something went wrong")
            default:
                CommonFunctions.sharedmanagerCommon.println(object: "verifyPhoneAndEmailGardian APi status change")
                break
            }
            
            }, completionnilResponse: { (nilResponseError) in
                
                self.addStudentView?.hideLoader()
                
                if let error = nilResponseError{
                    self.addStudentView?.showAlert(alert: error)
                    
                }else{
                    CommonFunctions.sharedmanagerCommon.println(object: "verifyPhoneAndEmailGardian APi Nil response")
                }
                
        }) { (error) in
            self.addStudentView?.hideLoader()
            if let err = error?.localizedDescription{
                self.addStudentView?.showAlert(alert: err)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "verifyPhoneAndEmailGardian APi error response")
            }
        }
        
    }
    
    func getStudentDetail(enrollmentId: Int?){
        self.addStudentView?.showLoader()
        print("abc: ",enrollmentId ?? "")
        
        AdStudentApi.sharedInstance.getStudentDetail(url: ApiEndpoints.KStudentDetailApi + "\(enrollmentId ?? 0)", parameters: nil, completionResponse: {[weak self] (GetStudentDetail) in
            if GetStudentDetail.statusCode == KStatusCode.kStatusCode200{
                self?.addStudentView?.hideLoader()
                //                self?.addStudentView?.showAlert(alert: GetStudentDetail.message ?? "")
                self?.addStudentDelegate?.StudentDetailDidSuccess(Data: GetStudentDetail)
            }else if GetStudentDetail.statusCode == KStatusCode.kStatusCode401{
                self?.addStudentView?.hideLoader()
                self?.addStudentView?.showAlert(alert: GetStudentDetail.message ?? "")
                self?.addStudentDelegate?.unauthorizedUser()
            }else{
                self?.addStudentView?.hideLoader()
                self?.addStudentView?.showAlert(alert: GetStudentDetail.message ?? "Something went wrong")
                CommonFunctions.sharedmanagerCommon.println(object: "student APi status change")
            }
             
            }, completionnilResponse: { (nilResponseError) in
                
                self.addStudentView?.hideLoader()
                
                if let error = nilResponseError{
                    self.addStudentView?.showAlert(alert: error)
                    
                }else{
                    CommonFunctions.sharedmanagerCommon.println(object: "student APi Nil response")
                }
                
        }) { (error) in
            self.addStudentView?.hideLoader()
            if let err = error?.localizedDescription{
                self.addStudentView?.showAlert(alert: err)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "student APi error response")
            }
        }
        
    }
    
    func getRelationId(id: Int?, enumtype: Int?){
        guard let selectId = id else{ return }
        guard let enumType = enumtype else { return }
        //        self.addStudentView?.showLoader()
        
        AdStudentApi.sharedInstance.getClassDropdownData(id: selectId, enumType: enumType, completionResponse: {[weak self] (responseModel) in
            //            self?.addStudentView?.hideLoader()
            self?.addStudentDelegate?.getRelationdropdownDidSucceed(data: responseModel)
            
            }, completionnilResponse: {[weak self] (nilResponse) in
                //            self?.addStudentView?.hideLoader()
                if let nilRes = nilResponse{
                    self?.addStudentView?.showAlert(alert: nilRes)
                }
        }) {[weak self] (error) in
            //            self?.addStudentView?.hideLoader()
            if let err = error{
                self?.addStudentView?.showAlert(alert: err.localizedDescription)
            }
        }
    }
    func getDepartmentId(id: Int?, enumtype: Int?)
    {
        guard let selectId = id else{ return }
        guard let enumType = enumtype else { return }
        
        //        self.addStudentView?.showLoader()
        
        AdStudentApi.sharedInstance.getDepartmentDropdownData(id: selectId, enumType: enumType, completionResponse: { (responseModel) in
            //            self.addStudentView?.hideLoader()
            self.addStudentDelegate?.getDepartmentdropdownDidSucceed(data: responseModel.resultData)
            
            
            
        }, completionnilResponse: { (nilResponse) in
            //            self.addStudentView?.hideLoader()
            if let nilRes = nilResponse{
                self.addStudentView?.showAlert(alert: nilRes)
            }
        }) { (error) in
            //            self.addStudentView?.hideLoader()
            if let err = error{
                self.addStudentView?.showAlert(alert: err.localizedDescription)
            }
        }
    }
    
    func getClassId(id: Int?, enumtype: Int?){
        guard let selectId = id else{ return }
        guard let enumType = enumtype else { return }
        
        self.addStudentView?.showLoader()
        
        AdStudentApi.sharedInstance.getDepartmentDropdownData(id: selectId, enumType: enumType, completionResponse: { (responseModel) in
            
            if responseModel.statusCode == 200{
                self.addStudentView?.hideLoader()
                self.addStudentDelegate?.getClassdropdownDidSucceed(data: responseModel.resultData)
            }else{
                self.addStudentView?.hideLoader()
                
            }
            
            
            
            
            
        }, completionnilResponse: { (nilResponse) in
            self.addStudentView?.hideLoader()
            if let nilRes = nilResponse{
                self.addStudentView?.showAlert(alert: nilRes)
            }
        }) { (error) in
            self.addStudentView?.hideLoader()
            if let err = error{
                self.addStudentView?.showAlert(alert: err.localizedDescription)
            }
        }
    }
}
