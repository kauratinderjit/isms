//
//  HODListVC.swift
//  ISMS
//
//  Created by Taranjeet Singh on 6/19/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class HODListVC: BaseUIViewController {
    //OUTLETS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnAddHod: UIButton!
    
    //VARIABLES
    var arrHODlist = [GetHodListResultData]()
    var viewModel : HODListViewModel?
    var selectedHODId : Int?
    var selectedHODArrIndex : Int?
    var isUnauthorizedUser = false
    var isHODDeleteSuccessfully = false
    var skip = Int()
    var isScrolling : Bool?
    var pageSize = KIntegerConstants.kInt10
    var pointNow:CGPoint!
    var isFetching:Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.viewModel = HODListViewModel.init(delegate: self)
        self.viewModel?.attachView(viewDelegate: self)
        setUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if checkInternetConnection(){
            self.viewModel?.isSearching = false
            arrHODlist.removeAll()
            self.viewModel?.hodList(searchText: "", pageSize: pageSize, filterBy: 0, skip: KIntegerConstants.kInt0)
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
            if arrHODlist.count > 0{
                let data = arrHODlist[sender.tag]
                selectedHODId = data.hodId
                let vc = UIStoryboard.init(name: KStoryBoards.kHOD, bundle: Bundle.main).instantiateViewController(withIdentifier: KStoryBoards.KAddHODIdentifiers.kAddHODVC) as! AddHODVC
                if let hodId = selectedHODId{
                    vc.hodID = hodId
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
    }
    
    @IBAction func btnDeleteClass(_ sender: UIButton) {
            if arrHODlist.count > 0{
                let data = arrHODlist[sender.tag]
                selectedHODArrIndex = sender.tag
                selectedHODId = data.hodId
                initializeCustomYesNoAlert(self.view, isHideBlurView: true)
                self.yesNoAlertView.delegate = self
                yesNoAlertView.lblResponseDetailMessage.text = Alerts.kDeleteHODAlert
            }
    }
    
    @IBAction func btnAddHOD(_ sender: UIButton) {
        let vc = UIStoryboard.init(name: KStoryBoards.kHOD, bundle: Bundle.main).instantiateViewController(withIdentifier: KStoryBoards.KAddHODIdentifiers.kAddHODVC) as! AddHODVC
        vc.hodID = 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
//MARk:- View Delegate
extension HODListVC : ViewDelegate{
    
    func setUI(){
        
        setBackButton()
        //Set Search bar in navigation
        self.setSearchBarInNavigationController(placeholderText: KSearchBarPlaceHolder.kUserSearchBarPlaceHolder, navigationTitle: KStoryBoards.KHODListIdentifiers.kHODListTitle, navigationController: self.navigationController, navigationSearchBarDelegates: self)
        
        //Title
        self.title = KStoryBoards.KHODListIdentifiers.kHODListTitle
        
        //Table View Settings
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        
//        guard let theme = ThemeManager.shared.currentTheme else {return}
//        btnAddHod.backgroundColor = theme.uiButtonBackgroundColor
        
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
extension HODListVC : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
    }
    
}

//MARK:- Table view data source
 extension HODListVC : UITableViewDataSource{
    
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            if arrHODlist.count > 0{
                tableView.separatorStyle = .singleLine
                return (arrHODlist.count)
            }else{
                tblViewCenterLabel(tblView: tableView, lblText: KConstants.kNoDataFound, hide: true)
                return 0
            }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: KTableViewCellIdentifier.kHodTableViewCell, for: indexPath) as! HODListTableViewCell
        cell.setCellUI(data: arrHODlist, indexPath: indexPath)
        return cell
    }
}

//MARK:- Custom Ok Alert
extension HODListVC : OKAlertViewDelegate{
    
    //Ok Button Clicked
    func okBtnAction() {
        
        self.okAlertView.removeFromSuperview()
        if isUnauthorizedUser == true{
            isUnauthorizedUser = false
            CommonFunctions.sharedmanagerCommon.setRootLogin()
        }
        if isHODDeleteSuccessfully == true {
            isHODDeleteSuccessfully = false
            if let selectedIndex = self.selectedHODArrIndex{
                self.arrHODlist.remove(at: selectedIndex)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}

//MARK:- Custom Yes No Alert Delegate
extension HODListVC : YesNoAlertViewDelegate{
    
    func yesBtnAction() {
        
        yesNoAlertView.removeFromSuperview()
        
        if self.checkInternetConnection(){
            if let hodId = self.selectedHODId{
                self.viewModel?.deleteHOD(hodId: hodId)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Delete Hod id is nil")
            }
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
        
    }
    
    func noBtnAction() {
        yesNoAlertView.removeFromSuperview()
    }
}
