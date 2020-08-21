//
//  SubstituteTeacherVC.swift
//  ISMS
//
//  Created by Poonam  on 01/07/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//
import UIKit

class SubstituteTeacherVC: BaseUIViewController {
    //Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnAddTeacher: UIButton!
    
    @IBOutlet weak var btnAdd: UIButton!
    //Variables
    var arrTeacherlist = [GetTeacherListResultData]()
     var arrSubstituteTeacherlist = [GetSubstituteTeacherData]()
    var viewModel : TeacherListViewModel?
      var isAssignTeacherSubjectSuccessfully : Bool?
    var selectedTeacherId : Int?
    var selectedTeacherArrIndex : Int?
    var isUnauthorizedUser = false
    var isTeacherDeleteSuccessfully = false
    var skip = Int()
    var isScrolling : Bool?
    var pageSize = KIntegerConstants.kInt10
    var pointNow:CGPoint!
    var isFetching:Bool?
    var isEdit:Bool = false
    var isDelete:Bool = false
    var classId : Int?
    var teacherID : Int?
    var selectedSubstituteTeacherId = 0
    var classSubjectId : Int?
    var periodId : Int?
    var dayId : Int?
    
    public var lstActionAccess : GetMenuFromRoleIdModel.ResultData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //Initiallize memory for view model
        self.viewModel = TeacherListViewModel.init(delegate: self)
        self.viewModel?.attachView(viewDelegate: self)
        DispatchQueue.main.async {
            self.setUI()
        }
       
        SetViewAccordingToResponce()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        arrTeacherlist.removeAll()
        teacherListApi()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.view.setNeedsLayout() // force update layout
        navigationController?.view.layoutIfNeeded() // to fix height of the navigation bar
//        setNavigationBarHeight()
    }

    //SetView
    func SetViewAccordingToResponce()
    {
        if(lstActionAccess?.lstActionAccess != nil)
        {
            for resultData in (lstActionAccess?.lstActionAccess)!
            {
                switch resultData.actionName
                {
                case KAccessIntitifiers.kAdd:
//                    btnAdd.isHidden = false
                    break
                case KAccessIntitifiers.kEdit:
                    isEdit = true
              
                    break
                case KAccessIntitifiers.kDelete:
                    isDelete = true
                    break
                default:
                    print(Alerts.kNoRecordFound)
                    break
                }
            }
            
        }
        
    }
    //TeacherListApi
    func teacherListApi(){
        if checkInternetConnection(){
            self.viewModel?.isSearching = false
            self.viewModel?.substituteTeacherList(classId: self.classId ?? 0, teacherId: self.teacherID ?? 0, periodId: self.periodId ?? 0,dayId: dayId ?? 0)
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
    }
    
    //Set Ui
    func setUI(){
        setBackButton()
        
        //Title
        self.title = KStoryBoards.KTeacherListIdentifiers.kTeacherListTitle
        
        //Table View Settings
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.separatorColor = KAPPContentRelatedConstants.kLightBlueColour
        
        //Set Color According To Theme
        guard let theme = ThemeManager.shared.currentTheme else{return}
//        btnAddTeacher.tintColor = theme.uiButtonBackgroundColor
    }
    //MARK:- Button Actions
    @IBAction func btnEditAction(_ sender: UIButton) {
            if arrTeacherlist.count > 0{
                let data = arrTeacherlist[sender.tag]
                selectedTeacherId = data.teacherId
                let vc = UIStoryboard.init(name: KStoryBoards.kTeacher, bundle: Bundle.main).instantiateViewController(withIdentifier: KStoryBoards.KAddTeacherIdentifiers.kAddTeacherVC) as! AddTeacherVC
                if let teacherId = selectedTeacherId{
                    vc.teacherID = teacherId
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
    }
    
    @IBAction func btnDeleteClass(_ sender: UIButton) {
        selectedSubstituteTeacherId = arrSubstituteTeacherlist[sender.tag].teacherId ?? 0
//        sender.setImage(UIImage(named: "check"), for: .normal)
        tableView.reloadData()
        
    }
    
    @IBAction func submitBtn(_ sender: Any) {
        if checkInternetConnection(){
            self.viewModel?.isSearching = false
            self.viewModel?.substituteTeacherSubmit(SubstituteId: 0, TeacherId: self.teacherID ?? 0,SubstituteTeacherId: selectedSubstituteTeacherId,ClassId: classId ?? 0,ClassSubjectId: self.classSubjectId ?? 0,PeriodId: self.periodId ?? 0,DayId: self.dayId ?? 0)
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
    }
    
}
//MARk:- View Delegate
extension SubstituteTeacherVC : ViewDelegate{
    
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
}

//MARK:- Table view delagate
extension SubstituteTeacherVC : UITableViewDelegate{

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
    }
    
}

//MARK:- Table view data source
extension SubstituteTeacherVC : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrSubstituteTeacherlist.count > 0{
            tableView.separatorStyle = .singleLine
            return (arrSubstituteTeacherlist.count)
        }else{
            tblViewCenterLabel(tblView: tableView, lblText: KConstants.kNoDataFound, hide: true)
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "substituteCell", for: indexPath) as! SubstituteTableCell
        cell.setCellUI(data: arrSubstituteTeacherlist, indexPath: indexPath,isEdit:isEdit,isDelete: isDelete)
        if selectedSubstituteTeacherId == arrSubstituteTeacherlist[indexPath.row].teacherId{
            cell.btnDelete.setImage(UIImage(named: "check"), for: .normal)
        }else{
              cell.btnDelete.setImage(UIImage(named: "uncheck"), for: .normal)
        }
        return cell
    }
}

//MARK:- Custom Ok Alert
extension SubstituteTeacherVC : OKAlertViewDelegate{
    
    //Ok Button Clicked
    func okBtnAction() {
        okAlertView.removeFromSuperview()
        if isUnauthorizedUser == true{
            isUnauthorizedUser = false
            CommonFunctions.sharedmanagerCommon.setRootLogin()
        }
        if isTeacherDeleteSuccessfully == true {
            isTeacherDeleteSuccessfully = false
            if let selectedIndex = self.selectedTeacherArrIndex{
                self.arrTeacherlist.remove(at: selectedIndex)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        if isAssignTeacherSubjectSuccessfully == true{
            isAssignTeacherSubjectSuccessfully = false
            self.navigationController?.popViewController(animated: true)
        }
    }
}

//MARK:- Custom Yes No Alert Delegate
extension SubstituteTeacherVC : YesNoAlertViewDelegate{
    func yesBtnAction() {
        yesNoAlertView.removeFromSuperview()
        if self.checkInternetConnection(){
            if let teacherId = self.selectedTeacherId{
                self.viewModel?.deleteTeacher(teacherId: teacherId)
            }else{
                CommonFunctions.sharedmanagerCommon.println(object: "Delete Teacher id is nil")
            }
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
    }
    func noBtnAction() {
        yesNoAlertView.removeFromSuperview()
    }
}
//MARK:- UISearchController Bar Delegates
extension SubstituteTeacherVC : NavigationSearchBarDelegate{
    
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
extension SubstituteTeacherVC : UIScrollViewDelegate{
    
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
extension SubstituteTeacherVC : TeacherListDelegate{
    func substituteTeacherListDidSuccess(data: [GetSubstituteTeacherData]?) {
        if data != nil{
            if data?.count ?? 0 > 0{
                arrSubstituteTeacherlist = data!
                tableView.reloadData()
            }
        }
      
    }
    func submitSubstitute(){
        isAssignTeacherSubjectSuccessfully = true
    }
    
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

