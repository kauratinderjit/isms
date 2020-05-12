//
//  ContactUsVC.swift
//  ISMS
//
//  Created by Poonam Sharma on 12/5/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import UIKit

class ContactUsVC: BaseUIViewController {
    
    
    @IBOutlet weak var ourName: UILabel!
    @IBOutlet weak var lblEstablishment: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var lblAdmissionPhn: UILabel!
    
    @IBOutlet weak var lblAdmissionEmail: UILabel!
    
    @IBOutlet weak var lblGenralEmail: UILabel!
    @IBOutlet weak var lblGenralPhn: UILabel!
    var viewModel : ContactUsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = ContactUsViewModel.init(delegate: self)
        self.viewModel?.attachView(viewDelegate: self)
        
        viewModel?.getContactUs()
    }
}

extension ContactUsVC : ContactUsViewModelDelegate{
    func ContactUsDidSuccess(data: ContactUsResult?) {
        if data != nil{
            self.ourName.text = data?.name
            self.lblEstablishment.text = data?.strEstablishDate
            self.lblAdmissionPhn.text = data?.admissionNumber
            self.lblAdmissionEmail.text = data?.admissionEmail
            self.lblGenralPhn.text = data?.genernalNumber
            self.lblGenralEmail.text = data?.genernalEmail
        }
    }
}
 extension ContactUsVC : ViewDelegate{
     
     func showAlert(alert: String){
         initializeCustomOkAlert(self.view, isHideBlurView: true)
         okAlertView.delegate = self
         okAlertView.lblResponseDetailMessage.text = alert
     }
     func showLoader() {
         ShowLoader()
     }
     func hideLoader() {
         HideLoader()
     }
 }
 //MARK:- OK Alert Delegate
 extension ContactUsVC : OKAlertViewDelegate{
     func okBtnAction() {
         okAlertView.removeFromSuperview()
 //        if isUnauthorizedUser == true{
 //            isUnauthorizedUser = false
 //            CommonFunctions.sharedmanagerCommon.setRootLogin()
 //        }else if isStudentAttendanceSuccess == true{
 //            isStudentAttendanceSuccess = false
 //            self.navigationController?.popViewController(animated: true)
 //        }
     }
 }

