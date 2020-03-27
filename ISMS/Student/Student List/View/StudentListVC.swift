//
//  StudentListVC.swift
//  ISMS
//
//  Created by Poonam Sharma on 6/26/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class StudentListVC: BaseUIViewController {
    static var isStartSearching = false
    var ViewModel : StudentListViewModel?
    var arrStudentlist = [GetStudentResultData]()
    var selectedStudentArrIndex : Int?
    var enrollmentId:Int?
    var classData : GetCommonDropdownModel!
    var selectedClassIndex = 0
    var selectedClassID : Int?
    var skip = Int()
    var isScrolling : Bool?
    var pageSize = KIntegerConstants.kInt10
    var pointNow:CGPoint!
    var isFetching:Bool?
    var isUnauthorizedUser = false
    var isStudentDelete = false
    var selectedSubjectArrIndex : Int?
    var isClassSelected : Bool?
    
    
    
    @IBOutlet weak var btnAddStudent: UIButton!
    @IBOutlet weak var dropDownTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackButton()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if checkInternetConnection(){
            arrStudentlist.removeAll()
            self.ViewModel?.studentList(classId : 0, Search: "", Skip: KIntegerConstants.kInt0, PageSize: pageSize)
            
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
        
    }
    
    @IBAction func BtnEditAction(_ sender: Any) {
        if arrStudentlist.count > 0{
            
            let data = arrStudentlist[(sender as AnyObject).tag]
            let vc = UIStoryboard.init(name: KStoryBoards.kStudent, bundle: Bundle.main).instantiateViewController(withIdentifier: KStoryBoards.KAddStudentIdentifiers.kAddStudentVC) as! AddStudentVC
            vc.enrollmentId = data.enrollmentId
            vc.studentUserId = data.studentUserId
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        
        if arrStudentlist.count > 0{
            let data = arrStudentlist[(sender as AnyObject).tag]
            selectedStudentArrIndex = (sender as AnyObject).tag
            enrollmentId = data.enrollmentId
            initializeCustomYesNoAlert(self.view, isHideBlurView: true)
            yesNoAlertView.delegate = self
            yesNoAlertView.lblResponseDetailMessage.text = Alerts.kDeleteClassAlert
            //                self.alertForRemoveStudent()
            
        }
        
        
    }
    
    
    @IBAction func AddStudentAction(_ sender: Any) {
        let vc = UIStoryboard.init(name: KStoryBoards.kStudent, bundle: Bundle.main).instantiateViewController(withIdentifier: KStoryBoards.KAddStudentIdentifiers.kAddStudentVC) as! AddStudentVC
        vc.studentId = 0
        vc.enrollmentId = 0
        vc.studentUserId = 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnOpenDropDown(_ sender: Any) {
        self.ViewModel?.getClassId(id: 0, enumtype: 6)
        
    }
    
    //Setup UI
    func setupUI(){
        
//        guard let theme = ThemeManager.shared.currentTheme else {return}
//        btnAddStudent.tintColor = theme.uiButtonBackgroundColor
        
        self.title = KStoryBoards.KAddStudentIdentifiers.kStudentListTitle
        self.ViewModel = StudentListViewModel.init(delegate: self)
        self.ViewModel?.attachView(viewDelegate: self)
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        SetpickerView(self.view)
        
        self.setSearchBarInNavigationController(placeholderText: KSearchBarPlaceHolder.kUserSearchBarStudentPlaceHolder, navigationTitle: KStoryBoards.KAddStudentIdentifiers.kStudentListTitle, navigationController: self.navigationController, navigationSearchBarDelegates: self)
    }
    
}

extension StudentListVC : OKAlertViewDelegate{
    
    //Ok Button Clicked
    func okBtnAction() {
        if isUnauthorizedUser == true{
            isUnauthorizedUser = false
            CommonFunctions.sharedmanagerCommon.setRootLogin()
        }else if isStudentDelete == true{
            isStudentDelete = false
            if let selectedIndex = self.selectedStudentArrIndex{
                self.arrStudentlist.remove(at: selectedIndex)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
        }
        okAlertView.removeFromSuperview()
    }
}

extension StudentListVC : YesNoAlertViewDelegate{
    
    func yesBtnAction() {
        if self.checkInternetConnection(){
            if let enrollmentId = self.enrollmentId{
                self.ViewModel?.deleteStudent(enrollmentId: enrollmentId)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Delete subject id is nil")
            }
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
        yesNoAlertView.removeFromSuperview()
        
    }
    
    func noBtnAction() {
        yesNoAlertView.removeFromSuperview()
    }
}


