//
//  AddParentPresenter.swift
//  ISMS
//
//  Created by Taranjeet Singh on 6/12/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation


protocol AddParentDelegate: class {
    
    func AddParentDidSuccess()
    func AddParentDidFailed()
    
    
}

class AddParentPresenter{
    
    //Global ViewDelegate weak object
    private weak var addParentView : ViewDelegate?
    
    //AddTeacherDelegate weak object
    private weak var addParentDelegate : AddParentDelegate?
    
    //Initiallize the presenter class using delegates
    init(delegate: AddParentDelegate) {
        addParentDelegate = delegate
    }
    
    //Attach GlobalViewDelegate
    func attachView(viewDelegate : ViewDelegate){
        addParentView = viewDelegate
    }
    
    //Deattach View for free the memory from instances
    func deattachView(){
        addParentView = nil
        addParentDelegate = nil
    }
    
    //MARK:- Add Parent
    func addParent(firstName: String?, lastName: String?,relation: String?, address: String?, dateOfBirth: String?, gender: String?, email: String?, idProof: String?, phoneNumber: String?, others: String?){
        
        
        do {
            try validationsAddParent(firstName: firstName, lastName: lastName, relation: relation, address: address, dateOfBirth: dateOfBirth, gender: gender, email: email, idProof: idProof, phoneNumber: phoneNumber, others: others)
            
            
            
        } catch let error {
            
            switch  error {
                
            case ValidationError.emptyFirstName:
                addParentView?.showAlert(alert: Alerts.kEmptyFirstName)
                
            case ValidationError.emptyLastName:
                addParentView?.showAlert(alert: Alerts.kEmptyLastName)
                
            case ValidationError.emptyAddress:
                addParentView?.showAlert(alert: Alerts.kEmptyAddress)
                
            case ValidationError.emptyDateOfBith:
                addParentView?.showAlert(alert: Alerts.kEmptyDOB)
                
            case ValidationError.emptyGender:
                addParentView?.showAlert(alert: Alerts.kEmptyGender)
                
            case ValidationError.emptyIdProof:
                addParentView?.showAlert(alert: Alerts.kEmptyIdProof)
      
            case ValidationError.invalidEmail:
                addParentView?.showAlert(alert: Alerts.kInvalidEmail)
                
            case ValidationError.emptyPhoneNumber:
                addParentView?.showAlert(alert: Alerts.kEmptyPhoneNumber)
                
            case ValidationError.minCharactersPhoneNumber:
                addParentView?.showAlert(alert: Alerts.kMinPhoneNumberCharacter)

            case ValidationError.emptyRelation:
                addParentView?.showAlert(alert: Alerts.kEmptyRelation)
                
            default:
                break
                //                self.signUPView?.showAlert(alertMessage: SignUpStrings.Alerts.k_EmptyFirstName)
            }
            
            
        }
        
        
        
        
        
    }
    
    
    //MARK:- Validations Add Parent
    func validationsAddParent(firstName: String?, lastName: String?,relation: String?, address: String?, dateOfBirth: String?, gender: String?, email: String?, idProof: String?, phoneNumber: String?, others: String?) throws
    {
        
        guard let firstName = firstName,  !firstName.isEmpty, !firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else
        {
            throw ValidationError.emptyFirstName
        }
        
        guard let lastName  = lastName, !lastName.isEmpty, !lastName.trimmingCharacters(in: .whitespaces).isEmpty else
        {
            throw ValidationError.emptyLastName
        }
        
        guard let relation  = relation, !relation.isEmpty, !relation.trimmingCharacters(in: .whitespaces).isEmpty
            else
        {
            throw ValidationError.emptyRelation
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
        
        guard let idProof  = idProof, !idProof.isEmpty, !idProof.trimmingCharacters(in: .whitespaces).isEmpty
            else
        {
            throw ValidationError.emptyIdProof
        }
        
        
        /*guard let others  = others, !others.isEmpty, !others.trimmingCharacters(in: .whitespaces).isEmpty
            else
        {
            throw ValidationError.emptyOthers
        }*/
        
        
    }
    
    
}

