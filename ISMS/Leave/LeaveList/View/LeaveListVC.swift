//
//  LeaveListVC.swift
//  ISMS
//
//  Created by Poonam  on 08/06/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import UIKit

class LeaveListVC: BaseUIViewController {

    @IBOutlet weak var btnAddReqLeave: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel : LeaveListViewModel?
    var isUnauthorizedUser = false
    var HODdepartmentId = UserDefaultExtensionModel.shared.HODDepartmentId
    var arrLeaveList = [GetLeaveListResultData]()
    var isScrolling : Bool?
    var pageSize = KIntegerConstants.kInt1000
    var pointNow:CGPoint!
    var isFetching:Bool?
      var skip = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.viewModel = LeaveListViewModel.init(delegate: self)
        self.viewModel?.attachView(viewDelegate: self)
      if UserDefaultExtensionModel.shared.currentUserRoleId == 2{
            btnAddReqLeave.isHidden = true
            }
        setUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if checkInternetConnection(){
            self.viewModel?.isSearching = false
            self.viewModel?.LeaveList(Search: "", Skip: KIntegerConstants.kInt0,PageSize: KIntegerConstants.kInt10,SortColumnDir: "",  SortColumn: "", ParticularId : HODdepartmentId)
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
    }
  
    @IBAction func actionLeaveEditBtn(_ sender: Any) {
        self.view.endEditing(true)
        let data = arrLeaveList[(sender as AnyObject).tag]
        let storyboard = UIStoryboard.init(name: "Leave", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddLeaveReqVC") as? AddLeaveReqVC
        vc?.isLeaveEditing = true
        vc?.arrLeaveListReq = data
        let frontVC = revealViewController().frontViewController as? UINavigationController
        frontVC?.pushViewController(vc!, animated: false)
        revealViewController().pushFrontViewController(frontVC, animated: true)
    }
    
    @IBAction func actionAddLeaveReq(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Leave", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddLeaveReqVC") as? AddLeaveReqVC
         vc?.isLeaveEditing = false
        let frontVC = revealViewController().frontViewController as? UINavigationController
        frontVC?.pushViewController(vc!, animated: false)
        revealViewController().pushFrontViewController(frontVC, animated: true)
    }
    
}
//MARk:- View Delegate
extension LeaveListVC : ViewDelegate{
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
          //Set Back Button
          self.setBackButton()
          //Title
          self.title = "Leave"
          self.tableView.tableFooterView = UIView()
          tableView.separatorStyle = .none
          tableView.separatorColor = KAPPContentRelatedConstants.kLightBlueColour
      }
}

//MARK:- leave Deleagate
extension LeaveListVC : LeaveListDelegate{
    func leaveListDidSuccess(data: [GetLeaveListResultData]?) {
         isFetching = true
        if data?.count ?? 0>0{
            arrLeaveList = data!
        }
        tableView.reloadData()
    }
    
    func unauthorizedUser() {
        isUnauthorizedUser = true
    }

    func leaveListDidFailed() {
        self.tableView.reloadData()
        tblViewCenterLabel(tblView: tableView, lblText: KConstants.kPleaseTryAgain, hide: false)
    }
}
//MARK:- Custom Ok Alert
extension LeaveListVC : OKAlertViewDelegate{
    //Ok Button Clicked
    func okBtnAction() {
        if isUnauthorizedUser == true{
            isUnauthorizedUser = false
            CommonFunctions.sharedmanagerCommon.setRootLogin()
        }
         self.okAlertView.removeFromSuperview()
        }
}
//MARK:- Table view delagate
extension LeaveListVC : UITableViewDelegate{
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
    }
}

//MARK:- Table view data source
extension LeaveListVC : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrLeaveList.count > 0{
                tableView.separatorStyle = .singleLine
            
            tblViewCenterLabel(tblView: tableView, lblText: KConstants.kNoDataFound, hide: true)
            return (arrLeaveList.count)
            
        }else{
            tblViewCenterLabel(tblView: tableView, lblText: KConstants.kNoDataFound, hide: false)
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "leaveCell", for: indexPath) as! LeaveTableCell
        cell.setCellUI(data: arrLeaveList, indexPath: indexPath)
        return cell
    }
}
//MARK:- Scroll View delegates
extension LeaveListVC : UIScrollViewDelegate{
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
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
                
                self.viewModel?.LeaveList(Search: "", Skip: skip,PageSize: pageSize,SortColumnDir: "",  SortColumn: "", ParticularId : HODdepartmentId)
                
            }
        }else{
            CommonFunctions.sharedmanagerCommon.println(object: "Scrolling")
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        pointNow = scrollView.contentOffset
    }
    
}
