//
//  TeacherListVC.swift
//  ISMS
//
//  Created by Taranjeet Singh on 6/20/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class TeacherListVC: BaseUIViewController {
    //Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnAddTeacher: UIButton!
    
    @IBOutlet weak var btnAdd: UIButton!
    //Variables
    var arrTeacherlist = [GetTeacherListResultData]()
    var viewModel : TeacherListViewModel?
    var selectedTeacherId : Int?
    var selectedTeacherArrIndex : Int?
    var isUnauthorizedUser = false
    var isTeacherDeleteSuccessfully = false
    var skip = Int()
    var isScrolling : Bool?
    var pageSize = KIntegerConstants.kInt10
    var pointNow:CGPoint!
    var isFetching:Bool?
    var isEdit:Bool = false
    var isDelete:Bool = false
    public var lstActionAccess : GetMenuFromRoleIdModel.ResultData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //Initiallize memory for view model
        self.viewModel = TeacherListViewModel.init(delegate: self)
        self.viewModel?.attachView(viewDelegate: self)
        DispatchQueue.main.async {
            self.setUI()
        }
        btnAdd.isHidden = true
        SetViewAccordingToResponce()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        arrTeacherlist.removeAll()
        teacherListApi()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.view.setNeedsLayout() // force update layout
        navigationController?.view.layoutIfNeeded() // to fix height of the navigation bar
//        setNavigationBarHeight()
    }

    //SetView
    func SetViewAccordingToResponce()
    {
        if(lstActionAccess?.lstActionAccess != nil)
        {
            for resultData in (lstActionAccess?.lstActionAccess)!
            {
                switch resultData.actionName
                {
                case KAccessIntitifiers.kAdd:
                    btnAdd.isHidden = false
                    break
                case KAccessIntitifiers.kEdit:
                    isEdit = true
              
                    break
                case KAccessIntitifiers.kDelete:
                    isDelete = true
                    break
                default:
                    print(Alerts.kNoRecordFound)
                    break
                }
            }
            
        }
        
    }
    //TeacherListApi
    func teacherListApi(){
        if checkInternetConnection(){
            self.viewModel?.isSearching = false
            self.viewModel?.teacherList(searchText: "", pageSize: pageSize, filterBy: 0, skip: KIntegerConstants.kInt0)
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
    }
    
    //Set Ui
    func setUI(){
        
        //Set Search bar in navigation
        self.setSearchBarInNavigationController(placeholderText: KSearchBarPlaceHolder.kUserSearchBarPlaceHolder, navigationTitle: KStoryBoards.KTeacherListIdentifiers.kTeacherListTitle, navigationController: self.navigationController, navigationSearchBarDelegates: self)
        setBackButton()
        
        //Title
        self.title = KStoryBoards.KTeacherListIdentifiers.kTeacherListTitle
        
        //Table View Settings
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.separatorColor = KAPPContentRelatedConstants.kLightBlueColour
        
        //Set Color According To Theme
        guard let theme = ThemeManager.shared.currentTheme else{return}
        btnAddTeacher.tintColor = theme.uiButtonBackgroundColor
    }
    //MARK:- Button Actions
    @IBAction func btnEditAction(_ sender: UIButton) {
            if arrTeacherlist.count > 0{
                let data = arrTeacherlist[sender.tag]
                selectedTeacherId = data.teacherId
                let vc = UIStoryboard.init(name: KStoryBoards.kTeacher, bundle: Bundle.main).instantiateViewController(withIdentifier: KStoryBoards.KAddTeacherIdentifiers.kAddTeacherVC) as! AddTeacherVC
                if let teacherId = selectedTeacherId{
                    vc.teacherID = teacherId
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
    }
    
    @IBAction func btnDeleteClass(_ sender: UIButton) {
            if arrTeacherlist.count > 0{
                let data = arrTeacherlist[sender.tag]
                selectedTeacherArrIndex = sender.tag
                selectedTeacherId = data.teacherId
                initializeCustomYesNoAlert(self.view, isHideBlurView: true)
                yesNoAlertView.delegate = self
                yesNoAlertView.lblResponseDetailMessage.text = Alerts.kDeleteTeacherAlert
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Delete department Count is not greter then zero.")
        }
    }
    
    @IBAction func btnAddHOD(_ sender: UIButton) {
        
        let vc = UIStoryboard.init(name: KStoryBoards.kTeacher, bundle: Bundle.main).instantiateViewController(withIdentifier: KStoryBoards.KAddTeacherIdentifiers.kAddTeacherVC) as! AddTeacherVC
        vc.teacherID = 0
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
//MARk:- View Delegate
extension TeacherListVC : ViewDelegate{
    
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

//MARK:- Table view delagate
extension TeacherListVC : UITableViewDelegate{

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
    }
    
}

//MARK:- Table view data source
extension TeacherListVC : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrTeacherlist.count > 0{
            tableView.separatorStyle = .singleLine
            return (arrTeacherlist.count)
        }else{
            tblViewCenterLabel(tblView: tableView, lblText: KConstants.kNoDataFound, hide: false)
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: KTableViewCellIdentifier.kTeacherTableViewCell, for: indexPath) as! TeacherListTableViewCell
        cell.setCellUI(data: arrTeacherlist, indexPath: indexPath,isEdit:isEdit,isDelete: isDelete)
        return cell
    }
}

//MARK:- Custom Ok Alert
extension TeacherListVC : OKAlertViewDelegate{
    
    //Ok Button Clicked
    func okBtnAction() {
        okAlertView.removeFromSuperview()
        if isUnauthorizedUser == true{
            isUnauthorizedUser = false
            CommonFunctions.sharedmanagerCommon.setRootLogin()
        }
        if isTeacherDeleteSuccessfully == true {
            isTeacherDeleteSuccessfully = false
            if let selectedIndex = self.selectedTeacherArrIndex{
                self.arrTeacherlist.remove(at: selectedIndex)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}

//MARK:- Custom Yes No Alert Delegate
extension TeacherListVC : YesNoAlertViewDelegate{
    func yesBtnAction() {
        yesNoAlertView.removeFromSuperview()
        if self.checkInternetConnection(){
            if let teacherId = self.selectedTeacherId{
                self.viewModel?.deleteTeacher(teacherId: teacherId)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Delete Teacher id is nil")
            }
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
    }
    func noBtnAction() {
        yesNoAlertView.removeFromSuperview()
    }
}

