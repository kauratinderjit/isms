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
    
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var tableViewAdmission: UITableView!
   
    @IBOutlet weak var tableViewEmergency: UITableView!
    @IBOutlet weak var tableGeneralHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var tableViewGeneral: UITableView!
    @IBOutlet weak var viewTopConstraints: NSLayoutConstraint!
    @IBOutlet weak var viewHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var tableAdmissionHeightConstraints: NSLayoutConstraint!
    
    @IBOutlet weak var tableViewEmergencyHeight: NSLayoutConstraint!
    var lstAdmissionInquiryViewModels = [[String:Any]]()
     var lstGeneralInquiryViewModels = [[String:Any]]()
     var lstEmergencyInquiryViewModels = [[String:Any]]()
    
    var lstdeleteAdmissionInquiryViewModels = [[String:Any]]()
    var lstdeleteEmergencyInquiryViewModels = [[String:Any]]()
    var lstdeleteGeneralInquiryViewModels = [[String:Any]]()
    var viewModel : ContactUsViewModel?
    var firstAdmission = 1
     var firstGeneral = 1
    var firstEmerg = 1
    var fromAdmin : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = ContactUsViewModel.init(delegate: self)
        self.viewModel?.attachView(viewDelegate: self)
        setBackButton()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
              view.addGestureRecognizer(tap)
        if fromAdmin  == 1{
             viewTopConstraints.constant = 20
            imgProfile.isHidden = false
            lblEstablishment.isHidden = false
            ourName.isHidden = false
            btnSubmit.isHidden = true
            btnSubmit.setTitle("Locate Us", for: .normal)
            
        }else{
             viewTopConstraints.constant = -50
        }
       
        
        self.title = "Contact Us"
        viewModel?.getContactUs()
    }
    
    @objc override func dismissKeyboard() {
         view.endEditing(true)
       }
    
    @IBAction func actionAddMoreBtn(_ sender: Any) {
        firstAdmission = 3
        let indexPath = IndexPath(row: (sender as AnyObject).tag, section: 0)
               if let cell = tableViewAdmission.cellForRow(at: indexPath) as? AdmissionTableCell {
                if cell.txtFieldPhoneNum.text != ""{
                    if cell.txtFieldEmail.text != ""{
                       if cell.txtFieldEmail.text?.isValidEmail() == false{
                            self.showAlert(alert: "Please enter valid email.")
                        }else{
                            var data = [String:Any]()
                            data = ["AdmissionInquiryId":0 , "AdmissionEmail": cell.txtFieldEmail.text,"AdmissionNumber":cell.txtFieldPhoneNum.text]
                            print("data: ",data)
                            cell.btnMinus.isHidden = false
                            cell.addMoreBtn.isHidden = true
                            lstAdmissionInquiryViewModels.append(data)
                            tableAdmissionHeightConstraints.constant = (tableAdmissionHeightConstraints.constant ?? 167)+120
                            viewHeightConstraints.constant = (viewHeightConstraints.constant ?? 653) + 120
                            tableViewAdmission.reloadData()
                        }
                    }else{
                        self.showAlert(alert: "Please enter email.")
                    }
                }else{
                     self.showAlert(alert: "Please enter phone number.")
                }
        }
        
    }
    @IBAction func actionMinusBtn(_ sender: Any) {
         let indexPath = IndexPath(row: (sender as AnyObject).tag, section: 0)
                
                if let cell = tableViewAdmission.cellForRow(at: indexPath) as? AdmissionTableCell {
                    if lstAdmissionInquiryViewModels.count > 0{
                        let index = indexPath.row
                        guard let admissionInquiryId = (lstAdmissionInquiryViewModels[index] as NSDictionary).value(forKey: "AdmissionInquiryId") as? Int  else {
                            return
                        }
                        let refreshAlert = UIAlertController(title: "iEMS", message: "Are you sure you want to delete this contact?", preferredStyle: UIAlertController.Style.alert)
                        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                           if self.lstAdmissionInquiryViewModels.count == 1{
                                if admissionInquiryId > 0{
                                   var data = [String:Any]()
                                   data = ["AdmissionInquiryId":admissionInquiryId]
                                   print("data: ",data)
                                    self.lstdeleteAdmissionInquiryViewModels.append(data)
                                }
                                else{
                                    print("addded locally")
                                }
                                DispatchQueue.main.async {
                                    self.lstAdmissionInquiryViewModels.remove(at: index)
                                    cell.txtFieldEmail.text = ""
                                    cell.txtFieldPhoneNum.text = ""
                                    self.tableViewAdmission.reloadData()
                                    print(self.lstAdmissionInquiryViewModels.count)
                                }
                            }else{
                                
                                if admissionInquiryId > 0{
                                    var data = [String:Any]()
                                    data = ["AdmissionInquiryId":admissionInquiryId]
                                    print("data: ",data)
                                    self.lstdeleteAdmissionInquiryViewModels.append(data)
                                }
                                else{
                                    print("addded locally")
                                }
                                DispatchQueue.main.async {
                                    self.lstAdmissionInquiryViewModels.remove(at: index)
                                    self.tableViewAdmission.deleteRows(at: [indexPath], with: .fade)
                                    self.tableViewAdmission.reloadData()
                                    print(self.lstAdmissionInquiryViewModels.count)
                                }
                            }
                            self.tableAdmissionHeightConstraints.constant = self.tableAdmissionHeightConstraints.constant - 120
                            self.viewHeightConstraints.constant = self.viewHeightConstraints.constant - 120
                        }))
                        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
                            print("Cancel")
                        }))
                        self.present(refreshAlert, animated: true, completion: nil)
                    }else{
                        debugPrint("Last Cell")
                    }
    }

        
    
//    @IBAction func btnCall(_ sender: Any) {
//        if lblAdmissionPhn.text != nil{
//            if let url = URL(string: "tel://\(lblAdmissionPhn.text!)"),
//                UIApplication.shared.canOpenURL(url) {
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            }
//        }
//    }
    
//    @IBAction func btnMail(_ sender: Any) {
//        print("mail btn")
//        let appURL = URL(string: lblAdmissionEmail.text!)!
//
//        if #available(iOS 10.0, *) {
//            UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
//        } else {
//            UIApplication.shared.openURL(appURL)
//        }
//    }
//
    
    }
    
    @IBAction func actionAddGeneralBtn(_ sender: Any) {
        firstEmerg = 3
        let indexPath = IndexPath(row: (sender as AnyObject).tag, section: 0)
               if let cell = tableViewGeneral.cellForRow(at: indexPath) as? GeneralTableCell {
                if cell.txtFieldPhoneNum.text != ""{
                    if cell.txtFieldEmail.text != ""{
                        if cell.txtFieldEmail.text?.isValidEmail() == false{
                            self.showAlert(alert: "Please enter valid email.")
                        }else{
                            var data = [String:Any]()
                            data = ["GeneralInquiryId":0 , "GenernalEmail": cell.txtFieldEmail.text,"GenernalNumber":cell.txtFieldPhoneNum.text]
                            print("data: ",data)
                            cell.btnMinus.isHidden = false
                            lstGeneralInquiryViewModels.append(data)
                            cell.addMoreBtn.isHidden = true
                            tableGeneralHeightConstraints.constant = (tableGeneralHeightConstraints.constant ?? 167)+120
                            viewHeightConstraints.constant = (viewHeightConstraints.constant ?? 653) + 120
                            tableViewGeneral.reloadData()
                        }
                    
                    }else{
                        self.showAlert(alert: "Please enter email number.")
                    }
                }else{
                     self.showAlert(alert: "Please enter phone number.")
                }
        }
    }
    
    @IBAction func actionMinusGeneralBtn(_ sender: Any) {
        let indexPath = IndexPath(row: (sender as AnyObject).tag, section: 0)
        if let cell = tableViewGeneral.cellForRow(at: indexPath) as? GeneralTableCell {
            if lstGeneralInquiryViewModels.count > 0{
                let index = indexPath.row
                guard let admissionInquiryId = (lstGeneralInquiryViewModels[index] as NSDictionary).value(forKey: "GeneralInquiryId") as? Int  else {
                    return
                }
                let refreshAlert = UIAlertController(title: "iEMS", message: "Are you sure you want to delete this contact?", preferredStyle: UIAlertController.Style.alert)
                refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                    if self.lstGeneralInquiryViewModels.count == 1{
                        if admissionInquiryId > 0{
                           var data = [String:Any]()
                            data = ["GeneralInquiryId":admissionInquiryId]
                            print("data: ",data)
                            self.lstdeleteGeneralInquiryViewModels.append(data)
                        }
                        else{
                            print("addded locally")
                        }
                        DispatchQueue.main.async {
                            self.lstGeneralInquiryViewModels.remove(at: index)
                            cell.txtFieldEmail.text = ""
                            cell.txtFieldPhoneNum.text = ""
                            self.tableViewGeneral.reloadData()
                            print(self.lstGeneralInquiryViewModels.count)
                        }
                    }else{
                        
                        if admissionInquiryId > 0{
                            var data = [String:Any]()
                            data = ["GeneralInquiryId":admissionInquiryId]
                            print("data: ",data)
                            self.lstdeleteGeneralInquiryViewModels.append(data)
                        }
                        else{
                            print("addded locally")
                        }
                        DispatchQueue.main.async {
                            self.lstGeneralInquiryViewModels.remove(at: index)
                            self.tableViewGeneral.deleteRows(at: [indexPath], with: .fade)
                            self.tableViewGeneral.reloadData()
                            print(self.lstGeneralInquiryViewModels.count)
                        }
                    }
                    
                    self.tableGeneralHeightConstraints.constant = self.tableGeneralHeightConstraints.constant - 120
                    self.viewHeightConstraints.constant = self.viewHeightConstraints.constant - 120
                }))
                refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
                    print("Cancel")
                }))
                self.present(refreshAlert, animated: true, completion: nil)
            }else{
                debugPrint("Last Cell")
            }
        }
    }
    
    
    @IBAction func actionAddMoreEmergency(_ sender: Any) {
        firstEmerg = 3
        let indexPath = IndexPath(row: (sender as AnyObject).tag, section: 0)
        if let cell = tableViewEmergency.cellForRow(at: indexPath) as? EmergencyTableCell {
            if cell.txtFieldPhoneNum.text != ""{
                if cell.txtFieldEmail.text != ""{
                    if cell.txtFieldEmail.text?.isValidEmail() == false{
                            self.showAlert(alert: "Please enter valid email.")
                    }else{
                        var data = [String:Any]()
                        data = ["EmergencyInquiryId":0 , "EmergencyEmail": cell.txtFieldEmail.text,"EmergencyNumber":cell.txtFieldPhoneNum.text]
                        print("data: ",data)
                        cell.btnMinus.isHidden = false
                        cell.addMoreBtn.isHidden = true
                        lstEmergencyInquiryViewModels.append(data)
                        tableViewEmergencyHeight.constant = (tableViewEmergencyHeight.constant ?? 167)+120
                        viewHeightConstraints.constant = (viewHeightConstraints.constant ?? 653) + 120
                        tableViewEmergency.reloadData()
                    }
                    
                }else{
                    self.showAlert(alert: "Please enter email number.")
                }
            }else{
                self.showAlert(alert: "Please enter phone number.")
            }
        }
    }
    
    @IBAction func actionMinusEmergency(_ sender: Any) {
        let indexPath = IndexPath(row: (sender as AnyObject).tag, section: 0)
        if let cell = tableViewEmergency.cellForRow(at: indexPath) as? EmergencyTableCell {
            if lstEmergencyInquiryViewModels.count > 0{
                let index = indexPath.row
                guard let admissionInquiryId = (lstEmergencyInquiryViewModels[index] as NSDictionary).value(forKey: "EmergencyInquiryId") as? Int  else {
                    return
                }
                let refreshAlert = UIAlertController(title: "iEMS", message: "Are you sure you want to delete this contact?", preferredStyle: UIAlertController.Style.alert)
                refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                    if self.lstEmergencyInquiryViewModels.count == 1{
                        if admissionInquiryId > 0{
                            var data = [String:Any]()
                            data = ["EmergencyInquiryId":admissionInquiryId]
                            print("data: ",data)
                            self.lstdeleteEmergencyInquiryViewModels.append(data)
                        }
                        else{
                            print("addded locally")
                        }
                        DispatchQueue.main.async {
                            self.lstEmergencyInquiryViewModels.remove(at: index)
                            cell.txtFieldEmail.text = ""
                            cell.txtFieldPhoneNum.text = ""
                            self.tableViewEmergency.reloadData()
                            print(self.lstEmergencyInquiryViewModels.count)
                        }
                    }else{
                        
                        if admissionInquiryId > 0{
                            var data = [String:Any]()
                            data = ["EmergencyInquiryId":admissionInquiryId]
                            print("data: ",data)
                            self.lstdeleteEmergencyInquiryViewModels.append(data)
                        }
                        else{
                            print("addded locally")
                        }
                        DispatchQueue.main.async {
                            self.lstEmergencyInquiryViewModels.remove(at: index)
                            self.tableViewEmergency.deleteRows(at: [indexPath], with: .fade)
                            self.tableViewEmergency.reloadData()
                            print(self.lstEmergencyInquiryViewModels.count)
                        }
                    }
                    
                    self.tableViewEmergencyHeight.constant = self.tableViewEmergencyHeight.constant - 120
                    self.viewHeightConstraints.constant = self.viewHeightConstraints.constant - 120
                }))
                refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
                    print("Cancel")
                }))
                self.present(refreshAlert, animated: true, completion: nil)
            }else{
                debugPrint("Last Cell")
            }
        }
    }
   
    
    @IBAction func actionSubmit(_ sender: Any) {
          if fromAdmin  == 1{
             self.showToast("Coming Soon")
          }else{
//            let lastRowIndex = tableViewAdmission.numberOfRows(inSection: tableViewAdmission.numberOfSections-1)
//            if let cell = tableViewAdmission.cellForRow(at: lastRowIndex - 1) as? AdmissionTableCell{
//                cell.lblEmail.text = ""
//            }
            
            print("admision count",lstAdmissionInquiryViewModels.count)
            print("admisionsss count",lstAdmissionInquiryViewModels.count)
            
            let lastIndex = lstAdmissionInquiryViewModels.count
                  let indexPath = IndexPath(row: lastIndex,section: 0)
                  if let lastcell = tableViewAdmission.cellForRow(at: indexPath) as? AdmissionTableCell {
                    if(lastcell.txtFieldPhoneNum.text != ""){
                        if(lastcell.txtFieldEmail.text != ""){
                                var data = [String:Any]()
                                data = ["AdmissionInquiryId":0 , "AdmissionEmail": lastcell.txtFieldEmail.text,"AdmissionNumber":lastcell.txtFieldPhoneNum.text]
                                print("data: ",data)
                                lstAdmissionInquiryViewModels.append(data)
                            }
                        }
                    }
            
            if let lastcell = tableViewGeneral.cellForRow(at: indexPath) as? GeneralTableCell {
                if(lastcell.txtFieldPhoneNum.text != ""){
                    if(lastcell.txtFieldEmail.text != ""){
                            var data = [String:Any]()
                            data = ["GeneralInquiryId":0 , "GenernalEmail": lastcell.txtFieldEmail.text,"GenernalNumber":lastcell.txtFieldPhoneNum.text]
                            print("data: ",data)
                            lstGeneralInquiryViewModels.append(data)
                    }
                }
            }
            
            if let lastcell = tableViewEmergency.cellForRow(at: indexPath) as? EmergencyTableCell {
                if(lastcell.txtFieldPhoneNum.text != ""){
                    if(lastcell.txtFieldEmail.text != ""){
                          var data = [String:Any]()
                            data = ["EmergencyInquiryId":0 , "EmergencyEmail": lastcell.txtFieldEmail.text,"EmergencyNumber":lastcell.txtFieldPhoneNum.text]
                            print("data: ",data)
                            lstEmergencyInquiryViewModels.append(data)
                    }
                }
            }
            
             viewModel?.addContact(ContactId: 31,InstituteId: 1,Message: "",lstEmergencyInquiryViewModels: lstEmergencyInquiryViewModels,lstAdmissionInquiryViewModels: lstAdmissionInquiryViewModels,lstGeneralInquiryViewModels: lstGeneralInquiryViewModels,lstdeleteEmergencyInquiryViewModels: lstdeleteEmergencyInquiryViewModels,lstdeleteAdmissionInquiryViewModels: lstdeleteAdmissionInquiryViewModels,lstdeleteGeneralInquiryViewModels : lstdeleteGeneralInquiryViewModels)
        }
    }
}
extension ContactUsVC : ContactUsViewModelDelegate{
    func ContactUsDidSuccess(data: ContactUsResult?) {
        if data != nil{
            self.ourName.text = data?.name
            self.lblEstablishment.text = data?.strEstablishDate
            
            
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
            
            if data?.lstAdmissionInquiryViewModels?.count ?? 0 > 0{
                firstAdmission = 2
                 if let total = data?.lstAdmissionInquiryViewModels{
                for i in 0..<total.count{
                    var data = [String:Any]()
                    data = ["AdmissionInquiryId":total[i].AdmissionInquiryId ?? 0 , "AdmissionEmail": total[i].AdmissionEmail ?? "", "AdmissionNumber" : total[i].AdmissionNumber]
                    print("data: ",data)
                    self.lstAdmissionInquiryViewModels.append(data)
                }
            }
                
                if fromAdmin == 1{
                    self.tableAdmissionHeightConstraints.constant = self.tableAdmissionHeightConstraints.constant + CGFloat(((data?.lstAdmissionInquiryViewModels?.count ?? 0)*120))
                    self.tableAdmissionHeightConstraints.constant = self.tableAdmissionHeightConstraints.constant - 120
                    
                    self.viewHeightConstraints.constant = self.viewHeightConstraints.constant + CGFloat(((data?.lstAdmissionInquiryViewModels?.count ?? 0)*120))
                    self.viewHeightConstraints.constant = self.viewHeightConstraints.constant - 120
                    
                    tableViewAdmission.reloadData()
                }else{
                    self.tableAdmissionHeightConstraints.constant = self.tableAdmissionHeightConstraints.constant + CGFloat(((data?.lstAdmissionInquiryViewModels?.count ?? 0)*120))
                    
                    self.viewHeightConstraints.constant = self.viewHeightConstraints.constant + CGFloat(((data?.lstAdmissionInquiryViewModels?.count ?? 0)*120))
                    
                    tableViewAdmission.reloadData()
                }
             
            }
            
            if data?.lstGeneralInquiryViewModels?.count ?? 0 > 0{
                firstGeneral = 2
                 if let total = data?.lstGeneralInquiryViewModels{
                for i in 0..<total.count{
                    var data = [String:Any]()
                    data = ["GeneralInquiryId":total[i].GeneralInquiryId ?? 0 , "GenernalEmail": total[i].GenernalEmail ?? "", "GenernalNumber" : total[i].GenernalNumber]
                    print("data: ",data)
                    self.lstGeneralInquiryViewModels.append(data)
                }
            }
                 if fromAdmin == 1{
                 self.tableGeneralHeightConstraints.constant = self.tableGeneralHeightConstraints.constant + CGFloat(((data?.lstGeneralInquiryViewModels?.count ?? 0)*120))
                    self.tableGeneralHeightConstraints.constant = self.tableGeneralHeightConstraints.constant - 120
                    
                     self.viewHeightConstraints.constant = self.viewHeightConstraints.constant + CGFloat(((data?.lstGeneralInquiryViewModels?.count ?? 0)*120))
                    self.viewHeightConstraints.constant = self.viewHeightConstraints.constant - 120
                    
                 }else{
                    self.tableGeneralHeightConstraints.constant = self.tableGeneralHeightConstraints.constant + CGFloat(((data?.lstGeneralInquiryViewModels?.count ?? 0)*120))
                    
                    self.viewHeightConstraints.constant = self.viewHeightConstraints.constant + CGFloat(((data?.lstGeneralInquiryViewModels?.count ?? 0)*120))
                }
            
                
                tableViewGeneral.reloadData()
            }
            
            if data?.lstEmergencyInquiryViewModels?.count ?? 0 > 0{
                           firstEmerg = 2
                            if let total = data?.lstEmergencyInquiryViewModels{
                           for i in 0..<total.count{
                               var data = [String:Any]()
                               data = ["EmergencyInquiryId":total[i].EmergencyInquiryId ?? 0 , "EmergencyEmail": total[i].EmergencyEmail ?? "", "EmergencyNumber" : total[i].EmergencyNumber]
                               print("data: ",data)
                               self.lstEmergencyInquiryViewModels.append(data)
                           }
                       }
                 if fromAdmin == 1{
                    self.tableViewEmergencyHeight.constant = self.tableViewEmergencyHeight.constant + CGFloat(((data?.lstEmergencyInquiryViewModels?.count ?? 0)*120))
                     self.tableViewEmergencyHeight.constant = self.tableViewEmergencyHeight.constant - 120
                                       
                    self.viewHeightConstraints.constant = self.viewHeightConstraints.constant + CGFloat(((data?.lstEmergencyInquiryViewModels?.count ?? 0)*120))
                       self.viewHeightConstraints.constant = self.viewHeightConstraints.constant - 120
                    
                    tableViewEmergency.reloadData()
                 }else{
                    self.tableViewEmergencyHeight.constant = self.tableViewEmergencyHeight.constant + CGFloat(((data?.lstEmergencyInquiryViewModels?.count ?? 0)*120))
                    
                    self.viewHeightConstraints.constant = self.viewHeightConstraints.constant + CGFloat(((data?.lstEmergencyInquiryViewModels?.count ?? 0)*120))
                    
                    tableViewEmergency.reloadData()
                }
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
         self.navigationController?.popToRootViewController(animated: true)
     }
 }
//MARK:- Table view delagate
extension ContactUsVC : UITableViewDelegate{
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
          return 120
      }
}

//MARK:- Table view data source
extension ContactUsVC : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableViewAdmission{
            if lstAdmissionInquiryViewModels.count>0{
                if fromAdmin == 1{
                    return lstAdmissionInquiryViewModels.count
                }else{
                    return lstAdmissionInquiryViewModels.count+1
                }
            }
        }else if tableView == tableViewGeneral{
            if lstGeneralInquiryViewModels.count>0{
                if fromAdmin == 1{
                    return lstGeneralInquiryViewModels.count
                }else{
                    return lstGeneralInquiryViewModels.count+1
                }
            }
        }else{
            if lstEmergencyInquiryViewModels.count>0{
                 if fromAdmin == 1{
                     return lstEmergencyInquiryViewModels.count
                 }else{
                     return lstEmergencyInquiryViewModels.count+1
                }
            }
        }
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableViewAdmission{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AdmissionCell", for: indexPath) as! AdmissionTableCell
            if firstAdmission == 2{
                cell.setCellUI(data: lstAdmissionInquiryViewModels, indexPath: indexPath, isFromAdmin: fromAdmin ?? 0)
            }else{
                cell.btnMinus.tag = indexPath.row
                cell.addMoreBtn.tag = indexPath.row
                if lstAdmissionInquiryViewModels.count == 0{
                    cell.btnMinus.isHidden = true
                    cell.addMoreBtn.isHidden = false
                }
            }
            return cell
        }else if tableView == tableViewGeneral{
            let cell = tableView.dequeueReusableCell(withIdentifier: "GeneralCell", for: indexPath) as! GeneralTableCell
            if firstGeneral == 2{
                cell.setCellUI(data: lstGeneralInquiryViewModels, indexPath: indexPath,isFromAdmin: fromAdmin ?? 0)
            }else{
                if lstGeneralInquiryViewModels.count == 0{
                    cell.btnMinus.isHidden = true
                    cell.addMoreBtn.isHidden = false
                }
                cell.btnMinus.tag = indexPath.row
                cell.addMoreBtn.tag = indexPath.row
            }
            return cell
        }else if tableView == tableViewEmergency{
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmergencyCell", for: indexPath) as! EmergencyTableCell
            if firstEmerg == 2{
                cell.setCellUI(data: lstEmergencyInquiryViewModels, indexPath: indexPath,isFromAdmin: fromAdmin ?? 0)
            }else{
                if lstEmergencyInquiryViewModels.count == 0{
                    cell.btnMinus.isHidden = true
                    cell.addMoreBtn.isHidden = false
                }
                cell.btnMinus.tag = indexPath.row
                cell.addMoreBtn.tag = indexPath.row
            }
            return cell
        }
        return UITableViewCell()
    }
}
