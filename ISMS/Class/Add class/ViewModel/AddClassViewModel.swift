//
//  AddClassPresenter.swift
//  ISMS
//
//  Created by Taranjeet Singh on 6/18/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation


protocol AddClassDelegate: class {
    func addClassDataDidSucceed(data: CommonSuccessResponseModel)
    func unauthorizedUser()
    func getClassDetailDidSucceed(data : ClassDetailModel)
    func getDepartmentdropdownDidSucceed(data : GetCommonDropdownModel)
}

class AddClassViewModel {
    //Weak Object of ViewDelegate
    weak var addClassView : ViewDelegate?
    
    //Weak object of add class delegate protocol
    weak var addClassDelegate : AddClassDelegate?
    
    //Initialize the class with delegate
    init(delegate : AddClassDelegate) {
        addClassDelegate = delegate
    }
    
    //Attach View
    func attachView(viewDelegate : ViewDelegate){
        addClassView = viewDelegate
    }
    
    //Deattach view
    func deattachView(){
        addClassView = nil
        addClassDelegate = nil
    }
  
    //MARk:- Get departments dropdown data
    func getDepartments(selectedDepartmentId: Int?,enumtype: Int?){

        guard let selectId = selectedDepartmentId else{ return }
        guard let enumType = enumtype else { return }
        
        self.addClassView?.showLoader()
        
        ClassApi.sharedManager.getDepartmentsDropdownData(selectedDepartmentId: selectId, enumType: enumType, completionResponse: { (responseModel) in
            
            self.addClassView?.hideLoader()
            switch responseModel.statusCode{
            case KStatusCode.kStatusCode200:
                self.addClassDelegate?.getDepartmentdropdownDidSucceed(data: responseModel)
                self.addClassView?.hideLoader()
            case KStatusCode.kStatusCode401:
                self.addClassView?.showAlert(alert: responseModel.message ?? "")
                self.addClassDelegate?.unauthorizedUser()
            default:
                self.addClassView?.showAlert(alert: responseModel.message ?? "")
            }
        }, completionnilResponse: { (nilResponse) in
            self.addClassView?.hideLoader()
            if let nilRes = nilResponse{
                self.addClassView?.showAlert(alert: nilRes)
            }
        }) { (error) in
            self.addClassView?.hideLoader()
            if let err = error{
                self.addClassView?.showAlert(alert: err.localizedDescription)
            }
        }
    }

    //MARK:- Add Class
    func addUpdateClass(classid : Int,className : String?,selectedDepartmentId : Int?,departmentName : String?,description : String?,others : String?,imageUrl : URL?){
        
        //MARK:- Validations
       if (className!.trimmingCharacters(in: .whitespaces).isEmpty){
            self.addClassView?.showAlert(alert: Alerts.kEmptyClass)
        }
        else if selectedDepartmentId == nil{
            self.addClassView?.showAlert(alert: Alerts.kEmptyDepartment)
        }
        else if(description!.trimmingCharacters(in: .whitespaces).isEmpty)
        {
            self.addClassView?.showAlert(alert: Alerts.kEmptyDescription)
        }
        else{
            var othrs : String?
            guard let departmentID = selectedDepartmentId else{
                return
            }
            if others == ""{
                othrs = nil
            }else{
                othrs = others
            }
            
            let parameters = [KApiParameters.KAddClassApiPerameters.kClassId:classid,KApiParameters.KAddClassApiPerameters.kDepartmentId:departmentID,KApiParameters.KAddClassApiPerameters.kName: className!,KApiParameters.KAddClassApiPerameters.kDescription : description!,KApiParameters.KAddClassApiPerameters.kOthers : othrs as Any,KApiParameters.KAddClassApiPerameters.kLogoUrl : imageUrl as Any] as [String : Any]
            self.addClassView?.showLoader()
            ClassApi.sharedManager.addUpdateClass(url: ApiEndpoints.kAddClass, parameters: parameters, completionResponse: { (responseModel) in
                CommonFunctions.sharedmanagerCommon.println(object: "Response Model of addClass:- \(responseModel) ")
                self.addClassView?.hideLoader()
                switch responseModel.statusCode{
                case KStatusCode.kStatusCode200:
                    self.addClassView?.showAlert(alert: responseModel.message ?? "")
                    self.addClassDelegate?.addClassDataDidSucceed(data: responseModel)
                case KStatusCode.kStatusCode401:
                    self.addClassView?.showAlert(alert: responseModel.message ?? "")
                    self.addClassDelegate?.unauthorizedUser()
                default:
                    self.addClassView?.showAlert(alert: responseModel.message ?? "")
                }
            }, completionnilResponse: { (nilresponse) in
                self.addClassView?.hideLoader()
                self.addClassView?.showAlert(alert: nilresponse ?? Alerts.kMapperModelError)
            }) { (error) in
                self.addClassView?.hideLoader()
                self.addClassView?.showAlert(alert: error?.localizedDescription ?? Alerts.kMapperModelError)
            }
        }
    }
    
    //MARK:- Get Class Detail
    func getClassDetail(classId : Int){
        
        let getUrl = ApiEndpoints.kGetClassDetail + "?classId=\(classId)"
        self.addClassView?.showLoader()
        ClassApi.sharedManager.getClassDetail(url: getUrl, completionResponse: { (classDetailresponse) in
            self.addClassView?.hideLoader()
            switch classDetailresponse.statusCode{
            case KStatusCode.kStatusCode200:
                self.addClassDelegate?.getClassDetailDidSucceed(data: classDetailresponse)
            case KStatusCode.kStatusCode401:
                self.addClassView?.showAlert(alert: classDetailresponse.message ?? "")
                self.addClassDelegate?.unauthorizedUser()
            default:
                self.addClassView?.showAlert(alert: classDetailresponse.message ?? "Server Error")
            }
        }, completionnilResponse: { (error) in
            self.addClassView?.hideLoader()
            if let nilResponse = error{
                self.addClassView?.showAlert(alert: nilResponse)
            }
        }) { (error) in
            self.addClassView?.hideLoader()
            if let err = error{
                self.addClassView?.showAlert(alert: err.localizedDescription)
            }
        }
    }
}

//MARK:- Add Class Delegate
extension AddClassVC : AddClassDelegate{
    
    //MARK:- Unathorized User
    func unauthorizedUser() {
        isUnauthorizedUser = true
    }
    
    //MARK:- Class Detail Success
    func getClassDetailDidSucceed(data: ClassDetailModel) {
        self.setDataInTextFields(data: data)
    }
    
    //MARK:- Add Class Succeed
    func addClassDataDidSucceed(data : CommonSuccessResponseModel) {
        isClassAddUpdateSuccess = true
    }
    
    //MARK:- Get Department Dropdown success
    func getDepartmentdropdownDidSucceed(data: GetCommonDropdownModel) {
        departmentData = data
        if let count = data.resultData?.count{
            if count > 0 {
                UpdatePickerModel(count: departmentData?.resultData?.count ?? 0, sharedPickerDelegate: self, View: self.view)
            }else{
                print("City Count is zero.")
            }
        }
    }
}

//MARK:- Picker View Delegates
extension AddClassVC:SharedUIPickerDelegate{
    func DoneBtnClicked() {
        
        if let count = departmentData.resultData?.count{
            if count > 0{
                if selectedDepartmentIndex == 0{
                    self.txtFieldDepartment.text = self.departmentData?.resultData?[0].name
                    self.selectedDepartmentId = self.departmentData?.resultData?[0].id ?? 0
                }else{
                    self.txtFieldDepartment.text = self.departmentData?.resultData?[selectedDepartmentIndex].name
                    self.selectedDepartmentId = self.departmentData?.resultData?[selectedDepartmentIndex].id ?? 0
                }
            }
        }
    }
    
    func GetTitleForRow(index: Int) -> String {
        if let count = departmentData.resultData?.count{
            if count > 0{
//                txtFieldDepartment.text = departmentData?.resultData?[0].name
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
//                    self.txtFieldDepartment.text = self.departmentData?.resultData?[index].name
//                    self.selectedDepartmentId = self.departmentData?.resultData?[index].id ?? 0
                    self.selectedDepartmentIndex = index
                    print("Selected Country:- \(String(describing: self.departmentData?.resultData?[index].name))")
                }
            }
        }
    }
}
