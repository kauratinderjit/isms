//
//  DepartmentListPresenter.swift
//  ISMS
//
//  Created by Taranjeet Singh on 6/17/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation

protocol DepartmentListDelegate: class {
    func unatuhorizedUser()
    func departmentListDidSuccess(data : [GetDepartmentListResultData]?)
    func departmentListDidFailed()
    func departmentDeleteDidSuccess(data : AddDepartmentModel)
    func departmentDeleteDidfailed()
    
}

class DepartmentListViewModel{
    var isSearching : Bool?
    //Global ViewDelegate weak object
    private weak var departmentListView : ViewDelegate?
    
    //DepartmentListDelegate weak object
    private weak var departmentListDelegate : DepartmentListDelegate?
    
    //Initiallize the presenter class using delegates
    init(delegate: DepartmentListDelegate) {
        departmentListDelegate = delegate
    }
    
    //Attach GlobalViewDelegate
    func attachView(viewDelegate : ViewDelegate){
        departmentListView = viewDelegate
    }
    
    //Deattach View for free the memory from instances
    func deattachView(){
        departmentListView = nil
        departmentListDelegate = nil
    }
    
    //MARK:- Department list
    func departmentList(searchText: String,pageSize : Int,filterBy: Int,skip: Int){
        if isSearching == false{
            self.departmentListView?.showLoader()
        }
        var postDict = [String:Any]()
        postDict[KApiParameters.KCommonParametersForList.kSearch] = searchText
        postDict[KApiParameters.KCommonParametersForList.kPageSize] = pageSize
        postDict[KApiParameters.KCommonParametersForList.kSortColumn] = ""
        postDict[KApiParameters.KCommonParametersForList.kSkip] = skip
        postDict[KApiParameters.KCommonParametersForList.kSortColumnDir] = ""
        
        print(postDict)
        
        DepartmentApi.sharedInstance.getDepartmentList(url: ApiEndpoints.kGetDepartmentList, parameters: postDict, completionResponse: { (departmentModel) in
            self.departmentListView?.hideLoader()
            switch departmentModel.statusCode{
            case KStatusCode.kStatusCode200:
                
                self.departmentListDelegate?.departmentListDidSuccess(data: departmentModel.resultData)
            case KStatusCode.kStatusCode401:
                if let msg = departmentModel.message{
                    self.departmentListView?.showAlert(alert: msg)
                }
                self.departmentListDelegate?.unatuhorizedUser()
            default:
                self.departmentListView?.showAlert(alert: departmentModel.message ?? "")
            }
        }, completionnilResponse: { (nilResponseError) in
            self.departmentListView?.hideLoader()
            self.departmentListDelegate?.departmentListDidFailed()
            if let error = nilResponseError{
                self.departmentListView?.showAlert(alert: error)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Department APi Nil response")
            }
        }) { (error) in
            self.departmentListView?.hideLoader()
            self.departmentListDelegate?.departmentListDidFailed()
            if let err = error?.localizedDescription{
                self.departmentListView?.showAlert(alert: err)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Department APi error response")
            }
        }
    }
    
    //MARK:- delete Department
    func deleteDepartment(departmentId: Int){
        
        self.departmentListView?.showLoader()
        DepartmentApi.sharedInstance.deleteDepartmentApi(url: ApiEndpoints.kDeleteDepartment+"?departmentId=\(departmentId)", completionResponse: {deleteModel in
            self.departmentListView?.hideLoader()
            switch deleteModel.statusCode{
            case KStatusCode.kStatusCode200:
                if let msg = deleteModel.message{
                    self.departmentListView?.showAlert(alert: msg)
                }
                self.departmentListDelegate?.departmentDeleteDidSuccess(data: deleteModel)
            case KStatusCode.kStatusCode401:
                if let msg = deleteModel.message{
                    self.departmentListView?.showAlert(alert: msg)
                }
                self.departmentListDelegate?.unatuhorizedUser()
            default:
                self.departmentListView?.hideLoader()
                if let msg = deleteModel.message{
                    self.departmentListView?.showAlert(alert: msg)
                }
            }
        }, completionnilResponse: { (nilResponse) in
            self.departmentListView?.hideLoader()
            if let res = nilResponse{
                self.departmentListView?.showAlert(alert: res)
            }
        }) { (error) in
            if let err = error{
                self.departmentListView?.showAlert(alert: err.localizedDescription)
            }
        }
    }
}

//MARK:- Scroll View delegates
extension DepartmentListVC : UIScrollViewDelegate{
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        if (tableView.contentOffset.y < pointNow.y){
            CommonFunctions.sharedmanagerCommon.println(object: "Down scroll view")
            isScrolling = true
        }
        else if (tableView.contentOffset.y + tableView.frame.size.height >= tableView.contentSize.height){
            isScrolling = true
            if (isFetching == true){
                skip = skip + KIntegerConstants.kInt10
                isFetching = false
                self.viewModel?.departmentList(searchText: "", pageSize: pageSize, filterBy: 0, skip: skip)
            }
        }else{
            CommonFunctions.sharedmanagerCommon.println(object: "Scrolling")
        }
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        pointNow = scrollView.contentOffset
    }
}
//MARK:- UISearchController Bar Delegates
extension DepartmentListVC : NavigationSearchBarDelegate{
    
    func textDidChange(searchBar: UISearchBar, searchText: String) {
        viewModel?.isSearching = true
        arrDepartmentlist.removeAll()
        self.viewModel?.departmentList(searchText: searchText, pageSize: KIntegerConstants.kInt10, filterBy: 0, skip: KIntegerConstants.kInt0)
        
    }
    
    func cancelButtonPress(uiSearchBar: UISearchBar) {
        viewModel?.isSearching = false
        DispatchQueue.main.async {
            self.arrDepartmentlist.removeAll()
            self.viewModel?.departmentList(searchText: "", pageSize: KIntegerConstants.kInt10, filterBy: 0, skip: KIntegerConstants.kInt0)
        }
    }
}
//MARK:- Department Deleagate
extension DepartmentListVC : DepartmentListDelegate{
    
    func unatuhorizedUser() {
        isUnauthorizedUser = true
    }
    func departmentDeleteDidSuccess(data : AddDepartmentModel) {
        isDepartmentDeleteSuccessfully = true
    }
    func departmentDeleteDidfailed() {
        isDepartmentDeleteSuccessfully = false
    }
    func departmentListDidSuccess(data: [GetDepartmentListResultData]?) {
        isFetching = true
        if data != nil{
            if data?.count ?? 0 > 0
            {
              //  arrDepartmentlist = [GetDepartmentListResultData]()
                for value in data!{
                    let containsSameValue = arrDepartmentlist.contains(where: {$0.departmentId == value.departmentId})
                    if containsSameValue == false{
                        print("atinder")
                        arrDepartmentlist.append(value)
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
    func departmentListDidFailed() {
        self.tableView.reloadData()
        tblViewCenterLabel(tblView: tableView, lblText: KConstants.kPleaseTryAgain, hide: false)
    }
    
}
