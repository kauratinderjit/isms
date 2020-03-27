//
//  AddOtherFacultyPresenter.swift
//  DemoProjectScreens
//
//  Created by Taranjeet Singh on 6/5/19.
//  Copyright © 2019 Taranjeet Singh. All rights reserved.
//

import Foundation

protocol AddOtherFacultyDelegate: class {
    func AddOtherFacultyDataDidSucceed()
    func AddOtherFacultyDataDidFailed()
}

class AddOtherFacultyPresenter{
    
    //Weak object of Delegates
    weak var addOtherFacultyDelegates : AddOtherFacultyDelegate?
    
    //Weak Object of ViewDelegate
    weak var addOtherFacultyView : ViewDelegate?
    
    //Initialize the class with delegate
    init(delegate : AddOtherFacultyDelegate) {
        addOtherFacultyDelegates = delegate
    }
    
    //Attach View
    func attachView(viewDelegate : ViewDelegate){
        addOtherFacultyView = viewDelegate
    }
    
    //Deattach view
    func deattachView(){
        addOtherFacultyView = nil
        addOtherFacultyDelegates = nil
    }
    
    //Submit the add faculty detail
    func submitAddFacultyData(firstName: String?,lastName: String?,address: String?,dateOfBirth: String?,gender: String?,assignDepartment: String?,email:String?,phoneNumber: String?,idProof: String?,others: String?){
        
        do {
            try Validations(firstName: firstName,lastName: lastName,address: address,dateOfBirth: dateOfBirth,gender: gender,assignDepartment: assignDepartment,email:email,phoneNumber: phoneNumber,idProof: idProof,others: others)
            
            
            
        } catch let error {
    
            switch  error {
            
            case ValidationError.emptyFirstName:
                self.addOtherFacultyView?.showAlert(alert: Alerts.kEmptyFirstName)
            case ValidationError.emptyLastName:
                self.addOtherFacultyView?.showAlert(alert: Alerts.kEmptyLastName)

            case ValidationError.emptyAddress:
                self.addOtherFacultyView?.showAlert(alert: Alerts.kEmptyAddress)

            case ValidationError.emptyDateOfBith:
                self.addOtherFacultyView?.showAlert(alert: Alerts.kEmptyDOB)

            case ValidationError.emptyGender:
                self.addOtherFacultyView?.showAlert(alert: Alerts.kEmptyGender)

            case ValidationError.emptyAssignDepartment:                 self.addOtherFacultyView?.showAlert(alert: Alerts.kEmptyAssignDepartment)

            case ValidationError.emptyEmailAddress:                 self.addOtherFacultyView?.showAlert(alert: Alerts.kEmptyEmail)

            case ValidationError.invalidEmail:
                self.addOtherFacultyView?.showAlert(alert: Alerts.kInvalidEmail)

            case ValidationError.emptyPhoneNumber:
                self.addOtherFacultyView?.showAlert(alert: Alerts.kEmptyPhoneNumber)

            case ValidationError.minCharactersPhoneNumber:
                self.addOtherFacultyView?.showAlert(alert: Alerts.kMinPhoneNumberCharacter)

            case ValidationError.emptyIdProof:
                self.addOtherFacultyView?.showAlert(alert: Alerts.kEmptyIdProof)

            case ValidationError.emptyOthers:
                self.addOtherFacultyView?.showAlert(alert: Alerts.kEmptyOthers)

            default:
                break
                //                self.signUPView?.showAlert(alertMessage: SignUpStrings.Alerts.k_EmptyFirstName)
            }
            
            
        }
    
    }
    
    
    //Simple SignUp Validations
    func Validations(firstName: String?,lastName: String?,address: String?,dateOfBirth: String?,gender: String?,assignDepartment: String?,email:String?,phoneNumber: String?,idProof: String?,others: String?) throws
    {
        
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
        
        guard let assignDepartment = assignDepartment,!assignDepartment.isEmpty,!assignDepartment.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else{
            throw ValidationError.emptyAssignDepartment
        }
        
        
        guard let emailAddress  = email, !emailAddress.isEmpty, !emailAddress.trimmingCharacters(in: .whitespaces).isEmpty
            else
        {
            throw ValidationError.emptyEmailAddress
        }
        
        /*if(!emailAddress.isValidEmail())
        {
            throw ValidationError.invalidEmail
        }*/
        
        guard let phoneNumber  = phoneNumber, !phoneNumber.isEmpty, !phoneNumber.trimmingCharacters(in: .whitespaces).isEmpty else
        {
            throw ValidationError.emptyPhoneNumber
        }
        
        /*if phoneNumber.count < 10{
            throw ValidationError.minCharactersPhoneNumber
        }*/
        
        guard let idProof = idProof,!idProof.isEmpty,!idProof.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw ValidationError.emptyIdProof
        }
        
        guard let others = others,!others.isEmpty,!others.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else{
            throw ValidationError.emptyOthers
        }
        
    }
    
    
   
}
