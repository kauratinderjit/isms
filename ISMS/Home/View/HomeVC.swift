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
    
    
    
    override func viewDidLoad() {
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
    
    override func viewWillAppear(_ animated: Bool) {
        
               // Do any additional setup after loading the view.
               self.homeViewModel = HomeViewModel.init(delegate: self)
               self.homeViewModel?.attachView(view: self)
               setLeftMenuButton()


               //If it is came from direct login screen and have only one role then it is executed zero index role id of user
               if HomeVC.isCameDirectFromLoginScreen == true{
                   HomeVC.isCameDirectFromLoginScreen = false
                   if let userRoleId = UserDefaults.standard.value(forKey: UserDefaultKeys.userRoleId.rawValue) as? Int,let userId = UserDefaults.standard.value(forKey: UserDefaultKeys.userId.rawValue) as? Int{
                       self.homeViewModel?.getMenuFromUserRoleId(userId: userId, roleId: userRoleId)
                   }
               }else{
                   //For Multi Roles Of User
                   if let userRoleId = UserDefaults.standard.value(forKey: UserDefaultKeys.userRoleId.rawValue) as? Int
                   {
                       self.homeViewModel?.getMenuFromUserRoleId(userId: UserDefaultExtensionModel.shared.currentUserId, roleId: userRoleId)
                   }
                   else{
                       
                   }
                //   menuVC.getMenuArraySuccess(data: )
               }
               
               self.title = KAPPContentRelatedConstants.kAppTitle
        self.homeViewModel?.getRoleId(userID: UserDefaultExtensionModel.shared.currentUserId)
        
        if UserDefaultExtensionModel.shared.currentHODRoleName == "HOD" {
            self.title = "HOD's Dashboard"
            self.homeViewModel?.getData(userId: UserDefaultExtensionModel.shared.currentUserId) }
        else if UserDefaultExtensionModel.shared.currentHODRoleName.contains("Teacher") {
              self.title = "Teacher's Dashboard"
            tblViewListing.isHidden = true
        }
        else if UserDefaultExtensionModel.shared.currentHODRoleName.contains("Admin") {
                   self.title = "Admin's Dashboard"
            tblViewListing.isHidden = true

             }
        else if UserDefaultExtensionModel.shared.currentHODRoleName.contains("Student") {
                     self.title = "Student's Dashboard"
            tblViewListing.isHidden = true

               }
        
         

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

extension HomeVC : HomeViewModelDelegate{
    func hodData(data: homeResultData) {
        
        lblName.text = data.HodName
        lblDept.text = (data.DepartmentName ?? "") + " " + "Department"
        lblCount1.text = "\(String(describing: data.NumberofClasses!))"
        lblCount2.text  = "\(String(describing: data.NumberofTeacher!))"
        lblCount3.text = "\(String(describing: data.NumberofStudent!))"
        lblName1.text = "Classes"
        lblName2.text =  "Teachers"
        lblName3.text =  "Students"
        
        arrEventlist = data.lstEvent
        tblViewListing.reloadData()
    }
    
    func userUnauthorize() {
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
