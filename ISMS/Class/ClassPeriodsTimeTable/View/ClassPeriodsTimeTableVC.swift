////
////  ClassPeriodsTimeTableVC.swift
////  ISMS
////
////  Created by Taranjeet Singh on 7/17/19.
////  Copyright © 2019 Atinder Kaur. All rights reserved.
////
//
//import UIKit
//
//class ClassPeriodsTimeTableVC: BaseUIViewController {
//
//    //MARK:- Properties
//    @IBOutlet weak var txtFieldClass: UITextField!
//    @IBOutlet weak var btnSelectClassDropDown: UIButton!
//    @IBOutlet weak var tableViewClassPeriods: UITableView!
//
//    //MARK:- Variables
//    var viewModel : ClassPeriodsTimetableViewModel?
//    var isUnauthorizedUser = false
//    var selectedClassId : Int?
//    var classDropdownData : GetAllCountryStateCityModel!
//    var selectedClassIndex = 0
//    var selectedCollectionCell:String?
//
//    //MARK:- View functions
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//        setUI()
//        print(selectedCollectionCell)
//        classListDropdownApi()
//    }
//
//    //MARK:- Actions
//    @IBAction func btnActionClassList(_ sender: Any) {
//        updatePickerModel()
//    }
//
//    //MARK:- Update Picker Model
//    func updatePickerModel(){
//        UpdatePickerModel2(count: classDropdownData.resultData?.count ?? 0, sharedPickerDelegate: self, View: self.view)
//    }
//    //MARK:- Class List Dropdown
//    func classListDropdownApi(){
//        if checkInternetConnection(){
//            self.viewModel?.getClassListDropdown(selectId: 0, enumType: CountryStateCity.classes.rawValue)
//        }else{
//            self.showAlert(alert: Alerts.kNoInternetConnection)
//        }
//    }
//    //MARK:- Set UI
//    func setUI(){
//        //Initiallize memory for view model
//        self.viewModel = ClassPeriodsTimetableViewModel.init(delegate: self)
//        self.viewModel?.attachView(viewDelegate: self)
//        //Set table view footer view
//        tableViewClassPeriods.tableFooterView = UIView()
//        tableViewClassPeriods.allowsSelection = false
//        //Set title
//        self.title = KStoryBoards.KClassPeriodIdIdentifiers.kClassPeriodTimeTableTitle
//        //Set back button
//        setBackButton()
//        //Set picker view
//        SetpickerView(self.view)
//    }
//    //MARK:- Segues
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let vc = segue.destination as! AssignSubjectTeacherToPeriodVC
//        vc.previousSelectedValue = selectedCollectionCell
//    }
//}
////MARK:- Table View Delegate
//extension ClassPeriodsTimeTableVC : UITableViewDelegate{
//    //Will Display cell for set the seprator lines
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        cell.separatorInset = UIEdgeInsets.zero
//        cell.layoutMargins = UIEdgeInsets.zero
//    }
//}
//////MARK:- Table View Data Source
////extension ClassPeriodsTimeTableVC : UITableViewDataSource{
////    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
////        return viewModel?.arrDays.count ?? 0
////    }
////
////    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
////        let cell = tableView.dequeueReusableCell(withIdentifier: KTableViewCellIdentifier.kClassPeriodTimeTable, for: indexPath) as! ClassPeriodsTableViewCell
////        cell.cellSetUp(arrDays: viewModel?.arrDays, arrPeriods: viewModel?.periodsArray, indexPath: indexPath)
////        cell.delegate = self
////        return cell
////    }
////
////}
////MARK:- Class Periods Time Table Delegate
//extension ClassPeriodsTimeTableVC : ClassPeriodsTimeTableDelegate{
//
//    func classListDidSuccess(data: GetAllCountryStateCityModel) {
////        if data.resultData != nil{
////            if data.resultData?.count ?? 0 > 0{
////                classDropdownData = data
//////                txtFieldClass.text = data.resultData?[0].name
//////                selectedClassId = data.resultData?[0].id
////            }else{
////                CommonFunctions.sharedmanagerCommon.println(object: "Count is zero.")
////            }
////        }
//    }
//
//    func classListDidFailed() {
//
//    }
//
//    func getTimeTableSuccess() {
//
//    }
//
//    func getTimeTableFailed() {
//
//    }
//
//    func unauthorizedUser() {
//        isUnauthorizedUser = true
//    }
//
//
//}
////MARK:- Class Periods TimeTable View Delegate
//extension ClassPeriodsTimeTableVC : ViewDelegate{
//    func showAlert(alert: String){
//        initializeCustomOkAlert(self.view, isHideBlurView: true)
//        okAlertView.delegate = self
//        okAlertView.lblResponseDetailMessage.text = alert
//    }
//    func showLoader() {
//        ShowLoader()
//    }
//    func hideLoader() {
//        HideLoader()
//    }
//}
//
////MARK:- OK Alert Delegate
//extension ClassPeriodsTimeTableVC : OKAlertViewDelegate{
//    func okBtnAction() {
//        okAlertView.removeFromSuperview()
//        if isUnauthorizedUser == true{
//            isUnauthorizedUser = false
//            CommonFunctions.sharedmanagerCommon.setRootLogin()
//        }
//    }
//}
////MARK:- UiPicker Delegate
//extension ClassPeriodsTimeTableVC:SharedUIPickerDelegate{
//    func DoneBtnClicked() {
//        if classDropdownData.resultData?.count ?? 0 > 0{
//                self.txtFieldClass.text = self.classDropdownData.resultData?[selectedClassIndex].name
//                self.selectedClassId = self.classDropdownData.resultData?[selectedClassIndex].id
//        }
//    }
//    func GetTitleForRow(index: Int) -> String {
//        if classDropdownData.resultData?.count ?? 0 > 0{
////                txtFieldClass.text = self.classDropdownData.resultData?[0].name
//                return classDropdownData.resultData?[index].name ?? ""
//        }
//        return ""
//    }
//
//    func SelectedRow(index: Int) {
//        if classDropdownData.resultData?.count ?? 0 > 0{
//                txtFieldClass.text = self.classDropdownData.resultData?[index].name
//                selectedClassId = self.classDropdownData.resultData?[index].id ?? 0
//                selectedClassIndex = index
//        }
//    }
//
//    func cancelButtonClicked() {
//
//    }
//
//}
//extension ClassPeriodsTimeTableVC: UpdateValueDelegate{
//    func changeValue(selectedRow: String) {
//        selectedCollectionCell = selectedRow
//        self.performSegue(withIdentifier: "PeriodListToDetail", sender: self)
//
//        print(selectedCollectionCell)
//    }
//
//}
