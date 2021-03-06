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

//MARK:- UISearchController Bar Delegates
extension TeacherListVC : NavigationSearchBarDelegate{
    
    func textDidChange(searchBar: UISearchBar, searchText: String) {
        viewModel?.isSearching = true
        arrTeacherlist.removeAll()
        self.viewModel?.teacherList(searchText: searchText, pageSize: KIntegerConstants.kInt10, filterBy: 0, skip: KIntegerConstants.kInt0)
    }
    func cancelButtonPress(uiSearchBar: UISearchBar) {
        viewModel?.isSearching = false
        DispatchQueue.main.async {
            self.arrTeacherlist.removeAll()
            self.viewModel?.teacherList(searchText: "", pageSize: KIntegerConstants.kInt10, filterBy: 0, skip: KIntegerConstants.kInt0)
        }
    }
}

//MARK:- Scroll View delegates
extension TeacherListVC : UIScrollViewDelegate{
    
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
//
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
                self.viewModel?.teacherList(searchText: "", pageSize: pageSize, filterBy: 0, skip: skip)
            }
        }else{
            CommonFunctions.sharedmanagerCommon.println(object: "Scrolling")
        }
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        pointNow = scrollView.contentOffset
    }
    
}

//MARK:- Teacher Deleagate
extension TeacherListVC : TeacherListDelegate{
    func submitSubstitute() {
        
    }
    
    func substituteTeacherListDidSuccess(data: [GetSubstituteTeacherData]?) {
        
    }
    
    
    func unauthorizedUser() {
        isUnauthorizedUser = true
    }
    func teacherListDidFailed() {
        tableView.reloadData()
        tblViewCenterLabel(tblView: tableView, lblText: KConstants.kPleaseTryAgain, hide: false)
    }
    func teacherDeleteDidSuccess(data: DeleteTeacherModel) {
        isTeacherDeleteSuccessfully = true
    }
    func teacherDeleteDidfailed() {
        isTeacherDeleteSuccessfully = false
    }
    func teacherListDidSuccess(data: [GetTeacherListResultData]?) {
        isFetching = true
        if data != nil{
            if data?.count ?? 0 > 0{
                for value in data!{
                    let containsSameValue = arrTeacherlist.contains(where: {$0.teacherId == value.teacherId})
                    if containsSameValue == false{
                        arrTeacherlist.append(value)
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
}
