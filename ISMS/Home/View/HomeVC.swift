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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    func userUnauthorize() {
        isUnauthorizedUser = true
    }
    
    func didSuccessUserRole(data: UserRoleIdModel) {
        UserDefaults.standard.set(data.resultData?.count ?? 0, forKey: UserDefaultKeys.userRolesCount.rawValue)
        UserDefaults.standard.synchronize()
        
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
