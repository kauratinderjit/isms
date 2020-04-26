//
//  HomeVC.swift
//  ISMS
//
//  Created by Taranjeet Singh on 6/19/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit
import SWRevealViewController

class HomeVC: BaseUIViewController {
    
    
    @IBOutlet weak var viewName: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var viewDept: UIView!
    @IBOutlet weak var lblDept: UILabel!
    
    @IBOutlet weak var lblCount1: UILabel!
    @IBOutlet weak var lblCount2: UILabel!
    @IBOutlet weak var lblCount3: UILabel!
    @IBOutlet weak var lblName1: UILabel!
    @IBOutlet weak var lblName2: UILabel!
    @IBOutlet weak var lblName3: UILabel!
    @IBOutlet weak var viewEvents: UIView!
    
    @IBOutlet var iv1: UIImageView!
    @IBOutlet var iv2: UIImageView!
    @IBOutlet var iv3: UIImageView!
    
    
    
    
    var arrEventlist : [ListData]?
    
    var roleUserName:String?
    var homeViewModel : HomeViewModel?
    var isUnauthorizedUser = false
    //For check the user is came on home screen from login or not when user have only one role
    static var isCameDirectFromLoginScreen : Bool?
    //For set the role id when user came from login id and selectRole
    static var roleIdFromUserRoleId : Int?
    
    fileprivate var userRoleDelegate = MultiRoleTableViewDataSource()
    
    @IBOutlet var multiRoleView: UIView!
    @IBOutlet weak var barBtnMenu: UIBarButtonItem!
    @IBOutlet weak var multiRoleTableView: UITableView!
    @IBOutlet weak var selectRoleLabel: UILabel!
    @IBOutlet weak var heightofMultiRoleTableView: NSLayoutConstraint!
    var menuArray = [KMenuRowsTitles.kHomeTitle,KMenuRowsTitles.kManageInstituteTitle,KMenuRowsTitles.kManageRolesTitle,KMenuRowsTitles.kManageDepartmentsTitle,KMenuRowsTitles.kManageHODTitle,KMenuRowsTitles.kManageClassesTitle,KMenuRowsTitles.kManageTeachersTitle,KMenuRowsTitles.kManageStudentTitle,KMenuRowsTitles.kManageSubjectTitle,KMenuRowsTitles.kManageClassSubjectTitle,KMenuRowsTitles.kClassPeriodTimeTableTitle,KMenuRowsTitles.kAssignSubjectTeacherToPeriodTitle,KMenuRowsTitles.kAddPeriod,KMenuRowsTitles.kLogOutTitle]
    
    var menuHOD = [KMenuRowsTitles.kHomeTitle,KMenuRowsTitles.kManageTeachersTitle,KMenuRowsTitles.kManageStudentTitle,KMenuRowsTitles.kManageSubjectTitle,KMenuRowsTitles.kManageClassSubjectTitle,KMenuRowsTitles.kClassPeriodTimeTableTitle,KMenuRowsTitles.kAssignSubjectTeacherToPeriodTitle,KMenuRowsTitles.kAddPeriod,KMenuRowsTitles.kLogOutTitle]
    
    var menuVC = MenuVC()
    @IBOutlet weak var tblViewListing: UITableView!
    
    @IBOutlet weak var topEventView: NSLayoutConstraint!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //        self.homeViewModel = HomeViewModel.init(delegate: self)
        //        self.homeViewModel?.attachView(view: self)
        //        setLeftMenuButton()
        //
        //        //If it is came from direct login screen and have only one role then it is executed zero index role id of user
        //        if HomeVC.isCameDirectFromLoginScreen == true{
        //            HomeVC.isCameDirectFromLoginScreen = false
        //            if let userRoleId = UserDefaults.standard.value(forKey: UserDefaultKeys.userRoleId.rawValue) as? Int,let userId = UserDefaults.standard.value(forKey: UserDefaultKeys.userId.rawValue) as? Int{
        //                self.homeViewModel?.getMenuFromUserRoleId(userId: userId, roleId: userRoleId)
        //            }
        //        }else{
        //            //For Multi Roles Of User
        //            if let userRoleId = UserDefaults.standard.value(forKey: UserDefaultKeys.userRoleId.rawValue) as? Int
        //            {
        //                self.homeViewModel?.getMenuFromUserRoleId(userId: UserDefaultExtensionModel.shared.currentUserId, roleId: userRoleId)
        //            }
        //            else{
        //
        //            }
        //         //   menuVC.getMenuArraySuccess(data: )
        //        }
        //
        //        self.title = KAPPContentRelatedConstants.kAppTitle
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        
        // Do any additional setup after loading the view.
        self.homeViewModel = HomeViewModel.init(delegate: self)
        self.homeViewModel?.attachView(view: self)
        setLeftMenuButton()
        tblViewListing.tableFooterView = UIView()

        
        //If it is came from direct login screen and have only one role then it is executed zero index role id of user
        if HomeVC.isCameDirectFromLoginScreen == true
        {
            HomeVC.isCameDirectFromLoginScreen = false
            if let userRoleId = UserDefaults.standard.value(forKey: UserDefaultKeys.userRoleId.rawValue) as? Int,let userId = UserDefaults.standard.value(forKey: UserDefaultKeys.userId.rawValue) as? Int
            {
                self.homeViewModel?.getMenuFromUserRoleId(userId: userId, roleId: userRoleId)
            }
        }
        else
        {
            //For Multi Roles Of User
            if let userRoleId = UserDefaults.standard.value(forKey: UserDefaultKeys.userRoleId.rawValue) as? Int
            {
                self.homeViewModel?.getMenuFromUserRoleId(userId: UserDefaultExtensionModel.shared.currentUserId, roleId: userRoleId)
            }
            else
            {
                
            }
            //   menuVC.getMenuArraySuccess(data: )
        }
        
        self.title = KAPPContentRelatedConstants.kAppTitle
        self.homeViewModel?.getRoleId(userID: UserDefaultExtensionModel.shared.currentUserId)
        
        if UserDefaultExtensionModel.shared.currentHODRoleName == "HOD"
        {
            self.title = "HOD's Dashboard"
            self.homeViewModel?.getData(userId: UserDefaultExtensionModel.shared.currentUserId)
        }
        else if UserDefaultExtensionModel.shared.currentHODRoleName.contains("Teacher")
        {
            self.title = "Teacher's Dashboard"
            self.homeViewModel?.getDataTeacher(userId: UserDefaultExtensionModel.shared.currentUserId)
            //mohit tblViewListing.isHidden = true
        }
        else if UserDefaultExtensionModel.shared.currentHODRoleName.contains("Admin")
        {
            self.homeViewModel?.getDataForAdmin(userId: UserDefaultExtensionModel.shared.currentUserId)
            self.title = "Admin's Dashboard"
            tblViewListing.isHidden = true
        }
        else if UserDefaultExtensionModel.shared.currentHODRoleName.contains("Student")
        {
            self.title = "Student's Dashboard"
            // tblViewListing.isHidden = true
            self.homeViewModel?.getDataStudent(userId: UserDefaultExtensionModel.shared.currentUserId)
          
        }
        
        
        
    }
    
    
    
    @IBAction func TESTING_ACTION(_ sender: Any)
    {
        let vc = UIStoryboard.init(name:"CalendarAndEvents", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddEventVC") as! AddEventVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    @IBAction func btnMenuAction(_ sender: UIBarButtonItem) {
        self.revealViewController()?.revealToggle(animated: true)
    }
    
}
//
//extension HomeVC : UserRoleTableViewDelegate{
//    func selectRoleButton(_ selectedData: UserRoleIdModel.ResultData?) {
//        let selectedRoleId = selectedData?.roleId
//        homeViewModel?.getMenuFromUserRoleId(userRoleId: selectedRoleId)
//    }
//}

extension HomeVC : HomeViewModelDelegate
{
    func AdminData(data: homeAdminResultData)
    {
        lblName.text = data.AdminName
        lblDept.text = (data.EmailId ?? "")
        var strClass : String = "Class"
        var strTeacher : String = "Teacher"
        var strHOD : String = "HOD"
        
        if data.NoOfClasses! > 1 {
            strClass = "Classes"
        }
        if data.NoOfTeachers! > 1 {
            strTeacher = "Teachers"
        }
        if data.NoOfHODs! > 1 {
            strHOD = "HODs"
        }
        
        lblName1.text = "\(String(describing: data.NoOfClasses!))" + " " + strClass
        lblName2.text =  "\(String(describing: data.NoOfTeachers!))" + " " + strTeacher
        lblName3.text =  "\(String(describing: data.NoOfHODs!))" + " " + strHOD
        
        if data.lstEvent?.count ?? 0 > 0 {
            arrEventlist = data.lstEvent
            tblViewListing.reloadData()
        }
        else{
            tblViewListing.isHidden = true
        }
    }
    
    func hodData(data: homeResultData)
    {
        
        self.iv1.isHidden = false
        self.iv2.isHidden = false
        self.iv3.isHidden = false
        
        self.lblName1.isHidden = false
        self.lblName2.isHidden = false
        self.lblName3.isHidden = false
        
        print(data)
        lblName.text = data.HodName
        lblDept.text = (data.DepartmentName ?? "")
        
        var strClass : String = "Class"
        var strTeacher : String = "Teacher"
        var strStudent : String = "Student"
        
        if data.NumberofClasses! > 1
        {
            strClass = "Classes"
        }
        if data.NumberofTeacher! > 1
        {
            strTeacher = "Teachers"
        }
        if data.NumberofStudent! > 1
        {
            strStudent = "Students"
        }
        
        lblName1.text = "\(String(describing: data.NumberofClasses!))" + " " + strClass
        lblName2.text =  "\(String(describing: data.NumberofTeacher!))" + " " + strTeacher
        lblName3.text =  "\(String(describing: data.NumberofStudent!))" + " " + strStudent
        
        if data.lstEvent?.count ?? 0 > 0
        {
            arrEventlist = data.lstEvent
            tblViewListing.reloadData()
        }
        else
        {
            tblViewListing.isHidden = true
        }
    }
    
    func teacherData(data: teacherData)
    {
        
        self.iv1.isHidden = false
        self.iv2.isHidden = false
        self.iv3.isHidden = false
        
        self.lblName1.isHidden = false
        self.lblName2.isHidden = false
        self.lblName3.isHidden = false
        
        print(data)
        lblName.text = data.TeacherName
        lblDept.text = ""
        
        var strClass : String = "Class"
        var strTeacher : String = "Subjects"
        var strStudent : String = "Student"
        
        if data.NoOfClasses ?? 0 > 1
        {
            strClass = "Classes"
        }
        if data.NoOfSubjects ?? 0 > 1
        {
            strTeacher = "Subjects"
        }
        if data.NoOfStudents ?? 0 > 1
        {
            strStudent = "Students"
        }
        
        lblName1.text = "\(String(describing: data.NoOfClasses!))" + " " + strClass
        lblName2.text =  "\(String(describing: data.NoOfSubjects!))" + " " + strTeacher
        lblName3.text =  "\(String(describing: data.NoOfStudents!))" + " " + strStudent
        
        if data.lstEvent?.count ?? 0 > 0
        {
            arrEventlist = data.lstEvent
            tblViewListing.reloadData()
        }
        else
        {
            tblViewListing.isHidden = true
        }
    }
    
    
    
    func studentData(data: StudentData)
    {
        print(data)
        lblName.text = data.StudentName
        lblDept.text = ""
        
        self.iv1.isHidden = true
        self.iv2.isHidden = true
        self.iv3.isHidden = true
        
        self.lblName1.isHidden = true
        self.lblName2.isHidden = true
        self.lblName3.isHidden = true
        
          topEventView.constant = -100
//        var strClass : String = "Class"
        var strTeacher = "Teacher"
//        var strStudent : String = "Student"
        
//        if data.NoOfClasses ?? 0 > 1
//        {
//            strClass = "Classes"
//        }
        if data.subjectNameLists?.count ?? 0 > 1
        {
            strTeacher = "Subjects"
        }
//        if data.NoOfStudents ?? 0 > 1
//        {
//            strStudent = "Students"
//        }
        
        lblName1.text = "\(String(describing: data.subjectNameLists?.count ?? 0))" + " " + "Subjects"
      //  lblName2.text =  "\(String(describing: data.NoOfSubjects!))" + " " + strTeacher
     //   lblName3.text =  "\(String(describing: data.NoOfStudents!))" + " " + strStudent
        
                if data.lstEvent?.count ?? 0 > 0
                {
                    arrEventlist = data.lstEvent
                    tblViewListing.reloadData()
                }
                else
                {
                    tblViewListing.isHidden = true
                }
    }
    
    func userUnauthorize()
    {
        isUnauthorizedUser = true
        
    }
    
    func didSuccessUserRole(data: UserRoleIdModel) {
        // UserDefaults.standard.set(data.resultData?.count ?? 0, forKey: UserDefaultKeys.userRolesCount.rawValue)
        //        UserDefaults.standard.synchronize()
        UserDefaultExtensionModel.shared.userName = data.resultData?[0].UserName ?? ""
        UserDefaultExtensionModel.shared.userProfile = data.resultData?[0].ImageUrl ?? ""
        
        if data.resultData?.count ?? 0 == 0{
            debugPrint("Count is zero")
        }else if data.resultData?.count ?? 0 == 1{
            debugPrint("Count is one")
        }else if data.resultData?.count ?? 0 > 1{
            debugPrint("Count is greater then one")
        }
    }
    
    func didSuccessMenuAccordingRole(data: GetMenuFromRoleIdModel)
    {
        menuVC.getMenuArraySuccess(data: data)
        CommonFunctions.sharedmanagerCommon.println(object: "Role menu:- \(data.resultData)")
        _ = data.resultData?.enumerated().map({ (index,valueNew) in
            let sideMenuName = valueNew.pageName
            MenuVC.menuArray.insert(sideMenuName ?? "No", at: index)
        })
    }
    
}

extension HomeVC : ViewDelegate{
    func showLoader() {
        self.ShowLoader()
    }
    
    func hideLoader() {
        self.HideLoader()
    }
    
    func showAlert(alert: String) {
        initializeCustomOkAlert(self.view, isHideBlurView: true)
        okAlertView.delegate = self
    }
    
}

extension HomeVC : OKAlertViewDelegate{
    func okBtnAction() {
        okAlertView.removeFromSuperview()
        if isUnauthorizedUser == true{
            isUnauthorizedUser = false
            CommonFunctions.sharedmanagerCommon.setRootLogin()
        }
    }
}
extension HomeVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrEventlist?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ExamScheduleTableViewCell
        
        cell?.lblTitle.text = arrEventlist?[indexPath.row].Name
        
        cell?.imgView.addInitials(first: "E", second: "")
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
}
