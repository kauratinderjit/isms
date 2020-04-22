//
//  HODLIstPresenter.swift
//  ISMS
//
//  Created by Taranjeet Singh on 6/19/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation


protocol HODListDelegate: class {
    func unauthorizedUser()
    func hodListDidSuccess(data : [GetHodListResultData]?)
    func hodListDidFailed()
    func hodDeleteDidSuccess(data : DeleteHODModel)
    func hodDeleteDidfailed()
    
    
}


class HODListViewModel{
    var isSearching : Bool?
    
    //Global ViewDelegate weak object
    private weak var hodListView : ViewDelegate?
    
    //ClassListDelegate weak object
    private weak var hodListDelegate : HODListDelegate?
    
    //Initiallize the presenter class using delegates
    init(delegate: HODListDelegate) {
        hodListDelegate = delegate
    }
    
    //Attach GlobalViewDelegate
    func attachView(viewDelegate : ViewDelegate){
        hodListView = viewDelegate
    }
    
    //Deattach View for free the memory from instances
    func deattachView(){
        hodListView = nil
        hodListDelegate = nil
    }
    
    //MARK:- HOD list
    func hodList(searchText: String,pageSize : Int,filterBy: Int,skip: Int){
        var postDict = [String:Any]()
        postDict[KApiParameters.KCommonParametersForList.kSearch] = searchText
        postDict[KApiParameters.KCommonParametersForList.kPageSize] = pageSize
        postDict[KApiParameters.KCommonParametersForList.kSortColumn] = ""
        postDict[KApiParameters.KCommonParametersForList.kSkip] = skip
        postDict[KApiParameters.KCommonParametersForList.kSortColumnDir] = ""
        if isSearching == false{
            self.hodListView?.showLoader()
        }
        HODApi.sharedManager.getHODList(url: ApiEndpoints.kGetHodList, parameters: postDict, completionResponse: { (hodModel) in
            self.hodListView?.hideLoader()
            switch hodModel.statusCode{
            case KStatusCode.kStatusCode200:
                self.hodListDelegate?.hodListDidSuccess(data: hodModel.resultData)
            case KStatusCode.kStatusCode401:
                if let msg = hodModel.message{
                    self.hodListView?.showAlert(alert: msg)
                }
                self.hodListDelegate?.unauthorizedUser()
            default:
                if let msg = hodModel.message{
                    self.hodListView?.showAlert(alert: msg)
                }
            }
        }, completionnilResponse: { (nilResponseError) in
            self.hodListView?.hideLoader()
            self.hodListDelegate?.hodListDidFailed()
            self.hodListView?.showAlert(alert: nilResponseError ?? "Server Error")
        }) { (error) in
            self.hodListView?.hideLoader()
            self.hodListDelegate?.hodListDidFailed()
            if let err = error?.localizedDescription{
                self.hodListView?.showAlert(alert: err)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Hod APi error response")
            }
        }
    }
    
    //MARK:- delete HOD
    func deleteHOD(hodId: Int){
        
        self.hodListView?.showLoader()
        HODApi.sharedManager.deleteHODApi(url: ApiEndpoints.kDeleteHod+"?hodId=\(hodId)", completionResponse: {deleteModel in
            self.hodListView?.hideLoader()
            switch deleteModel.statusCode{
            case KStatusCode.kStatusCode200:
                if let msg = deleteModel.message{
                    self.hodListView?.showAlert(alert: msg)
                }
                self.hodListDelegate?.hodDeleteDidSuccess(data: deleteModel)
            case KStatusCode.kStatusCode401:
                if let msg = deleteModel.message{
                    self.hodListView?.showAlert(alert: msg)
                }
                self.hodListDelegate?.unauthorizedUser()
            default:
                if let msg = deleteModel.message{
                    self.hodListView?.showAlert(alert: msg)
                }
            }
        }, completionnilResponse: { (nilResponse) in
            self.hodListView?.hideLoader()
            self.hodListDelegate?.hodDeleteDidfailed()
            if let res = nilResponse{
                self.hodListView?.showAlert(alert: res)
            }
        }) { (error) in
            self.hodListView?.hideLoader()
            self.hodListDelegate?.hodDeleteDidfailed()
            if let err = error{
                self.hodListView?.showAlert(alert: err.localizedDescription)
            }
        }
    }
}

//MARK:- UISearchController Bar Delegates
extension HODListVC : NavigationSearchBarDelegate{
    func textDidChange(searchBar: UISearchBar, searchText: String) {
        viewModel?.isSearching = true
        DispatchQueue.main.async {
            self.arrHODlist.removeAll()
            self.viewModel?.hodList(searchText: searchText, pageSize: KIntegerConstants.kInt10, filterBy: 0, skip: KIntegerConstants.kInt0)
        }
    }
    func cancelButtonPress(uiSearchBar: UISearchBar) {
        viewModel?.isSearching = false
        DispatchQueue.main.async {
            self.arrHODlist.removeAll()
            self.viewModel?.hodList(searchText: "", pageSize: KIntegerConstants.kInt10, filterBy: 0, skip: KIntegerConstants.kInt0)
        }
    }
}

//MARK:- Hod Deleagate
extension HODListVC : HODListDelegate{
    func unauthorizedUser() {
        isUnauthorizedUser = true
    }
    func hodListDidFailed() {
        tableView.reloadData()
        tblViewCenterLabel(tblView: tableView, lblText: KConstants.kPleaseTryAgain, hide: true)
    }
    func hodDeleteDidSuccess(data: DeleteHODModel) {
        isHODDeleteSuccessfully = true
    }
    func hodDeleteDidfailed() {
        isHODDeleteSuccessfully = false
    }
    func hodListDidSuccess(data: [GetHodListResultData]?) {
        
        isFetching = true
        if data != nil{
            if data?.count ?? 0 > 0{
                for value in data!{
                    
                    let containsSameValue = arrHODlist.contains(where: {$0.hodId == value.hodId})
                    if containsSameValue == false{
                        arrHODlist.append(value)
                    }
                }
                self.tblViewCenterLabel(tblView: tableView, lblText: "", hide: true)
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
//MARK:- Scroll View delegates
extension HODListVC : UIScrollViewDelegate{
    
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
                self.viewModel?.hodList(searchText: "", pageSize: pageSize, filterBy: 0, skip: skip)
            }
        }else{
            CommonFunctions.sharedmanagerCommon.println(object: "Scrolling")
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        pointNow = scrollView.contentOffset
    }
    
    
}
