//
//  AppConstants.swift
//  LatestArchitechtureDemo
//
//  Created by Atinder Kaur on 5/23/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import Foundation

public struct BaseUrl
{
  public static let kBaseURL =  "http://stgsd.appsndevs.com/EducationProApi/"
}

public struct ApiEndpoints
{
    public static let kGetCommonDropdownApi = "api/Common/DropdownBind"
    public static let kStudentListForAttendence = "api/Institute/GetStudentForAttendence"
    public static let kAddStudentListForAttendence = "api/Institute/AddUpdateStudentAttendence"
    
    //MARK:- AttendanceReport Api
    public static let kGetAttendenceReportByClassId = "api/Institute/GetAttendenceReportByClassId"
    //MARK:- User Api
    public static let kLogin  =  "api/User/Login"
    public static let kVerifyPhoneEmail = "api/User/VerifyPhoneEmail"
    public static let kSignUpApi = "api/User/UserSignUp"
    
    //MARK:- Institute Api
    public static let kAddDepartment = "api/Institute/AddDepartment"
    public static let kGetDepartmentList = "api/Institute/GetDepartmentList"
    public static let kDeleteDepartment = "api/Institute/DeleteDepartment"
    public static let kGetDepartmentDetail = "api/Institute/GetDepartmentDetail?departmentId="
    
    //Classes Api
    public static let kAddClass = "api/Institute/AddClass"
    public static let kGetClassList = "api/Institute/GetClassList"
    public static let kGetClassDetail = "api/Institute/GetClassDetail"
    public static let kDeleteClass = "api/Institute/DeleteClass"

    //HOD Api
    public static let kAddHod = "api/Institute/AddHOD"
    public static let kGetHodList = "api/Institute/GetHODList"
    public static let kGetHodDetail = "api/Institute/GetHODDetail"
    public static let kDeleteHod = "api/Institute/DeleteHOD"
    public static let KHODPhoneEmailVerifyApi = "api/Institute/GetHODDetailByPhoneEmail"
 
    //Teacher Api
    public static let kAddTeacher = "api/Institute/AddTeacher"
    public static let kGetTeacherList = "api/Institute/GetTeacherList"
    public static let kGetTeacherDetail = "api/Institute/GetTeacherDetail"
    public static let kDeleteTeacher = "api/Institute/DeleteTeacher"
    public static let kTeacherDetailByPhoneEmail  = "api/Institute/GetTeacherDetailByPhoneEmail"
    public static let kTeacherRating = "api/Institute/GetAllTeacherRatingbyClassSubjectId"

    //Add Update School APIS
    public static let kGetSchoolApi = "api/Institute/GetInstituteById"
    public static let kUpdateSchoolApi = "api/Institute/UpdateInstitute"
    public static let kGetDropDownCollegeSchoolApi = "api/Common/DropdownBind"
    //USer Access Roles
    public static let kUserAccess = "api/User/GetAccessRolesById"
    public static let kUserAccessUpdate = "api/User/UpdateUserAccess"
    public static let kUserAccessUpdatePageIDs = "pageIds="
    public static let kUserAccessUpdateActionIDs = "actionIds="
    
    //  Student Api (Poonam)
    public static let KAddStudentApi = "api/Institute/AddStudent"
    public static let KStudentListApi = "api/Institute/GetStudentList"
    public static let KStudentPhoneEmailVerifyApi = "api/Institute/GetStudentDetailByPhoneEmail"
    public static let KStudentDetailApi = "api/Institute/GetStudentDetail?enrollmentId="
    public static let KDeleteStudent = "api/Institute/DeleteStudent?enrollmentId="
    public static let KClassdropDown = "api/Common/DropdownBind"
    public static let KGardianPhoneEmailVerifyApi = "api/Institute/GetGuardianDetailByPhoneEmail"
    
    //  Subject Api (Poonam)
    public static let KSubjectListApi = "api/Institute/GetSubjectList"
    public static let kAddStudentRating = "api/Institute/AddStudentRating"
    public static let KDeleteSubject = "api/Institute/DeleteSubject?subjectId="
    public static let KAddSubject = "api/Institute/AddSubject"
    public static let KSubjectDetailApi = "api/Institute/GetSubjectDetail?SubjectId="
    public static let kStudentRating =  "api/Institute/GetAllStudentRatingByClassSubjecId"
    public static let kTeacherListApi = "api/Institute/GetTeacherList"
    public static let kSkillList = "api/Common/DropdownBind"
    public static let kAddTeacherRating = "api/Institute/AddTeacherRating"
    public static let kGetSubjectWiseRating = "api/Institute/GetAllStudentRatingBySubjectWise"
    public static let kGetSubjectEnrollement = "api/Institute/GetStudentRatingViewByEnrollmentClassSubjectId"
    

    public static let kGetTeacherSubjectWiseRating = "api/Institute/GetTeacherRatingBySubjectWise"

    public static let kGetSubjectSkillRating = "api/Institute/GetStudentRatingViewByEnrollmentClassSubjectId"
    public static let kGetTeacherSkillRating = "api/Institute/GetTeacherRatingViewByTeacherClassSubjectId"
    
    public static let kGetClassSubjectsByteacherId = "api/Institute/GetClassSubjectsByteacherId"
    
    public static let kGetStudentsByClassId = "api/Institute/GetStudentsByClassId"
    

// AddTeacherRating api
     public static let kTeacherRatingAdd = "api/Institute/TeachersAssignedToStudent"
     public static let kGetSubjectListByteacherId = "api/Institute/GetSubjectListByteacherId"
     public static let kAddTeacherFeedBack = "api/Institute/AddTeacherFeedBack"
     public static let kGetTeacherRatingByHOD = "api/Institute/GetTeacherRatingByHOD"

    
    //Chapter Api
    public static let KChapterListApi = "api/Institute/GetChapterList"
    public static let KChapterDetailApi = "api/Institute/GetChapterDetail"
    public static let KDeleteChapterApi =  "api/Institute/DeleteChapter?chapterId="
    public static let KAddChapterApi = "api/Institute/AddChapter"
    
    public static let KAddTopicApi = "api/Institute/AddTopic"
    public static let KDeleteTopicApi = "api/Institute/DeleteTopic?topicId="
    public static let KTopicListApi = "api/Institute/GetTopicList"
    public static let KTopicDetailApi = "api/Institute/GetTopicDetail"
    //GetClassAssignSubject
    public static let kGetAllAssignSubjectApi = "api/Institute/GetAllAssignedSubject"

    //Assign Subjects to class
    public static let kAssignSubjectsToClass = "api/Institute/AssignClassSubject"
    
    //User List by Role Id
    public static let kUserListByRoleId = "api/User/GetAllUserByRoleId"
    public static let kUserRole = "api/User/GetUserRoleListByUserId?userId="
    public static let kUserRoleMenu = "api/User/GetPagesByRoleIdAndUserId"
    
    //Assign Subject,Teacher to Period
    public static let kAddUpdateTimeTable = "api/Institute/AddUpdateTimeTable"
    
    //Add period Api
    public static let kAddPeriod = "api/Institute/AddPeriod"
    public static let kGetPeriod = "api/Institute/GetPeriodList"
    public static let kDeletePeriod = "api/Institute/DeletePeriod?periodId="
    //Get Time Table Api
    public static let getTimeTableListApi = "api/Institute/GetTimeTableList"
    
}




//MARK: Alert Strings
 let KNoInternetConnection =  "No internet connection"
 let k_EmptyFirstName: String = "Please enter First name."
 let k_MaxFirstName: String = "First name is not more then 32 characters."
 let k_EmptyLastName: String = "Please enter Last name."
 let k_MaxLastName: String = "Last name is not more then 32 characters."
 let k_EmptyEmail: String = "Please enter Email."
 let k_InValidEmail: String = "Please enter valid email."
 let k_EmptyPassword: String = "Please enter password."
 let k_MinPasswordLength: String = "Password length should be 4-16 long."
 let k_EmptyConfirmPassword: String = "Please enter confirm password."
 let k_ConfirmPasswordNotMatch: String = "Confirm password is not match with password."
 let k_EmptyPhoneNumber: String = "Please enter phone number."
 let k_PasswordComplexity: String = "Password must have Lower Case, Upper Case, Digits, Special Characters."
 let k_MinPhoneNumberLength: String = "Phone number must be 10 characters."
 let k_EmailAlreadyExist: String = "Email already exist."
 let k_UserAlreadyExist :String = "User already exist."
 let k_LoginSuccessfullyAlert :String = "Login successfully."
 let k_ServerError :String = "Server Error. Please try again."
let k_InvalidPhoneNumberPassword : String = "Invalid phone number or password."
let k_Message : String = "Message"

let k_DefaultCase : String = "Default case called"
let k_UniqueDeviceId : String = "UniqueDeviceId"
let k_Device_Type : String = "DeviceType"
let k_DeviceToken : String = "DeviceToken"


//MARK:-SignUp Alert
public struct Alerts
{
    //Internet/Server Related Errors
    public static let kNoInternetConnection = "No internet connection."
    public static let kServerErrorAlert = "Server error."
     public static let kNoRecordFound = "No Record Found"
    
    //Delete Alerts
    public static let kDeleteDepartmentAlert = "Do you really want to delete this department."
    public static let kDeleteClassAlert = "Do you really want to delete this class."
    public static let kDeleteHODAlert = "Do you really want to delete this HOD."
    public static let kDeleteTeacherAlert = "Do you really want to delete this teacher."
    
    //Hardware Related Errors
    public static let kDontHaveCamera : String = "You dont't have camera."
    
    //Other Alert
    public static let kLogOutAlert : String = "Are you sure you want to logout."


    
    public static let kFirstName = "Enter first name"
    public static let kmiddleName = "Enter middle name."
    public static let kLastName = "Enter last name"
    public static let kgender = "select gender"
    public static let kcountry = "Select country"
    public static let kcity = "Enter city"
    public static let kdistrict = "select district"
    public static let kAddress = "Enter address"
    public static let kEmail = "Enter email."
    
    //MARK:- Faculty Alerts
    public static let kEmptyFirstName : String = "Please enter first name."
    public static let kEmptyMiddleName = "Enter middle name."
    public static let kEmptyLastName : String = "Please enter last name."
    public static let kEmptyAddress : String = "Please enter address."
    public static let kEmptyDOB : String = "Please select DOB."
    public static let kSelectCountry = "Please select country"
    public static let kSelectState = "Please select state"
    public static let kEmptyCity = "Please enter city."
    public static let kSelectDistrict = "Please select district."
    
    public static let kEmptyGender : String = "Please select gender."
    public static let kEmptyAssignDepartment : String = "Please select assign department."
    public static let kEmptyRelation : String = "Please enter relation."
    public static let kEmptyEmail : String = "Please enter email."
    public static let kEmptyPhoneNumber : String = "Please enter phone number."
    public static let kEmptyIdProof : String = "Please enter Id proof name."
    public static let kEmptyOthers : String = "Please enter others."
    public static let kInvalidEmail : String = "Please enter valid email."
    public static let kMinPhoneNumberCharacter : String = "Phone number must be 10 characters."
    public static let kEmptyClass : String = "Please enter class."
    public static let kEmptyRollNoAddmissionID = "Please enter addmission id or roll no."
    public static let kEmptyFatherName : String = "Please enter father name."
    public static let kEmptyDesignation : String = "Please select designation."
    public static let kEmptyWorkExperience : String = "Please select work experience."

    public static let kMapperModelError: String = "Mapper Error."
    public static let kUnderAge: String = "You are under age."
    public static let kEmptyTitle: String = "Please enter title."
    public static let kEmptyDescription: String = "Please enter description."
    public static let kEmptyDepartment: String = "Please select department."
    public static let kSelectIdProofImage : String = "Please select id proof image."
    
    public static let kAssignSubjectToTeacher : String = "Please assign department to teacher."

    //    Poonam
    public static let kEmptyParentFName : String = "Please enter parent first name."
    public static let kEmptyParentLName : String = "Please enter parent last name."
    public static let kEmptyParentAddress : String = "Please enter parent adress."
    public static let kEmptyParentDOB : String = "Please enter parent DOB."
    public static let kEmptyParentEmail : String = "Please enter parent Email."
    public static let kEmptyParentPhoneNo : String = "Please enter parent phone number."
    
    public static let kDeleteStudentAlert = "Do you really want to delete this Student."
    public static let kDeleteSubjectAlert = "Do you really want to delete this Subject."
     public static let kEmptySubjectName : String = "Please enter Subject name."
}

//Login Params
let k_AppDeviceId = "fgf44343554"
let k_UserDeviceTokenSettings = "dheu673yet3t7gg7gu"
let k_DeviceType = "Iphone"
let k_PhoneNumber = "9914199335"
let k_Password = "qwerty123"

//MARK:- StoryBoard and view identifiers
public struct KStoryBoards
{
    public static let kMain = "Main"
    public static let kDepartment = "Department"
    public static let kStudent = "Student"
    public static let kTeacher = "Teacher"
    public static let kHOD = "HOD"
    public static let kParent = "Parent"
    public static let kClass = "Class"
    public static var kHome = "Home"
    public static let kSchool = "School"
    public static let kUserAccess = "UserAccess"
    public static let kSWRevealVC = "SWRevealVC"
    public static let kSubject = "Subject"
      public static let kPeriod = "Period"
    public static let kSubjectStoryboard = "Subject"
    public static let kExamResult = "ExamResult"
    public static let kPerformance = "Performance"
    public static let kNewsfeedAndLetter = "NewsFeedAndLetter"
    public static let kStudentListToMarkAttendence = "StudentAttendence"
    public static let kCourses = "Courses"
     public static let kCalender = "CalendarAndEvents"
   
    internal struct KWelcomeIdentifiers{
        public static let kWelcomeVC = "WelcomeVC"
        public static let kWelcomeNav = "WelcomeNav"

    }
    
    internal struct KLoginIdentifiers
    {
        public static let kLoginNav = "LoginNav"
        public static let kTitle = "Login"
        public static let kLoginVC = "LoginVC"
    }
    
    internal struct KForgotPassIdentifiers
    {
        public static let kForgotTitle = "Forgot Password"
        public static let kCreatePassTitle = "Create Password"
        public static let kForgotPassVC = "ForgotPasswordVC"
        public  static let kCreatePassVC = "ConfirmPasswordVC"
    }
    
    internal struct KSignUpIdentifiers
    {
        public static let kSignUpTitle = "Sign Up"
        public static let kSignUpViewController = "SignUpViewController"
    }
    
    internal struct KAddDepartMentIdentifiers
    {
        public static let kAddDepartmentTitle = "Add Department"
        public static let kAddDepartmentVC = "AddDepartmentVC"
        public static let kUpdateDepartmentTitle = "Update Department"

    }
    
    internal struct KDepartMentListIdentifiers
    {
        public static let kDepartmentListTitle = "Department List"
        public static let kDepartmentListVC =  "DepartmentListVC"
        
    }
    internal struct kAssignSubjectToClass
    {
        public static let kClassAssignSubjectListVC = "ClassAssignSubjectListVC"
        
    }
    
    internal struct KSyllabusCoverageIdentifiers
     {
         public static let kSyllabusCoverageVC = "SyllabusCoverageVC"
         
     }
    
    internal struct KAddClassIdentifiers{
        public static let kAddClassTitle = "Add Class"
        public static let kAddClassVC = "AddClassVC"
        public static let kUpdateClassTitle = "Update Class"
    }
    internal struct KClassListIdentifiers{
        public static let kClassListTitle = "Class List"
        public static let kStudentRating = "Student Rating"
        public static let kClassListVC = "ClassListVC"
        public static let kClassAssignSubjectsListVC = "ClassAssignSubjectListVC"
    }
    internal struct KAddHODIdentifiers{
        public static let kAddHODTitle = "Add HOD"
        public static let kAddHODVC = "AddHODVC"
        public static let kUpdateHodTitle = "Update HOD"
    }
    internal struct KHODListIdentifiers{
        public static let kHODListTitle = "HOD List"
        public static let kHODListVC = "HODListVC"
    }
    internal struct KAddTeacherIdentifiers{
        public static let kAddTeacherTitle = "Add Teacher"
        public static let kAddTeacherVC = "AddTeacherVC"
        public static let kUpdateTeacherTitle = "Update Teacher"
    }
    internal struct kTeacherSubjectWiseRating {
        public static let kTeacherSubjectWiseRatingVC = "TeacherSubjectWiseRatingVC"
    }
    internal struct kStudentSubjectWiseRating {
        public static let kStudentSubjectWiseRatingVC = "StudentSubjectWiseRatingVC"
    }
    internal struct kStudentRating {
        public static let kStudentRatingVC = "StudentRatingVC"
    }
    internal struct kTeacherRating {
        public static let kTeacherRating = "TeacherRatingVC"
    }
    internal struct KTeacherListIdentifiers{
        public static let kTeacherListTitle = "Teacher List"
        public static let kTeacherListVC = "TeacherListVC"
    }
    internal struct KHomeIdentifiers{
        public static let kTHomeTitle = "Home"
        public static let kHomeVC = "HomeVC"
    }
    internal struct KAddSchoolIdentifiers{
        public static let kAddSchoolTitle = "Add School"
        public static let kAddSchoolVC = "AddSchoolVC"
    }
    internal struct KUserListIdentifiers{
        public static let kUserListTitle = "User List"
        public static let kUserListVC = "UserListVC"
    }
    internal struct KUserAccessRoleIdentifiers{
        public static let kUserAccessTitle = "User Access Role"
        public static let kUserAccessVC = "UserAccessRoleVC"
    }
    //    poonam
    internal struct KAddStudentIdentifiers
    {
        public static let kAddTitle = "Add Student"
        public static let kUpdateTitle = "Update Student"
        public static let kAddStudentVC = "AddStudentVC"
        public static let kAddStudentListVC = "StudentListVC"
        public static let kStudentListTitle = "Student List"
        public static let kAddSubjectListVC = "SubjectListVC"
    }
    
    internal struct KAddSubjectIdentifiers{
        public static let kAddSubjectVC = "AddSubjectVC"
        public static let kAddTitle = "Add Subject"
        public static let kUpdateTitle = "Update Subject"
        public static let kSubjectListTitle = "Subject List"
    }
    
    internal struct KUserRoleIdIdentifiers{
        public static let kUserRoleIdVC = "UserRoleIdVC"
        static let kUserMultiRoleTitle = "Roles"
    }
    
    internal struct KClassPeriodIdIdentifiers{
        public static let kClassPeriodTimeTableVC = "ClassPeriodsTimeTableVC"
        public static let kClassPeriodTimeTableTitle = "Period Time Table"
        public static let kTimePeriodVC = "TimePeriodVC"
        public static let kAddPeriodTitle = "Add Period"
    }
}

//MARK:- Api Parameters
public struct KApiParameters{
    
    internal struct kStudentListForAttendence {
        public static let kTimeTableId = "TimeTableId"
        public static let kClassId = "ClassId"
    }
    
    internal struct KCommonResponsePerameters{
        static let kMessage : String = "Message"
        static let kResultData : String = "ResultData"
        static let kStatus : String = "Status"
        static let kStatusCode : String = "StatusCode"
        static let kResourceType : String = "ResourceType"
    }
    
    
    internal struct LoginApiPerameters{
        public static let kPhoneNumber : String = "PhoneNo"
        public static let kUsername : String = "UserName"
        public static let kPassword : String = "Password"
        public static let kUserId : String = "UserId"
    }
    
    internal struct SignUpApiPerameters{
        public static let kUserId : String = "UserId"
        public static let kFirstName : String = "FirstName"
        public static let kLastName : String = "LastName"
        public static let kAddress : String = "Address"
        public static let kEmail : String = "Email"
        public static let kGender : String = "Gender"
        public static let kDOB : String = "DOB"
        public static let kCityId : String = "CityId"
        public static let kPassword : String = "Password"
        public static let kIsResgister : String = "IsRegister"
        public static let kPhoneNumber : String = "PhoneNo"
        public static let kIFile : String = "IFile"
        public static let kImageUrl : String = "ImageUrl"
        public static let kThumbImageUrl : String = "ThumbImageUrl"

    }
    
    internal struct AddDepartmentApiPerameters{
        public static let kDepartmentId : String = "DepartmentId"
        public static let kTitle : String = "Title"
        public static let kDescription : String = "Description"
        public static let kOthers : String = "Others"
        public static let kLogoUrl : String = "LogoUrl"
        public static let kIFile : String = "IFile"
        public static let kName : String = "Name"


    }
    
    internal struct KAddClassApiPerameters{
        public static let kClassId : String = "ClassId"
        public static let kName : String = "Name"
        public static let kDescription : String = "Description"
        public static let kOthers : String = "Others"
        public static let kLogoUrl : String = "LogoUrl"
        public static let kIFile : String = "IFile"
        public static let kDepartmentId : String = "DepartmentId"

    }
    
    internal struct KGetPagesByUserIdIdintifier
    {
        public static let kUserId : String = "UserId"
        public static let kRoleId : String = "RoleId"
    }
    
    internal struct KAddHODApiParameters{
        public static let kHODId : String = "HODId"
        public static let kImageUrl : String = "ImageUrl"
        public static let kFirstName : String = "FirstName"
        public static let kLastName : String = "LastName"
        public static let kAddress : String = "Address"
        public static let kDOB : String = "DOB"
        public static let kGender : String = "Gender"
        public static let kEmail : String = "Email"
        public static let kPhoneNo : String = "PhoneNo"
        public static let kIDProof : String = "IDProof"
        public static let kIDProofTitle : String = "IDProofTitle"
        public static let kDepartmentId : String = "DepartmentId"
        public static let kDepartmentName : String = "DepartmentName"
        public static let kQualification : String = "Qualification"
        public static let kWorkExperience : String = "WorkExperience"
        public static let kAdditionalSkills : String = "AdditionalSkills"
        public static let kOthers : String = "Others"
        public static let kIsHide : String = "IsHide"
        public static let kIFile : String = "IFile"
        public static let kRoleid : String = "Roleid"
        public static let kuserId : String = "UserId"
        public static let kCityId : String = "CityId"
    }
    
    internal struct KAddTeacherApiParameters{
        public static let kTeacherId : String = "TeacherId"
        public static let kImageUrl : String = "ImageUrl"
        public static let kFirstName : String = "FirstName"
        public static let kLastName : String = "LastName"
        public static let kAddress : String = "Address"
        public static let kDOB : String = "DOB"
        public static let kGender : String = "Gender"
        public static let kEmail : String = "Email"
        public static let kPhoneNo : String = "PhoneNo"
        public static let kIDProof : String = "IDProof"
        public static let kIDProofTitle : String = "IDProofTitle"
        public static let kQualification : String = "Qualification"
        public static let kWorkExperience : String = "WorkExperience"
        public static let kAdditionalSkills : String = "AdditionalSkills"
        public static let kOthers : String = "Others"
        public static let kIFile : String = "IFile"
        public static let kuserId : String = "UserId"
        public static let kHODId : String = "HODId"
        public static let kHODName : String = "HODName"
        public static let kDepartmentName : String = "DepartmentName"
        public static let kStrDepartmentId : String = "StrDepartment"
        public static let kDepartmentId : String = "DepartmentId"
        public static let kDepartmentListModels : String = "DepartmentListModels"
        public static let kStrTeacherDOB : String = "StrDOB"
    }
    
    internal struct kSyllabusCoverageApiParameter {
        public static let kClassSubjectId = "ClassSubjectId"
        public static let kCoveragePercentage = "CoveragePercentage"
        public static let kSubjectName = "SubjectName"
        
    }

    internal struct kStudentListForAttApiParameter {
        public static let kEnrollmentId = "EnrollmentId"
        public static let kStudentName = "StudentName"
        public static let kStatus = "Status"
         public static let kImageUrl = "ImageUrl"
        
    }
    
    
 
    
//    //MARK:- Syllabus coverage
//    public struct SyllabusCoverage {
//
//        public static let kSyllabusResponseNotGet = "Syllabus APi Nil response"
//        public static let kSyllabusResponseError = "Syllabus APi error response"
//        public static let kCell = "cell1"
//        public static let kSyllabusCoverageUrl = "api/Institute/GetAllSyllabusCoverageSubject"
//        public static let kTeacherId =  "TeacherId"
//        public static let kClassId = "ClassId"
//
//    }

    
    internal struct kUpdateSyllabusApiParameter {
        
        public static let kChapter : String = "Chapter"
        public static let kSubjectName : String = "SubjectName"
        public static let kChapterId = "ChapterId"
        public static let kChapterName = "ChapterName"
        public static let kAddUpdateSyllabus = "api/Institute/AddUpdateSyllabus"
        public static let kChapterListApi = "api/Institute/GetChapterList"
         public static let kChapterAndTopicApi = "api/Institute/GetChapterListWithTopic"
        // param Subject list
        public static let kStrChapterId =  "StrChapterId"
        public static let kChapterID =      "ChapterId"
        public static let kClassSubjectId = "ClassSubjectId"
        public static let kClassId      =    "ClassId"
        public static let kUserId       =     "UserId"
        // param chapter list
        public static let kSearch = "Search"
        public static let kSkip = "Skip"
        public static let kPageSize = "PageSize"
        public static let kSortColumnDir = "SortColumnDir"
        public static let kSortCoumn = "SortColumn"
        public static let kParticularId = "ParticularId"
        
    }
   
    internal struct kAddStudentAttendence {
        public static let kTimeTableId = "TimeTableId"
        public static let kTeacherId = "TeacherId"
        public static let kClassSubjectId = "ClassSubjectId"
        public static let kListAttendences = "ListAttendences"
    }
    
    
    internal struct KGetDetailByPhoneEmail{
        public static let kPhone : String = "Phone"
        public static let kEmail : String = "Email"
    }
    
    internal struct KCommonParametersForList{
        public static let kSearch : String = "Search"
        public static let kSkip : String = "Skip"
        public static let kPageSize : String = "PageSize"
        public static let kSortColumn : String = "SortColumn"
        public static let kFilterBy : String = "FilterBy"
        public static let kSortColumnDir : String = "SortColumnDir"
        
    }
    
    internal struct KAllUserByRoleIdParameter{
        public static let kUserId : String = "UserId"
        public static let kUserName : String = "UserName"
        public static let kRoleId : String = "RoleId"
        public static let kRoleName : String = "RoleName"
        public static let kImageUrl : String = "ImageUrl"
    }
    
    internal struct KUserAccessRoleParameter{
        public static let kUserId : String = "UserId"
        public static let kModuleIds : String = "ModuleIds"
        public static let kPageIds : String = "PageIds"
        public static let kActionIds : String = "ActionIds"
        public static let kLstModuleAccess : String = "LstModuleAccess"
        public static let kLstPageAccess : String = "LstPageAccess"
        public static let kPageName : String = "PageName"
        public static let kDisplayOrder : String = "DisplayOrder"
        public static let kPageId : String = "PageId"
        public static let kModuleId : String = "ModuleId"
        public static let kIsAccess : String = "IsAccess"
        public static let kLstActionAccess : String = "LstActionAccess"
        public static let kActionName : String = "ActionName"
        public static let kTabId : String = "TabId"
        public static let kActionId : String = "ActionId"
    }
    
    //    Poonam
    internal struct AddStudentApi{
        public static let StudentId : String = "StudentId"
        public static let StudentRollNo : String = "StudentRollNo"
        public static let studentFirstName : String = "StudentFirstName"
        public static let studentLastName : String = "StudentLastName"
        public static let Studentaddress : String = "StudentAddress"
        public static let studentDOB : String = "StudentDOB"
        public static let studentGender : String = "StudentGender"
        public static let studentEmail: String = "StudentEmail"
        public static let studentPhoneNo : String = "StudentPhoneNo"
        public static let studentOthers : String = "StudentOthers"
        public static let parentFirstName : String = "GuardianFirstName"
        public static let parentLastName: String = "GuardianLastName"
        public static let parentAddress : String = "GuardianAddress"
        public static let parentDOB : String = "GuardianDOB"
        public static let parentGender : String = "GuardianGender"
        public static let parentEmail : String = "GuardianEmail"
        public static let parentPhoneNo : String = "GuardianPhoneNo"
        public static let parentOther : String = "GuardianOthers"
        public static let StudentUserId : String = "StudentUserId"
        public static let ClassIdb : String = "ClassId"
        public static let GuardianId : String = "GuardianId"
        public static let GuardianUserId : String = "GuardianUserId"
        public static let RelationId : String = "RelationId"
        public static let SessionId : String = "SessionId"
        public static let studentImg : String = "StudentImageUrl"
        public static let parentProfileImg : String = "GuardianImageUrl"
        public static let StudentPhone : String = "Phone"
        public static let StudentEmail : String = "Email"
        public static let studentIDProofTitle : String = "StudentIDProofTitle"
        public static let guardianIDProofTitle : String = "GuardianIDProofTitle"
        public static let studentIDProof : String = "StudentIDProof"
        public static let guardianIDProof : String = "GuardianIDProof"
        public static let userId : String = "UserId"
        
    }
    
    internal struct AddSubjectApi{
        public static let subjectId : String = "SubjectId"
        public static let subjectName : String = "subjectName"
        public static let classSubjectId : String = "classSubjectId"
        public static let classId : String = "classId"
        public static let description : String = "description"
        //gurleen
        public static let chapterId : String = "ChapterId"
        public static let chapterName : String = "ChapterName"
        public static let kclassSubjectId : String = "ClassSubjectId"
        public static let kTopicId : String = "TopicId"
        public static let kTopicName : String =  "TopicName"
       
    }
    
    internal struct AssignSubjectToClassApi{
        public static let kClassSubjectId : String = "ClassSubjectId"
        public static let kClassSubjectModels : String = "classSubjectModels"
        public static let kStrSubject : String = "StrSubject"
        public static let kClassId : String = "ClassId"
        public static let kSubjectId : String = "SubjectId"
    }
    
    internal struct AddUpdateTimeTableApi{
        public static let kTimeTableId = "TimeTableId"
        public static let kTeacherId = "TeacherId"
        public static let kPeriodId = "PeriodId"
        public static let kClassSubjectId = "ClassSubjectId"
        public static let kStrDay = "StrDay"
        public static let kClassId = "ClassId"
    }
    
    internal struct UpdateUserAccess{
        
    }
    
    //    StudentListApi
    internal struct StudentListApi{
        public static let StudentClassId : String = "classId"
        public static let StudentSearch : String = "Search"
        public static let PageSkip : String = "Skip"
        public static let PageSize : String = "PageSize"
    }
    
    //    SubjectListApi
    internal struct SubjectListApi{
        public static let subjectSearch : String = "search"
        public static let PageSkip : String = "skip"
        public static let PageSize : String = "pageSize"
        public static let sortColumnDir : String = "sortColumnDir"
        public static let sortColumn : String = "sortColumn"
        public static let particularId: String = "ParticularId"
    }
    
   
    
    
    
}

public struct SubjectSkillRating {
//    public static let kSubjectSkillRatingVC = "Subject Skill Rating"
      public static let kSubjectSkillRatingVC = "Rating"
}

//MARK:- Syllabus coverage
public struct SyllabusCoverage {
    
    public static let kSyllabusResponseNotGet = "Syllabus APi Nil response"
    public static let kSyllabusResponseError = "Syllabus APi error response"
    public static let kCell = "cell1"
    public static let kSyllabusCoverageUrl = "api/Institute/GetAllSyllabusCoverageSubject"
    public static let kTeacherId =  "TeacherId"
    public static let kClassId = "ClassId"
    //"TeacherId" : 0 ,
    //"ClassId": 10
    
}

    
    
//MARK:- Cell Identifiers
public struct KTableViewCellIdentifier{
    public static let kClassTableViewCell = "classCell"
    public static let kHodTableViewCell = "hodCell"
    public static let kTeacherTableViewCell = "teacherCell"
    public static let kDepartmentTableViewCell = "departmentCell"
    public static let kUserAccessTableViewCell : String = "userAccessCell"
    public static let kSelectionTableViewCell : String = "selectionTblViewCell"
    public static let kClassPeriodTimeTable : String = "periodTimeTableCell"
    //    poonam
    public static let kStudentTableViewCell = "StudentCell"
    public static let kSubjectTableViewCell = "SubjectList"
       public static let kRoleIdTableViewCell = "roleIdCell"
     public static let kTopicTableView = "TopicCell"
     public static let kTimePeriodCell = "periodCell"
}


//MARK:- App Content Related
public struct KAPPContentRelatedConstants{
    public static let kThemeColour : UIColor = UIColor.init(red: 183.0/255.0, green: 23.0/255.0, blue: 36.0/255.0, alpha: 1.0)
    public static let kThemeColorName : String = "DarkRed"
    public static let kAppTitle = "ISMS"
    public static let kAppGlobalFontName : String = "OpenSans-Semibold"
}

public enum ThemeMode : String{
    case HodTheme
    case StudentTheme
    case TeacherTheme
    case AdminTheme
}
    //MARK:- Chapter Parameter
    public struct ChapterVC {
        
        public static let kChapterVC = "SubjectChapterVC"
        
        internal struct chapterParam {
            public static let kChapterId = "chapterId"
        }
        internal struct ChapterModelParam {
            public static let kChatperId = "ChapterId"
            public static let kChapterName = "ChapterName"
            
        }
        
        internal struct CustomViewString {
            public static let kAddChapter = "Add Chapter"
            public static let kAdd = "Add"
            public static let kCancel = "Cancel"
            public static let kUpdate = "Update"
        }
        
        
    }
    
    public struct TopicVC {
        
        public static let kSubjectTopicVC = "SubjectTopicVC"
        
        internal struct ChapterTopicParam {
            public static let kChapter = ""
            
        }
        
    }
//MARK:- STUDENT RATING
public struct StudentRating {
    
    public static let kStudentRatingCell = "StudentRatingCell"
    
}

public struct AddStudentRating {
    
    public static let kId = "Id"
    public static let kEnumType = "enumType"
    public static let kAddStudentRatingCell = "AddStudentRatingCell"
    
    
    
}

public struct RatingToTeacher {
    
    public static let kRatingToTeacherCell = "RatingToTeacherRating"
    public static let kAddTeacherRating = "Add Teacher Rating"
    
    
}

public struct TeacherRating {
   
    public static let kTeacherRatingCell = "TeacherRatingCell"
    public static let kTeacherRatingVC = "Teacher Rating"
    
}

public struct SubjectWiseRating {
    
    public static let kSubjectWiseRatingCell = "SubjectWiseRatingCell"
    public static let kSubjectSkillRatingCell = "SubjectSkillRatingCell"
    public static let kTeacherSubjectSkillRatingCell1 = "TeacherSubjectSkillRatingCell1"
    public static let kTeacherSubjectSkillRatingCell = "TeacherSubjectSkillRatingCell"
    
    
}

//MARK:- PRINT ERROR MESSAGE
public struct kPrintErrorMsg {
    
    internal struct kServiceError {
        static let kStatusError : String = "APi status change"
        static let kResponseError : String = "APi error response"
        
    }
    
}

//MARK:- Images Names
public struct kImages
{
    public static let KBackIcon = "backIcon"
    public static let kRadioSelected = "radioSelected"
    public static let kUnselectedRadio = "radioUnSelected"
    public static let kBackGroundImage = "BgIcon"
    public static let kAttachmentImage = "attachment"
    public static let kProfileImage = "profile"
    public static let kCheck = "check"
    public static let kUncheck = "uncheck"
    public static let kMinusIcon = "MinusIcon"

}
//MARK:- FontName
public struct KFontNames
{
    public static let KOpenSans = "OpenSans"
    public static let kOpenSansNBold = "OpenSans-Semibold"
    public static let KRalewaySemiBold = "Raleway-SemiBold"
}

//MARK:- PlaceHolders
public struct KPlaceholder
{
    public static let kPhoneNumber = "Phone Number"
    public static let kPhoneEmail = "PhoneNo/Email"
    public static let kPassword = "Password"
    public static let kConfirmPassword = "Confirm Password"
    public static let kEnterPassword = "Enter Password"
    public static let kFirstName = "First Name"
    public static let kMiddleName = "Middle Name"
    public static let kLastName = "Last Name"
    public static let kCountry = "Country"
    public static let kState = "State"
    public static let kDistrict = "District"
    public static let kCity = "City/Town/Village"
    public static let kAddress = "Address"
    public static let kEmail = "Enter Email"
    public static let kDescription = "Write Description"
    public static let kDOB = "DOB"
    public static let kOthers = "Others"
    public static let kIdProof = "ID Proof Name"
    public static let kAssignDepartment = "Assign Department"
    public static let kClass = "Class"
    public static let kFatherName = "Father name"
    public static let kMotherName = "Mother name"
    public static let kAllocatedBus = "Allocated Bus"
    public static let kRollNoOrAdmissionId = "Roll no/Admission Id"
    public static let kWorkExperience = "Work Experience"
    public static let kAllocatedClassesAndSubjects = "Allocated classes & Subjects"
    public static let kAdditionalSkills = "Additional Skills"
    public static let kDesignation = "Designation"
    public static let kQualification = "Qualification"
    public static let kAssignHOD = "Assign HOD"
    public static let kRelation = "Relation"
    public static let kTitle = "Title"
    public static let kDepartment = "Department"
    public static let kSearchbarPlaceholder : String = "Search"

    public static let kSelectClassPlaceholder : String = "Select Class"
    public static let kSubjectNamePlaceholder : String = "Subject Name"
    public static let kDescriptionPlaceholder : String = "Description"
     public static let kSelectDepartment : String = "Select department"
     public static let kSelectClass : String = "Select class"
    public static let kChapterNamePlaceholder : String = "Chapter Name"
    public static let kTopicNamePlaceholder : String = "Topic Name"

}

//MARk:- Text Sizes
public struct KTextSize
{
    public static let KSixteen : Int = 16
    public static let KSeventeen : Int = 17
    public static let KFourteen : Int = 14
    public static let KEight : Int = 8
    public static let KFifteen : Int = 15
    public static let KTwentyEight : Int = 28
    
}

//MARK:- Alerts Titles
public struct KAlertTitle
{
    public static let KChooseImage : String = "Choose Image"
    public static let KCamera : String = "Camera"
    public static let KGallery : String = "Gallery"
    public static let KCancel : String = "Cancel"
    public static let kOk : String = "Ok"
    public static let kWarning : String = "Warning"

    
}

//MARK:- View Shadow Veriables
public struct KShadow{
    
    static let KShadowOpacity: Float = 0.3
    static let KShadowBlackColour = UIColor.black.cgColor
    
}

//MARK:- String Constants
public struct KConstants{
    
    static let KMale : String = "M"
    static let KFemale : String = "F"
    static let KNA : String = "O"
    static let kAccept : String = "Accept"
    static let kContentType : String = "Content-Type"
    static let kApplicationJson : String = "application/json"
    static let kWriteDescription : String = "Write description"
    static let kHeaderAuthorization : String = "Authorization"
    static let kHeaderBearer : String = "bearer"
    static let kMultipartFormData : String = "multipart/form-data"
    static let kHod : String = "HOD"
    static var kTeacher : String = "Teacher"
    static var kDesc : String = "Desc"
    static var kAsc : String = "ASC"
    static var kNoDataFound : String = "No data found."
    static var kPleaseTryAgain : String = "Please try again."
    //Button Title
    static var kBtnLoginTitle = "LOGIN"
    static var kBtnDoneTitle = "DONE"
    //    poonam
    static let kIsStudentDOB : String = "student"
    static let kIsParentDOB : String = "parent"
    
    static let kPeriodArr : String = "period1"
    static let kstartTime : String = "StrStartTime"
    static let kendTime : String = "StrEndTime"
    static let kperiod : String = "period"
    static let kDateFormat : String = "yyyy-MM-dd HH:mm:ss"
    static let kTime : String = "hh:mm a"
   // static let
    static let kPeriodTitle : String = "PeriodTitle"
    static let kPeriodId : String = "PeriodId"
    static let kUserExist : String = "User exist"
    static let kemptyStartTime: String = "Please select start time"
    static let kemptyEndTime: String = "Please select end time"
    static let kemptyClass: String = "Please select class"
    static let kPeriodGreater: String = "End time must be greater then start time"
    static let kNextPeriod: String = "End time must be smaller then next period start time"
     static let kGardianExist : String = "Guardian exist"
     static let kHODExist : String = "HOD Exist"
}

//MARK:- Navigation Titles
public struct KNavigationTitle{
    static let kAddTeacherTitle = "Add Teacher"
    static let kUpdateTeacherTitle = "Update Teacher"
    static let kAddHodTitle = "Add HOD"
    static let kUpdateHODTitle = "Update HOD"
    static let kAddParentTitle = "Add Parent"
    static let kAddStudentTitle = "Add Student"
    static let kUpdateStudentTitle = "Update Student"
    static let kAddOtherFacultyTitle = "Add Other Faculty"
}

//MARK:- Status Code
public struct KStatusCode{
    
    static let kStatusCode200 : Int = 200
    static let kStatusCode400 : Int = 400
    static let kStatusCode404 : Int = 404
    static let kStatusCode302 : Int = 302
    static let kStatusCode208 : Int = 208
    static let kStatusCode401 : Int = 401
    static let kStatusCode202 : Int = 202
    static let kStatusCode408 : Int = 408
    static let kStatusCode409 : Int = 409

    
}

//MARK:- Side Menu Rows Titles
public struct KMenuRowsTitles{
    
    static let kHomeTitle = "Home"
    static let kManageInstituteTitle = "Manage Institute"
    static let kManageRolesTitle = "Manage Roles"
    static let kManageDepartmentsTitle = "Manage Departments"
    static let kManageHODTitle = "Manage HOD"
    static let kManageClassesTitle = "Manage Classes"
    static let kManageTeachersTitle = "Manage Teachers"
    static let kManageStudentTitle = "Manage Student"
    static let kManageSubjectTitle = "Manage Subject"
    static let kManageClassSubjectTitle = "Manage Class Subject"
    static let kClassPeriodTimeTableTitle = "Class Period Time table"
    static let kAssignSubjectTeacherToPeriodTitle = "Assign Subject/Teacher period"
     static let kAddPeriod = "Add Period"
    static let kLogOutTitle = "Log out"

}

//MARK:- Search Bar Place Holders
public struct KSearchBarPlaceHolder{
    
    static let kUserSearchBarPlaceHolder : String = "Search User"
    static let kUserSearchBarStudentPlaceHolder : String = "Search Student"
      static let kUserSearchBarSubjectPlaceHolder : String = "Search Subject"

    
}

//MARK:- Integer Constants
public struct KIntegerConstants{
    
    static let kInt10  = 10
    static let kInt0 = 0
    static let kInt1 = 1
    static let kInt2 = 2
    static let kInt3 = 3
    static let kInt4 = 4
    static let kInt5 = 5
    static let kInt8 = 8
    static let kInt20 = 20
    static let kInt15 = 15
    static let kInt1000 = 1000

}
//MARK:- GiveAccessIntitifiers
public struct KAccessIntitifiers
{
    static let kAdd = "Add"
    static let kEdit = "Edit"
    static let kDelete = "Delete"
}

public struct KPerformanceIdentifiers
{
    static let kPerformanceTrackingTitle = "Performance Tracking"
    static let kPerformanceTrackingVC = "PerformanceTrackingVC"
    static let kPerformanceTrackingTableCell = "PerformanceTrackingTableCell"
    static let kPerformanceGraphVC = "PerformanceGraphVC"
    static let kCellIdentifier = "cell"
}

public struct kPaymentIdentifiers
{
    static let kPaymentHistoryVC = "PaymentHistoryVC"
    static let kOnlinePaymentVC = "OnlinePaymentVC"
    static let kPaymentTitle = "Payment"
}

public struct kSuperAdminIdentifier
{
    static let kManageUserVC = "ManageUserVC"
    static let kManageUserCell = "ManageTableCell"
    static let kManageUserTitle = "Manage Users"
}

public struct kNewsLetterAndFeedIdentifiers{
    static let kEventTableCell = "EventTableCell"
    static let kNewsLetterTableCell = "NewsLetterTableCell"
    static let kBulletinTableCell = "BulletinTableCell"
    static let kNewsLetterAndFeedVC = "NewsLetterAndFeedVC"
    static let kNewsLetterAndFeedTitle = "Feed"
}

public struct kExamResultIdentifiers {
    static let kExamResultVC = "ExamResultVC"
    static let kExamResultTitle = "Results"
    static let kExamResultCell = "ExamResultTableCell"
}

