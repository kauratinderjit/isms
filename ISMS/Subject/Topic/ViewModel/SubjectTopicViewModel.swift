//
//  SubjectTopicViewModel.swift
//  ISMS
//
//  Created by Gurleen Osahan on 11/18/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation

//MARK: PROTOCOL SUBJECT CHAPTER
protocol SubjectChapterTopicDelegate: class {
        func unauthorizedUser()
        func SubjectListDidSuccess(data: [GetTopicResultData]?)
        func  getTopicList()
//        func SubjectListDidFailed()
      func SubjectDeleteSuccess(data: DeleteTopicModel)
//       func SubjectDetailDidSuccess(Data: TopicListModel)
//        func SubjectDetailDidFailed()
}


class SubjectChapterTopicViewModel{
    
    //Global ViewDelegate weak object
    private weak var TopicView : ViewDelegate?
    
    //StudentListDelegate weak object
    private weak var TopicDelegate : SubjectChapterTopicDelegate?
    
    //Initiallize the ViewModel StudentList using delegates
    init(delegate:SubjectChapterTopicDelegate) {
        TopicDelegate = delegate
    }
    
    //Attach GlobalViewDelegate
    func attachView(viewDelegate : ViewDelegate){
        TopicView = viewDelegate
    }
    
    //Deattach View for free the memory from instances
    func deattachView(){
        TopicView = nil
        TopicDelegate = nil
    }
    
  
    
    //MARK:- GET TOPIC LIST
    func TopicList(search : String?,skip : Int?,pageSize: Int?,sortColumnDir: String?,sortColumn: String? , particularID : Int ){
        
        self.TopicView?.showLoader()
        let paramDict = [KApiParameters.SubjectListApi.subjectSearch: search ?? "",KApiParameters.SubjectListApi.PageSkip:skip ?? 0,KApiParameters.SubjectListApi.PageSize: pageSize ?? 0,KApiParameters.SubjectListApi.sortColumnDir: sortColumnDir ?? "", KApiParameters.SubjectListApi.sortColumn: sortColumn ?? "", KApiParameters.SubjectListApi.particularId : particularID] as [String : Any]
 
        
        SubjectTopicApi.sharedInstance.getTopicList(url: ApiEndpoints.KTopicListApi, parameters: paramDict as [String : Any], completionResponse: { (SubjectListModel) in
            
            self.TopicView?.hideLoader()
            if SubjectListModel.statusCode == KStatusCode.kStatusCode200{
                let data = SubjectListModel.resultData
                 self.TopicDelegate?.SubjectListDidSuccess(data: data)
            }else if SubjectListModel.statusCode == KStatusCode.kStatusCode401{
                self.TopicView?.showAlert(alert: SubjectListModel.message ?? "")
                //    self.ChapterDelegate?.unauthorizedUser()
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "student APi status change")
            }
            
        }, completionnilResponse: { (nilResponseError) in
            self.TopicView?.hideLoader()
            self.TopicView?.showAlert(alert: nilResponseError ?? "")
        }) { (error) in
            self.TopicView?.hideLoader()
            self.TopicView?.showAlert(alert: error?.localizedDescription ?? "")
        }
    }
    //MARK:- GET ADD TOPIC LIST
    func addTopic(TopicId: Int,TopicName: String,ChapterId: Int){
        self.TopicView?.showLoader()
       let paramDict = [KApiParameters.AddSubjectApi.kTopicId:TopicId,KApiParameters.AddSubjectApi.kTopicName:TopicName, KApiParameters.AddSubjectApi.chapterId :ChapterId] as [String : Any]
        print("value of param: ",paramDict)
        SubjectApi.sharedInstance.AddSubject(url: ApiEndpoints.KAddTopicApi, parameters: paramDict, completionResponse: { (responseModel) in
            print(responseModel)
            self.TopicView?.hideLoader()
            self.TopicView?.showAlert(alert: responseModel.message ?? "")
            self.TopicDelegate?.getTopicList()
        }, completionnilResponse: { (nilResponse) in
            self.TopicView?.hideLoader()
            self.TopicView?.showAlert(alert: nilResponse ?? "")
        }) { (error) in
            self.TopicView?.hideLoader()
            self.TopicView?.showAlert(alert: error?.localizedDescription ?? "")
        }
}
    
    func topicDetail(topicId: Int?) {
        self.TopicView?.showLoader()
        SubjectApi.sharedInstance.getSubjectDetail(url: ApiEndpoints.KChapterDetailApi + "\(topicId ?? 0)", parameters: nil, completionResponse: { (GetSubjectDetail) in
            if GetSubjectDetail.statusCode == KStatusCode.kStatusCode200{
                self.TopicView?.hideLoader()
            //   self.SubjectListDelegate?.SubjectDetailDidSuccess(Data: GetSubjectDetail)
            }else if GetSubjectDetail.statusCode == KStatusCode.kStatusCode401{
                self.TopicView?.showAlert(alert: GetSubjectDetail.message ?? "")
                //  self.SubjectListDelegate?.unauthorizedUser()
            }else{
                self.TopicView?.hideLoader()
                CommonFunctions.sharedmanagerCommon.println(object: "student APi status change")
            }
        }, completionnilResponse: { (nilResponseError) in
            self.TopicView?.hideLoader()
            if let error = nilResponseError{
                self.TopicView?.showAlert(alert: error)
            }
        }) { (error) in
            self.TopicView?.hideLoader()
            //  self.SubjectListDelegate?.SubjectDetailDidFailed()
            if let err = error?.localizedDescription{
                self.TopicView?.showAlert(alert: err)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "student APi error response")
            }
        }
    }
    
    func deletechapter(topicId: Int){
        
        self.TopicView?.showLoader()
        SubjectTopicApi.sharedInstance.deleteTopicApi(url: ApiEndpoints.KDeleteTopicApi + "\(topicId)", completionResponse: {DeleteSubjectModel in
            
            if DeleteSubjectModel.statusCode == KStatusCode.kStatusCode200{
                
                if DeleteSubjectModel.status == true{
                    CommonFunctions.sharedmanagerCommon.println(object: "delete student true")
                    self.TopicView?.hideLoader()
            self.TopicDelegate?.SubjectDeleteSuccess(data: DeleteSubjectModel)
                }else{
                    CommonFunctions.sharedmanagerCommon.println(object: "delete student false")
                    self.TopicView?.hideLoader()
                    //                    self.SubjectListVC?.showAlert(alert: DeleteSubjectModel.message ?? Alerts.kServerErrorAlert)
                }
                
            }
            
        }, completionnilResponse: { (nilResponse) in
            self.TopicView?.hideLoader()
            if let res = nilResponse{
                self.TopicView?.showAlert(alert: res)
            }
        }) { (error) in
            self.TopicView?.hideLoader()
            if let err = error{
                self.TopicView?.showAlert(alert: err.localizedDescription)
            }
        }
        
    }
}
//MARK:- TABLEVIEW DELEGATE METHODS
extension SubjectTopicVC : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 70;//Choose your custom row height
    }
    
}

//MARK:- CELL DELETE ,EDIT BUTTON , TABLEVIEW DATA SOURCE
extension SubjectTopicVC : UITableViewDataSource , SubjectTopicTableViewDelegate {
    
    func didPressDeleteButton(_ tag: Int) {
        if let topicID = arrSubjectlist[tag].topicId {
            self.ViewModel?.deletechapter(topicId: topicID)
        }
    }
    
    func didPressEditButton(_ tag: Int) {
        if let Id = arrSubjectlist[tag].topicId {
            self.topicID = Id
            if let topicName = arrSubjectlist[tag].topicName {
             self.textFieldAlert.txtFieldVal.text = topicName
            }
        }
        setupCustomViewForUpdate()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrSubjectlist.count > 0 {
            tableView.separatorStyle = .singleLine
            return (arrSubjectlist.count)
        }else{
            tblViewCenterLabel(tblView: tableView, lblText: KConstants.kNoDataFound, hide: true)
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: KTableViewCellIdentifier.kTopicTableView, for: indexPath) as! SubjectTopicTableViewCell
        cell.cellDelegate = self
        cell.deleteBtn.tag = indexPath.row
        let row = arrSubjectlist[indexPath.row]
        cell.setCellUI(data: row, indexPath: indexPath)
         return cell
    }
}

//MARK:- SubjectChapterTopicDelegate
extension SubjectTopicVC : SubjectChapterTopicDelegate {
    func SubjectDeleteSuccess(data: DeleteTopicModel) {
        initializeCustomOkAlert(self.view, isHideBlurView: true)
        okAlertView.delegate = self
        okAlertView.lblResponseDetailMessage.text = data.message
        if let ChapterId = ChapterID {
            self.ViewModel?.TopicList(search: "", skip: 0, pageSize: 10, sortColumnDir: "", sortColumn: "", particularID: ChapterId)
        }
    }

    func getTopicList() {
        if let ChapterId = self.ChapterID {
            self.ViewModel?.TopicList(search: "", skip: 0, pageSize: 10, sortColumnDir: "", sortColumn: "", particularID: ChapterId)
        }
    }
    
    func SubjectListDidSuccess(data: [GetTopicResultData]?) {
        if let data1 = data {
            arrSubjectlist = data1
        }
        tableView.reloadData()
    }
    
  
    func unauthorizedUser() {
         self.isUnauthorizedUser = true
    }
  
}
extension SubjectTopicVC : OKAlertViewDelegate {
    //Ok Button Clicked
    func okBtnAction() {
        if isUnauthorizedUser == true{
            isUnauthorizedUser = false
            CommonFunctions.sharedmanagerCommon.setRootLogin()
            //        }else if isSubjectAddSuccessFully == true{
            //            isSubjectAddSuccessFully = false
            //            textFieldAlert.removeFromSuperview()
            //            DispatchQueue.main.async {
            //                self.tableView.reloadData()
            //            }
            //        }else if isSubjectDelete == true{
            //            isSubjectDelete = false
            //            if let selectedIndex = self.selectedSubjectArrIndex{
            //                self.arrChapterList.remove(at: selectedIndex)
            //                DispatchQueue.main.async {
            //                    self.tableView.reloadData()
            //                }
            //            }
            //
            //        }
            textFieldAlert.removeFromSuperview()
            okAlertView.removeFromSuperview()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        else {
            textFieldAlert.removeFromSuperview()
            okAlertView.removeFromSuperview()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
extension SubjectTopicVC : UIScrollViewDelegate {
    
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
               // self.ViewModel?.chapterList(search : "",skip : skip,pageSize: pageSize,sortColumnDir: "",sortColumn: "")
                
            }
        }else{
            CommonFunctions.sharedmanagerCommon.println(object: "Scrolling")
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        pointNow = scrollView.contentOffset
    }
    
}

extension SubjectTopicVC : NavigationSearchBarDelegate{
    func textDidChange(searchBar: UISearchBar, searchText: String) {
        DispatchQueue.main.async {
            self.arrSubjectlist.removeAll()
        //    self.ViewModel?.chapterList(search : "",skip : KIntegerConstants.kInt0,pageSize: KIntegerConstants.kInt10,sortColumnDir: "",sortColumn: "")
        }
    }
    
    func cancelButtonPress(uiSearchBar: UISearchBar) {
        DispatchQueue.main.async {
            self.arrSubjectlist.removeAll()
           // self.ViewModel?.chapterList(search : "",skip : KIntegerConstants.kInt0,pageSize:  KIntegerConstants.kInt10,sortColumnDir: "",sortColumn: "")
        }
    }
}
extension SubjectTopicVC :ViewDelegate {
    func showAlert(alert: String){
        initializeCustomOkAlert(self.view, isHideBlurView: true)
        okAlertView.delegate = self
        okAlertView.lblResponseDetailMessage.text = alert
        // backToInitial()
    }
    
    func showLoader() {
        ShowLoader()
    }
    
    func hideLoader() {
        HideLoader()
    }
    func setupUI(){
        self.textFieldAlert.txtFieldVal.SetTextFont(textSize: KTextSize.KSixteen, placeholderText: KPlaceholder.kTopicNamePlaceholder)
        self.textFieldAlert.txtFieldVal.addViewCornerShadow(radius: 8, view: self.textFieldAlert.txtFieldVal)
        self.textFieldAlert.txtFieldVal.txtfieldPadding(leftpadding: 20, rightPadding: 0)
    }
    //MARK:- CUSTOM VIEW FOR ALERT
    func setupCustomView(){
        initializeCustomTextFieldView(self.view, isHideBlurView: true)
        textFieldAlert.delegate = self
        self.setupUI()
        self.textFieldAlert.lblTitle.text = "Add Topic"
        self.textFieldAlert.txtFieldVal.text = ""
        self.textFieldAlert.BtnTxt.setTitle("Add", for: .normal)
        self.textFieldAlert.btnCancel.setTitle("Cancel", for: .normal)
        self.textFieldAlert.btnCancel.cornerRadius = 4.0
        self.textFieldAlert.BtnTxt.cornerRadius = 4.0
         setButton = "Add"
    }
    func setupCustomViewForUpdate() {
        initializeCustomTextFieldView(self.view, isHideBlurView: true)
        textFieldAlert.delegate = self
        self.textFieldAlert.lblTitle.text = "Add Topic"
      //  self.textFieldAlert.txtFieldVal.text =
        self.textFieldAlert.BtnTxt.setTitle("Update", for: .normal)
        self.textFieldAlert.btnCancel.setTitle("Cancel", for: .normal)
        self.textFieldAlert.btnCancel.cornerRadius = 4.0
        self.textFieldAlert.BtnTxt.cornerRadius = 4.0
        setButton = "Update"
    }
}


extension SubjectTopicVC : TextFieldAlertDelegate {
  
    func btnCancel() {

    }

        func BtnTxt() {
            self.view.endEditing(true)
            if self.checkInternetConnection(){
                if ChapterID! != 0{
                    if textFieldAlert.txtFieldVal.text != ""{
                        self.isSubjectAddSuccessFully = true
                        
                    textFieldAlert.removeFromSuperview()
                        
                        if self.setButton == "Add" {
                            if let text = textFieldAlert.txtFieldVal.text {
                                if let id = ChapterID {
                                self.ViewModel?.addTopic(TopicId: 0,TopicName: text,ChapterId: id)
                                }
                            }
                        }
                        else {
                            if let text = textFieldAlert.txtFieldVal.text {
                                if let id = ChapterID {
                                    self.ViewModel?.addTopic(TopicId: topicID,TopicName: text,ChapterId: id)
                                }
                            }
                        }
                        yesNoAlertView.removeFromSuperview()
                    }
                    else {
                        self.showAlert(alert: Alerts.kEmptySubjectName)
                    }
    
                }else{
                    if textFieldAlert.txtFieldVal.text != ""{
                        isSubjectAddSuccessFully = true
                        //self.ViewModel?.addSubject(subjectName: textFieldAlert.txtFieldVal.text, subjectID: subjectId)
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

