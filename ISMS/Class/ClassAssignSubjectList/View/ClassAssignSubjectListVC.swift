//
//  ClassAssignSubjectList.swift
//  ISMS
//
//  Created by Taranjeet Singh on 7/5/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class ClassAssignSubjectListVC: BaseUIViewController {

    //Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtFieldSelectClass: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    //Variables
    var isFirstTime : Bool?
    var arrClassList = [GetClassListResultData]()
    var arrAllAssignedSubjects = [GetAllAssignSubjectResultData]()
    var arrSelectedAssignSubjectId = [String]()
    var arrAssignSubtoClass = [AssignSubjectsToClassModel]()
    var selectedAssignedSubjectIds : String?
    var viewModel : ClassAssignSubjectListViewModel?
    var selectedClassId : Int?
    var selectedClassArrIndex : Int?
    var isUnauthorizedUser = false
    var isClassListOrAssignSubjectListFailed = false
    var skip = Int()
    var isScrolling : Bool?
    var pageSize = KIntegerConstants.kInt1000
    var pointNow:CGPoint!
    var isFetching:Bool?
    var selectedClassIndex = 0
    
        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view.
            setUI()
            registerTableViewCell()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(true)
            if checkInternetConnection(){
                self.viewModel?.classList(searchText: "", pageSize: KIntegerConstants.kInt1000, filterBy: 0, skip: KIntegerConstants.kInt0)
            }else {
                self.showAlert(alert: Alerts.kNoInternetConnection)
            }
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            navigationController?.view.setNeedsLayout() // force update layout
            navigationController?.view.layoutIfNeeded() // to fix height of the navigation bar
        }
    
    //MARK:- Class Button Drop down
    @IBAction func btnClassDropDown(_ sender: UIButton) {
        if checkInternetConnection(){
            if arrClassList.count > 0{
                UpdatePickerModel(count: arrClassList.count, sharedPickerDelegate: self, View:  self.view)
                selectedClassId = arrClassList[0].classId
            }
//            self.viewModel?.classList(searchText: "", pageSize: KIntegerConstants.kInt1000, filterBy: 0, skip: KIntegerConstants.kInt0)
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
    }
    
    //Mark:- Submit button
    
    @IBAction func btnSubmitAction(_ sender: UIButton) {
        
        if arrAssignSubtoClass.count == 0{
            CommonFunctions.sharedmanagerCommon.println(object: "Please select another subjects.")
            self.showAlert(alert: "Please assigned new subjects to class.")
        }else{
            self.viewModel?.assignSubjectsClass(classId: selectedClassId ?? 0, classSubjectList: arrAssignSubtoClass)
        }
    }
}
    
//MARK:- Class Deleagate
extension ClassAssignSubjectListVC : ClassAssignSubjectListDelegate
{
    
    func assignSubjectsToClassDidSuccess(data: AssignSubjectsToClassResponseModel)
    {
        if let msg = data.message
        {
            arrAssignSubtoClass.removeAll()
            
            self.AlertMessageWithOkAction(titleStr: KAPPContentRelatedConstants.kAppTitle, messageStr: "Subject assigned successfully and now you can add syllabus by clicking selected subjects.", Target: self) {
                self.arrAllAssignedSubjects.removeAll()
                self.viewModel?.getAllAssignSubjectList(classId: self.selectedClassId ?? 0, searchText: "", pageSize: KIntegerConstants.kInt1000, filterBy: 0, skip: self.skip)
            }
        }
    }
    
    func assignSubjectsToClassFailed() {
        
    }
    

    func classSubjectDidSuccess(data: [GetAllAssignSubjectResultData]?) {
        if data != nil{
            if data?.count ?? 0 > 0{
                 self.tblViewCenterLabel(tblView: tableView, lblText: "", hide: true)
                for value in (data)!{
                    let containsSameValue = arrAllAssignedSubjects.contains(where: {$0.subjectId == value.subjectId})
                    if containsSameValue == false{
                        arrAllAssignedSubjects.append(value)
                    }
                }
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Zero")
               // self.tblViewCenterLabel(tblView: tblViewpopUp.tblView, lblText: KConstants.KDataNotFound, hide: false)

            }
        }else{
            CommonFunctions.sharedmanagerCommon.println(object: "Nil")
            self.tblViewCenterLabel(tblView: tblViewpopUp.tblView, lblText: KConstants.KDataNotFound, hide: false)

        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    func classSubjectDidfailed() {
        isClassListOrAssignSubjectListFailed = true
    }
    func unauthorizedUser() {
        isUnauthorizedUser = true
    }
    func classListDidSuccess(data: [GetClassListResultData]?) {
        isFetching = true
        if data != nil{
            if data?.count ?? 0 > 0{
                arrClassList = data!
                if arrClassList.count > 0{
                    //Hit Get All Assigned Subjects List to Class Api first time
//                    if isFirstTime == true{
                       // txtFieldSelectClass.text = arrClassList[0].name
                       // selectedClassId = arrClassList[0].classId
                       // self.viewModel?.getAllAssignSubjectList(classId: selectedClassId ?? 0, searchText: "", pageSize: KIntegerConstants.kInt1000, filterBy: 0, skip: skip)
//                    }else{
//                    }
                    
                }
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Zero")
            }
        }else{
            CommonFunctions.sharedmanagerCommon.println(object: "Nil")
        }
    }
    func classListDidFailed() {
        isClassListOrAssignSubjectListFailed = false
    }
}
    
    //MARk:- View Delegate
    extension ClassAssignSubjectListVC : ViewDelegate{
        func registerTableViewCell(){
            self.tableView.register(UINib(nibName: "SelectionTblViewCell", bundle: nil), forCellReuseIdentifier: KTableViewCellIdentifier.kSelectionTableViewCell)
        }
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
            //Initiallize memory for view model
            self.viewModel = ClassAssignSubjectListViewModel.init(delegate: self)
            self.viewModel?.attachView(viewDelegate: self)
            //Set Search bar in navigation
            self.setSearchBarInNavigationController(placeholderText: KSearchBarPlaceHolder.kUserSearchBarClassPlaceHolder, navigationTitle: KStoryBoards.KClassListIdentifiers.kSubjectListTitle, navigationController: self.navigationController, navigationSearchBarDelegates: self)
            txtFieldSelectClass.txtfieldPadding(leftpadding: 20, rightPadding: 0)
            tblViewCenterLabel(tblView: tableView, lblText: "Select class to assign subject", hide: false)
            //Set Back Button
            self.setBackButton()
            
            //Set picker view
            self.SetpickerView(self.view)
            
           // cornerButton(btn: btnSubmit, radius: 8)
            
            //Title
            self.title = KStoryBoards.KClassListIdentifiers.kClassListTitle
            
            self.tableView.tableFooterView = UIView()
            tableView.separatorStyle = .none
            tableView.separatorColor = KAPPContentRelatedConstants.kLightBlueColour
            
            viewModel?.isSearching = false
            
            guard let theme = ThemeManager.shared.currentTheme else{ return }
            btnSubmit.backgroundColor = theme.uiButtonBackgroundColor
            btnSubmit.titleLabel?.textColor = theme.uiButtonTextColor
        }
        //Mark:- Select/Unselect Subjects
        @objc func btnActionSelectDeselectSubjects(_ sender: UIButton){
            
            if sender.currentImage == UIImage(named: kImages.kUncheck){
                //Check ClassSubjectId > 0
                sender.setImage(UIImage(named: kImages.kCheck), for: .normal)
                arrAllAssignedSubjects[sender.tag].isSelected = 1
            }else{
                //If already subject assigned then untick send remove id's in list
                sender.setImage(UIImage(named:  kImages.kUncheck), for: .normal)
                arrAllAssignedSubjects[sender.tag].isSelected = 0
            }
            
            if arrAllAssignedSubjects[sender.tag].classSubjectId ?? 0 > 0&&arrAllAssignedSubjects[sender.tag].isSelected == 1{
                let customListContainId = arrAssignSubtoClass.contains(where:{$0.subjectId == arrAllAssignedSubjects[sender.tag].subjectId})
                
                if customListContainId == true{
                    arrAssignSubtoClass = arrAssignSubtoClass.filter(){$0.subjectId != arrAllAssignedSubjects[sender.tag].subjectId}
                }else{
                    CommonFunctions.sharedmanagerCommon.println(object: "Does not contain subject Id.")
                }

            }else if arrAllAssignedSubjects[sender.tag].classSubjectId ?? 0 == 0&&arrAllAssignedSubjects[sender.tag].isSelected == 0{
                let customListContainId = arrAssignSubtoClass.contains(where:{$0.subjectId == arrAllAssignedSubjects[sender.tag].subjectId})
                if customListContainId == true{
                    arrAssignSubtoClass = arrAssignSubtoClass.filter(){$0.subjectId != arrAllAssignedSubjects[sender.tag].subjectId}
                }else{
                    CommonFunctions.sharedmanagerCommon.println(object: "Does not contain subject Id.")
                }
                CommonFunctions.sharedmanagerCommon.println(object: "When class id is zero and selected if is zero:- \(arrAssignSubtoClass.count)")
            }else if arrAllAssignedSubjects[sender.tag].classSubjectId ?? 0 > 0&&arrAllAssignedSubjects[sender.tag].isSelected == 0{
                CommonFunctions.sharedmanagerCommon.println(object: "When class id is greater then zero and selected if is zero:- \(arrAssignSubtoClass.count)")
                let unselectAlreadyAssignValue = AssignSubjectsToClassModel(classSubjectId: arrAllAssignedSubjects[sender.tag].classSubjectId, subjectId: arrAllAssignedSubjects[sender.tag].subjectId, subjectName: arrAllAssignedSubjects[sender.tag].subjectName)
                arrAssignSubtoClass.append(unselectAlreadyAssignValue)
                
            }else if arrAllAssignedSubjects[sender.tag].classSubjectId ?? 0 == 0&&arrAllAssignedSubjects[sender.tag].isSelected == 1{
                let newlyAssignValue = AssignSubjectsToClassModel(classSubjectId: arrAllAssignedSubjects[sender.tag].classSubjectId, subjectId: arrAllAssignedSubjects[sender.tag].subjectId, subjectName: arrAllAssignedSubjects[sender.tag].subjectName)
                arrAssignSubtoClass.append(newlyAssignValue)
                CommonFunctions.sharedmanagerCommon.println(object: "When class id is zero and selected if is One:- \(arrAssignSubtoClass.count)")
            }
        }
    }

    //MARK:- Table view delagate
    extension ClassAssignSubjectListVC : UITableViewDelegate{
        func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
        }
        
        
        func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
            return 70;
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
            return UITableView.automaticDimension;//Choose your custom row height
        }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            if let foundId = arrAllAssignedSubjects[indexPath.row].classSubjectId  {
                
                if arrAllAssignedSubjects[indexPath.row].isSelected == 1 && foundId != 0 {
                let storyboard = UIStoryboard.init(name: KStoryBoards.kSubjectStoryboard, bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "SubjectChapterVC") as! SubjectChapterVC
                vc.subject_Id = foundId
                self.navigationController?.pushViewController(vc, animated: true)
                }
                else {
                    print("your check box has zero value")
                }
            }
            else {
                print("Not found Subject ID")
            }
            
            if tableView == tblViewpopUp.tblView{
                CommonFunctions.sharedmanagerCommon.println(object: "Selection Table View")
              
         
                
            }
        }
    }
    
    //MARK:- Table view data source
    extension ClassAssignSubjectListVC : UITableViewDataSource{
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            switch tableView {
            case self.tableView:
                if arrAllAssignedSubjects.count > 0{
                    tblViewpopUp.tblView.separatorStyle = .singleLine
                    return (arrAllAssignedSubjects.count)
                }else{
                   // tblViewCenterLabel(tblView: tblViewpopUp.tblView, lblText: KConstants.kNoDataFound, hide: false)
                    return 0
                }
            default:
                return 0
            }
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
            let cell = tableView.dequeueReusableCell(withIdentifier: KTableViewCellIdentifier.kSelectionTableViewCell, for: indexPath) as! SelectionTblViewCell
            
            if arrAllAssignedSubjects.count > 0 {
            cell.lblRowTitle.text = arrAllAssignedSubjects[indexPath.row].subjectName
//            cell.selectionStyle = .none
            
                //For Show already assigned subjects to class
            if let classSubId = arrAllAssignedSubjects[indexPath.row].classSubjectId{
                    //Set the assign subjects to assignselected array
             
                print("your checked value :\(arrAllAssignedSubjects[indexPath.row].isSelected)")
                print("your class sub id :\(classSubId)")
               
                    
                    if arrAllAssignedSubjects[indexPath.row].isSelected == 0&&classSubId == 0{
                        cell.btnIsSelected.setImage(UIImage.init(named: kImages.kUncheck), for: .normal)
                    }else if arrAllAssignedSubjects[indexPath.row].isSelected == 1&&classSubId == 0{
                        cell.btnIsSelected.setImage(UIImage.init(named: kImages.kCheck), for: .normal)
                        arrAllAssignedSubjects[indexPath.row].isSelected = 1
                    }else if arrAllAssignedSubjects[indexPath.row].isSelected == 0&&classSubId > 0{
                        cell.btnIsSelected.setImage(UIImage.init(named: kImages.kUncheck), for: .normal)
                        arrAllAssignedSubjects[indexPath.row].isSelected = 0
                    }
                    else if arrAllAssignedSubjects[indexPath.row].isSelected == 1&&classSubId > 0{
                        cell.btnIsSelected.setImage(UIImage.init(named: kImages.kCheck), for: .normal)
                        arrAllAssignedSubjects[indexPath.row].isSelected = 1
                    }

            }
            cell.btnIsSelected.tag = indexPath.row
            cell.btnIsSelected.addTarget(self, action: #selector(btnActionSelectDeselectSubjects(_:)), for: .touchUpInside)
            }
            return cell
        }
    }
    
    //MARK:- Scroll View delegates
    extension ClassAssignSubjectListVC : UIScrollViewDelegate{
        
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
                    self.viewModel?.getAllAssignSubjectList(classId: selectedClassId ?? 0, searchText: "", pageSize: KIntegerConstants.kInt1000, filterBy: 0, skip: skip)
                }
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Scrolling")
            }
        }
        func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
            pointNow = scrollView.contentOffset
        }
    }


extension ClassAssignSubjectListVC : SharedUIPickerDelegate{
    func DoneBtnClicked() {
        if checkInternetConnection(){
            selectedClassId = arrClassList[self.selectedClassIndex].classId
            txtFieldSelectClass.text = arrClassList[self.selectedClassIndex].name
            arrAllAssignedSubjects.removeAll()
            self.viewModel?.getAllAssignSubjectList(classId: selectedClassId ?? 0, searchText: "", pageSize: KIntegerConstants.kInt1000, filterBy: 0, skip: 0)
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
    }
    
    func GetTitleForRow(index: Int) -> String {
        if arrClassList.count > 0{
            self.selectedClassIndex = 0
           // txtFieldSelectClass.text = arrClassList[0].name
            return arrClassList[index].name ?? ""
        }
        return ""
    }
    
    func SelectedRow(index: Int) {
        if arrClassList.count > 0{
            self.selectedClassIndex = index
            selectedClassId = arrClassList[index].classId
          //  txtFieldSelectClass.text = arrClassList[index].name
        }
    }
}

    //MARK:- Custom Ok Alert
    extension ClassAssignSubjectListVC : OKAlertViewDelegate{
        
        //Ok Button Clicked
        func okBtnAction() {
            self.okAlertView.removeFromSuperview()
            if isUnauthorizedUser == true{
                isUnauthorizedUser = false
                CommonFunctions.sharedmanagerCommon.setRootLogin()
            }
            if isClassListOrAssignSubjectListFailed == true{
                isClassListOrAssignSubjectListFailed = false
            }
        }
    }
//MARK:- Custom Table Popup View delegate
extension ClassAssignSubjectListVC : CustomTableViewPopUpDelegate{
    func submitButton() {
        if arrSelectedAssignSubjectId.count == 0{
            
        }
        if checkInternetConnection(){
//            self.viewModel?.assignSubjectsClass(classId: selectedClassId ?? 0, subjectId: <#T##Int#>)
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
        tblViewpopUp.isHidden = true
    }
}

