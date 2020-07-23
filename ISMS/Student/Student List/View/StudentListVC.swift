//
//  StudentListVC.swift
//  ISMS
//
//  Created by Poonam Sharma on 6/26/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class StudentListVC: BaseUIViewController {
    static var isStartSearching = false
    var ViewModel : StudentListViewModel?
    var arrStudentlist = [GetStudentResultData]()
    var selectedStudentArrIndex : Int?
    var enrollmentId:Int?
    var classData : GetCommonDropdownModel!
    var selectedClassIndex = 0
    var selectedClassID : Int?
    var skip = Int()
    var isScrolling : Bool?
    var pageSize = KIntegerConstants.kInt10
    var pointNow:CGPoint!
    var isFetching:Bool?
    var isUnauthorizedUser = false
    var isStudentDelete = false
    var selectedSubjectArrIndex : Int?
    var isClassSelected : Bool?
    
     let departmentId = UserDefaultExtensionModel.shared.HODDepartmentId
    
    @IBOutlet weak var btnAddStudent: UIButton!
    @IBOutlet weak var dropDownTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackButton()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if checkInternetConnection()
        {
           // arrStudentlist.removeAll()
              self.ViewModel?.getClassId(id:departmentId, enumtype: 6)
//             self.ViewModel?.studentList(classId : selectedClassID, Search: "", Skip: 0, PageSize: 1000)
        }
        else
        {
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
         
    }
    
    @IBAction func BtnEditAction(_ sender: Any) {
        if arrStudentlist.count > 0{
            
            let data = arrStudentlist[(sender as AnyObject).tag]
            let vc = UIStoryboard.init(name: KStoryBoards.kStudent, bundle: Bundle.main).instantiateViewController(withIdentifier: KStoryBoards.KAddStudentIdentifiers.kAddStudentVC) as! AddStudentVC
            vc.approach = "Edit"
            vc.enrollmentId = data.enrollmentId
            vc.studentUserId = data.studentUserId
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        
        if arrStudentlist.count > 0{
            let data = arrStudentlist[(sender as AnyObject).tag]
            selectedStudentArrIndex = (sender as AnyObject).tag
            enrollmentId = data.enrollmentId
            initializeCustomYesNoAlert(self.view, isHideBlurView: true)
            yesNoAlertView.delegate = self
            yesNoAlertView.lblResponseDetailMessage.text = Alerts.kDeleteStudentAlert
            //                self.alertForRemoveStudent()
            
        }
        
        
    }
    
    
    @IBAction func AddStudentAction(_ sender: Any) {
        let vc = UIStoryboard.init(name: KStoryBoards.kStudent, bundle: Bundle.main).instantiateViewController(withIdentifier: KStoryBoards.KAddStudentIdentifiers.kAddStudentVC) as! AddStudentVC
        vc.studentId = 0
        vc.enrollmentId = 0
        vc.studentUserId = 0
        vc.approach = "AddNew"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnOpenDropDown(_ sender: Any) {
        if classData.resultData?.count ?? 0 > 0{
            UpdatePickerModel2(count: classData?.resultData?.count ?? 0, sharedPickerDelegate: self, View:  self.view, index: 0)
        }
    }
    
    //Setup UI
    func setupUI(){
        
//        guard let theme = ThemeManager.shared.currentTheme else {return}
//        btnAddStudent.tintColor = theme.uiButtonBackgroundColor
        
        self.title = KStoryBoards.KAddStudentIdentifiers.kStudentListTitle
        self.ViewModel = StudentListViewModel.init(delegate: self)
        self.ViewModel?.attachView(viewDelegate: self)
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = KAPPContentRelatedConstants.kLightBlueColour
        self.tblViewCenterLabel(tblView: tableView, lblText: "Select student class", hide: false)
        dropDownTextField.txtfieldPadding(leftpadding: 10, rightPadding: 0)
        SetpickerView(self.view)
        
        self.setSearchBarInNavigationController(placeholderText: KSearchBarPlaceHolder.kUserSearchBarStudentPlaceHolder, navigationTitle: KStoryBoards.KAddStudentIdentifiers.kStudentListTitle, navigationController: self.navigationController, navigationSearchBarDelegates: self)
    }
    
}

extension StudentListVC : OKAlertViewDelegate{
    
    //Ok Button Clicked
    func okBtnAction() {
        if isUnauthorizedUser == true{
            isUnauthorizedUser = false
            CommonFunctions.sharedmanagerCommon.setRootLogin()
        }else if isStudentDelete == true{
            isStudentDelete = false
            if let selectedIndex = self.selectedStudentArrIndex{
                self.arrStudentlist.remove(at: selectedIndex)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
        }else{
            
        }
        okAlertView.removeFromSuperview()
    }
}

extension StudentListVC : YesNoAlertViewDelegate{
    
    func yesBtnAction() {
        if self.checkInternetConnection(){
            if let enrollmentId = self.enrollmentId{
                self.ViewModel?.deleteStudent(enrollmentId: enrollmentId)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Delete subject id is nil")
            }
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
        yesNoAlertView.removeFromSuperview()
        
    }
    
    func noBtnAction() {
        yesNoAlertView.removeFromSuperview()
    }
}


extension StudentListVC : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 109;//Choose your custom row height
    }
    
}
extension StudentListVC : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrStudentlist.count > 0{
            tableView.separatorStyle = .singleLine
            return (arrStudentlist.count)
        }else{
          //  tblViewCenterLabel(tblView: tableView, lblText: KConstants.kNoDataFound, hide: false)
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: KTableViewCellIdentifier.kStudentTableViewCell, for: indexPath) as! StudentListTableCell
        
        cell.setCellUI(data: arrStudentlist, indexPath: indexPath)
        return cell
    }
}

extension StudentListVC : StudentListDelegate{
    func sessionListDidSuccess(data: [GetSessionResultData]?) {
        
    }
    
    func StudentSessionListDidSuccess(data: GetStudentSessionResultData?) {
        
    }
    
    func unauthorizedUser() {
        isUnauthorizedUser = true
    }
    func getClassdropdownDidSucceed(data : GetCommonDropdownModel){
        classData = data
        if let count = data.resultData?.count{
            if count > 0 {
//                UpdatePickerModel2(count: classData?.resultData?.count ?? 0, sharedPickerDelegate: self, View:  self.view, index: 0)
                var resultData = classData.resultData
               // self.dropDownTextField.text = resultData?[0].name
              //  var newClassId = resultData?[0].id
               //  self.ViewModel?.studentList(classId : newClassId, Search: "", Skip: KIntegerConstants.kInt0, PageSize: pageSize)
            }else{
                print("Department Count is zero.")
            }
        }
    }
    
    func StudentDeleteSuccess(Data: DeleteStudentModel) {
        
        isStudentDelete = true
        initializeCustomOkAlert(self.view, isHideBlurView: true)
        okAlertView.delegate = self
        okAlertView.lblResponseDetailMessage.text = Data.message
        tableView.reloadData()
        
    }
    
    func StudentDeleteDidSuccess() {
        
    }
    
    func StudentListDidSuccess(data : [GetStudentResultData]?)
    {
        isFetching = true
        // arrStudentlist.removeAll()
        if data != nil{
            if data?.count ?? 0 > 0
            {
                guard let rsltData = data else
                {
                    return
                }
                
                tableView.delegate = self
                tableView.dataSource = self
                
                //When user select the class for change the data in list selected
                if isClassSelected == true
                {
                    arrStudentlist.removeAll()
                    _ = rsltData.map({ (data) in
                        arrStudentlist.append(data)
                    })
                    self.tblViewCenterLabel(tblView: tableView, lblText: "", hide: true)
                }
                else
                {
                    for value in rsltData{
                        let containsSameValue = arrStudentlist.contains(where: {$0.enrollmentId == value.enrollmentId})
                        if containsSameValue == false{
                            arrStudentlist.append(value)
                        }
                    }
                    self.tblViewCenterLabel(tblView: tableView, lblText: "", hide: true)
                }
            }
            else
            {
                //Remove the array student list
                if isClassSelected == true
                {
                    arrStudentlist.removeAll()
                }
               // self.tblViewCenterLabel(tblView: tableView, lblText: KConstants.KDataNotFound, hide: false)
                //                CommonFunctions.sharedmanagerCommon.println(object: "Zero")
            }
        }
        else
        {
            arrStudentlist.removeAll()
            self.tblViewCenterLabel(tblView: tableView, lblText: KConstants.kNoDataFound, hide: false)
            //            CommonFunctions.sharedmanagerCommon.println(object: "Nil")
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    func StudentListDidFailed() {
        
    }
    
    
    func StudentDeleteDidfailed() {
        
    }
    
}

extension StudentListVC : ViewDelegate{
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
    
    func alertForRemoveStudent(){
        let alertController = UIAlertController(title: KAPPContentRelatedConstants.kAppTitle, message: Alerts.kDeleteStudentAlert, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
            UIAlertAction in
            
            if let enrollmentId1 = self.enrollmentId{
                self.ViewModel?.deleteStudent(enrollmentId: enrollmentId1)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Delete Student id is nil")
            }
            
        }
        let cancelAction = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
    
}
extension StudentListVC: SharedUIPickerDelegate{
    func DoneBtnClicked() {
        if let count = classData.resultData?.count{
            if count > 0{
                //Bool for set the array in the list of students for selected class
                isClassSelected = true
                dropDownTextField.text = classData?.resultData?[selectedClassIndex].name
                if selectedClassIndex == 0{
                    self.dropDownTextField.text = self.classData?.resultData?[selectedClassIndex].name
                    self.selectedClassID = self.classData?.resultData?[selectedClassIndex].id ?? 0
                    self.ViewModel?.studentList(classId : selectedClassID, Search: "", Skip: 0, PageSize: 1000)
                }else{
                    self.dropDownTextField.text = self.classData?.resultData?[selectedClassIndex].name
                    self.selectedClassID = self.classData?.resultData?[selectedClassIndex].id ?? 0
                    self.ViewModel?.studentList(classId : selectedClassID, Search: "", Skip: 0, PageSize: 1000)
                }
            }
        }
    }
    
    func GetTitleForRow(index: Int) -> String {
        if let count = classData.resultData?.count{
            if count > 0{
                //dropDownTextField.text = classData?.resultData?[0].name
                selectedClassID = classData?.resultData?[0].id ?? 0
                selectedClassIndex = 0
                return classData?.resultData?[index].name ?? ""
            }
        }
        return ""
    }
    
    
    func SelectedRow(index: Int) {
        
        //Using Exist Method of collection prevent from indexoutof range error
        if let count = classData.resultData?.count{
            if count > 0{
                if (self.classData.resultData?[exist: index]?.name) != nil{
                   // self.dropDownTextField.text = self.classData?.resultData?[index].name
                    self.selectedClassID = self.classData?.resultData?[index].id ?? 0
                    self.selectedClassIndex = index
                    print("Selected Department:- \(String(describing: self.classData?.resultData?[index].name))")
                }
            }
        }
    }
    
    func cancelButtonClicked() {
        isClassSelected = true
    }
    
}

extension StudentListVC : NavigationSearchBarDelegate{
    func textDidChange(searchBar: UISearchBar, searchText: String) {
        DispatchQueue.main.async {
            self.arrStudentlist.removeAll()
            if self.selectedClassID != nil{
            self.ViewModel?.studentList(classId :self.selectedClassID, Search: searchText, Skip: KIntegerConstants.kInt0, PageSize: KIntegerConstants.kInt10)
            }
        }
    }
    
    func cancelButtonPress(uiSearchBar: UISearchBar) {
        DispatchQueue.main.async {
            self.arrStudentlist.removeAll()
             if self.selectedClassID != nil{
            self.ViewModel?.studentList(classId : self.selectedClassID, Search: "", Skip: KIntegerConstants.kInt0, PageSize: KIntegerConstants.kInt10)
            }
        }
    }
}

//MARK:- Scroll View delegates
extension StudentListVC : UIScrollViewDelegate{
    
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
                if isClassSelected == true{
                    debugPrint("Class Selected true:- \(isClassSelected)")
                }else{
                    skip = skip + KIntegerConstants.kInt10
                    isFetching = false
                    self.ViewModel?.studentList(classId : 0, Search: "", Skip: skip, PageSize: pageSize)
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

