//
//  SubjectChapterVC.swift
//  ISMS
//
//  Created by Kuldeep Singh on 11/15/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class SubjectChapterVC: BaseUIViewController {
    //MARK:- Variables
    
    var ViewModel : SubjectChapterViewModel?
    var arrChapterList = [ChaptersData]()
    var selectedSubjectArrIndex : Int?
 
    var isUnauthorizedUser = false
    var isSubjectAddSuccessFully = false
    var isSubjectDelete = false
    var skip = Int()
    var isScrolling : Bool?
    var pageSize = KIntegerConstants.kInt10
    var pointNow:CGPoint!
    var isFetching:Bool?
    var subject_Id:Int?
    var setButton = ""
    var ChapterID = 0
    var chapterId : Int?
    //MARK:- Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblSubjectName: UILabel!
    //MARK:- View Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.separatorColor = KAPPContentRelatedConstants.kLightBlueColour
        // subject_Id = 40
        self.ViewModel = SubjectChapterViewModel.init(delegate: self)
        self.ViewModel?.attachView(viewDelegate: self)
        
        self.title = KStoryBoards.KAddSubjectIdentifiers.kChapterListTitle
        setBackButton()
        self.setSearchBarInNavigationController(placeholderText: KSearchBarPlaceHolder.kUserSearchBarChapterPlaceHolder, navigationTitle: KStoryBoards.KAddSubjectIdentifiers.kChapterListTitle, navigationController: self.navigationController, navigationSearchBarDelegates: self)
    
    
    }

    override func viewWillAppear(_ animated: Bool) {
       // subject_Id = 40
        if checkInternetConnection(){
            if let id = subject_Id {
                print("your clicked subject id : \(id)")
            self.ViewModel?.chapterList(search : "",skip : KIntegerConstants.kInt0,pageSize: pageSize,sortColumnDir: "",sortColumn: "", particularId: id)
            }
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
    }
    @IBAction func ActionCreateNewChapter(_ sender: Any) {
        self.setupCustomView()
        textFieldAlert.delegate = self
     
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    

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

extension SubjectChapterVC : YesNoAlertViewDelegate{
    
    func yesBtnAction() {
        if self.checkInternetConnection(){
            if let chapterId1 = self.chapterId{
                self.ViewModel?.deletechapter(chapterId: chapterId1)
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

extension SubjectChapterVC : UITableViewDataSource , SubjectChapterTableViewDelegate {
    
    //MARK:- DELETE BUTTON
    func didPressDeleteButton(_ tag: Int) {
        if let ChapterId = arrChapterList[tag].ChapterId {
            self.chapterId = ChapterId
            print("your chapter id : \(ChapterId)")
            initializeCustomYesNoAlert(self.view, isHideBlurView: true)
            yesNoAlertView.delegate = self
            yesNoAlertView.lblResponseDetailMessage.text = Alerts.kDeleteChapterAlert
            //            self.AlertMessageWithOkCancelAction(titleStr: KAPPContentRelatedConstants.kAppTitle, messageStr: "Do you want to delete this Chapter?", Target: self) { (actn) in
            //                if (actn == "Yes")
            //                {
            //                    self.ViewModel?.deletechapter(chapterId: ChapterId)
            //                }
            //            }
            
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



