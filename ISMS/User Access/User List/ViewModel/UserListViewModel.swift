//
//  UserListPresenter.swift
//  ISMS
//
//  Created by Taranjeet Singh on 6/25/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

protocol UserListDelegate: class {
    func userListDidSuccess(data : [GetAllUserByRoleIdResultData]?)
    func userUnauthorize()
    func userListDidFailed()
    func getDropdownSucceed(data: GetCommonDropdownModel)
}

import Foundation

class UserListViewModel{
    var isSearching : Bool?
    
    //Global ViewDelegate weak object
    private weak var userListView : ViewDelegate?
    
    //UserListDelegate weak object
    private weak var userListDelegate : UserListDelegate?
    
    //Initiallize the presenter class using delegates
    init(delegate: UserListDelegate) {
        userListDelegate = delegate
    }
    
    //Attach GlobalViewDelegate
    func attachView(viewDelegate : ViewDelegate){
        userListView = viewDelegate
    }
    
    //Deattach View for free the memory from instances
    func deattachView(){
        userListView = nil
        userListDelegate = nil
    }
    //MARK:- User list
    func userList(searchText: String,pageSize : Int,filterBy: Int,skip: Int){
        
        if isSearching == false{
            self.userListView?.showLoader()
        }
        var postDict = [String:Any]()
        
        postDict[KApiParameters.KCommonParametersForList.kSearch] = searchText
        postDict[KApiParameters.KCommonParametersForList.kPageSize] = pageSize
        postDict[KApiParameters.KCommonParametersForList.kSortColumn] = ""
        postDict[KApiParameters.KCommonParametersForList.kSkip] = skip
        postDict[KApiParameters.KCommonParametersForList.kFilterBy] = filterBy
        postDict[KApiParameters.KCommonParametersForList.kSortColumnDir] = KConstants.kDesc
        
        UserAccessApi.sharedInstance.getUserListByRoleId(url: ApiEndpoints.kUserListByRoleId, parameters: postDict, completionResponse: { (userListModel) in
            
            self.userListView?.hideLoader()
            
            switch userListModel.statusCode{
            case KStatusCode.kStatusCode200:
                self.userListDelegate?.userListDidSuccess(data: userListModel.resultData)
            case KStatusCode.kStatusCode401:
                if let msg = userListModel.message{
                    self.userListView?.showAlert(alert: msg)
                }
                self.userListDelegate?.userUnauthorize()
            default:
                self.userListView?.showAlert(alert: userListModel.message ?? "")
                CommonFunctions.sharedmanagerCommon.println(object: "User List api status change.")
            }
            
        }, completionnilResponse: { (nilResponseError) in
            
            self.userListView?.hideLoader()
            self.userListDelegate?.userListDidFailed()
            
            if let error = nilResponseError{
                self.userListView?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "User List APi Nil response")
            }
            
        }) { (error) in
            self.userListView?.hideLoader()
            self.userListDelegate?.userListDidFailed()
            if let err = error?.localizedDescription{
                self.userListView?.showAlert(alert: err)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "user List APi error response")
            }
        }
    }
    
    
    //MARK:- Get HOD/Teacher Dropdown
    func getHodTeacherDropdown(selectedhodTeacherId: Int?,enumtype: Int?){
        
        guard let selectId = selectedhodTeacherId else{ return }
        guard let enumType = enumtype else { return }
        
        self.userListView?.showLoader()
        
        UserAccessApi.sharedInstance.getHodTeacherDropdownData(selectedHodTeacherId: selectId, enumType: enumType, completionResponse: { (responseModel) in
            
            self.userListDelegate?.getDropdownSucceed(data: responseModel)
            self.userListView?.hideLoader()
            
            
        }, completionnilResponse: { (nilResponse) in
            self.userListView?.hideLoader()
            if let nilRes = nilResponse{
                self.userListView?.showAlert(alert: nilRes)
            }
        }) { (error) in
            self.userListView?.hideLoader()
            if let err = error{
                self.userListView?.showAlert(alert: err.localizedDescription)
            }
        }
        
    }
    
}

//MARK:- User List Deleagate
extension UserListVC : UserListDelegate{
    
    //User Unauthorize and move to login
    func userUnauthorize() {
        isUnauthorizedUser = true
    }
    
    //For Teacher,hod,student,parent
    func getDropdownSucceed(data: GetCommonDropdownModel) {
        dropdownData = data
        if dropdownData.resultData?.count != nil{
            if let count = data.resultData?.count{
                
                if count > 0 {
                    UpdatePickerModel(count: dropdownData?.resultData?.count ?? 0, sharedPickerDelegate: self, View:  self.view)
                }else{
                    CommonFunctions.sharedmanagerCommon.println(object: "Dropdown is zero.")
                }
                
            }
        }
        
    }
    
    //User List Data Success
    func userListDidSuccess(data: [GetAllUserByRoleIdResultData]?) {
        
        isFetching = true
        
        if data != nil{
            if data?.count ?? 0 > 0{
                
                for value in data!{
                    let containsSameValue = arrUserlist.contains(where: {$0.userId == value.userId})
                    if containsSameValue == false{
                        arrUserlist.append(value)
                        tblViewCenterLabel(tblView: tableView, lblText: "", hide: true)
                    }
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
    
    //User list failed
    func userListDidFailed() {
        isFetching = false
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tblViewCenterLabel(tblView: self.tableView, lblText: KConstants.kPleaseTryAgain, hide: false)
        }
    }
}
//MARK:- Scroll View delegates
extension UserListVC : UIScrollViewDelegate{
    
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
                switch selectedIndex{
                case 0:
                    self.viewModel?.userList(searchText: "", pageSize: pageSize, filterBy: KIntegerConstants.kInt2, skip: skip)
                case 1:
                    self.viewModel?.userList(searchText: "", pageSize: pageSize, filterBy: KIntegerConstants.kInt4, skip: skip)
                case 2:
                    self.viewModel?.userList(searchText: "", pageSize: pageSize, filterBy: KIntegerConstants.kInt3, skip: skip)
                case 3:
                    self.viewModel?.userList(searchText: "", pageSize: pageSize, filterBy: KIntegerConstants.kInt5, skip: skip)
                default:
                    CommonFunctions.sharedmanagerCommon.println(object: "Default case.")
                }
            }
        }else{
            CommonFunctions.sharedmanagerCommon.println(object: "Scrolling")
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        pointNow = scrollView.contentOffset
    }
    
    
}

//MARK:- Picker View Delegates
extension UserListVC:SharedUIPickerDelegate
{
    
    func DoneBtnClicked() {
        
        if arrDropDown.count > KIntegerConstants.kInt0{
            switch selectedIndex{
            case KIntegerConstants.kInt0:
                //For Hod Id
                arrUserlist.removeAll()
                self.txtFieldSelectRole.text = self.arrDropDown[selectedIndex]
                self.selectedValueFromDropdown = KIntegerConstants.kInt0
                if checkInternetConnection(){
                    self.viewModel?.userList(searchText: "", pageSize: KIntegerConstants.kInt10,filterBy: KIntegerConstants.kInt2, skip: KIntegerConstants.kInt0)
                }else{
                    self.showAlert(alert: Alerts.kNoInternetConnection)
                }
                break
            case KIntegerConstants.kInt1:
                //For teacher Id
                arrUserlist.removeAll()
                self.txtFieldSelectRole.text = self.arrDropDown[selectedIndex]
                self.selectedValueFromDropdown = KIntegerConstants.kInt1
                if checkInternetConnection(){
                    self.viewModel?.userList(searchText: "", pageSize: KIntegerConstants.kInt10,filterBy: KIntegerConstants.kInt4, skip: KIntegerConstants.kInt0)
                }else{
                    self.showAlert(alert: Alerts.kNoInternetConnection)
                }
                break
            case KIntegerConstants.kInt2:
                //For Student
                arrUserlist.removeAll()
                self.txtFieldSelectRole.text = self.arrDropDown[selectedIndex]
                self.selectedValueFromDropdown = KIntegerConstants.kInt2
                if checkInternetConnection(){
                    self.viewModel?.userList(searchText: "", pageSize: KIntegerConstants.kInt10,filterBy: KIntegerConstants.kInt3, skip: KIntegerConstants.kInt0)
                }else{
                    self.showAlert(alert: Alerts.kNoInternetConnection)
                }
                break
            case KIntegerConstants.kInt3:
                //For Guardian Id
                arrUserlist.removeAll()
                self.txtFieldSelectRole.text = self.arrDropDown[selectedIndex]
                self.selectedValueFromDropdown = KIntegerConstants.kInt3
                if checkInternetConnection(){
                    self.viewModel?.userList(searchText: "", pageSize: KIntegerConstants.kInt10,filterBy: KIntegerConstants.kInt5, skip: KIntegerConstants.kInt0)
                }else{
                    self.showAlert(alert: Alerts.kNoInternetConnection)
                }
                break
            default:
                CommonFunctions.sharedmanagerCommon.println(object: "Default Case")
                break
            }
        }
    }
    
    func GetTitleForRow(index: Int) -> String {
//        txtFieldSelectRole.text = arrDropDown[0]
//        selectedIndex = KIntegerConstants.kInt0
        return arrDropDown[index]
    }
    
    func SelectedRow(index: Int) {
        //        self.txtFieldSelectRole.text = self.arrDropDown[index]
        self.selectedIndex = index
        CommonFunctions.sharedmanagerCommon.println(object: "Selected Dropdown:- \(String(describing: self.dropdownData?.resultData?[index].name))")
    }
    
}

//MARK:- UISearchController Bar Delegates
extension UserListVC : NavigationSearchBarDelegate{
    
    func textDidChange(searchBar: UISearchBar, searchText: String) {
        viewModel?.isSearching = true
        switch selectedIndex{
        case 0:
            arrUserlist.removeAll()
            self.viewModel?.userList(searchText: searchText, pageSize: KIntegerConstants.kInt10, filterBy: KIntegerConstants.kInt2, skip: KIntegerConstants.kInt0)
        case 1:
            arrUserlist.removeAll()
            self.viewModel?.userList(searchText: searchText, pageSize: KIntegerConstants.kInt10, filterBy: KIntegerConstants.kInt4, skip: KIntegerConstants.kInt0)
        case 2:
            arrUserlist.removeAll()
            self.viewModel?.userList(searchText: searchText, pageSize: KIntegerConstants.kInt10, filterBy: KIntegerConstants.kInt3, skip: KIntegerConstants.kInt0)
        case 3:
            arrUserlist.removeAll()
            self.viewModel?.userList(searchText: searchText, pageSize: KIntegerConstants.kInt10, filterBy: KIntegerConstants.kInt5, skip: KIntegerConstants.kInt0)
        default:
            CommonFunctions.sharedmanagerCommon.println(object: "Default case")
        }
    }
    
    func cancelButtonPress(uiSearchBar: UISearchBar) {
        viewModel?.isSearching = false
        DispatchQueue.main.async {
            self.arrUserlist.removeAll()
            if self.arrUserlist.count > 0{
                self.tableView.reloadData()
            }else{
                
                self.txtFieldSelectRole.text = self.arrDropDown[0]
                self.selectedValueFromDropdown = KIntegerConstants.kInt2
                if self.checkInternetConnection(){
                    self.viewModel?.userList(searchText: "", pageSize: KIntegerConstants.kInt10,filterBy: self.selectedValueFromDropdown, skip: KIntegerConstants.kInt0)
                }else{
                    self.showAlert(alert: Alerts.kNoInternetConnection)
                }
            }
        }
    }
}
