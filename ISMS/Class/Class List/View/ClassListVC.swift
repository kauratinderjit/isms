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
    var arr_Classlist = [GetClassListByDeptResultData]()
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
    var HODdepartmentId = UserDefaultExtensionModel.shared.HODDepartmentId
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
            self.viewModel?.classList(departmentId: HODdepartmentId)
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
        tableView.separatorColor = KAPPContentRelatedConstants.kLightBlueColour
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
//MARK:- Custom Yes No Alert Delegate
extension ClassListVC : YesNoAlertViewDelegate{
    
    func yesBtnAction() {
        yesNoAlertView.removeFromSuperview()
        if self.checkInternetConnection(){
            if let classId = self.selectedClassId{
                self.viewModel?.deleteClass(classId: classId)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Delete Class id is nil")
            }
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
    }
    func noBtnAction() {
        yesNoAlertView.removeFromSuperview()
    }
}

//MARK:- Class Deleagate
extension ClassListVC : ClassListDelegate{
    func unauthorizedUser() {
        isUnauthorizedUser = true
        
    }
    func classDeleteDidSuccess(data: DeleteClassModel) {
        isClassDeleteSuccessfully = true
    }
    func classDeleteDidfailed() {
        isClassDeleteSuccessfully = false
    }
    func classListDidSuccess(data: [GetClassListByDeptResultData]?) {
        isFetching = true
        if data != nil{
            if data?.count ?? 0 > 0{
                for value in data!{
                    let containsSameValue = arr_Classlist.contains(where: {$0.classId == value.classId})
                    if containsSameValue == false{
                        arr_Classlist.append(value)
                    }
                    self.tblViewCenterLabel(tblView: tableView, lblText: "", hide: true)
                }
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Zero")
            }
        }else{
            CommonFunctions.sharedmanagerCommon.println(object: "Nil")
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    func classListDidFailed() {
        self.tableView.reloadData()
        tblViewCenterLabel(tblView: tableView, lblText: KConstants.kPleaseTryAgain, hide: false)
    }
}

//MARK:- UISearchController Bar Delegates
extension ClassListVC : NavigationSearchBarDelegate{
    
    func textDidChange(searchBar: UISearchBar, searchText: String) {
        viewModel?.isSearching = true
        arr_Classlist.removeAll()
        //        self.viewModel?.classList(searchText: searchText, pageSize: KIntegerConstants.kInt10, filterBy: 0, skip: KIntegerConstants.kInt0)
        
    }
    
    func cancelButtonPress(uiSearchBar: UISearchBar) {
        viewModel?.isSearching = false
        DispatchQueue.main.async {
            self.arr_Classlist.removeAll()
            //            self.viewModel?.classList(searchText: "", pageSize: KIntegerConstants.kInt10, filterBy: 0, skip: KIntegerConstants.kInt0)
        }
    }
}

//MARK:- Scroll View delegates
extension ClassListVC : UIScrollViewDelegate{
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        //        if(velocity.y>0) {
        //            //Code will work without the animation block.I am using animation block incase if you want to set any delay to it.
        //            UIView.animate(withDuration: 2.5, delay: 0, options: UIView.AnimationOptions(), animations: {
        //                self.navigationController?.setNavigationBarHidden(true, animated: true)
        //            }, completion: nil)
        //
        //        } else {
        //            UIView.animate(withDuration: 2.5, delay: 0, options: UIView.AnimationOptions(), animations: {
        //                self.navigationController?.setNavigationBarHidden(false, animated: true)
        //            }, completion: nil)
        //        }
        
        if (tableView.contentOffset.y < pointNow.y)
        {
            CommonFunctions.sharedmanagerCommon.println(object: "Down scroll view")
            isScrolling = true
        }
        else if (tableView.contentOffset.y + tableView.frame.size.height >= tableView.contentSize.height)
        {
            isScrolling = true
            if (isFetching == true)
            {
                skip = skip + KIntegerConstants.kInt10
                isFetching = false
                //                self.viewModel?.classList(searchText: "", pageSize: pageSize, filterBy: 0, skip: skip)
            }
        }else{
            CommonFunctions.sharedmanagerCommon.println(object: "Scrolling")
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        pointNow = scrollView.contentOffset
    }
    
}
