//
//  SubjectListVC.swift
//  ISMS
//
//  Created by Poonam Sharma on 7/1/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class SubjectListVC: BaseUIViewController {
    
    var ViewModel : SubjectListViewModel?
    var arrSubjectlist=[GetSubjectResultData]()
    var selectedSubjectArrIndex : Int?
    var subjectId:Int?
    var isUnauthorizedUser = false
    var isSubjectAddSuccessFully = false
    var isSubjectDelete = false
    var skip = Int()
    var isScrolling : Bool?
    var pageSize = KIntegerConstants.kInt10
    var pointNow:CGPoint!
    var isFetching:Bool?
    
    
    @IBOutlet weak var btnAddSubject: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackButton()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        self.ViewModel = SubjectListViewModel.init(delegate: self)
        self.ViewModel?.attachView(viewDelegate: self)
        self.title = KStoryBoards.KAddSubjectIdentifiers.kSubjectListTitle
        self.setSearchBarInNavigationController(placeholderText: KSearchBarPlaceHolder.kUserSearchBarSubjectPlaceHolder, navigationTitle: KStoryBoards.KAddSubjectIdentifiers.kSubjectListTitle, navigationController: self.navigationController, navigationSearchBarDelegates: self)

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let userName = UserDefaults.standard.value(forKey: UserDefaultKeys.userRoleName.rawValue)  as?  String{
            if userName == KConstants.kHod{
                btnAddSubject.isHidden = true
            }
        }
        if checkInternetConnection(){
            self.ViewModel?.subjectList(search : "",skip : KIntegerConstants.kInt0,pageSize: pageSize,sortColumnDir: "",sortColumn: "")
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
    }
    
    @IBAction func ActEditBtn(_ sender: Any) {
        
        if arrSubjectlist.count>0{
            let data = arrSubjectlist[(sender as AnyObject).tag]
            self.subjectId = data.subjectId
            setupUI()
            initializeCustomTextFieldView(self.view, isHideBlurView: true)
            textFieldAlert.delegate = self
            self.textFieldAlert.lblTitle.text = "update subject"
            self.textFieldAlert.BtnTxt.setTitle("Submit", for: .normal)
            self.ViewModel?.subjectDetail(subjectId: data.subjectId)
            
        }
        
    }
    func setupUI(){
        self.textFieldAlert.txtFieldVal.SetTextFont(textSize: KTextSize.KSixteen, placeholderText: KPlaceholder.kSubjectNamePlaceholder)
        self.textFieldAlert.txtFieldVal.addViewCornerShadow(radius: 8, view: self.textFieldAlert.txtFieldVal)
        self.textFieldAlert.txtFieldVal.txtfieldPadding(leftpadding: 20, rightPadding: 0)
    }
    
    
    @IBAction func ActDeleteBtn(_ sender: Any) {
        if arrSubjectlist.count>0{
            let data = arrSubjectlist[(sender as AnyObject).tag]
            selectedSubjectArrIndex = (sender as AnyObject).tag
            subjectId = data.subjectId
            initializeCustomYesNoAlert(self.view, isHideBlurView: true)
            yesNoAlertView.delegate = self
            yesNoAlertView.lblResponseDetailMessage.text = Alerts.kDeleteClassAlert
            
        }
    }
    
    
    @IBAction func AddSubject(_ sender: Any) {
        self.view.endEditing(true)
        self.subjectId = 0
        setupUI()
        initializeCustomTextFieldView(self.view, isHideBlurView: true)
        textFieldAlert.delegate = self
        self.textFieldAlert.lblTitle.text = "Add subject"
        self.textFieldAlert.txtFieldVal.text = ""
        self.textFieldAlert.BtnTxt.setTitle("Add", for: .normal)
        self.textFieldAlert.btnCancel.setTitle("Cancel", for: .normal)
        self.textFieldAlert.btnCancel.cornerRadius = 4.0
        self.textFieldAlert.BtnTxt.cornerRadius = 4.0
    }
    
    func setUITextField(data: GetSubjectDetail){
        self.textFieldAlert.txtFieldVal.text = data.resultData?.subjectName
    }
    
    func backToInitial() {
        self.view.endEditing(true)
        okAlertView.removeFromSuperview()
    }
}

extension SubjectListVC : TextFieldAlertDelegate{
    func btnCancel() {
    textFieldAlert.removeFromSuperview()
    }
    
    
    func BtnTxt() {
        self.view.endEditing(true)
        if self.checkInternetConnection(){
            if subjectId != 0{
                if textFieldAlert.txtFieldVal.text != ""{
                    isSubjectAddSuccessFully = true
                    self.ViewModel?.addSubject(subjectName: textFieldAlert.txtFieldVal.text, subjectID: subjectId)
                    yesNoAlertView.removeFromSuperview()
                }
                else {
                    self.showAlert(alert: Alerts.kEmptySubjectName)
                }
                
            }else{
                if textFieldAlert.txtFieldVal.text != ""{
                    isSubjectAddSuccessFully = true
                    self.ViewModel?.addSubject(subjectName: textFieldAlert.txtFieldVal.text, subjectID: subjectId)
                    yesNoAlertView.removeFromSuperview()
                }
                else  {
                    self.showAlert(alert: Alerts.kEmptySubjectName)
                }
            }
            
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
            yesNoAlertView.removeFromSuperview()
        }
        
    }
}

extension SubjectListVC : OKAlertViewDelegate {
    //Ok Button Clicked
    func okBtnAction() {
        if isUnauthorizedUser == true{
            isUnauthorizedUser = false
            CommonFunctions.sharedmanagerCommon.setRootLogin()
        }else if isSubjectAddSuccessFully == true{
            isSubjectAddSuccessFully = false
            textFieldAlert.removeFromSuperview()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }else if isSubjectDelete == true{
            isSubjectDelete = false
            if let selectedIndex = self.selectedSubjectArrIndex{
                self.arrSubjectlist.remove(at: selectedIndex)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
        }
        okAlertView.removeFromSuperview()
    }
}

extension SubjectListVC : YesNoAlertViewDelegate{
    
    func yesBtnAction() {
        if self.checkInternetConnection(){
            if let SubjectId1 = self.subjectId{
                self.ViewModel?.deleteSubject(SubjectId: SubjectId1)
                yesNoAlertView.removeFromSuperview()
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Delete subject id is nil")
                yesNoAlertView.removeFromSuperview()
            }
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
            yesNoAlertView.removeFromSuperview()
        }
        yesNoAlertView.removeFromSuperview()
    }
    
    func noBtnAction() {
        yesNoAlertView.removeFromSuperview()
    }
}

extension SubjectListVC : ViewDelegate{
    
    
    func showAlert(alert: String){
        initializeCustomOkAlert(self.view, isHideBlurView: true)
        okAlertView.delegate = self
        okAlertView.lblResponseDetailMessage.text = alert
        backToInitial()
    }
    
    func showLoader() {
        ShowLoader()
    }
    
    func hideLoader() {
        HideLoader()
    }
    
    func alertForRemoveStudent(){
        let alertController = UIAlertController(title: KAPPContentRelatedConstants.kAppTitle, message: Alerts.kDeleteSubjectAlert, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
            UIAlertAction in
            
            if let SubjectId1 = self.subjectId{
                self.ViewModel?.deleteSubject(SubjectId: SubjectId1)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Delete subject id is nil")
            }
            
        }
        let cancelAction = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func setupCustomView(){
        initializeCustomTextFieldView(self.view, isHideBlurView: true)
        textFieldAlert.delegate = self
    }
}

