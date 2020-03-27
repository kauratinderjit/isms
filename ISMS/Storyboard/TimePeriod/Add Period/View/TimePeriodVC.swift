//
//  TimePeriodVC.swift
//  ISMS
//
//  Created by Poonam Sharma on 7/8/19.
//  Copyright © 2019 Atinder Kaur. All rights reserved.
//

import UIKit

class TimePeriodVC: BaseUIViewController {
    
     var ViewModel : PeriodViewModel?
     var periodArr =  [KConstants.kPeriodArr]
     var items: [Dictionary<String,Any>] = []
     var getPeriod:GetPeriodListModel?
    var startTime:String?
    var time:String?
    var classData = [ResultData]()
    var selectedClassIndex = 0
    var selectedClassID : Int?
     var isUnauthorizedUser = false
    var isAddPeriod = false
    var getData = false
    var isnewData = false
    var isemptyCell = false
    
    @IBOutlet weak var btnAddPeriod: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtFieldClass: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        self.ViewModel = PeriodViewModel.init(delegate: self)
        self.ViewModel?.attachView(viewDelegate: self)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if checkInternetConnection(){
             self.ViewModel?.getClassId(id: 0, enumtype: 6)
        }else{
            self.showAlert(alert: Alerts.kNoInternetConnection)
        }
    }
   
    
    
    @IBAction func ActionDropDownBtn(_ sender: Any) {
            if classData.count > 0{
                    self.txtFieldClass.text = self.classData[0].name
                    self.selectedClassID = self.classData[0].id ?? 0
                    self.selectedClassIndex = 0
                    print("Selected Department:- \(String(describing: self.classData[0].name))")
                UpdatePickerModel(count: classData.count , sharedPickerDelegate: self)
            }
    }
    @IBAction func actionStartTime(_ sender: Any) {
        view.endEditing(true)
        time = KConstants.kstartTime
        showDatePicker(datePickerDelegate: self)
    }
    
    @IBAction func actionEndTime(_ sender: Any) {
        view.endEditing(true)
       time = KConstants.kendTime
        showDatePicker(datePickerDelegate: self)
    }
    
    @IBAction func ActionAddPeriod(_ sender: Any) {
       time = ""
        let indexPath = IndexPath(row: (sender as AnyObject).tag, section: 0)
        print("ndex: ",indexPath.row)
        if let cell = tableView.cellForRow(at: indexPath) as? TimePeriodCell {
            if(cell.btnPlusMinus.currentImage != UIImage(named: kImages.kMinusIcon)){
                if (selectedClassID != nil){
                    if(cell.txtFieldPeriodStartTime.text != ""){
                        if(cell.txtFieldPeriodEndTime.text != ""){
                            let formatter = DateFormatter()
                            formatter.dateFormat = "HH:mm"
                            let startTime = formatter.date(from: cell.txtFieldPeriodStartTime.text!)
                            let endTime = formatter.date(from: cell.txtFieldPeriodEndTime.text!)
                            if startTime?.compare(endTime!) == .orderedAscending {
                                if(items.count>0){
                                    let formatter = DateFormatter()
                                    formatter.dateFormat = "HH:mm"
                                    let startTime = formatter.date(from: cell.txtFieldPeriodStartTime.text!)
                                    let endTime = formatter.date(from: items[indexPath.row-1][KConstants.kendTime] as! String)
                                    if startTime?.compare(endTime!) == .orderedAscending {
                                        cell.btnPlusMinus.setImage(UIImage(named: kImages.kMinusIcon), for: UIControl.State.normal)
                                        cell.btnCancelPeriod.isHidden = true
                                        getData = false
                                        let dict1 = [KConstants.kstartTime: cell.txtFieldPeriodStartTime.text ?? "", KConstants.kendTime: cell.txtFieldPeriodEndTime.text ?? "",KConstants.kPeriodTitle: cell.txtFieldPeriodTitle.text ?? "",KConstants.kPeriodId: 0] as [String : Any]
                                        items.append(dict1 )
                                        let lastIndex = periodArr.count
                                        let period = KConstants.kperiod+"\(lastIndex+1)"
                                        periodArr.append(period)
                                        DispatchQueue.main.async {
                                            self.tableView.reloadData()
                                        }
                                    }else{
                                        self.showAlert(alert: KConstants.kNextPeriod)
                                    }
                                }else{
                                    cell.btnPlusMinus.setImage(UIImage(named: kImages.kMinusIcon), for: UIControl.State.normal)
                                    cell.btnCancelPeriod.isHidden = true
                                    getData = false
                                    let dict1 = [KConstants.kstartTime: cell.txtFieldPeriodStartTime.text ?? "", KConstants.kendTime: cell.txtFieldPeriodEndTime.text ?? "",KConstants.kPeriodTitle: cell.txtFieldPeriodTitle.text ?? "",KConstants.kPeriodId: 0] as [String : Any]
                                    items.append(dict1 )
                                    let lastIndex = periodArr.count
                                    let period = KConstants.kperiod+"\(lastIndex+1)"
                                    periodArr.append(period)
                                    DispatchQueue.main.async {
                                        self.tableView.reloadData()
                                    }
                                }
                               
                            }else{
                                 self.showAlert(alert: KConstants.kPeriodGreater)
                            }
                            
                        }else{
                            self.showAlert(alert: KConstants.kemptyEndTime)
                        }
                    }else{
                        self.showAlert(alert: KConstants.kemptyStartTime)
                    }
                }else{
                      self.showAlert(alert: KConstants.kemptyClass)
                }
                
            }else{
                let index = indexPath.row
                if getData == false{
                     periodArr.remove(at: index)
                    for i in index..<periodArr.count{
                        periodArr[i] = KConstants.kperiod+"\(i+1)"
                    }
                }

                let periodId = items[index][KConstants.kPeriodId]
                items.remove(at: index)
                tableView.deleteRows(at: [indexPath], with: .fade)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                self.ViewModel?.deletePeriod(periodId: periodId as! Int)
            }
          
        }
       
    }
    
    func setUI(){
        //Title
        self.title = KStoryBoards.KClassPeriodIdIdentifiers.kAddPeriodTitle
        
        //Table View Settings
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        SetpickerView(self.view)
        setDatePickerView(self.view, type: .time)
        tableView.delegate = self
        tableView.dataSource = self
        self.setBackButton()
    }
    
    
    @IBAction func btnCancelAct(_ sender: Any) {
    }
    
    @IBAction func ActionSubmit(_ sender: Any) {
        self.btnAddPeriod.isEnabled = false
        let lastIndex = periodArr.count-1
        let indexPath = IndexPath(row: lastIndex,section: 0)
        if let cell = tableView.cellForRow(at: indexPath) as? TimePeriodCell {
            if(cell.txtFieldPeriodEndTime.text != ""){
                if(cell.txtFieldPeriodStartTime.text != ""){
                    let dict1 = [KConstants.kstartTime: cell.txtFieldPeriodStartTime.text ?? "", KConstants.kendTime: cell.txtFieldPeriodEndTime.text ?? "", KConstants.kPeriodTitle: cell.txtFieldPeriodTitle.text ?? "",KConstants.kPeriodId: 0] as [String : Any]
                    items.append(dict1)
                    
                    var set = Set<String>()
                    let arraySet: [[String : Any]] = items.compactMap {
                        guard let name = $0[KConstants.kPeriodTitle] as? String else {return nil }
                        return set.insert(name).inserted ? $0 : nil
                    }
                    print("duplicate element2 : ",arraySet)
                   
                    items = arraySet
                   print("Items array : ",items)
                    self.ViewModel?.addPeriod(periodList: items, ClassId: selectedClassID)
                }
            }
        }
    }
    
    
    
}
extension TimePeriodVC: SharedUIDatePickerDelegate{
    
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
            startTime = strDate
            
            let lastIndex = periodArr.count-1
            let indexPath = IndexPath(row: lastIndex,section: 0)
            if let cell = tableView.cellForRow(at: indexPath) as? TimePeriodCell {
                if startTime != nil{
                    if time == KConstants.kstartTime{
                        cell.txtFieldPeriodStartTime?.text = startTime
                    }else if time == KConstants.kendTime{
                        cell.txtFieldPeriodEndTime.text = startTime
                    }
                }
            }
        }
    }
}
extension TimePeriodVC : UITableViewDelegate{
    
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
extension TimePeriodVC : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (getData == false){
            if periodArr.count > 0{
                return (periodArr.count)
            }else{
                tblViewCenterLabel(tblView: tableView, lblText: KConstants.kNoDataFound, hide: true)
                return 0
            }
        }else if (getData == true){
            return (items.count)
        }else{
            tblViewCenterLabel(tblView: tableView, lblText: KConstants.kNoDataFound, hide: true)
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:
            KTableViewCellIdentifier.kTimePeriodCell, for: indexPath) as! TimePeriodCell
        if isnewData == true{
            cell.txtFieldPeriodTitle.text = periodArr[indexPath.row]
            cell.viewPeriod.addViewCornerShadow(radius: 8, view: cell.viewPeriod)
            cell.txtFieldPeriodTitle.addViewCornerShadow(radius: 8, view: cell.txtFieldPeriodTitle)
            cell.txtFieldPeriodEndTime.addViewCornerShadow(radius: 8, view: cell.txtFieldPeriodEndTime)
            cell.txtFieldPeriodStartTime.addViewCornerShadow(radius: 8, view: cell.txtFieldPeriodStartTime)
            
            if(periodArr.count-1 == 0){
                cell.btnCancelPeriod.isHidden = true
            }else if(periodArr.count-1 == indexPath.row){
                cell.btnCancelPeriod.isHidden = false
            }
            
            if let startTime1 = self.startTime{
                cell.setCellUI(indexPath: indexPath, startTime: startTime1, time: time ?? "", PeriodListArray: items)
            }
        }else if getData == true{
            cell.viewPeriod.addViewCornerShadow(radius: 8, view: cell.viewPeriod)
            cell.txtFieldPeriodTitle.addViewCornerShadow(radius: 8, view: cell.txtFieldPeriodTitle)
            cell.txtFieldPeriodEndTime.addViewCornerShadow(radius: 8, view: cell.txtFieldPeriodEndTime)
            cell.txtFieldPeriodStartTime.addViewCornerShadow(radius: 8, view: cell.txtFieldPeriodStartTime)
            cell.setCellUIArray(indexPath: indexPath, PeriodListArray: items)
        }else{
            if isemptyCell == true{
                isemptyCell = false
                cell.txtFieldPeriodStartTime.text = ""
                cell.txtFieldPeriodEndTime.text = ""
                cell.btnPlusMinus.setImage(UIImage(named: "addIcon"), for: UIControl.State.normal)
            }
            cell.btnCancelPeriod.tag = indexPath.row
            cell.btnPlusMinus.tag = indexPath.row
            cell.txtFieldPeriodTitle.text = periodArr[indexPath.row]
           
            cell.viewPeriod.addViewCornerShadow(radius: 8, view: cell.viewPeriod)
            cell.txtFieldPeriodTitle.addViewCornerShadow(radius: 8, view: cell.txtFieldPeriodTitle)
            cell.txtFieldPeriodEndTime.addViewCornerShadow(radius: 8, view: cell.txtFieldPeriodEndTime)
            cell.txtFieldPeriodStartTime.addViewCornerShadow(radius: 8, view: cell.txtFieldPeriodStartTime)
            
            if(periodArr.count-1 == 0){
                cell.btnCancelPeriod.isHidden = true
            }else if(periodArr.count-1 == indexPath.row){
                cell.btnCancelPeriod.isHidden = false
            }
            
            if let startTime1 = self.startTime{
                cell.setCellUI(indexPath: indexPath, startTime: startTime1, time: time ?? "",PeriodListArray: items)
               
            }
        }
        return cell
    }
}
extension TimePeriodVC : ViewDelegate{
    func showAlert(alert: String){
        self.btnAddPeriod.isEnabled = true
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
extension TimePeriodVC : PeriodDelegate{
    func getPeriodListSucced(data: GetPeriodListModel) {
        if let count = data.resultData?.count {
            if count > 0{
                items.removeAll()
                periodArr.removeAll()
                for i in 0..<count {
                    getData = true
                   
                    let dict1 = [KConstants.kstartTime: data.resultData?[i].strStartTime ?? "", KConstants.kendTime: data.resultData?[i].strEndTime ?? "",KConstants.kPeriodTitle:  data.resultData?[i].title ?? "",KConstants.kPeriodId: data.resultData?[i].periodId ?? 0] as [String : Any]
                    let periodVal = data.resultData?[i].title
                    items.append(dict1 )
                    periodArr.append(periodVal ?? "")
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }else{
                items.removeAll()
                getData = false
                isemptyCell = true
                periodArr = [KConstants.kPeriodArr]
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
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
extension TimePeriodVC: SharedUIPickerDelegate{
    
    func DoneBtnClicked() {
        
        if checkInternetConnection(){
            items.removeAll()
             self.ViewModel?.getPeriodList(classId: selectedClassID ?? 0, Search: "", Skip: 0,PageSize: 10, SortColumnDir: "",SortColumn: "" )
        }else{
            
            self.showAlert(alert: Alerts.kNoInternetConnection)
            
        }
        
    }
    
    
    
    func GetTitleForRow(index: Int) -> String {
        
        if classData.count > 0{
            self.txtFieldClass.text = classData[0].name
            return classData[index].name ?? ""
        }
        return ""
    }
    func SelectedRow(index: Int) {
        if classData.count > 0{
            self.selectedClassID = classData[index].id
             self.txtFieldClass.text = classData[index].name
        }
        
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

