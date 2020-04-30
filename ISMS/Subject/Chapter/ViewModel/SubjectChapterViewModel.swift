//
//  SubjectChapterViewModel.swift
//  ISMS
//
//  Created by Kuldeep Singh on 11/15/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation
protocol SubjectChapterDelegate: class {
    func unauthorizedUser()
    //    func SubjectListDidSuccess(data: [GetSubjectResultData]?)
    //    func SubjectListDidFailed()
    func SubjectDeleteSuccess(data: DeleteSubjectModel)
    func GetChapterList()
    //    func SubjectDetailDidSuccess(Data: GetSubjectDetail)
    //    func SubjectDetailDidFailed()
    func chapterList(data: [ChaptersData])
}
class SubjectChapterViewModel{
    
    var isSearching : Bool?
    //Global ViewDelegate weak object
    private weak var ChapterView : ViewDelegate?
    
    //StudentListDelegate weak object
    private weak var ChapterDelegate : SubjectChapterDelegate?
    
    //Initiallize the ViewModel StudentList using delegates
    init(delegate:SubjectChapterDelegate) {
        ChapterDelegate = delegate
    }
    
    //Attach GlobalViewDelegate
    func attachView(viewDelegate : ViewDelegate){
        ChapterView = viewDelegate
    }
    
    //Deattach View for free the memory from instances
    func deattachView(){
        ChapterView = nil
        ChapterDelegate = nil
    }
    
    
}
//MARK :- Web Services
extension SubjectChapterViewModel {
    
    func chapterList(search : String?,skip : Int?,pageSize: Int?,sortColumnDir: String?,sortColumn: String?, particularId : Int) {
       
        if isSearching == false
        {
            self.ChapterView?.showLoader()
        }
        
        let paramDict = [KApiParameters.SubjectListApi.subjectSearch: search ?? "",KApiParameters.SubjectListApi.PageSkip:skip ?? 0,KApiParameters.SubjectListApi.PageSize: pageSize ?? 0,KApiParameters.SubjectListApi.sortColumnDir: sortColumnDir ?? "", KApiParameters.SubjectListApi.sortColumn: sortColumn ?? "", KApiParameters.kUpdateSyllabusApiParameter.kParticularId :particularId ] as [String : Any]
        
        SubjectChapterApi.sharedInstance.getChapterList(url: ApiEndpoints.KChapterListApi, parameters: paramDict as [String : Any], completionResponse: { (SubjectListModel) in
            self.ChapterView?.hideLoader()
            if SubjectListModel.statusCode == KStatusCode.kStatusCode200{
                if let resltdata = SubjectListModel.resultData {
                    self.ChapterDelegate?.chapterList(data: resltdata)
                }
            }else if SubjectListModel.statusCode == KStatusCode.kStatusCode401{
                self.ChapterDelegate?.unauthorizedUser()
                self.ChapterView?.showAlert(alert: SubjectListModel.message ?? "")
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "student APi status change")
            }
            
        }, completionnilResponse: { (nilResponseError) in
            self.ChapterView?.hideLoader()
            self.ChapterView?.showAlert(alert: nilResponseError ?? "")
        }) { (error) in
            self.ChapterView?.hideLoader()
            self.ChapterView?.showAlert(alert: error?.localizedDescription ?? "")
        }
    }
    
    func addChapter( ChapterId: Int,ChapterName: String,ClassSubjectId: Int) {
        self.ChapterView?.showLoader()
        let paramDict = [KApiParameters.AddSubjectApi.chapterId:ChapterId,KApiParameters.AddSubjectApi.chapterName:ChapterName, KApiParameters.AddSubjectApi.kclassSubjectId :ClassSubjectId ,"IsCover": false,
                         "CoveredBy": 0] as [String : Any]
        
        SubjectApi.sharedInstance.AddSubject(url: ApiEndpoints.KAddChapterApi, parameters: paramDict, completionResponse: { (responseModel) in
            print(responseModel)
            self.ChapterView?.hideLoader()
            self.ChapterView?.showAlert(alert: responseModel.message ?? "")
            self.ChapterDelegate?.GetChapterList()
            
        }, completionnilResponse: { (nilResponse) in
            self.ChapterView?.hideLoader()
            self.ChapterView?.showAlert(alert: nilResponse ?? "")
            // self.SubjectListVC?.showAlert(alert: nilResponse ?? Alerts.kMapperModelError)
        }) { (error) in
            self.ChapterView?.hideLoader()
            self.ChapterView?.showAlert(alert: error?.localizedDescription ?? "")
            
        }
    }
    
    func chapterDetail(chapterId: Int?) {
        self.ChapterView?.showLoader()
        
        SubjectApi.sharedInstance.getSubjectDetail(url: ApiEndpoints.KChapterDetailApi + "\(chapterId ?? 0)", parameters: nil, completionResponse: { (GetSubjectDetail) in
            
            if GetSubjectDetail.statusCode == KStatusCode.kStatusCode200{
                self.ChapterView?.hideLoader()
                //self.SubjectListDelegate?.SubjectDetailDidSuccess(Data: GetSubjectDetail)
            }else if GetSubjectDetail.statusCode == KStatusCode.kStatusCode401{
                self.ChapterView?.showAlert(alert: GetSubjectDetail.message ?? "")
                self.ChapterDelegate?.unauthorizedUser()
            }else{
                self.ChapterView?.hideLoader()
                CommonFunctions.sharedmanagerCommon.println(object: kPrintErrorMsg.kServiceError.kStatusError)
            }
        }, completionnilResponse: { (nilResponseError) in
            
            self.ChapterView?.hideLoader()
            // self.SubjectListDelegate?.SubjectDetailDidFailed()
            if let error = nilResponseError{
                self.ChapterView?.showAlert(alert: error)
            }
        }) { (error) in
            self.ChapterView?.hideLoader()
            //  self.SubjectListDelegate?.SubjectDetailDidFailed()
            if let err = error?.localizedDescription{
                self.ChapterView?.showAlert(alert: err)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: kPrintErrorMsg.kServiceError.kResponseError)
            }
        }
    }
    
    func deletechapter(chapterId: Int){
        let url = ApiEndpoints.KDeleteChapterApi +  "\(chapterId)"
        let param = [ChapterVC.chapterParam.kChapterId : chapterId ]
        self.ChapterView?.showLoader()
        SubjectApi.sharedInstance.deleteSubjectApi(url: url,completionResponse: {DeleteSubjectModel in
            self.ChapterView?.hideLoader()
            if DeleteSubjectModel.statusCode == KStatusCode.kStatusCode200{
                if DeleteSubjectModel.status == true{
                    self.ChapterView?.hideLoader()
                    self.ChapterDelegate?.SubjectDeleteSuccess(data: DeleteSubjectModel)
                }else{
                    self.ChapterView?.hideLoader()
                    self.ChapterView?.showAlert(alert: DeleteSubjectModel.message ?? Alerts.kServerErrorAlert)
                }
            }
        }, completionnilResponse: { (nilResponse) in
            self.ChapterView?.hideLoader()
            if let res = nilResponse{
                self.ChapterView?.showAlert(alert: res)
            }
        }) { (error) in
            self.ChapterView?.hideLoader()
            if let err = error{
                self.ChapterView?.showAlert(alert: err.localizedDescription)
            }
        }
    }
}

extension SubjectChapterVC : UITableViewDelegate{
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChapterToTopic"{
            let vc = segue.destination as? SubjectTopicVC
            vc?.ChapterID = ChapterID
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.performSegue(withIdentifier: "SubjectToChapter", sender: self)
        ChapterID = arrChapterList[indexPath.row].ChapterId ?? 0
        self.performSegue(withIdentifier: "ChapterToTopic", sender: self)
        
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
extension SubjectChapterVC : UITableViewDataSource , SubjectChapterTableViewDelegate {
    
    //MARK:- DELETE BUTTON
    func didPressDeleteButton(_ tag: Int) {
        if let ChapterId = arrChapterList[tag].ChapterId {
            print("your chapter id : \(ChapterId)")
            self.AlertMessageWithOkCancelAction(titleStr: KAPPContentRelatedConstants.kAppTitle, messageStr: "Do you want to delete this Chapter?", Target: self) { (actn) in
                if (actn == "Yes")
                {
                    self.ViewModel?.deletechapter(chapterId: ChapterId)
                }
            }
            
        }
    }
    //Mark:- EDIT BUTTON ACTION
    func didPressEditButton(_ tag: Int) {
        if let ChapterId = arrChapterList[tag].ChapterId {
            if let chapterID1  = arrChapterList[tag].ChapterId {
                self.ChapterID = chapterID1
                if let chapterName = arrChapterList[tag].ChapterName {
                    self.textFieldAlert.txtFieldVal.text = chapterName
                }
            }
            self.setupCustomViewForUpdate()
            textFieldAlert.delegate = self
        }
    }
    //MARK:- TABLE VIEW DATA SOURCE METHODS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrChapterList.count > 0{
            tableView.separatorStyle = .singleLine
             self.tblViewCenterLabel(tblView: tableView, lblText: KConstants.KDataNotFound, hide: true)
            return (arrChapterList.count)
        }else{
            tblViewCenterLabel(tblView: tableView, lblText: KConstants.kNoDataFound, hide: false)
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SubjectChapterTableViewCell
        
        cell.cellDelegate = self
        cell.deleteBtn.tag = indexPath.row
        
        if(arrChapterList.count > 0){
        let row = arrChapterList[indexPath.row]
        cell.setCellUI(data: row, indexPath: indexPath)
    }
        return cell
    }
}
//MARK:- CHAPTER DELEGATE
extension SubjectChapterVC : SubjectChapterDelegate{
    func GetChapterList() {
        if let id = subject_Id {
            self.ViewModel?.chapterList(search : "",skip : KIntegerConstants.kInt0,pageSize: 10,sortColumnDir: "",sortColumn: "", particularId: id)
        }
    }
    
    func SubjectDeleteSuccess(data: DeleteSubjectModel) {
        //  isSubjectDelete = true
        initializeCustomOkAlert(self.view, isHideBlurView: true)
        okAlertView.delegate = self
        okAlertView.lblResponseDetailMessage.text = data.message
        if let id = subject_Id {
            self.ViewModel?.chapterList(search : "",skip : KIntegerConstants.kInt0,pageSize: pageSize,sortColumnDir: "",sortColumn: "", particularId: id)
        }
    }
    func chapterList(data: [ChaptersData]) {
        arrChapterList = data
        self.tableView.reloadData()
    }
    func unauthorizedUser() {
        isUnauthorizedUser = true
    }
    
}

extension SubjectChapterVC : OKAlertViewDelegate {
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

extension SubjectChapterVC : UIScrollViewDelegate{
    
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
                if let id = subject_Id {
                self.ViewModel?.chapterList(search : "",skip : skip,pageSize: pageSize,sortColumnDir: "",sortColumn: "", particularId: id)
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

extension SubjectChapterVC : NavigationSearchBarDelegate{
    func textDidChange(searchBar: UISearchBar, searchText: String) {
        DispatchQueue.main.async {
            self.ViewModel?.isSearching = true
            self.arrChapterList.removeAll()
            if let id = self.subject_Id {
            self.ViewModel?.chapterList(search : searchText,skip : KIntegerConstants.kInt0,pageSize: KIntegerConstants.kInt10,sortColumnDir: "",sortColumn: "", particularId: id)
            }
        }
    }
    
    func cancelButtonPress(uiSearchBar: UISearchBar) {
        DispatchQueue.main.async {
            self.ViewModel?.isSearching = false
            self.arrChapterList.removeAll()
            if let id = self.subject_Id {
            self.ViewModel?.chapterList(search : "",skip : KIntegerConstants.kInt0,pageSize:  KIntegerConstants.kInt10,sortColumnDir: "",sortColumn: "", particularId: id)
            }
        }
    }
}
extension SubjectChapterVC :ViewDelegate {
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
        self.textFieldAlert.txtFieldVal.SetTextFont(textSize: KTextSize.KSixteen, placeholderText: KPlaceholder.kChapterNamePlaceholder)
        self.textFieldAlert.txtFieldVal.addViewCornerShadow(radius: 8, view: self.textFieldAlert.txtFieldVal)
        self.textFieldAlert.txtFieldVal.txtfieldPadding(leftpadding: 20, rightPadding: 0)
    }
    func setupCustomView(){
        initializeCustomTextFieldView(self.view, isHideBlurView: true)
        textFieldAlert.delegate = self
        setupUI()
        self.textFieldAlert.lblTitle.text = ChapterVC.CustomViewString.kAddChapter
        self.textFieldAlert.txtFieldVal.text = ""
        self.textFieldAlert.BtnTxt.setTitle(ChapterVC.CustomViewString.kAdd, for: .normal)
        self.textFieldAlert.btnCancel.setTitle(ChapterVC.CustomViewString.kCancel, for: .normal)
        self.textFieldAlert.btnCancel.cornerRadius = 4.0
        self.textFieldAlert.BtnTxt.cornerRadius = 4.0
        setButton = ChapterVC.CustomViewString.kAdd
    }
    
    func setupCustomViewForUpdate() {
        initializeCustomTextFieldView(self.view, isHideBlurView: true)
        textFieldAlert.delegate = self
        self.textFieldAlert.lblTitle.text = ChapterVC.CustomViewString.kAddChapter
        self.textFieldAlert.BtnTxt.setTitle(ChapterVC.CustomViewString.kUpdate, for: .normal)
        self.textFieldAlert.btnCancel.setTitle(ChapterVC.CustomViewString.kCancel, for: .normal)
        self.textFieldAlert.btnCancel.cornerRadius = 4.0
        self.textFieldAlert.BtnTxt.cornerRadius = 4.0
        setButton = ChapterVC.CustomViewString.kUpdate
    }
}

extension SubjectChapterVC : TextFieldAlertDelegate {
    func btnCancel() {
    }
    
    func BtnTxt() {
        self.view.endEditing(true)
        if self.checkInternetConnection(){
            if subject_Id != 0{
                if textFieldAlert.txtFieldVal.text != ""{
                    isSubjectAddSuccessFully = true
                    textFieldAlert.removeFromSuperview()
                    if setButton == ChapterVC.CustomViewString.kAdd {
                        if let text = textFieldAlert.txtFieldVal.text {
                            self.ViewModel?.addChapter(ChapterId: 0, ChapterName: text, ClassSubjectId: subject_Id ?? 0)
                        }
                    }
                    else {
                        if let text = textFieldAlert.txtFieldVal.text {
                            self.ViewModel?.addChapter(ChapterId: ChapterID, ChapterName:text, ClassSubjectId: subject_Id ?? 0)
                            //
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



