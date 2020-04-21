//
//  UserRoleIdVC.swift
//  ISMS
//
//  Created by Poonam Sharma on 7/4/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class UserRoleIdVC: BaseUIViewController {
    //Variables
    var roleIdArr:UserRoleIdModel?
    var menuArray : [GetMenuFromRoleIdModel.ResultData]?
    var selectedRoleArrIndex:Int?
    var userRoleId:Int?
    var viewModel : UserRoleViewModel?
    var userRoleName:String?
    var isCameFromSideMenu : Bool?
    var isCameFromLoginVC : Bool?
    var isUnauthorizedUser = false

    var menuHOD = [KMenuRowsTitles.kHomeTitle,KMenuRowsTitles.kManageTeachersTitle,KMenuRowsTitles.kManageStudentTitle,KMenuRowsTitles.kManageSubjectTitle,KMenuRowsTitles.kManageClassSubjectTitle,KMenuRowsTitles.kClassPeriodTimeTableTitle,KMenuRowsTitles.kAssignSubjectTeacherToPeriodTitle,KMenuRowsTitles.kAddPeriod,KMenuRowsTitles.kLogOutTitle]
    
    //Properties
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        DispatchQueue.main.async {
            self.setUpUI()
        }
    }
    
    @IBAction func BtnRoleAction(_ sender: Any) {
        let indexPath = IndexPath(row: (sender as AnyObject).tag, section: 0)
        if let cell = tableView.cellForRow(at: indexPath) as? UserRoleTableCell {
            userRoleName = cell.BtnRoleName.currentTitle
            //Set Name in userdefaults
            UserDefaultExtensionModel.shared.currentUserRoleName = userRoleName ?? ""
//            UserDefaults.standard.set(userRoleName, forKey: UserDefaultKeys.userRoleName.rawValue)
        }
        if let count = roleIdArr?.resultData?.count{
            if count > 0{
                let data = roleIdArr?.resultData?[(sender as AnyObject).tag]
                selectedRoleArrIndex = (sender as AnyObject).tag
                userRoleId = data?.roleId
                //Save UserRole Id in User Defaults
                UserDefaultExtensionModel.shared.currentUserRoleId = userRoleId ?? 0
//                UserDefaults.standard.set(userRoleId, forKey: UserDefaultKeys.userRoleId.rawValue)
                
                if data?.roleName == "HOD"{
                    //ApplyTheme
                    let themeColors = ThemeColors.init(values: hodThemeDict)
                    let theme = Theme.init(themeColors: themeColors)
                    UserDefaultExtensionModel.shared.currentHODRoleName = data?.roleName ?? ""

                    ThemeManager.applyTheme(theme: theme)
                }else if data?.roleName == "Student"{
                    let themeColors = ThemeColors.init(values: studentThemeDict)
                    let theme = Theme.init(themeColors: themeColors)
                    ThemeManager.applyTheme(theme: theme)
                }else {
                    let themeColors = ThemeColors.init(values: defaultThemeDict)
                    let theme = Theme.init(themeColors: themeColors)
                    ThemeManager.applyTheme(theme: theme)
                }
                //Reload tableView for update colors
                self.tableView.reloadData()

                setupNavigationColor()
                //Hit get Menu From User Role
                self.viewModel?.getMenuFromUserRoleId(userId: UserDefaultExtensionModel.shared.currentUserId, roleId: userRoleId)
            }
        }
    }
    
    func hitGetRolesByUserId(){
        let userId = UserDefaultExtensionModel.shared.currentUserId
        self.viewModel?.getRoleId(userID: userId)
    }
    
    
}

extension UserRoleIdVC : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
    }
}

extension UserRoleIdVC : UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: KTableViewCellIdentifier.kRoleIdTableViewCell, for: indexPath) as! UserRoleTableCell
        if roleIdArr?.resultData?.count ?? 0 > 1{
            cell.setCellUI(data: roleIdArr, indexPath: indexPath)
        }

        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = roleIdArr?.resultData?.count
        {
            if count > 0{
                tableView.separatorStyle = .singleLine
                return roleIdArr?.resultData?.count ?? 0
            }else{
                tblViewCenterLabel(tblView: tableView, lblText: "No data found.", hide: true)
                return 0
            }
        }else{
            tblViewCenterLabel(tblView: tableView, lblText: "No data found.", hide: true)
            return 0
        }
    }
}

extension UserRoleIdVC : ViewDelegate{
    
    func setupTheme(theme: Theme){
        UINavigationBar.appearance().barTintColor = theme.navigationBarTintColor
        UINavigationBar.appearance().tintColor = theme.navigationTintColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barStyle = .blackTranslucent
        
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
    
    func setUpUI(){
        self.viewModel = UserRoleViewModel.init(delegate: self)
        self.viewModel?.attachView(viewDelegate: self)
        self.title = KStoryBoards.KUserRoleIdIdentifiers.kUserMultiRoleTitle

        UnHideNavigationBar(navigationController: self.navigationController)
        //It is called when user logged in and came from side menu.If it is came from login screen then onlyreload table view data or if it came from side menu then hit get roles by user id for getting roles of user.
        if isCameFromSideMenu == true{
            //Set false value of ispresentonmultirole screen when user successfully enter in the app
            UserDefaults.standard.set(false, forKey: UserDefaultKeys.isPresentOnMultiRoleScreen.rawValue)
            debugPrint("Came from side menu screen")
            setBackButton()
            //Get Roles of user using userid
            hitGetRolesByUserId()
        }else{
            debugPrint("Came from login screen.")
            UserDefaults.standard.set(true, forKey: UserDefaultKeys.isPresentOnMultiRoleScreen.rawValue)
            UserDefaults.standard.synchronize()
            
            //It is called when user have multiple roles login time.
            if isCameFromLoginVC == true{
//                isCameFromLoginVC = false
                hideNavigationDefaultBackButton()
                //Check the roleIDArray have nil or not
                if roleIdArr != nil{
                    tableView.dataSource = self
                    tableView.delegate = self
                    tableView.reloadData()
                }else{
                    hitGetRolesByUserId()
                }
            }else{
                //Here user come when user kill the app on multirole screen.
                debugPrint("Not came from Login Screen came after killing the app")
                hitGetRolesByUserId()
            }
        }
    }
}
extension UserRoleIdVC: UserRoleDelegate{
    //Response of User roles
    func didSuccessUserRole(data: UserRoleIdModel) {
        if data.resultData?.count ?? 0 == 0{
         debugPrint("User role count is zero")
        }else if data.resultData?.count ?? 0 == 1{
            debugPrint("Only one role here.")
            
//            roleIdArr = data
        }else if data.resultData?.count ?? 0 > 1{
            debugPrint("More then one role here.")
//            debugPrint("")
            self.roleIdArr = data
            tableView.delegate = self
            tableView.dataSource = self
            tableView.reloadData()
        }
    }
    
    func unauthorizedUser() {
        isUnauthorizedUser = true
    }
    
    func didSuccedRoleMenu(data: GetMenuFromRoleIdModel) {
        print("menu: ",data.resultData?.first?.pageName ?? "")
        if isCameFromSideMenu == true{
            isCameFromSideMenu = false
            debugPrint("Came from sidemenu")
        }else if isCameFromLoginVC == true{
            isCameFromLoginVC = false
            debugPrint("Came from after login.")
            let storyboard = UIStoryboard.init(name: KStoryBoards.kHome, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: KStoryBoards.kSWRevealVC)
            appDelegate.window?.rootViewController = vc
        }else if UserDefaults.standard.value(forKey: UserDefaultKeys.isPresentOnMultiRoleScreen.rawValue) as? Bool == true{
            UserDefaults.standard.set(false, forKey: UserDefaultKeys.isPresentOnMultiRoleScreen.rawValue)
            debugPrint("Came from directly app delegate")
            let storyboard = UIStoryboard.init(name: KStoryBoards.kHome, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: KStoryBoards.kSWRevealVC)
            if data.resultData?.count ?? 0 > 0{
//                MenuVC.menuArray = data.resultData
                data.resultData?.enumerated().map({ (index,sideMenuValue) in
                    
                    MenuVC.menuArray
                })
                
                
            }
            appDelegate.window?.rootViewController = vc
        }
        
    }
}

//MARK:- Custom Ok Alert
extension UserRoleIdVC : OKAlertViewDelegate{
    
    //Ok Button Clicked
    func okBtnAction() {
        okAlertView.removeFromSuperview()
        if isUnauthorizedUser == true{
            isUnauthorizedUser = false
            CommonFunctions.sharedmanagerCommon.setRootLogin()
        }
    }
}
