//
//  MenuVC.swift
//  ISMS
//
//  Created by Taranjeet Singh on 6/19/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit
import SWRevealViewController

protocol MenuVCDelegate: class
{
    func getMenuArraySuccess(data: GetMenuFromRoleIdModel)
}


class MenuVC: BaseUIViewController {

    @IBOutlet weak var tableView: UITableView!
    static var menuArray = ["Logout"]
    static var menuArrayFromApi : GetMenuFromRoleIdModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.tableFooterView = UIView()
        
        let userRoleCount = UserDefaults.standard.value(forKey: UserDefaultKeys.userRolesCount.rawValue) as? Int

//        if userRoleCount == 0{
//            debugPrint("zero count of roles.")
//            _ = MenuVC.menuArray.map { (title) in
//                if title == "Select Role"{
//                    MenuVC.menuArray.remove(at: 2)
//                }else{
//                    debugPrint("Chane Role is not found.")
//                }
//            }
//        }else if userRoleCount ?? 0 == 1{
//            _ = MenuVC.menuArray.map { (title) in
//                if title == "Select Role"{
//                    MenuVC.menuArray.remove(at: 2)
//                }else{
//                    debugPrint("Chane Role is not found.")
//                }
//            }
//        }else if userRoleCount ?? 0 > 1{
//            MenuVC.menuArray.insert("Change Role", at: 2)
//        }else{
//            debugPrint("No case is executed")
//        }
        
        self.tableView.delegate = self

        
     //   print("array count: ",MenuVC.menuArrayFromApi.count)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let theme = ThemeManager.shared.currentTheme{
            tableView.backgroundColor = theme.mainColor
            self.navigationController?.navigationBar.tintColor = theme.navigationTintColor
            self.navigationController?.navigationBar.barTintColor = theme.navigationBarTintColor
        }else{
            tableView.backgroundColor = UIColor.colorFromHexString("A90222")
            self.navigationController?.navigationBar.barTintColor = UIColor.colorFromHexString("A90222")
            self.navigationController?.navigationBar.tintColor = UIColor.colorFromHexString("FFFFFF")
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
  
}

//MARK:- Table View Delegate
extension MenuVC : UITableViewDelegate{
    
    //Will Display cell
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
    }
    
    //Did Select Row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        print("your get result : \(String(describing: MenuVC.menuArrayFromApi?.resultData?[indexPath.row].pageUrl))")

        
        switch MenuVC.menuArrayFromApi?.resultData?[indexPath.row].pageUrl!
        {
        case "ManageTeachers":
            let storyboard = UIStoryboard.init(name: KStoryBoards.kTeacher, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: KStoryBoards.KTeacherListIdentifiers.kTeacherListVC) as? TeacherListVC
            vc?.lstActionAccess = MenuVC.menuArrayFromApi?.resultData?[indexPath.row]
            let frontVC = revealViewController().frontViewController as? UINavigationController
            frontVC?.pushViewController(vc!, animated: false)
            revealViewController().pushFrontViewController(frontVC, animated: true)
            break
            
         
           case "ManageClass":

            let storyboard = UIStoryboard.init(name: KStoryBoards.kClass, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: KStoryBoards.KClassListIdentifiers.kClassListVC) as? ClassListVC
            //  vc?.lstActionAccess = MenuVC.menuArrayFromApi?.resultData?[indexPath.row].lstActionAccess
            let frontVC = revealViewController().frontViewController as? UINavigationController
            frontVC?.pushViewController(vc!, animated: false)
            revealViewController().pushFrontViewController(frontVC, animated: true)
            break
            
       
     
            case "ManageDepartment ":
                
            let storyboard = UIStoryboard.init(name: KStoryBoards.kDepartment, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: KStoryBoards.KDepartMentListIdentifiers.kDepartmentListVC) as? DepartmentListVC
            //vc?.lstActionAccess = MenuVC.menuArrayFromApi?.resultData?[indexPath.row].lstActionAccess
            let frontVC = revealViewController().frontViewController as? UINavigationController
            frontVC?.pushViewController(vc!, animated: false)
            revealViewController().pushFrontViewController(frontVC, animated: true)
            break
            
              case "CreateSyllabus&Topics":
            let storyboard = UIStoryboard.init(name: KStoryBoards.kCourses, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: KStoryBoards.KSyllabusCoverageIdentifiers.kSyllabusCoverageVC) as? SyllabusCoverageVC
            //vc?.lstActionAccess = MenuVC.menuArrayFromApi?.resultData?[indexPath.row].lstActionAccess
            let frontVC = revealViewController().frontViewController as? UINavigationController
            frontVC?.pushViewController(vc!, animated: false)
            revealViewController().pushFrontViewController(frontVC, animated: true)
            break
            
        case "ViewSyllabusCoverage" :
            let storyboard = UIStoryboard.init(name: KStoryBoards.kCourses, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: KStoryBoards.KSyllabusCoverageIdentifiers.kSyllabusCoverageVC) as? SyllabusCoverageVC
            //vc?.lstActionAccess = MenuVC.menuArrayFromApi?.resultData?[indexPath.row].lstActionAccess
            let frontVC = revealViewController().frontViewController as? UINavigationController
            frontVC?.pushViewController(vc!, animated: false)
            revealViewController().pushFrontViewController(frontVC, animated: true)
            break
            
            
        case "Update SyllabusCoverage":
            let storyboard = UIStoryboard.init(name: KStoryBoards.kCourses, bundle: nil)
                       let vc = storyboard.instantiateViewController(withIdentifier: KStoryBoards.KSyllabusCoverageIdentifiers.kSyllabusCoverageVC) as? SyllabusCoverageVC
                      vc?.lstActionAccess = MenuVC.menuArrayFromApi?.resultData?[indexPath.row]
                       let frontVC = revealViewController().frontViewController as? UINavigationController
                       frontVC?.pushViewController(vc!, animated: false)
                       revealViewController().pushFrontViewController(frontVC, animated: true)
            
            break
            
            case "AssignHomework":
                let storyboard = UIStoryboard.init(name: "Homework", bundle: nil)
                           let vc = storyboard.instantiateViewController(withIdentifier: "HomeworkListVC") as? HomeworkListVC
                           vc?.lstActionAccess = MenuVC.menuArrayFromApi?.resultData?[indexPath.row]
                           let frontVC = revealViewController().frontViewController as? UINavigationController
                           frontVC?.pushViewController(vc!, animated: false)
                           revealViewController().pushFrontViewController(frontVC, animated: true)
                
                
                break
             case "View&UpdateHomework":
                let storyboard = UIStoryboard.init(name: "Homework", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "SubjectListHW") as? SubjectListHW
               // vc?.lstActionAccess = MenuVC.menuArrayFromApi?.resultData?[indexPath.row]
                let frontVC = revealViewController().frontViewController as? UINavigationController
                frontVC?.pushViewController(vc!, animated: false)
                revealViewController().pushFrontViewController(frontVC, animated: true)
                
                
            break
            
            
            case KStoryBoards.kAssignSubjectToClass.kClassAssignSubjectListVC:
                
            let storyboard = UIStoryboard.init(name: KStoryBoards.kClass, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: KStoryBoards.kAssignSubjectToClass.kClassAssignSubjectListVC) as? ClassAssignSubjectListVC
            
            let frontVC = revealViewController().frontViewController as? UINavigationController
            frontVC?.pushViewController(vc!, animated: false)
            revealViewController().pushFrontViewController(frontVC, animated: true)
            break
            
           case KStoryBoards.kTeacherSubjectWiseRating.kTeacherSubjectWiseRatingVC :
            
            let storyboard = UIStoryboard.init(name: KStoryBoards.kTeacher, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: KStoryBoards.kTeacherSubjectWiseRating.kTeacherSubjectWiseRatingVC)
            let frontVC = revealViewController().frontViewController as? UINavigationController
            frontVC?.pushViewController(vc, animated: false)
            revealViewController().pushFrontViewController(frontVC, animated: true)
            
        case KStoryBoards.kStudentSubjectWiseRating.kStudentSubjectWiseRatingVC :
            let storyboard = UIStoryboard.init(name: KStoryBoards.kStudent, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: KStoryBoards.kStudentSubjectWiseRating.kStudentSubjectWiseRatingVC)
            let frontVC = revealViewController().frontViewController as? UINavigationController
            frontVC?.pushViewController(vc, animated: false)
            revealViewController().pushFrontViewController(frontVC, animated: true)
            
        case KStoryBoards.kStudentRating.kStudentRatingVC :
            let storyboard = UIStoryboard.init(name: KStoryBoards.kStudent, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: KStoryBoards.kStudentRating.kStudentRatingVC )
            let frontVC = revealViewController().frontViewController as? UINavigationController
            frontVC?.pushViewController(vc, animated: false)
            revealViewController().pushFrontViewController(frontVC, animated: true)
            
        case "ViewAttendance":
            let storyboard = UIStoryboard.init(name: KStoryBoards.kClass, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ClassTimeTableVC") as? ClassTimeTableVC
            //            vc?.isFromTimeTable = false
            vc?.isFromViewAttendence = true
            vc?.isFromTeacher = 0
            let frontVC = revealViewController().frontViewController as? UINavigationController
            frontVC?.pushViewController(vc!, animated: false)
            revealViewController().pushFrontViewController(frontVC, animated: true)
            
        case KStoryBoards.kTeacherRating.kTeacherRating :
            let storyboard = UIStoryboard.init(name: KStoryBoards.kTeacher, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: KStoryBoards.kTeacherRating.kTeacherRating )
            let frontVC = revealViewController().frontViewController as? UINavigationController
            frontVC?.pushViewController(vc, animated: false)
            revealViewController().pushFrontViewController(frontVC, animated: true)
            break
        case "ManageStudents":
            let storyboard = UIStoryboard.init(name: KStoryBoards.kStudent, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "StudentListVC" ) as! StudentListVC
            let frontVC = revealViewController().frontViewController as? UINavigationController
            frontVC?.pushViewController(vc, animated: false)
            revealViewController().pushFrontViewController(frontVC, animated: true)
            break
        case "ManageTimetable":
            let storyboard = UIStoryboard.init(name: KStoryBoards.kClass, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ClassTimeTableVC") as? ClassTimeTableVC
            vc?.isFromTimeTable = false
            vc?.isFromViewAttendence = false
            vc?.isFromTeacher = 2
            vc?.teacherViewTimeTble = false
            let frontVC = revealViewController().frontViewController as? UINavigationController
            frontVC?.pushViewController(vc!, animated: false)
            revealViewController().pushFrontViewController(frontVC, animated: true)
        case "ManageInstitute":
            let storyboard = UIStoryboard.init(name: KStoryBoards.kSchool, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "AddSchoolVC") as? AddSchoolViewController
            let frontVC = revealViewController().frontViewController as? UINavigationController
            frontVC?.pushViewController(vc!, animated: false)
            revealViewController().pushFrontViewController(frontVC, animated: true)
        case "ManageHOD":
            let storyboard = UIStoryboard.init(name: KStoryBoards.kHOD, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "HODListVC") as? HODListVC
            let frontVC = revealViewController().frontViewController as? UINavigationController
            frontVC?.pushViewController(vc!, animated: false)
            revealViewController().pushFrontViewController(frontVC, animated: true)
        case "ManageUserAccess":
            let storyboard = UIStoryboard.init(name: KStoryBoards.kUserAccess, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "UserListVC") as? UserListVC
            let frontVC = revealViewController().frontViewController as? UINavigationController
            frontVC?.pushViewController(vc!, animated: false)
            revealViewController().pushFrontViewController(frontVC, animated: true)
        case "ManageSubject":
            let storyboard = UIStoryboard.init(name: KStoryBoards.kSubject, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SubjectListVC") as? SubjectListVC
            let frontVC = revealViewController().frontViewController as? UINavigationController
            frontVC?.pushViewController(vc!, animated: false)
            revealViewController().pushFrontViewController(frontVC, animated: true)
            break
        case "PerformanceGraphVC":
            let storyboard = UIStoryboard.init(name: KStoryBoards.kPerformance, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: KPerformanceIdentifiers.kPerformanceGraphVC) as? PerformanceGraphVC
            let frontVC = revealViewController().frontViewController as? UINavigationController
            frontVC?.pushViewController(vc!, animated: false)
            revealViewController().pushFrontViewController(frontVC, animated: true)
            break
        case "NewsLetterAndFeedVC":
            let storyboard = UIStoryboard.init(name: KStoryBoards.kNewsfeedAndLetter, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: kNewsLetterAndFeedIdentifiers.kNewsLetterAndFeedVC) as? NewsLetterAndFeedVC
            let frontVC = revealViewController().frontViewController as? UINavigationController
            frontVC?.pushViewController(vc!, animated: false)
            revealViewController().pushFrontViewController(frontVC, animated: true)
            break
            
            case "ManageCalendarAndEvents":
                    let storyboard = UIStoryboard.init(name: KStoryBoards.kCalender, bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "ExamScheduleVC") as? ExamScheduleVC
                    let frontVC = revealViewController().frontViewController as? UINavigationController
                    frontVC?.pushViewController(vc!, animated: false)
                    revealViewController().pushFrontViewController(frontVC, animated: true)
                    break
            
        case "ViewCalendar&Events":
            let storyboard = UIStoryboard.init(name: KStoryBoards.kCalender, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ExamScheduleVC") as? ExamScheduleVC
            let frontVC = revealViewController().frontViewController as? UINavigationController
            vc?.lstActionAccess = MenuVC.menuArrayFromApi?.resultData?[indexPath.row]
            frontVC?.pushViewController(vc!, animated: false)
            revealViewController().pushFrontViewController(frontVC, animated: true)
            break
            
            
            
        case "ManagePeriods":
            let storyboard = UIStoryboard.init(name: KStoryBoards.kPeriod, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: KStoryBoards.KClassPeriodIdIdentifiers.kTimePeriodVC) as? TimePeriodVC
            let frontVC = revealViewController().frontViewController as? UINavigationController
            frontVC?.pushViewController(vc!, animated: false)
            revealViewController().pushFrontViewController(frontVC, animated: true)
            break
            
        case "Attendence":
            let storyboard = UIStoryboard.init(name: KStoryBoards.kClass, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ClassTimeTableVC") as? ClassTimeTableVC
            //            vc?.isFromTimeTable = false
            vc?.isFromViewAttendence = true
            vc?.isFromTeacher = 1
            vc?.teacherViewTimeTble = false

            let frontVC = revealViewController().frontViewController as? UINavigationController
            frontVC?.pushViewController(vc!, animated: false)
            revealViewController().pushFrontViewController(frontVC, animated: true)
             break
            
        case "ViewTimetable" :
            let storyboard = UIStoryboard.init(name: KStoryBoards.kClass, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ClassTimeTableVC") as? ClassTimeTableVC
            //            vc?.isFromTimeTable = false
            vc?.isFromViewAttendence = true
            vc?.isFromTeacher = 1
            vc?.teacherViewTimeTble = true
            let frontVC = revealViewController().frontViewController as? UINavigationController
            frontVC?.pushViewController(vc!, animated: false)
            revealViewController().pushFrontViewController(frontVC, animated: true)
            break
            
        case "ViewTeacherRatings":
            let storyboard = UIStoryboard.init(name: KStoryBoards.kTeacher, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ViewTeacherRatingVC") as? ViewTeacherRatingVC
            let frontVC = revealViewController().frontViewController as? UINavigationController
            frontVC?.pushViewController(vc!, animated: false)
            revealViewController().pushFrontViewController(frontVC, animated: true)
            break
            
        case "ViewStudentRating":
            let storyboard = UIStoryboard.init(name: KStoryBoards.kStudent, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "StudentRatingVC") as? StudentRatingVC
            vc?.isFromHod = true
            let frontVC = revealViewController().frontViewController as? UINavigationController
            frontVC?.pushViewController(vc!, animated: false)
            revealViewController().pushFrontViewController(frontVC, animated: true)
            break
        case "ViewTimeTableAndAttendance":
            
            let storyboard = UIStoryboard.init(name: "StudentAttendence", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "StudentViewAttendanceVC") as? StudentViewAttendanceVC
            let frontVC = revealViewController().frontViewController as? UINavigationController
            frontVC?.pushViewController(vc!, animated: false)
            revealViewController().pushFrontViewController(frontVC, animated: true)
            break
//            StudentViewAttendanceVC
            
        case "RateTeachers" :
            let storyboard = UIStoryboard.init(name: KStoryBoards.kTeacher, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "RatingTeacherVC") as? RatingTeacherVC
            let frontVC = revealViewController().frontViewController as? UINavigationController
            frontVC?.pushViewController(vc!, animated: false)
            revealViewController().pushFrontViewController(frontVC, animated: true)
            break
            
            
        case "ViewRating":
            let storyboard = UIStoryboard.init(name: KStoryBoards.kStudent, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SubjectWiseRatingVC") as? SubjectWiseRatingVC
            let frontVC = revealViewController().frontViewController as? UINavigationController
            frontVC?.pushViewController(vc!, animated: false)
            revealViewController().pushFrontViewController(frontVC, animated: true)
            break
            
        case "RateStudentPerformance":
            let storyboard = UIStoryboard.init(name: KStoryBoards.kStudent, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "StudentRatingVC") as? StudentRatingVC
            vc?.isFromHod = false
            let frontVC = revealViewController().frontViewController as? UINavigationController
            frontVC?.pushViewController(vc!, animated: false)
            revealViewController().pushFrontViewController(frontVC, animated: true)
             break
//            AddStudentRatingVC
            
        case "AssignHomework":
            let storyboard = UIStoryboard.init(name: KStoryBoards.kStudent, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "AssignHomeworkVC")
            let frontVC = revealViewController().frontViewController as? UINavigationController
            frontVC?.pushViewController(vc, animated: false)
            revealViewController().pushFrontViewController(frontVC, animated: true)
             break
        case "Logout":
            initializeCustomYesNoAlert(self.view, isHideBlurView: true)
            self.yesNoAlertView.delegate = self
            yesNoAlertView.lblResponseDetailMessage.text = Alerts.kLogOutAlert
        default:
            print(Alerts.kNoRecordFound)
            break
        }
    }
}

//MARK:- Table View Data Source
extension MenuVC : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return  MenuVC.menuArrayFromApi?.resultData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MenuTableViewCell
        cell.setData(MenuVC.menuArrayFromApi, indexPath)
        cell.lblRowTitle.text =  MenuVC.menuArrayFromApi?.resultData?[indexPath.row].pageName
        cell.lblRowTitle.numberOfLines = 0
        if let theme = ThemeManager.shared.currentTheme{
            cell.viewBG.backgroundColor = theme.mainColor
        }
        return cell
    }
}

extension MenuVC : MenuVCDelegate{
    
    func getMenuArraySuccess(data: GetMenuFromRoleIdModel) {
        MenuVC.menuArrayFromApi = data
    }
    
}

//MARK:- Custom Yes No Alert Delegate
extension MenuVC : YesNoAlertViewDelegate{
    
    func yesBtnAction() {
        yesNoAlertView.removeFromSuperview()
        if self.checkInternetConnection(){
            CommonFunctions.sharedmanagerCommon.setRootLogin()
        }else{
            self.showAlert(Message: Alerts.kNoInternetConnection)
        }
    }
    
    func noBtnAction() {
        yesNoAlertView.removeFromSuperview()
    }
}


//            var revealController = self.revealViewController
//            let storyboard = UIStoryboard.init(name: "Dashboard", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "DashBoardViewController")
////            appDelegate.window?.rootViewController = vc
//            let frontVC = revealViewController().frontViewController as? UINavigationController
//            frontVC?.pushViewController(vc, animated: false)
//            revealViewController().pushFrontViewController(frontVC, animated: true)

/*let storyboard = UIStoryboard.init(name: GlobalConstantClass.StoryboardsNames.k_Storyboard_DashBoard, bundle: nil)
 let vc = storyboard.instantiateViewController(withIdentifier: GlobalConstantClass.ViewControllerName.k_TabBarNameStartRoot)
 appDelegate.window?.rootViewController = vc*/
