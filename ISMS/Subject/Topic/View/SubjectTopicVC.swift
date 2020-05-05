//
//  SubjectTopicVC.swift
//  ISMS
//
//  Created by Gurleen Osahan on 11/15/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class SubjectTopicVC: BaseUIViewController {
    //MARK:- Variables
    
     var isUnauthorizedUser = false
    var ViewModel : SubjectChapterTopicViewModel?
    var arrSubjectlist = [GetTopicResultData]()
    var skip = Int()
    var isScrolling : Bool?
    var pageSize = KIntegerConstants.kInt10
    var pointNow:CGPoint!
    var isFetching:Bool?
    var ChapterID : Int?
    var isSubjectAddSuccessFully = false
    var setButton = ""
    var topicID = 0
    var deleteTopic:Int?
    
    //MARK:- Outlets
    @IBOutlet weak var tableView: UITableView!
    //MARK:- View Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.separatorColor = KAPPContentRelatedConstants.kLightBlueColour
        setBackButton()
        self.ViewModel = SubjectChapterTopicViewModel.init(delegate: self)
        self.ViewModel?.attachView(viewDelegate: self)
        self.title = KStoryBoards.KAddSubjectIdentifiers.kTopicListTitle
           self.setSearchBarInNavigationController(placeholderText: KSearchBarPlaceHolder.kUserSearchBarTopicPlaceHolder, navigationTitle: KStoryBoards.KAddSubjectIdentifiers.kTopicListTitle, navigationController: self.navigationController, navigationSearchBarDelegates: self)
        
        if let ChapterId = ChapterID {
        self.ViewModel?.TopicList(search: "", skip: 0, pageSize: 10, sortColumnDir: "", sortColumn: "", particularID: ChapterId)
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func ActionAddTopic(_ sender: Any) {
        self.setupCustomView()
        textFieldAlert.delegate = self
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
        //
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
                if let ChapterId = self.ChapterID {
                    self.ViewModel?.TopicList(search: "", skip: skip, pageSize: pageSize, sortColumnDir: "", sortColumn: "", particularID: ChapterId )
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

extension SubjectTopicVC : NavigationSearchBarDelegate{
    func textDidChange(searchBar: UISearchBar, searchText: String) {
        DispatchQueue.main.async {
            self.ViewModel?.isSearching = true
            self.arrSubjectlist.removeAll()
            //    self.ViewModel?.chapterList(search : "",skip : KIntegerConstants.kInt0,pageSize: KIntegerConstants.kInt10,sortColumnDir: "",sortColumn: "")
            if let ChapterId = self.ChapterID {
                self.ViewModel?.TopicList(search: searchText, skip: 0, pageSize: 10, sortColumnDir: "", sortColumn: "", particularID: ChapterId)
            }
        }
    }
    
    func cancelButtonPress(uiSearchBar: UISearchBar) {
        DispatchQueue.main.async {
            self.ViewModel?.isSearching = true
            self.arrSubjectlist.removeAll()
            if let ChapterId = self.ChapterID {
                self.ViewModel?.TopicList(search: "", skip: 0, pageSize: 10, sortColumnDir: "", sortColumn: "", particularID: ChapterId)
            }
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

//MARK:- TABLEVIEW DELEGATE METHODS
extension SubjectTopicVC : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
//    {
//        return 70;//Choose your custom row height
//    }
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 130;
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
//        return UITableView.automaticDimension;//Choose your custom row height
//    }
    
}

//MARK:- CELL DELETE ,EDIT BUTTON , TABLEVIEW DATA SOURCE
extension SubjectTopicVC : UITableViewDataSource , SubjectTopicTableViewDelegate {
    
    func didPressDeleteButton(_ tag: Int) {
        if let topicID = arrSubjectlist[tag].topicId {
            self.deleteTopic = topicID
            print("your chapter id : \(deleteTopic)")
            initializeCustomYesNoAlert(self.view, isHideBlurView: true)
            yesNoAlertView.delegate = self
            yesNoAlertView.lblResponseDetailMessage.text = Alerts.kDeleteChapterAlert
           
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
            self.tblViewCenterLabel(tblView: tableView, lblText: KConstants.KDataNotFound, hide: true)
            return (arrSubjectlist.count)
        }else{
            tblViewCenterLabel(tblView: tableView, lblText: KConstants.kNoDataFound, hide: false)
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: KTableViewCellIdentifier.kTopicTableView, for: indexPath) as! SubjectTopicTableViewCell
        cell.cellDelegate = self
        cell.deleteBtn.tag = indexPath.row
        if(arrSubjectlist.count > 0){
            let row = arrSubjectlist[indexPath.row]
            cell.setCellUI(data: row, indexPath: indexPath)
        }
        return cell
    }
}

extension SubjectTopicVC : YesNoAlertViewDelegate{
    
    func yesBtnAction() {
        if self.checkInternetConnection(){
            if let deleteTopic1 = self.deleteTopic{
                 self.ViewModel?.deletechapter(topicId: deleteTopic1)
                yesNoAlertView.removeFromSuperview()
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Delete subject id is nil")
                yesNoAlertView.removeFromSuperview()
            }
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
            yesNoAlertView.removeFromSuperview()
        }
        yesNoAlertView.removeFromSuperview()
    }
    
    func noBtnAction() {
        yesNoAlertView.removeFromSuperview()
    }
}
