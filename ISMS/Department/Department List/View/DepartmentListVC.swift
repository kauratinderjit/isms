//
//  DepartmentListVC.swift
//  ISMS
//
//  Created by Taranjeet Singh on 6/17/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit
import AMScrollingNavbar

class DepartmentListVC: BaseUIViewController {

    //MARK:- Properties
    @IBOutlet weak var tableView: UITableView!
    
    //Variables
    var arrDepartmentlist = [GetDepartmentListResultData]()
    var viewModel : DepartmentListViewModel?
    var selectedDepartmentId : Int?
    var selectedDepartmentArrIndex : Int?
    var scrollHideNavigationBar : ScrollingNavigationViewController?
    var isUnauthorizedUser = false
    var isDepartmentDeleteSuccessfully = false
    var skip = Int()
    var isScrolling : Bool?
    var pageSize = KIntegerConstants.kInt10
    var pointNow:CGPoint!
    var isFetching:Bool?
    public var lstActionAccess : GetMenuFromRoleIdModel.ResultData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getDepartmentListApi()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.view.setNeedsLayout() // force update layout
        navigationController?.view.layoutIfNeeded() // to fix height of the navigation bar
    }
    
    
    //MARK:- Button Actions
    @IBAction func btnEditAction(_ sender: UIButton) {
            if arrDepartmentlist.count > 0{
                let data = arrDepartmentlist[sender.tag]
                selectedDepartmentId = data.departmentId
                let vc = UIStoryboard.init(name: KStoryBoards.kDepartment, bundle: Bundle.main).instantiateViewController(withIdentifier: KStoryBoards.KAddDepartMentIdentifiers.kAddDepartmentVC) as! AddDepartmentVC
                if let departmentId = selectedDepartmentId{
                    vc.departmentId = departmentId
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Count is not greter then zero.")
            }
    }
    
    @IBAction func btnDeleteDepartment(_ sender: UIButton) {
            if arrDepartmentlist.count > 0{
                let data = arrDepartmentlist[sender.tag]
                selectedDepartmentArrIndex = sender.tag
                selectedDepartmentId = data.departmentId
                initializeCustomYesNoAlert(self.view, isHideBlurView: true)
                yesNoAlertView.delegate = self
                yesNoAlertView.lblResponseDetailMessage.text = Alerts.kDeleteDepartmentAlert
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Delete department Count is not greter then zero.")
            }
    }
    
    @IBAction func btnAddDepartment(_ sender: UIButton) {
        let vc = UIStoryboard.init(name: KStoryBoards.kDepartment, bundle: Bundle.main).instantiateViewController(withIdentifier: KStoryBoards.KAddDepartMentIdentifiers.kAddDepartmentVC) as! AddDepartmentVC
        vc.departmentId = 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
 
    //Get Department List
    func getDepartmentListApi(){
        if checkInternetConnection(){
            self.viewModel?.departmentList(searchText: "", pageSize: pageSize, filterBy: 0, skip: KIntegerConstants.kInt0)
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
    }
}



//MARk:- View Delegate
extension DepartmentListVC : ViewDelegate{
    func setUI(){
        //Initiallize memory for ViewModel
        self.viewModel = DepartmentListViewModel.init(delegate: self)
        self.viewModel?.attachView(viewDelegate: self)
        //Set Search bar in navigation
        self.setSearchBarInNavigationController(placeholderText: KSearchBarPlaceHolder.kUserSearchBarPlaceHolder, navigationTitle: KStoryBoards.KDepartMentListIdentifiers.kDepartmentListTitle, navigationController: self.navigationController, navigationSearchBarDelegates: self)
        //Title
        self.title = KStoryBoards.KDepartMentListIdentifiers.kDepartmentListTitle
        setBackButton()
        //Table View Settings
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.separatorColor = KAPPContentRelatedConstants.kLightBlueColour
    }
    
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
extension DepartmentListVC : UITableViewDelegate{

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
    }
    
}

//MARK:- Table view data source
extension DepartmentListVC : UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            if arrDepartmentlist.count > 0{
                tableView.separatorStyle = .singleLine
                return (arrDepartmentlist.count)
            }else{
                tblViewCenterLabel(tblView: tableView, lblText: "No data found.", hide: false)
                return 0
            }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: KTableViewCellIdentifier.kDepartmentTableViewCell, for: indexPath) as! DepartmentTableViewCell
        cell.setCellUI(data: arrDepartmentlist, indexPath: indexPath)
        return cell
    }
}

//MARK:- Custom Yes No Alert Delegate
extension DepartmentListVC : YesNoAlertViewDelegate{
    
    func yesBtnAction() {
        yesNoAlertView.removeFromSuperview()
        if let selectedDeptId = self.selectedDepartmentId{
            self.viewModel?.deleteDepartment(departmentId: selectedDeptId)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    func noBtnAction() {
        yesNoAlertView.removeFromSuperview()
    }
}


//MARK:- Custom Ok Alert
extension DepartmentListVC : OKAlertViewDelegate{
    
    //Ok Button Clicked
    func okBtnAction() {
        
        okAlertView.removeFromSuperview()
        if isUnauthorizedUser == true{
            isUnauthorizedUser = false
            CommonFunctions.sharedmanagerCommon.setRootLogin()
        }
        if isDepartmentDeleteSuccessfully == true {
            isDepartmentDeleteSuccessfully = false
            if let selectedIndex = self.selectedDepartmentArrIndex{
                self.arrDepartmentlist.remove(at: selectedIndex)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}

