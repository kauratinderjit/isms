//
//  ClassListViewModel.swift
//  ISMS
//
//  Created by Taranjeet Singh on 6/18/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation


protocol ClassListDelegate: class {
    func unauthorizedUser()
    func classListDidSuccess(data : [GetClassListResultData]?)
    func classListDidFailed()
    func classDeleteDidSuccess(data : DeleteClassModel)
    func classDeleteDidfailed()
}

class ClassListViewModel{
    var isSearching : Bool?
    //Global ViewDelegate weak object
    private weak var classListView : ViewDelegate?
    
    //ClassListDelegate weak object
    private weak var classListDelegate : ClassListDelegate?
    
    //Initiallize the presenter class using delegates
    init(delegate: ClassListDelegate) {
        classListDelegate = delegate
    }
    
    //Attach GlobalViewDelegate
    func attachView(viewDelegate : ViewDelegate){
        classListView = viewDelegate
    }
    
    //Deattach View for free the memory from instances
    func deattachView(){
        classListView = nil
        classListDelegate = nil
    }
    
    //MARK:- Class list
    func classList(searchText: String,pageSize : Int,filterBy: Int,skip: Int){
        
        if isSearching == false{
            self.classListView?.showLoader()
        }
        
        var postDict = [String:Any]()
        
        postDict[KApiParameters.KCommonParametersForList.kSearch] = searchText
        postDict[KApiParameters.KCommonParametersForList.kPageSize] = pageSize
        postDict[KApiParameters.KCommonParametersForList.kSortColumn] = ""
        postDict[KApiParameters.KCommonParametersForList.kSkip] = skip
        postDict[KApiParameters.KCommonParametersForList.kSortColumnDir] = ""
        
        
        
        ClassApi.sharedManager.getClassList(url: ApiEndpoints.kGetClassList, parameters: postDict, completionResponse: { (classModel) in
            
            self.classListView?.hideLoader()

            switch classModel.statusCode{
            case KStatusCode.kStatusCode200:
                self.classListDelegate?.classListDidSuccess(data: classModel.resultData)
            case KStatusCode.kStatusCode401:
                if let msg = classModel.message{
                    self.classListView?.showAlert(alert: msg)
                }
                self.classListDelegate?.unauthorizedUser()
            default:
                if let msg = classModel.message{
                    self.classListView?.showAlert(alert: msg)
                }
            }
        }, completionnilResponse: { (nilResponseError) in
            
            self.classListView?.hideLoader()
            self.classListDelegate?.classListDidFailed()
            
            if let error = nilResponseError{
                self.classListView?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Class APi Nil response")
            }
            
        }) { (error) in
            self.classListView?.hideLoader()
            self.classListDelegate?.classListDidFailed()
            if let err = error?.localizedDescription{
                self.classListView?.showAlert(alert: err)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Class APi error response")
            }
        }
    }
    
    //MARK:- delete Class
    func deleteClass(classId: Int){
        
        self.classListView?.showLoader()
        ClassApi.sharedManager.deleteClassApi(url: ApiEndpoints.kDeleteClass+"?classId=\(classId)", completionResponse: {deleteModel in
            
            self.classListView?.hideLoader()
            
            switch deleteModel.statusCode{
            case KStatusCode.kStatusCode200:
                if let msg = deleteModel.message{
                    self.classListView?.showAlert(alert: msg)
                }
                self.classListDelegate?.classDeleteDidSuccess(data: deleteModel)
            case KStatusCode.kStatusCode401:
                    if let res = deleteModel.message{
                        self.classListView?.showAlert(alert: res)
                    }
                    self.classListDelegate?.unauthorizedUser()
            default:
                if let msg = deleteModel.message{
                    self.classListView?.showAlert(alert: msg)
                }
            }
        }, completionnilResponse: { (nilResponse) in
            
            self.classListView?.hideLoader()
            if let res = nilResponse{
                self.classListView?.showAlert(alert: res)
            }
            
        }) { (error) in
            self.classListView?.hideLoader()
            if let err = error{
                self.classListView?.showAlert(alert: err.localizedDescription)
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
    func classListDidSuccess(data: [GetClassListResultData]?) {
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
        self.viewModel?.classList(searchText: searchText, pageSize: KIntegerConstants.kInt10, filterBy: 0, skip: KIntegerConstants.kInt0)
        
    }
    
    func cancelButtonPress(uiSearchBar: UISearchBar) {
        viewModel?.isSearching = false
        DispatchQueue.main.async {
            self.arr_Classlist.removeAll()
            self.viewModel?.classList(searchText: "", pageSize: KIntegerConstants.kInt10, filterBy: 0, skip: KIntegerConstants.kInt0)
        }
    }
}

//MARK:- Scroll View delegates
extension ClassListVC : UIScrollViewDelegate{
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if(velocity.y>0) {
            //Code will work without the animation block.I am using animation block incase if you want to set any delay to it.
            UIView.animate(withDuration: 2.5, delay: 0, options: UIView.AnimationOptions(), animations: {
                self.navigationController?.setNavigationBarHidden(true, animated: true)
            }, completion: nil)
            
        } else {
            UIView.animate(withDuration: 2.5, delay: 0, options: UIView.AnimationOptions(), animations: {
                self.navigationController?.setNavigationBarHidden(false, animated: true)
            }, completion: nil)
        }
        
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
                self.viewModel?.classList(searchText: "", pageSize: pageSize, filterBy: 0, skip: skip)
            }
        }else{
            CommonFunctions.sharedmanagerCommon.println(object: "Scrolling")
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        pointNow = scrollView.contentOffset
    }
    
}
