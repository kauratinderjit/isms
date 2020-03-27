//
//  ClassListVC.swift
//  ISMS
//
//  Created by Taranjeet Singh on 6/18/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class ClassListVC: BaseUIViewController {

    //Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //Veriables
    var arr_Classlist = [GetClassListResultData]()
    var viewModel : ClassListViewModel?
    var selectedClassId : Int?
    var selectedClassArrIndex : Int?
    var isUnauthorizedUser = false
    var isClassDeleteSuccessfully = false
    var skip = Int()
    var isScrolling : Bool?
    var pageSize = KIntegerConstants.kInt10
    var pointNow:CGPoint!
    var isFetching:Bool?
     public var lstActionAccess : GetMenuFromRoleIdModel.ResultData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.viewModel = ClassListViewModel.init(delegate: self)
        self.viewModel?.attachView(viewDelegate: self)
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if checkInternetConnection(){
            self.viewModel?.isSearching = false
            self.viewModel?.classList(searchText: "", pageSize: pageSize, filterBy: 0, skip: KIntegerConstants.kInt0)
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.view.setNeedsLayout() // force update layout
        navigationController?.view.layoutIfNeeded() // to fix height of the navigation bar
    }
    
    //MARK:- Button Actions
    @IBAction func btnEditAction(_ sender: UIButton) {
        if arr_Classlist.count > 0{
            let data = arr_Classlist[sender.tag]
            selectedClassId = data.classId
            let vc = UIStoryboard.init(name: KStoryBoards.kClass, bundle: Bundle.main).instantiateViewController(withIdentifier: KStoryBoards.KAddClassIdentifiers.kAddClassVC) as! AddClassVC
            if let classId = selectedClassId{
                vc.classId = classId
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    @IBAction func btnDeleteClass(_ sender: UIButton) {
        if arr_Classlist.count  > 0{
            let data = arr_Classlist[sender.tag]
                selectedClassArrIndex = sender.tag
            selectedClassId = data.classId
            initializeCustomYesNoAlert(self.view, isHideBlurView: true)
            yesNoAlertView.delegate = self
            yesNoAlertView.lblResponseDetailMessage.text = Alerts.kDeleteClassAlert
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Count is not greter then zero.")
            }
    }

    @IBAction func btnAddClass(_ sender: UIButton) {
        let vc = UIStoryboard.init(name: KStoryBoards.kClass, bundle: Bundle.main).instantiateViewController(withIdentifier: KStoryBoards.KAddClassIdentifiers.kAddClassVC) as! AddClassVC
        vc.classId = 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARk:- View Delegate
extension ClassListVC : ViewDelegate{
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
    func setUI(){
        //Set Search bar in navigation
        self.setSearchBarInNavigationController(placeholderText: KSearchBarPlaceHolder.kUserSearchBarPlaceHolder, navigationTitle: KStoryBoards.KClassListIdentifiers.kClassListTitle, navigationController: self.navigationController, navigationSearchBarDelegates: self)
        //Set Back Button
        self.setBackButton()
        //Title
        self.title = KStoryBoards.KClassListIdentifiers.kClassListTitle
        self.tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
    }
}

//MARK:- Table view delagate
extension ClassListVC : UITableViewDelegate{
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
    }
}

//MARK:- Table view data source
extension ClassListVC : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arr_Classlist.count > 0{
                tableView.separatorStyle = .singleLine
            return (arr_Classlist.count)
        }else{
            tblViewCenterLabel(tblView: tableView, lblText: KConstants.kNoDataFound, hide: false)
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: KTableViewCellIdentifier.kClassTableViewCell, for: indexPath) as! ClassListTableViewCell
        cell.setCellUI(data: arr_Classlist, indexPath: indexPath)
        return cell
    }
}
//MARK:- Custom Ok Alert
extension ClassListVC : OKAlertViewDelegate{
    //Ok Button Clicked
    func okBtnAction() {
        self.okAlertView.removeFromSuperview()
        if isUnauthorizedUser == true{
            isUnauthorizedUser = false
            CommonFunctions.sharedmanagerCommon.setRootLogin()
        }
        if isClassDeleteSuccessfully == true {
            isClassDeleteSuccessfully = false
            if let selectedIndex = self.selectedClassArrIndex{
                self.arr_Classlist.remove(at: selectedIndex)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}
