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
     var classId : Int = 0
    var isScrolling : Bool?
    var pageSize = KIntegerConstants.kInt1000
    var pointNow:CGPoint!
    var isFetching:Bool?
   var selectedImageUrl : URL?
    var isClassAddSuccessFully = false
    var HODdepartmentId = UserDefaultExtensionModel.shared.HODDepartmentId
     var HODdepartmentName = UserDefaultExtensionModel.shared.HODDepartmentName
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
            self.viewModel?.classList(Search: "", Skip: KIntegerConstants.kInt0,PageSize: KIntegerConstants.kInt10,SortColumnDir: "",  SortColumn: "", ParticularId : HODdepartmentId)
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
    @IBAction func btnEditAction(_ sender: UIButton)
    {
        if arr_Classlist.count > 0
        {
             self.view.endEditing(true)
            let data = arr_Classlist[sender.tag]
            classId = data.classId ?? 0
            setupUI()
            initializeCustomTextFieldView(self.view, isHideBlurView: true)
            textFieldAlert.delegate = self
            self.textFieldAlert.lblTitle.text = "Update Class"
            self.textFieldAlert.BtnTxt.setTitle("Submit", for: .normal)
            self.viewModel?.getClassDetail(classId: classId ?? 0)
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
        self.view.endEditing(true)
        self.classId = 0
        setupUI()
        initializeCustomTextFieldView(self.view, isHideBlurView: true)
        textFieldAlert.delegate = self
        self.textFieldAlert.lblTitle.text = "Add Class"
        self.textFieldAlert.txtFieldVal.text = ""
        self.textFieldAlert.BtnTxt.setTitle("Add", for: .normal)
        self.textFieldAlert.btnCancel.setTitle("Cancel", for: .normal)
        self.textFieldAlert.btnCancel.cornerRadius = 4.0
        self.textFieldAlert.BtnTxt.cornerRadius = 4.0
//        let vc = UIStoryboard.init(name: KStoryBoards.kClass, bundle: Bundle.main).instantiateViewController(withIdentifier: KStoryBoards.KAddClassIdentifiers.kAddClassVC) as! AddClassVC
//        vc.classId = 0
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setUITextField(data: ClassDetailModel){
        self.textFieldAlert.txtFieldVal.text = data.resultData?.name
    }
    
    func setupUI(){
        self.textFieldAlert.txtFieldVal.SetTextFont(textSize: KTextSize.KSixteen, placeholderText: "ClassName")
        self.textFieldAlert.txtFieldVal.addViewCornerShadow(radius: 8, view: self.textFieldAlert.txtFieldVal)
        self.textFieldAlert.txtFieldVal.txtfieldPadding(leftpadding: 20, rightPadding: 0)
    }
}

extension ClassListVC : TextFieldAlertDelegate{
    func btnCancel() {
        textFieldAlert.removeFromSuperview()
    }
    
    
    func BtnTxt() {
        self.view.endEditing(true)
        if self.checkInternetConnection(){
            if classId != 0{
                if textFieldAlert.txtFieldVal.text != ""{
                    isClassAddSuccessFully = true
                    self.viewModel?.addUpdateClass(classid: classId, className:textFieldAlert.txtFieldVal.text, selectedDepartmentId: HODdepartmentId, departmentName: HODdepartmentName, description: "", others: "", imageUrl: selectedImageUrl)
//                    self.ViewModel?.addSubject(subjectName: textFieldAlert.txtFieldVal.text, subjectID: subjectId)
                    yesNoAlertView.removeFromSuperview()
                }
                else {
                    self.showAlert(alert: Alerts.kEmptySubjectName)
                }
                
            }else{
                if textFieldAlert.txtFieldVal.text != ""{
                    isClassAddSuccessFully = true
                  self.viewModel?.addUpdateClass(classid: 0, className:textFieldAlert.txtFieldVal.text, selectedDepartmentId: HODdepartmentId, departmentName: HODdepartmentName, description: "", others: "", imageUrl: selectedImageUrl)
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
        self.setSearchBarInNavigationController(placeholderText: "Search Class", navigationTitle: KStoryBoards.KClassListIdentifiers.kClassListTitle, navigationController: self.navigationController, navigationSearchBarDelegates: self)
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
            
            tblViewCenterLabel(tblView: tableView, lblText: KConstants.kNoDataFound, hide: true)
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
        if isUnauthorizedUser == true{
            isUnauthorizedUser = false
            CommonFunctions.sharedmanagerCommon.setRootLogin()
        }else if isClassAddSuccessFully == true{
            
            isClassAddSuccessFully = false
            textFieldAlert.removeFromSuperview()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }else if isClassDeleteSuccessfully == true {
            isClassDeleteSuccessfully = false
            if let selectedIndex = self.selectedClassArrIndex{
                self.arr_Classlist.remove(at: selectedIndex)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    }
                }
            }
         self.okAlertView.removeFromSuperview()
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
    
    func getClassDetailDidSucceed(data: ClassDetailModel) {
       setUITextField(data: data)
    }
    func classDeleteDidSuccess(data: DeleteClassModel) {
        isClassDeleteSuccessfully = true
    }
    func classDeleteDidfailed() {
        isClassDeleteSuccessfully = false
    }
    func classListDidSuccess(data: [GetClassListResultData]?){
        isFetching = true
       // arr_Classlist.removeAll()
        if data != nil
        {
            if data?.count ?? 0 > 0
            {
                for value in data!
                {
                    let containsSameValue = arr_Classlist.contains(where: {$0.classId == value.classId})
                    if containsSameValue == false
                    {
                        arr_Classlist.append(value)
                    }
                    
                    
                    self.tblViewCenterLabel(tblView: tableView, lblText: "", hide: true)
                }
                
                
            }
            else
            {
                CommonFunctions.sharedmanagerCommon.println(object: "Zero")
                tblViewCenterLabel(tblView: tableView, lblText: KConstants.kNoDataFound, hide: false)
            }
        }
        else
        {
            CommonFunctions.sharedmanagerCommon.println(object: "Nil")
            tblViewCenterLabel(tblView: tableView, lblText: KConstants.kNoDataFound, hide: false)
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
                self.viewModel?.classList(Search: searchText, Skip: KIntegerConstants.kInt0,PageSize: KIntegerConstants.kInt10,SortColumnDir: "",  SortColumn: "", ParticularId : HODdepartmentId)
        
    }
    
    func cancelButtonPress(uiSearchBar: UISearchBar) {
        viewModel?.isSearching = false
        DispatchQueue.main.async {
            self.arr_Classlist.removeAll()
            self.viewModel?.classList(Search: "", Skip: KIntegerConstants.kInt0,PageSize: KIntegerConstants.kInt10,SortColumnDir: "",  SortColumn: "", ParticularId : self.HODdepartmentId)
//                        self.viewModel?.classList(searchText: "", pageSize: KIntegerConstants.kInt10, filterBy: 0, skip: KIntegerConstants.kInt0)
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
                
                self.viewModel?.classList(Search: "", Skip: skip,PageSize: pageSize,SortColumnDir: "",  SortColumn: "", ParticularId : HODdepartmentId)
                
            }
        }else{
            CommonFunctions.sharedmanagerCommon.println(object: "Scrolling")
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        pointNow = scrollView.contentOffset
    }
    
}

