//
//  AddDepartmentPresenter.swift
//  ISMS
//
//  Created by Taranjeet Singh on 6/17/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation

protocol AddDepartmentDelegate: class {
    func unauthorizedUser()
    func addDepartmentDataDidSucceed(data : AddDepartmentModel)
    func departmentdetailDidSucceed(data : DepartmentDetailModel)
}

class AddDepartmentViewModel{
    
    //Weak Object of ViewDelegate
    weak var addDepartmentView : ViewDelegate?
    
    //Weak object of add department delegate protocol
    weak var addDepartmentDelegate : AddDepartmentDelegate?

    //Initialize the class with delegate
    init(delegate : AddDepartmentDelegate) {
        addDepartmentDelegate = delegate
    }
    //Attach View
    func attachView(viewDelegate : ViewDelegate){
        addDepartmentView = viewDelegate
    }
    //Deattach view
    func deattachView(){
        addDepartmentView = nil
        addDepartmentDelegate = nil
    }
    //MARK:- Add Department
    func addUpdateDepartment(departmentId:Int?,title: String?,description : String?,others : String?,imageUrl : URL?){
        //MARK:- Validations
        if(title!.trimmingCharacters(in: .whitespaces).isEmpty){
            self.addDepartmentView?.showAlert(alert: Alerts.kEmptyTitle)
        }else if(description!.trimmingCharacters(in: .whitespaces).isEmpty){
            self.addDepartmentView?.showAlert(alert: Alerts.kEmptyDescription)
        }else{
            var othrs : String?
            guard let departmentID = departmentId else{
                return
            }
            if others == ""{
                othrs = nil
            }else{
                othrs = others
            }
            let parameters = [KApiParameters.AddDepartmentApiPerameters.kDepartmentId:departmentID,KApiParameters.AddDepartmentApiPerameters.kTitle: title!,KApiParameters.AddDepartmentApiPerameters.kDescription : description!,KApiParameters.AddDepartmentApiPerameters.kOthers : othrs as Any,KApiParameters.AddDepartmentApiPerameters.kLogoUrl : imageUrl as Any] as [String : Any]
            self.addDepartmentView?.showLoader()
            //AddDepartment API
            DepartmentApi.sharedInstance.addDepartment(url: ApiEndpoints.kAddDepartment, parameters: parameters, completionResponse: { (responseModel) in
                CommonFunctions.sharedmanagerCommon.println(object: "Response Model of addDepartment:- \(responseModel) ")
                self.addDepartmentView?.hideLoader()
                
                switch responseModel.statusCode{
                case KStatusCode.kStatusCode200:
                    self.addDepartmentView?.showAlert(alert: responseModel.message ?? "")
                    self.addDepartmentDelegate?.addDepartmentDataDidSucceed(data: responseModel)
                case KStatusCode.kStatusCode401:
                    self.addDepartmentView?.showAlert(alert: responseModel.message ?? "")
                    self.addDepartmentDelegate?.unauthorizedUser()
                default:
                    self.addDepartmentView?.showAlert(alert: responseModel.message ?? "")
                }
            }, completionnilResponse: { (nilresponse) in
                self.addDepartmentView?.hideLoader()
                self.addDepartmentView?.showAlert(alert: nilresponse ?? Alerts.kMapperModelError)
            }) { (error) in
                self.addDepartmentView?.hideLoader()
                self.addDepartmentView?.showAlert(alert: error?.localizedDescription ?? Alerts.kMapperModelError)
            }
        }
    }
    
    //MARK:- Get Department Detail
    func getDepartmentDetail(departmentId : Int){
        
        let getUrl = ApiEndpoints.kGetDepartmentDetail + "\(departmentId)"
        
        self.addDepartmentView?.showLoader()
        DepartmentApi.sharedInstance.getDepartmentDetail(url: getUrl, completionResponse: { (departmentDetailresponse) in
            
            self.addDepartmentView?.hideLoader()
            switch departmentDetailresponse.statusCode{
            case KStatusCode.kStatusCode200:
                self.addDepartmentDelegate?.departmentdetailDidSucceed(data: departmentDetailresponse)
            case KStatusCode.kStatusCode401:
                if let msg = departmentDetailresponse.message{
                    self.addDepartmentView?.showAlert(alert: msg)
                }
                self.addDepartmentDelegate?.unauthorizedUser()
            default:
                self.addDepartmentView?.showAlert(alert: departmentDetailresponse.message ?? "Server Error")
            }
        }, completionnilResponse: { (error) in
            self.addDepartmentView?.hideLoader()
            if let nilResponse = error{
                self.addDepartmentView?.showAlert(alert: nilResponse)
            }
        }) { (error) in
            self.addDepartmentView?.hideLoader()
            if let err = error{
                self.addDepartmentView?.showAlert(alert: err.localizedDescription)
            }
        }
    }
}
//MARK:- Add Department Delegate
extension AddDepartmentVC : AddDepartmentDelegate{
    //MARK:- Unathorized User
    func unauthorizedUser() {
        isUnauthorizedUser = true
    }
    func departmentdetailDidSucceed(data: DepartmentDetailModel) {
        self.setDataInTextFields(data: data)
    }
    func addDepartmentDataDidSucceed(data: AddDepartmentModel) {
        isDepartmentAddUpdateSuccess = true
        initializeCustomOkAlert(self.view, isHideBlurView: true)
        okAlertView.delegate = self
        okAlertView.lblResponseDetailMessage.text = data.message
    }
}
//MARK:- Add Department View
extension AddDepartmentVC : ViewDelegate{
    func showLoader() {
        ShowLoader()
    }
    func hideLoader() {
        HideLoader()
    }
    func showAlert(alert: String){
        initializeCustomOkAlert(self.view, isHideBlurView: true)
        okAlertView.delegate = self
        okAlertView.lblResponseDetailMessage.text = alert
    }
    func setDataInTextFields(data: DepartmentDetailModel){
        if let title = data.resultData?.title{
            txtfieldTitle.text = title
        }
        if let description = data.resultData?.description{
            txtViewDescription.text = description
        }
        if let othrs = data.resultData?.others{
            txtfieldOthers.text = othrs
        }
        if let imageUrl = data.resultData?.logoUrl{
            selectedImageUrl = URL(string: imageUrl)
            imgViewDepartment.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: kImages.kProfileImage))
        }else{
            selectedImageUrl = nil
            CommonFunctions.sharedmanagerCommon.println(object: "Image is nil in department detail.")
        }
    }
}
//MARK:- UITextFieldDelegates
extension AddDepartmentVC:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        switch textField {
        case txtfieldTitle:
            txtViewDescription.becomeFirstResponder()
        case txtfieldOthers:
            txtfieldOthers.resignFirstResponder()
        default:
            break
        }
        return true
    }
}
//MARK:- UITextViewDelegates
extension AddDepartmentVC : UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //Remove keyboard when clicking Done on keyboard
        if(text == "\n") {
            textView.resignFirstResponder()
            txtfieldOthers.becomeFirstResponder()
            return false
        }
        return true
    }
}
//MARK:- UIImagePickerView Delegate
extension AddDepartmentVC:UIImagePickerDelegate{
    func selectedImageUrl(url: URL) {
        CommonFunctions.sharedmanagerCommon.println(object: "Url:- \(url)")
        selectedImageUrl = url
    }
    func SelectedMedia(image: UIImage?, videoURL: URL?){
        self.imgViewDepartment.contentMode = .scaleAspectFill
        self.imgViewDepartment.image = image
    }
}

//MARK:- Custom Gallery Alert
extension AddDepartmentVC : GalleryAlertCustomViewDelegate{
    func galleryBtnAction() {
        self.OpenGalleryCamera(camera: false, imagePickerDelegate: self)
//        CommonFunctions.sharedmanagerCommon.println(object: "Gallery")
        galleryAlertView.removeFromSuperview()
        
    }
    func cameraButtonAction() {
        self.OpenGalleryCamera(camera: true, imagePickerDelegate: self)
//        CommonFunctions.sharedmanagerCommon.println(object: "Camera")
        galleryAlertView.removeFromSuperview()
    }
    func cancelButtonAction() {
        galleryAlertView.removeFromSuperview()
    }
}

//MARK:- Custom Ok Alert
extension AddDepartmentVC : OKAlertViewDelegate{
    //Ok Button Clicked
    func okBtnAction() {
        okAlertView.removeFromSuperview()
        if isDepartmentAddUpdateSuccess == true{
            self.navigationController?.popViewController(animated: true)
        }else if isUnauthorizedUser == true{
            isUnauthorizedUser = false
            CommonFunctions.sharedmanagerCommon.setRootLogin()
        }
    }
}

