//
//  ResultListVC.swift
//  ISMS
//
//  Created by Poonam  on 26/06/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//


import UIKit

class ResultListVC: BaseUIViewController {

    //Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //Veriables
    var arr_Classlist = [GetClassListResultData]()
    var arrResultList = [GetListResultData]()
    var viewModel : ClassListViewModel?
    var selectedResultId : Int?
    var selectedResultArrIndex : Int?
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
            self.viewModel?.ResultList(Search: "", Skip: KIntegerConstants.kInt0,PageSize: KIntegerConstants.kInt10,SortColumnDir: "",  SortColumn: "", ParticularId : 0)
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
        self.view.endEditing(true)
        let data = arrResultList[(sender as AnyObject).tag]
        let storyboard = UIStoryboard.init(name: "Result", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddResultVC") as? AddResultVC
        vc?.isResultEditing = true
        vc?.arr_resulrListReq = data
        let frontVC = revealViewController().frontViewController as? UINavigationController
        frontVC?.pushViewController(vc!, animated: false)
        revealViewController().pushFrontViewController(frontVC, animated: true)
    }

    @IBAction func btnDeleteClass(_ sender: UIButton) {
        if arrResultList.count  > 0{
            let data = arrResultList[sender.tag]
                selectedResultArrIndex = sender.tag
            selectedResultId = data.ResultId
            initializeCustomYesNoAlert(self.view, isHideBlurView: true)
            yesNoAlertView.delegate = self
            yesNoAlertView.lblResponseDetailMessage.text = "Do you really want to delete this Result."
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Count is not greter then zero.")
            }
    }

    @IBAction func btnAddClass(_ sender: UIButton) {
        self.view.endEditing(true)
        let vc = UIStoryboard.init(name: "Result", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddResultVC") as! AddResultVC
        vc.isResultEditing = false
        self.navigationController?.pushViewController(vc, animated: true)
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

extension ResultListVC : TextFieldAlertDelegate{
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
extension ResultListVC : ViewDelegate{
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
        self.title = "Result List"
        self.tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.separatorColor = KAPPContentRelatedConstants.kLightBlueColour
    }
}

//MARK:- Table view delagate
extension ResultListVC : UITableViewDelegate{
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
    }
}

//MARK:- Table view data source
extension ResultListVC : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrResultList.count > 0{
                tableView.separatorStyle = .singleLine
            
            tblViewCenterLabel(tblView: tableView, lblText: KConstants.kNoDataFound, hide: true)
            return (arrResultList.count)
            
        }else{
            tblViewCenterLabel(tblView: tableView, lblText: KConstants.kNoDataFound, hide: false)
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as! resultListCell
        cell.setCellUI(data: arrResultList, indexPath: indexPath)
        return cell
    }
}
//MARK:- Custom Ok Alert
extension ResultListVC : OKAlertViewDelegate{
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
            if let selectedIndex = self.selectedResultArrIndex{
                self.arrResultList.remove(at: selectedIndex)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    }
                }
            }
         self.okAlertView.removeFromSuperview()
        }
}

//MARK:- Custom Yes No Alert Delegate
extension ResultListVC : YesNoAlertViewDelegate{
    
    func yesBtnAction() {
        yesNoAlertView.removeFromSuperview()
        if self.checkInternetConnection(){
            if let resultId = self.selectedResultId{
                self.viewModel?.deleteResult(resultId: resultId)
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
extension ResultListVC : ClassListDelegate{
//    func deleteResult(){
//        tableView.reloadData()
//    }
    
    func resultListDidSuccess(data: [GetListResultData]?) {
        if data!.count > 0{
             arrResultList = data!
            tableView.reloadData()
        }
    }
    
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
extension ResultListVC : NavigationSearchBarDelegate{
    
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
extension ResultListVC : UIScrollViewDelegate{
    
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

