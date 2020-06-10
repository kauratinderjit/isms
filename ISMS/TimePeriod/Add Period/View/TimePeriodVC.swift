//
//  TimePeriodVC.swift
//  ISMS
//
//  Created by Poonam Sharma on 7/8/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class TimePeriodVC: BaseUIViewController {
    
    //MARK:- Variables
    var ViewModel : PeriodViewModel?
    var periodArr =  [KConstants.kPeriodArr]
    var getPeriod:GetPeriodListModel?
    var startTime:String?
    var time = ""
    var classData = [ResultData]()
    var timetableSelectedClassId : Int?
    var selectedClassIndex = 0
    var selectedClassID : Int?
    var selectedClassName: String?
    var isUnauthorizedUser = false
    var isAddPeriod = false
    var getData = false
    var isnewData = false
    var isemptyCell = false
    var viewDatePickerView = UIView()
    var datePickerView  = UIDatePicker()
    var newitems = [PeriodsListData]()
    var lastDouplicateElement : Bool?
     var HODdepartmentId = UserDefaultExtensionModel.shared.HODDepartmentId
    
    //MARK:- Outlets
    @IBOutlet weak var btnAddPeriod: UIButton!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtFieldClass: UITextField!
    @IBOutlet weak var btnSelectClass: UIButton!
    
    @IBOutlet weak var btnAddOccurance: UIButton!
    //MARK:- View Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ViewModel = PeriodViewModel.init(delegate: self)
        self.ViewModel?.attachView(viewDelegate: self)
        self.addDatePickerView()
        self.setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if checkInternetConnection(){
            self.ViewModel?.getClassId(id:HODdepartmentId , enumtype: 6)
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
    }
    //MARK:- Functions
    func setUI(){
        self.title = KStoryBoards.KClassPeriodIdIdentifiers.kAddPeriodTitle
        //Table View Settings
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        SetpickerView(self.view)
        setDatePickerView(self.view, type: .time)
        tableView.delegate = self
        tableView.dataSource = self
        self.setBackButton()
        txtFieldClass.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        
        //#TARAN
        if let theme = ThemeManager.shared.currentTheme{
            btnAddOccurance.backgroundColor = theme.uiButtonBackgroundColor
        }
        
        if let theme = ThemeManager.shared.currentTheme{
                   btnAddPeriod.backgroundColor = theme.uiButtonBackgroundColor
               }
        
        if timetableSelectedClassId != nil{
            txtFieldClass.text = selectedClassName
            selectedClassID = timetableSelectedClassId
            btnSelectClass.isUserInteractionEnabled = false
            txtFieldClass.isUserInteractionEnabled = false
            btnAddPeriod.setTitle("Update", for: .normal)
            getPeriodList()
        }
        
    }
    //gurleen
    func addDatePickerView() {
        //UIView for date picker view
        //#TARAN
        self.viewDatePickerView = UIView(frame: CGRect(x: 0, y: view.frame.size.height - 300, width: view.frame.size.width, height: 244))
        // UIDatePickerView
        self.datePickerView = UIDatePicker(frame: CGRect(x: 0, y: 44, width: viewDatePickerView.frame.size.width, height: 200))
        datePickerView.backgroundColor = UIColor.white
        datePickerView.datePickerMode = .time
        
        // ToolBar for done and cancel
        let toolBar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: datePickerView.frame.width, height: 44))
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.DoneBtn(sender:)))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.CancelButton(sender:)))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: true)
        
        viewDatePickerView.addSubview(toolBar)
        viewDatePickerView.addSubview(datePickerView)
        viewDatePickerView.isHidden = true
    }
    
    func showDatePickerStartTime(tag:Int){
        createBlurEffectView()
        viewDatePickerView.isHidden = false
        let previousindexPath = IndexPath(row: tag - 1,section: 0)
        //  let nextIndexPath = IndexPath(row: tag + 1,section: 0)
        let currentIndexPath = IndexPath(row: tag ,section: 0)
        
        //MINIMUM DATE
        if let previouscell = tableView.cellForRow(at: previousindexPath) as? TimePeriodCell   {
            if let stTime = previouscell.txtFieldPeriodEndTime.text {
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "h:mm a"
                if let date = dateFormatter.date(from:stTime) {
                    print(date)
                    dateFormatter.dateFormat = "HH:mm"
                    let datestr = dateFormatter.string(from: date)
                    print(datestr)
                    let strArray = datestr.components(separatedBy: ":")
                    print(strArray)
                    print(strArray[0])
                    print(strArray[1])
                    // if let str2ndVar = strArray[1] as? String {
                    //  let minutes = str2ndVar.components(separatedBy: " ")
                    if let hour = Int(strArray[0]) ,  let min = Int(strArray[1]) {
                        hoursSelectionMinimimum(startHour: hour, startMinute: min)
                        
                    }
                    
                }
            }
        }else {
            //no min date : case when cell is at 0  index
            datePickerView.minimumDate = nil
        }
        //MAXIMUM DATE
        //        if let nextCell = tableView.cellForRow(at: nextIndexPath) as? TimePeriodCell   {
        //            print(nextCell)
        if let currentCell = tableView.cellForRow(at: currentIndexPath) as? TimePeriodCell {
            if let stTime = currentCell.txtFieldPeriodEndTime.text {
                if stTime != "" {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "h:mm a"
                    if let date = dateFormatter.date(from:stTime) {
                        print(date)
                        dateFormatter.dateFormat = "HH:mm"
                        let datestr = dateFormatter.string(from: date)
                        print(datestr)
                        let strArray = datestr.components(separatedBy: ":")
                        print(strArray)
                        print(strArray[0])
                        print(strArray[1])
                        // if let str2ndVar = strArray[1] as? String {
                        //  let minutes = str2ndVar.components(separatedBy: " ")
                        if let hour = Int(strArray[0]) ,  let min = Int(strArray[1]) {
                            hoursSelectionMaximum(startHour: hour, startMinute: min)
                            
                        }
                        // }
                        
                    }
                }
                else{
                    datePickerView.maximumDate = nil
                }
            }
        }
        //        }
        //        else {
        //                //no min date : case when cell is at last  index
        //            datePickerView.maximumDate = nil
        //        }
        self.view.insertSubview(viewDatePickerView, aboveSubview: visualBlurView)
    }
    
    func showDatePickerEndTime(tag:Int){
        // datePickerView.minimumDate = Date()
        // datePickerView.maximumDate = Date()
        createBlurEffectView()
        viewDatePickerView.isHidden = false
        let currentindexPath = IndexPath(row:tag,section: 0)
        let nextIndexPath = IndexPath(row: tag + 1,section: 0)
        //check idf there is no start time in current
        if let currentcell = tableView.cellForRow(at: currentindexPath) as? TimePeriodCell {
            if let stTime = currentcell.txtFieldPeriodStartTime.text {
                if stTime == "" {
                    removeBlurEffect()
                    self.viewDatePickerView.isHidden = true
                    self.showAlert(alert: "Please set start time of current period")
                }
                else {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "h:mm a"
                    if let date = dateFormatter.date(from:stTime) {
                        print(date)
                        dateFormatter.dateFormat = "HH:mm a"
                        
                        let datestr = dateFormatter.string(from: date)
                        print(datestr)
                        let strArray = datestr.components(separatedBy: ":")
                        print(strArray)
                        print(strArray[0])
                        print(strArray[1])
                        // if let str2ndVar = strArray[1] as? String {
                        //  let minutes = str2ndVar.components(separatedBy: " ")
                        if let hour = Int(strArray[0]) ,  let min = Int(strArray[1]) {
                            hoursSelectionMinimimum(startHour: hour, startMinute: min)
                        }
                        
                    }
                }
            }
        } else {
            datePickerView.minimumDate = nil
        }
        
        //MAXIMUM DATE
        //checxk if no text is there
        if let nextCell = tableView.cellForRow(at: nextIndexPath) as? TimePeriodCell {
            print(nextCell)
            if let stTime = nextCell.txtFieldPeriodStartTime.text {
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "h:mm a"
                if let date = dateFormatter.date(from:stTime) {
                    print(date)
                    dateFormatter.dateFormat = "HH:MM"
                    let datestr = dateFormatter.string(from: date)
                    print(datestr)
                    let strArray = datestr.components(separatedBy: ":")
                    print(strArray)
                    print(strArray[0])
                    print(strArray[1])
                    // if let str2ndVar = strArray[1] as? String {
                    //  let minutes = str2ndVar.components(separatedBy: " ")
                    if let hour = Int(strArray[0]) ,  let min = Int(strArray[1]) {
                        hoursSelectionMaximum(startHour: hour, startMinute: min + 1)
                        
                    }
                }
            }
            
        }else {
            datePickerView.maximumDate = nil
            //            if let currentcell = tableView.cellForRow(at: currentindexPath) as? TimePeriodCell {
            //                if let endTime = currentcell.txtFieldPeriodEndTime.text {
            //                    if endTime != "" {
            //
            //                    let dateFormatter = DateFormatter()
            //                    dateFormatter.dateFormat = "h:mm a"
            //                    if let date = dateFormatter.date(from:endTime) {
            //                        print(date)
            //                        dateFormatter.dateFormat = "HH:mm"
            //                        let datestr = dateFormatter.string(from: date)
            //                        print(datestr)
            //                        let strArray = datestr.components(separatedBy: ":")
            //                        print(strArray)
            //                        print(strArray[0])
            //                        print(strArray[1])
            //                        // if let str2ndVar = strArray[1] as? String {
            //                        //  let minutes = str2ndVar.components(separatedBy: " ")
            //                        if let hour = Int(strArray[0]) ,  let min = Int(strArray[1]) {
            //                            hoursSelectionMaximum(startHour: hour, startMinute: min)
            //
            //                        }
            //                    }
            //                 }
            //                }
            //
            //            }
        }
        self.view.insertSubview(viewDatePickerView, aboveSubview: visualBlurView)
    }
    
    @objc func DoneBtn(sender: Any){
        
        //self.viewDatePickerView.isHidden = true
        // datePickerDelegate?.doneButtonClicked(datePicker: datePickerView)
        self.viewDatePickerView.isHidden = true
        removeBlurEffect()
        
        let dateFormatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        dateFormatter.dateFormat = KConstants.kDateFormat
        //Date which you need to convert in string
        let dateString = dateFormatter.string(from: datePickerView.date)
        
        let date = dateFormatter.date(from: dateString)
        //then again set the date format whhich type of output you need
        dateFormatter.dateFormat = KConstants.kTime
        dateFormatter.locale = Locale.current
        // again convert your date to string
        if date != nil{
            let strDate = dateFormatter.string(from: date!)
            let currentindexPath = IndexPath(row: datePickerView.tag,section: 0)
            
            if let cell = tableView.cellForRow(at: currentindexPath) as? TimePeriodCell {
                
                if time == KConstants.kstartTime{
                    cell.txtFieldPeriodStartTime?.text = strDate
                    if newitems.count != 0{
                        newitems[currentindexPath.row].strStartTime = strDate
                    }
                    
                }else {
                    cell.txtFieldPeriodEndTime?.text = strDate
                    if newitems.count != 0{
                        newitems[currentindexPath.row].strEndTime = strDate
                    }
                }
                
            }
        }
        
        
    }
    
    //Click on cancel button for uidatepicker
    @objc func CancelButton(sender: Any){
        //self.viewDatePickerView.isHidden = true
        self.viewDatePickerView.isHidden = true
        removeBlurEffect()
    }
    
    
    func hoursSelectionMinimimum(startHour:Int,startMinute:Int) {
        
        let startHour: Int = startHour
        let gregorian: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let date1: NSDate = NSDate()
        let components: NSDateComponents = gregorian.components(([.day, .month, .year]), from: date1 as Date) as NSDateComponents
        components.hour = startHour
        components.minute = startMinute
        components.second = 0
        let startDate: NSDate = gregorian.date(from: components as DateComponents)! as NSDate
        
        
        components.second = 0
        // let endDate: NSDate = gregorian.date(from: components as DateComponents)! as NSDate
        
        datePickerView.datePickerMode = .time
        datePickerView.minimumDate = startDate as Date
        datePickerView.setDate(startDate as Date, animated: true)
        datePickerView.reloadInputViews()
    }
    
    func hoursSelectionMaximum(startHour:Int,startMinute:Int) {
        
        let startHour: Int = startHour
        let gregorian: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let date1: NSDate = NSDate()
        let components: NSDateComponents = gregorian.components(([.day, .month, .year]), from: date1 as Date) as NSDateComponents
        components.hour = startHour
        components.minute = startMinute
        components.second = 0
        let startDate: NSDate = gregorian.date(from: components as DateComponents)! as NSDate
        
        
        components.second = 0
        // let endDate: NSDate = gregorian.date(from: components as DateComponents)! as NSDate
        
        datePickerView.datePickerMode = .time
        datePickerView.maximumDate = startDate as Date
        //datePickerView.setDate(startDate as Date, animated: true)
        datePickerView.reloadInputViews()
    }
    //#TARAN
    func getPeriodList(){
        if checkInternetConnection(){
            self.ViewModel?.getPeriodList(classId: selectedClassID ?? 0, Search: "", Skip: 0,PageSize: 10, SortColumnDir: "",SortColumn: "" )
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
    }
    
    //MARK:- Actions
    @IBAction func ActionDropDownBtn(_ sender: Any) {
        
        selectedClassID = nil
        
        if classData.count > 0{
            UpdatePickerModel2(count: classData.count , sharedPickerDelegate: self, View: self.view, index: 0)
        }
    }
    @IBAction func actionStartTime(_ sender: UIButton) {
        view.endEditing(true)
        time = KConstants.kstartTime
        datePickerView.tag = sender.tag
        showDatePickerStartTime(tag: sender.tag)
        
        // showDatePicker(datePickerDelegate: self)
    }
    
    @IBAction func actionEndTime(_ sender: UIButton) {
        view.endEditing(true)
        time = KConstants.kendTime
        datePickerView.tag = sender.tag
        showDatePickerEndTime(tag: sender.tag)
    }
    
    @IBAction func btnAddMoreCell(_ sender: UIButton) {
        time = ""
        print(newitems.count)
        let indexPath = IndexPath(row: (sender as AnyObject).tag, section: 0)
        if let cell = tableView.cellForRow(at: indexPath) as? TimePeriodCell {
            
            if (selectedClassID != nil){ // when class is not selected
                
                if(cell.txtFieldPeriodStartTime.text != ""){ // when start time is empty
                    
                    if(cell.txtFieldPeriodEndTime.text != ""){ //when end time is empty
                        //SAVE PREVIOUS VALUES
                        let previousTag =  sender.tag
                        
                        let lastindexPath = IndexPath(row:previousTag, section: 0)
                        
                        if let lastcell = tableView.cellForRow(at:lastindexPath) as? TimePeriodCell {
                            if let data =  PeriodsListData(JSON:  [KConstants.kstartTime: lastcell.txtFieldPeriodStartTime.text ?? "" , KConstants.kendTime: lastcell.txtFieldPeriodEndTime.text ?? "" ,KConstants.kPeriodTitle: lastcell.txtFieldPeriodTitle.text ?? "",KConstants.kPeriodId:0]){
                                
                                
                                if newitems.count != 0 {
                                    for i in 0..<newitems.count{
                                        if newitems[i].periodTitle == lastcell.txtFieldPeriodTitle.text{
                                            lastDouplicateElement = true
                                        }
                                    }
                                    if lastDouplicateElement == true {
                                        lastDouplicateElement = false
                                    }else{
                                        newitems[previousTag] = data
                                    }
                                }
                                else{
                                    newitems.append(data)
                                }
                            }
                            
                        }
                        //CREATE NEW ELEMENT WITH EMPTY FIELDS
                        if  let newElement = PeriodsListData(JSON:  [KConstants.kstartTime: cell.txtFieldPeriodEndTime.text! , KConstants.kendTime: "" ,KConstants.kPeriodTitle: cell.txtFieldPeriodTitle.text ?? "",KConstants.kPeriodId: 0] ){
                            print(newElement)
                            
                            newitems.append(newElement)
                        }
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        
                        
                    }else{
                        self.showAlert(alert: KConstants.kemptyEndTime)
                    }
                }else{
                    self.showAlert(alert: KConstants.kemptyStartTime)
                }
            }else{
                //when
                self.showAlert(alert: KConstants.kemptyClass)
            }
            
        }
        
    }
    //For Delete the cell
    @IBAction func ActionAddPeriod(_ sender: UIButton) {
        
        time = ""
        print(newitems.count)
        let indexPath = IndexPath(row: (sender as AnyObject).tag, section: 0)
        
        if let cell = tableView.cellForRow(at: indexPath) as? TimePeriodCell {
            if newitems.count > 0{
                let index = indexPath.row
                guard let period_id = newitems[index].periodId else {
                    return
                }
                let refreshAlert = UIAlertController(title: "iEMS", message: "Are you sure you want to delete this period?", preferredStyle: UIAlertController.Style.alert)
                refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                    if self.newitems.count == 1{
                        if period_id > 0{
                            self.ViewModel?.deletePeriod(periodId: period_id)
//                            self.getPeriodList()
                        }
                        else{
                            print("addded locally")
                        }
                        DispatchQueue.main.async {
                            self.newitems.remove(at: index)
                            cell.txtFieldPeriodStartTime.text = ""
                            cell.txtFieldPeriodEndTime.text = ""
                            //                            self.tableView.deleteRows(at: [indexPath], with: .fade)
                                                        self.tableView.reloadData()
                            print(self.newitems.count)
                        }
                    }else{
                        
                        if period_id > 0{
                            self.ViewModel?.deletePeriod(periodId: period_id)
//self.getPeriodList()
                        }
                        else{
                            print("addded locally")
                        }
                        DispatchQueue.main.async {
                            self.newitems.remove(at: index)
                            self.tableView.deleteRows(at: [indexPath], with: .fade)
                            self.tableView.reloadData()
                            print(self.newitems.count)
                        }
                    }
                }))
                refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
                    print("Cancel")
                }))
                self.present(refreshAlert, animated: true, completion: nil)
            }else{
                debugPrint("Last Cell")
            }
            //            if(cell.btnPlusMinus.currentImage != UIImage(named: kImages.kMinusIcon)){
            //                if (selectedClassID != nil){ // when class is not selected
            //
            //                    if(cell.txtFieldPeriodStartTime.text != ""){ // when start time is empty
            //
            //                        if(cell.txtFieldPeriodEndTime.text != ""){ //when end time is empty
            //                            //SAVE PREVIOUS VALUES
            //                             let previousTag =  sender.tag
            //
            //                            let lastindexPath = IndexPath(row:previousTag, section: 0)
            //
            //                            if let lastcell = tableView.cellForRow(at:lastindexPath) as? TimePeriodCell {
            //                                if let data =  PeriodsListData(JSON:  [KConstants.kstartTime: lastcell.txtFieldPeriodStartTime.text! , KConstants.kendTime: lastcell.txtFieldPeriodEndTime.text! ,KConstants.kPeriodTitle: lastcell.txtFieldPeriodTitle.text ?? "",KConstants.kPeriodId:0]){
            //                                    if newitems.count != 0 {
            //                                     newitems[previousTag] = data
            //                                    }
            //                                    else{
            //                                        newitems.append(data)
            //                                    }
            //                                }
            //
            //                            }
            //                            //CREATE NEW ELEMENT WITH EMPTY FIELDS
            //                            if  let newElement = PeriodsListData(JSON:  [KConstants.kstartTime: cell.txtFieldPeriodEndTime.text! , KConstants.kendTime: "" ,KConstants.kPeriodTitle: cell.txtFieldPeriodTitle.text ?? "",KConstants.kPeriodId: 0] ){
            //                                print(newElement)
            //
            //                                newitems.append(newElement)
            //                            }
            //
            //                            DispatchQueue.main.async {
            //                                self.tableView.reloadData()
            //                            }
            //
            //
            //                        }else{
            //                            self.showAlert(alert: KConstants.kemptyEndTime)
            //                        }
            //                    }else{
            //                        self.showAlert(alert: KConstants.kemptyStartTime)
            //                    }
            //                }else{
            //                    //when
            //                    self.showAlert(alert: KConstants.kemptyClass)
            //                }
            //
            //            }else {c
            //
            //
            //            }
            
        }
        
    }
    
    @IBAction func ActionSubmit(_ sender: Any) {
        //self.btnAddPeriod.isEnabled = false
        if (selectedClassID == nil) {
            self.showAlert(alert: KConstants.kemptyClass)
            return
        }
        let lastIndex = newitems.count-1
        let indexPath = IndexPath(row: lastIndex,section: 0)
        if let lastcell = tableView.cellForRow(at: indexPath) as? TimePeriodCell {
            
            if(lastcell.txtFieldPeriodStartTime.text != ""){
                
                if(lastcell.txtFieldPeriodEndTime.text != ""){
                    
                    if newitems[lastIndex].periodId ?? 0 > 0{
                        //last element is from backend
                    }else{
                        if  let newElement = PeriodsListData(JSON:  [KConstants.kstartTime: lastcell.txtFieldPeriodStartTime.text! , KConstants.kendTime: lastcell.txtFieldPeriodEndTime.text! ,KConstants.kPeriodTitle: lastcell.txtFieldPeriodTitle.text ?? "",KConstants.kPeriodId: 0,"StartTime": "","EndTime":""] ){
                            newitems[lastIndex] = newElement
                            
                        }
                    }
                    self.ViewModel?.addPeriod(periodList: newitems, ClassId: selectedClassID)
//                    getPeriodList()
                }
                else{
                    self.showAlert(alert: KConstants.kemptyEndTime)
                }
            }
            else{
                self.showAlert(alert: KConstants.kemptyStartTime)
            }
        }
        else{
            //count is 0
            if newitems.count == 0{
                let indexPath = IndexPath(row: 0,section: 0)
                if let cell = tableView.cellForRow(at: indexPath) as? TimePeriodCell {
                    if  let newElement = PeriodsListData(JSON:  [KConstants.kstartTime: cell.txtFieldPeriodStartTime.text! , KConstants.kendTime: cell.txtFieldPeriodEndTime.text! ,KConstants.kPeriodTitle: cell.txtFieldPeriodTitle.text ?? "",KConstants.kPeriodId: 0,"StartTime":"","EndTime":""] ){
                        newitems.append(newElement)
                    }
                }
                self.ViewModel?.addPeriod(periodList: newitems, ClassId: selectedClassID)
                
            }
        }
    }
    
    
    @IBAction func actionAddOccurance(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Period", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddOccuranceVC") as? AddOccuranceVC
        let frontVC = revealViewController().frontViewController as? UINavigationController
        frontVC?.pushViewController(vc!, animated: false)
        revealViewController().pushFrontViewController(frontVC, animated: true)
    }
}

extension TimePeriodVC: SharedUIDatePickerDelegate {
    
    func doneButtonClicked(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        dateFormatter.dateFormat = KConstants.kDateFormat
        //Date which you need to convert in string
        let dateString = dateFormatter.string(from: datePicker.date)
        
        let date = dateFormatter.date(from: dateString)
        //then again set the date format whhich type of output you need
        dateFormatter.dateFormat = KConstants.kTime
        dateFormatter.locale = Locale.current
        // again convert your date to string
        if date != nil{
            let strDate = dateFormatter.string(from: date!)
            //  startTime = strDate
            
            let lastIndex = newitems.count-1
            let indexPath = IndexPath(row: lastIndex,section: 0)
            if let cell = tableView.cellForRow(at: indexPath) as? TimePeriodCell {
                if startTime != nil{
                    if time == KConstants.kstartTime{
                        cell.txtFieldPeriodStartTime?.text = strDate
                    }else if time == KConstants.kendTime{
                        cell.txtFieldPeriodEndTime.text = strDate
                    }
                }
            }
        }
    }
}
extension TimePeriodVC : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 109;//Choose your custom row height
    }
    
}
extension TimePeriodVC : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if newitems.count != 0 {
            tblViewCenterLabel(tblView: tableView, lblText: KConstants.kNoDataFound, hide: true)
            return (newitems.count)
        }else{
            //tblViewCenterLabel(tblView: tableView, lblText: KConstants.kNoDataFound, hide: false)
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier:
            KTableViewCellIdentifier.kTimePeriodCell, for: indexPath) as! TimePeriodCell
        cell.setUI()
        cell.setData(PeriodListArray: newitems, indexPath: indexPath)
        
        DispatchQueue.main.async {
            self.tableViewHeight.constant = self.tableView.contentSize.height
            var frame = self.tableView.frame
            frame.size.height = tableView.contentSize.height
            self.tableView.frame = frame
        }
        
        return cell
    }
}
extension TimePeriodVC : ViewDelegate{
    func showAlert(alert: String){
        //   self.btnAddPeriod.isEnabled = true
        initializeCustomOkAlert(self.view, isHideBlurView: true)
        okAlertView.delegate = self
        okAlertView.lblResponseDetailMessage.text = alert
       getPeriodList()
    }
    
    func showLoader() {
        ShowLoader()
    }
    
    func hideLoader() {
        HideLoader()
    }
}
extension TimePeriodVC : PeriodDelegate{
    
    func getPeriodListSucced(data: [PeriodsListData]) {
        //if let count = data.count {
        if data.count > 0{
            newitems.removeAll()
            
            //gurleen
            newitems = data
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }else{
            newitems.removeAll()
            newitems = data
            getData = false
            isemptyCell = true
            periodArr = [KConstants.kPeriodArr]
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        //    }
        
    }
    func addPeriodSucced(msg: String){
       
    }
    
    func unauthorizedUser() {
        isUnauthorizedUser = true
    }
    
    func getClassdropdownDidSucceed(data : [ResultData]?){
        //        classData = data ?? ""
        
        if data != nil{
            if data?.count ?? 0 > 0{
                for value in data!{
                    
                    let containsSameValue = classData.contains(where: {$0.id == value.id})
                    
                    if containsSameValue == false{
                        classData.append(value)
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
//extension TimePeriodVC: SharedUIPickerDelegate{
//
//    func DoneBtnClicked() {
//        if checkInternetConnection(){
//            newitems.removeAll()
//            self.selectedClassID = classData[selectedClassIndex].id ?? 1 - 1
//            self.selectedClassName = classData[ self.selectedClassID!].name
//            self.txtFieldClass.text =  self.selectedClassName
//            self.ViewModel?.getPeriodList(classId: selectedClassID ?? 0, Search: "", Skip: 0,PageSize: 10, SortColumnDir: "",SortColumn: "" )
//
//        }else{
//
//            self.showAlert(alert: Alerts.kNoInternetConnection)
//
//        }
//
//    }
//
//    func GetTitleForRow(index: Int) -> String {
//
//        if classData.count > 0{
//            // self.txtFieldClass.text = classData[0].name
//            return classData[index].name ?? ""
//        }
//        return ""
//    }
//    func SelectedRow(index: Int) {
//        if classData.count > 0{
//            self.selectedClassName = classData[index].name
//            self.selectedClassIndex = index
//            //   self.txtFieldClass.text = classData[index].name
//        }
//
//    }
//
//}
extension TimePeriodVC:SharedUIPickerDelegate{
    func DoneBtnClicked() {
        if classData.count ?? 0 > 0{
            self.txtFieldClass.text = classData[selectedClassIndex].name
            self.selectedClassID = classData[selectedClassIndex].id
            self.ViewModel?.getPeriodList(classId: selectedClassID ?? 0, Search: "", Skip: 0,PageSize: 10, SortColumnDir: "",SortColumn: "" )
        }
    }
    func GetTitleForRow(index: Int) -> String {
        if classData.count ?? 0 > 0{
            return classData[index].name ?? ""
        }
        return ""
    }
    
    func SelectedRow(index: Int) {
        if classData.count ?? 0 > 0{
            selectedClassIndex = index
        }
    }
    
    func cancelButtonClicked() {
        
    }
}
extension TimePeriodVC : OKAlertViewDelegate{
    //Ok Button Clicked
    func okBtnAction() {
        if isUnauthorizedUser == true{
            isUnauthorizedUser = false
            CommonFunctions.sharedmanagerCommon.setRootLogin()
        }else if isAddPeriod == true{
            isAddPeriod = false
            self.ViewModel?.getPeriodList(classId: selectedClassID ?? 0, Search: "", Skip: 0,PageSize: 10, SortColumnDir: "",SortColumn: "" )
            okAlertView.removeFromSuperview()
        }
        okAlertView.removeFromSuperview()
    }
}



