//
//  ContactUsVC.swift
//  ISMS
//
//  Created by Poonam Sharma on 12/5/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import UIKit
import SDWebImage

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
        setBackButton()
        self.title = "Contact Us"
        viewModel?.getContactUs()
    }
    
    
    @IBAction func btnCall(_ sender: Any) {
        if lblAdmissionPhn.text != nil{
            if let url = URL(string: "tel://\(lblAdmissionPhn.text!)"),
                UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
       
        
    }
    
    
    @IBAction func btnCallGenral(_ sender: Any) {
        if lblGenralPhn.text != nil{
            if let url = URL(string: "tel://\(lblGenralPhn.text!)"),
                UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func btnMail(_ sender: Any) {
        print("mail btn")
        let appURL = URL(string: lblAdmissionEmail.text!)!

        if #available(iOS 10.0, *) {
            UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(appURL)
        }
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
            
            if data?.imageUrl != nil{
                var imgProfileUrl = data?.imageUrl ?? ""
                imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
                //mohit studentImgUrl = URL(string: imgProfileUrl)
                imgProfile.contentMode = .scaleAspectFill
                imgProfile.sd_setImage(with: URL(string: imgProfileUrl), placeholderImage: UIImage(named: kImages.kProfileImage))
            }else{
                //            studentImgUrl = URL(string: "")
                imgProfile.image = UIImage.init(named: kImages.kProfileImage)
            }
            
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

