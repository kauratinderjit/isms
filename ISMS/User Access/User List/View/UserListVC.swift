//
//  UserListVC.swift
//  ISMS
//
//  Created by Taranjeet Singh on 6/25/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class UserListVC: BaseUIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel : UserListViewModel?
    var selectedIndex = Int()
    var selectedValueFromDropdown = 0
    var arrUserlist = [GetAllUserByRoleIdResultData]()
    var dropdownData : GetCommonDropdownModel!
    var arrSearchUserList : GetAllUserByRoleIdModel?
    var arrDropDown = [KConstants.kHod,KConstants.kTeacher,"Student","Parent"]
    var isUnauthorizedUser = false
    var searchBar : UISearchBar?
    var skip = Int()
    var isScrolling : Bool?
    var pageSize = KIntegerConstants.kInt10
    var pointNow:CGPoint!
    var isFetching:Bool?
    var isStartSearching = false
    
    @IBOutlet weak var txtFieldSelectRole: UITextField!
    
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.viewModel = UserListViewModel.init(delegate: self)
        self.viewModel?.attachView(viewDelegate: self)
        setView()
        isScrolling = false
        if checkInternetConnection(){
            self.viewModel?.userList(searchText: "", pageSize: pageSize, filterBy: selectedValueFromDropdown, skip: KIntegerConstants.kInt0)
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.view.setNeedsLayout() // force update layout
        navigationController?.view.layoutIfNeeded() // to fix height of the navigation bar
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    //MARK:- Button Actions
    @IBAction func btnDropdownForRoleTypeAction(_ sender: UIButton) {
        if checkInternetConnection() {
            let index = CommonFunctions.sharedmanagerCommon.getIndexOfPickerModelObject(data: arrDropDown, pickerTextfieldString: txtFieldSelectRole.text)
            UpdatePickerModel2(count: arrDropDown.count, sharedPickerDelegate: self, View: self.view, index: index)
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
    }
    
    @IBAction func btnMoveToUserAccessRoles(_ sender: UIButton) {
        if arrUserlist.count > 0 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: KStoryBoards.KUserAccessRoleIdentifiers.kUserAccessVC) as! UserAccessRoleVC
            if let userID = arrUserlist[sender.tag].userId,let roleId = arrUserlist[sender.tag].roleId{
                vc.roleId = roleId
                vc.userId = userID
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            CommonFunctions.sharedmanagerCommon.println(object: "Dropdown is zero.")
        }
    }
}


//MARk:- View Delegate
extension UserListVC : ViewDelegate{
    
    
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
    
    //Set the view
    func setView(){
        self.title = KStoryBoards.KUserListIdentifiers.kUserListTitle
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        self.SetpickerView(self.view)
        txtFieldSelectRole.text = arrDropDown[0]
        selectedValueFromDropdown = 2
        setBackButton()
        //Set Search bar in navigation
        self.setSearchBarInNavigationController(placeholderText: KSearchBarPlaceHolder.kUserSearchBarPlaceHolder, navigationTitle: KStoryBoards.KUserListIdentifiers.kUserListTitle, navigationController: self.navigationController, navigationSearchBarDelegates: self)
    }
    
}

//MARK:- Table view delagate
extension UserListVC : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
    }
    
}

//MARK:- Table view data source
extension UserListVC : UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrUserlist.count > KIntegerConstants.kInt0{
            tableView.separatorStyle = .singleLine
            return (arrUserlist.count)
        }else{
            tblViewCenterLabel(tblView: tableView, lblText: KConstants.kNoDataFound, hide: false)
            return KIntegerConstants.kInt0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: KTableViewCellIdentifier.kUserAccessTableViewCell, for: indexPath) as! UserListTableViewCell
        cell.setCellUI(data: arrUserlist, indexPath: indexPath)
        return cell
    }
    
}


//MARK:- Custom Ok Alert
extension UserListVC : OKAlertViewDelegate{
    
    //Ok Button Clicked
    func okBtnAction() {
        okAlertView.removeFromSuperview()
        if isUnauthorizedUser == true{
            isUnauthorizedUser = false
            CommonFunctions.sharedmanagerCommon.setRootLogin()
        }
    }
}
