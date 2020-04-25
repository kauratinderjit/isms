//
//  TeacherListPresenter.swift
//  ISMS
//
//  Created by Taranjeet Singh on 6/20/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation

protocol TeacherListDelegate: class {
    func unauthorizedUser()
    func teacherListDidSuccess(data : [GetTeacherListResultData]?)
    func teacherListDidFailed()
    func teacherDeleteDidSuccess(data : DeleteTeacherModel)
    func teacherDeleteDidfailed()
    
    
}


class TeacherListViewModel{
    var isSearching : Bool?
    //Global ViewDelegate weak object
    private weak var teacherListView : ViewDelegate?
    
    //TeacherListDelegate weak object
    private weak var teacherListDelegate : TeacherListDelegate?
    
    //Initiallize the presenter class using delegates
    init(delegate: TeacherListDelegate) {
        teacherListDelegate = delegate
    }
    
    //Attach GlobalViewDelegate
    func attachView(viewDelegate : ViewDelegate){
        teacherListView = viewDelegate
    }
    
    //Deattach View for free the memory from instances
    func deattachView(){
        teacherListView = nil
        teacherListDelegate = nil
    }
    
    //MARK:- Teacher list
    func teacherList(searchText: String,pageSize : Int,filterBy: Int,skip: Int){
        if isSearching == false{
            self.teacherListView?.showLoader()
        }        
        var postDict = [String:Any]()
        
        postDict[KApiParameters.KCommonParametersForList.kSearch] = searchText
        postDict[KApiParameters.KCommonParametersForList.kPageSize] = pageSize
        postDict[KApiParameters.KCommonParametersForList.kSortColumn] = ""
        postDict[KApiParameters.KCommonParametersForList.kSkip] = skip
        postDict[KApiParameters.KCommonParametersForList.kSortColumnDir] = ""
        postDict["ParticularId"] = UserDefaultExtensionModel.shared.HODDepartmentId
        
        TeacherApi.sharedManager.getTeacherList(url: ApiEndpoints.kGetTeacherList, parameters: postDict, completionResponse: { (teacherModel) in
            self.teacherListView?.hideLoader()
           
            switch teacherModel.statusCode{
            case KStatusCode.kStatusCode200:
//                self.teacherListView?.hideLoader()
                self.teacherListDelegate?.teacherListDidSuccess(data: teacherModel.resultData)
            case KStatusCode.kStatusCode401:
                if let msg = teacherModel.message{
                    self.teacherListView?.showAlert(alert: msg)
                }
                self.teacherListDelegate?.unauthorizedUser()
            default:
                self.teacherListView?.showAlert(alert: teacherModel.message ?? "")
            }
        }, completionnilResponse: { (nilResponseError) in
            self.teacherListView?.hideLoader()
            self.teacherListDelegate?.teacherListDidFailed()
            if let error = nilResponseError{
                self.teacherListView?.showAlert(alert: error)
                
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Teacher APi Nil response")
            }
        }) { (error) in
            self.teacherListView?.hideLoader()
            self.teacherListDelegate?.teacherListDidFailed()
            if let err = error?.localizedDescription{
                self.teacherListView?.showAlert(alert: err)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Teacher APi error response")
            }
        }
    }
    
    //MARK:- delete Teacher
    func deleteTeacher(teacherId: Int){
        self.teacherListView?.showLoader()
        TeacherApi.sharedManager.deleteTeacherApi(url: ApiEndpoints.kDeleteTeacher+"?teacherId=\(teacherId)", completionResponse: {deleteModel in
            self.teacherListView?.hideLoader()
            switch deleteModel.statusCode{
            case KStatusCode.kStatusCode200:
                if let msg = deleteModel.message{
                    self.teacherListView?.showAlert(alert: msg)
                }
                self.teacherListDelegate?.teacherDeleteDidSuccess(data: deleteModel)
            case KStatusCode.kStatusCode401:
                if let msg = deleteModel.message{
                    self.teacherListView?.showAlert(alert: msg)
                }
                self.teacherListDelegate?.unauthorizedUser()
            default:
                if let msg = deleteModel.message{
                    self.teacherListView?.showAlert(alert: msg)
                }
            }
        }, completionnilResponse: { (nilResponse) in
            self.teacherListView?.hideLoader()
            if let res = nilResponse{
                self.teacherListView?.showAlert(alert: res)
            }
        }) { (error) in
            self.teacherListView?.hideLoader()
            if let err = error{
                self.teacherListView?.showAlert(alert: err.localizedDescription)
            }
        }
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
