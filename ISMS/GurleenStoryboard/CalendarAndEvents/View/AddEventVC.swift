//
//  AddEventVC.swift
//  ISMS
//
//  Created by Atinder Kaur on 4/2/20.
//  Copyright © 2020 Atinder Kaur. All rights reserved.
//

import UIKit
import FSCalendar

let month_Formatter: DateFormatter =
{
    let form = DateFormatter()
    form.dateFormat = "yyyy-MM-dd"
    return form
}()

class AddEventVC: BaseUIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var calenderDate: FSCalendar!
    @IBOutlet weak var txtfieldTitle: UITextField!
    @IBOutlet weak var txtViewDescription: UITextView!
    @IBOutlet weak var viewPicker: UIView!
    @IBOutlet weak var pickerTime: UIDatePicker!
    @IBOutlet weak var scrollView: UIScrollView!
    fileprivate var str_date_selected:    String? = ""
    @IBOutlet weak var lbl_MessagePlaceholder: UILabel!
    @IBOutlet weak var btnSend: UIBarButtonItem!
    
    @IBOutlet var tfEventDate: UITextField!
    @IBOutlet var tfEventEndDate: UITextField!
    @IBOutlet var tfStartTime: UITextField!
    @IBOutlet var tfEndTime: UITextField!
    
    var approach = "date"
    var startTimes = ""
    var endTimes = ""
    
    var datePicker = UIDatePicker()
    var datePickerStartDate = UIDatePicker()
    var datePickerEndDate = UIDatePicker()
    var datePickerStartTime = UIDatePicker()
    
    var selectedStrtDate = ""
    var selectedStrtDate2 = ""
    
    var startTime : Date?
    var endTime : Date?
    
    var viewModel     : EventScheduleViewModel?
    var selectedTime : String?
    var eventId :Int = 0
    var editMode : Bool = false
    var editEventModel : EventScheduleListResultData?
    public var lstActionAccess : GetMenuFromRoleIdModel.ResultData?
       var HODdepartmentId = UserDefaultExtensionModel.shared.HODDepartmentId
    @IBOutlet weak var selectedStartDate: UILabel!
    @IBOutlet weak var selectEndDate: UILabel!
    @IBOutlet weak var selectStartTime: UILabel!
    @IBOutlet weak var selectEndTime: UILabel!
    //Converts string into date
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setView()
        if UserDefaultExtensionModel.shared.currentUserRoleId == 5{
            self.selectStartTime.text = "Start Time"
            self.selectEndTime.text = "End Time"
            self.selectedStartDate.text = "Start Date"
            self.selectEndDate.text = "End Date"
            self.tfEventDate.isUserInteractionEnabled = false
            self.tfEventEndDate.isUserInteractionEnabled = false
            self.tfStartTime.isUserInteractionEnabled = false
            self.tfEndTime.isUserInteractionEnabled = false
            self.txtfieldTitle.isUserInteractionEnabled = false
            self.txtViewDescription.isUserInteractionEnabled = false
           self.navigationItem.rightBarButtonItem = nil
        }else if UserDefaultExtensionModel.shared.currentUserRoleId == 6{
            self.selectStartTime.text = "Start Time"
            self.selectEndTime.text = "End Time"
            self.selectedStartDate.text = "Start Date"
            self.selectEndDate.text = "End Date"
            self.tfEventDate.isUserInteractionEnabled = false
            self.tfEventEndDate.isUserInteractionEnabled = false
            self.tfStartTime.isUserInteractionEnabled = false
            self.tfEndTime.isUserInteractionEnabled = false
            self.txtfieldTitle.isUserInteractionEnabled = false
            self.txtViewDescription.isUserInteractionEnabled = false
            self.navigationItem.rightBarButtonItem = nil
        }else if UserDefaultExtensionModel.shared.currentUserRoleId == 4{
            self.selectStartTime.text = "Start Time"
            self.selectEndTime.text = "End Time"
            self.selectedStartDate.text = "Start Date"
            self.selectEndDate.text = "End Date"
            self.tfEventDate.isUserInteractionEnabled = false
            self.tfEventEndDate.isUserInteractionEnabled = false
            self.tfStartTime.isUserInteractionEnabled = false
            self.tfEndTime.isUserInteractionEnabled = false
            self.txtfieldTitle.isUserInteractionEnabled = false
            self.txtViewDescription.isUserInteractionEnabled = false
              self.navigationItem.rightBarButtonItem = nil
        }
        
        self.showDatePickerEventDate()
        self.showDatePickerEventDateEnd()
        self.showDatePickerEventStartTime()
        self.showDatePickerEventEndTime()
    }
    
    func setView()
    {
        self.setBackButton()
        
        self.viewModel = EventScheduleViewModel.init(delegate: self)
        self.viewModel?.attachView(viewDelegate: self)
        self.title = "Add Event"
        //  addShadow(view: calenderDate)
        //  addShadow(view: txtViewDescription)
        //styleTextField(textField: txtfieldTitle)
        //styleLabel(textField: lblTime)
        txtfieldTitle.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        //txtfieldTitle.txtfieldPadding(leftpadding: 20, rightPadding: 0)
        txtViewDescription.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20);
        self.CreateNavigationBackBarButton()
       
        
        // txtfieldTitle.attributedPlaceholder = NSAttributedString(string:"Enter Title", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        
        if editMode == true
        {
            
            if editEventModel != nil
            {
                txtViewDescription.text = editEventModel?.Description
                lbl_MessagePlaceholder.isHidden = true
                txtfieldTitle.text = editEventModel?.Title
                self.eventId = editEventModel?.EventId ?? 0
                
                let strtDate = self.dateFromISOStringNew(string: editEventModel?.StartDate ?? "")
                let endDate = self.dateFromISOStringNew(string: editEventModel?.EndDate ?? "")
                
                self.tfEventDate.text = strtDate
                self.tfEventEndDate.text = endDate
                self.tfStartTime.text = editEventModel?.StrStartTime
                self.tfEndTime.text = editEventModel?.StrEndTime
                
                
                let localDateFormatter = DateFormatter()
                localDateFormatter.dateFormat = "h:mm a"
                
                let localDateFormatter2 = DateFormatter()
                localDateFormatter2.dateFormat = "HH:mm a"
                
                let dateObj = localDateFormatter2.date(from: editEventModel?.StrStartTime ?? "")
//                print("\(localDateFormatter.string(from: dateObj!))")
                
                // self.tfEventDate.text = "\(localDateFormatter.string(from: dateObj!))"
                
                //  lblTime.text = "\(localDateFormatter.string(from: dateObj!))"
                
                selectedTime = editEventModel?.StrStartTime
                guard let strDate = editEventModel?.strStartDate else { return  }
                str_date_selected = strDate
                let dateFinal =  formatter.date(from: strDate)
                self.calenderDate.deselect(dateFinal!)
                self.calenderDate.select(dateFinal, scrollToDate: true)
                
                
                let arrAccess = lstActionAccess?.lstActionAccess
                
                _ = arrAccess?.enumerated().map { (index,element) in
                    
                    if element.actionName == "Edit" {
                        self.title = "Update Event"
                        
                        calenderDate.isUserInteractionEnabled = true
                        txtfieldTitle.isUserInteractionEnabled = true
                        txtViewDescription.isUserInteractionEnabled = true
                        //mohit     tfEventDate.isUserInteractionEnabled = true
                        self.navigationItem.rightBarButtonItem = btnSend
                        
                    }
                    else{
                        self.title = "View Event Details"
                        
                        calenderDate.isUserInteractionEnabled = false
                        txtfieldTitle.isUserInteractionEnabled = false
                        txtViewDescription.isUserInteractionEnabled = false
                        //mohit tfEventDate.isUserInteractionEnabled = false
                        self.navigationItem.rightBarButtonItem = nil
                        tfEventDate.isUserInteractionEnabled = false
                        tfEventEndDate.isUserInteractionEnabled = false
                        tfStartTime.isUserInteractionEnabled = false
                        tfEndTime.isUserInteractionEnabled = false
                        selectEndDate.text = "End Date"
                        selectedStartDate.text = "Start Date"
                        selectStartTime.text = "Start Time"
                        selectEndTime.text = "End Time"
                    }
                }
            }
        }
        else
        {
            //Start Date
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            self.tfEventDate.text = formatter.string(from: Date())
            self.selectedStrtDate =  self.tfEventDate.text!
            self.selectedStrtDate2 = self.selectedStrtDate
               formatter.dateFormat = "hh:mm"
            self.startTimes = formatter.string(from: Date())
            
            //Start Time
            formatter.dateFormat = "hh:mm a"
            self.tfStartTime.text = formatter.string(from: Date())
            startTime = formatter.date(from: self.tfStartTime.text ?? "") ?? Date()
            
            self.showDatePickerEventStartTime()
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        editMode = false
    }
    
    
    private func styleLabel(textField: UILabel)
    {
        textField.layer.masksToBounds = false
        textField.layer.cornerRadius = 5.0;
        textField.layer.backgroundColor = UIColor.white.cgColor
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowOffset = CGSize(width: 0, height: 0)
        textField.layer.shadowOpacity = 0.4
        textField.layer.shadowRadius = 5.0
    }
    
    
    func CreateNavigationBackBarButton()
    {
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isTranslucent = true
        let myBackButton:UIButton = UIButton()
        myBackButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        myBackButton.setImage(UIImage(named:"backIcon"), for: UIControl.State())
        myBackButton.addTarget(self, action: #selector(self.PopToRootViewController), for: UIControl.Event.touchUpInside)
        let leftBackBarButton:UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
        self.navigationItem.leftBarButtonItem = leftBackBarButton
        
    }
    
    
    @objc  func PopToRootViewController()
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async{
            self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 567) }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
        print(scrollView.contentOffset.x)
        
    }
    
    
    @IBAction func actionbtnDone(_ sender: UIButton)
    {
        
        if self.tfEventDate.text != ""
        {
            
            DispatchQueue.main.async {
                self.viewPicker.isHidden = true
                self.calenderDate.isUserInteractionEnabled = true
                self.pickerTime.minimumDate = nil
                
            }
        }
    }
    

  
    
    @IBAction func actionSendBtn(_ sender: UIBarButtonItem)
    {
        self.animateTextView(textView: self.txtViewDescription, up: false, movementDistance: 250, scrollView:self.scrollView)
        
        if (self.tfEventDate.text?.count == 0)
        {
            self.showAlert(alert: "Please select start date")
        }
        else if (self.tfEventEndDate.text?.count == 0)
        {
            self.showAlert(alert: "Please select end date")
        }
        else if (self.tfStartTime.text?.count == 0)
        {
            self.showAlert(alert: "Please select start time")
        }
        else if (self.tfEndTime.text?.count == 0)
        {
            self.showAlert(alert: "Please select end time")
        }
        else if (self.txtfieldTitle.text?.count == 0)
        {
            self.showAlert(alert: "Please add a title")
        }
        else if (self.txtViewDescription.text?.count == 0)
        {
            self.showAlert(alert: "Please add some description")
        }
        else
        {
            let stats = self.getTime_DIfference_isCorrect()
            if stats == true
            {
                if checkInternetConnection()
                {
                   // self.viewModel?.addUpdateEvent(eventId: eventId, title: txtfieldTitle.text, description: txtViewDescription.text, time: selectedTime, Date: str_date_selected)
                    
                    self.viewModel?.addUpdateEvent(eventId: eventId, title: txtfieldTitle.text, description: txtViewDescription.text, startTime: self.startTimes, endTime: self.endTimes, evntStartDate: tfEventDate.text, evntEndDate: tfEventEndDate.text,ParticularId: HODdepartmentId)
                }
                else
                {
                    self.showAlert(alert: Alerts.kNoInternetConnection)
                }
            }
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return true
    }
    
    
}




extension AddEventVC:UITextViewDelegate
{
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        
        if text == "\n"
        {
            textView.resignFirstResponder()
        }
        
        let maxAllowedCharactersPerLine = 100
        let lines = (textView.text as NSString).replacingCharacters(in: range, with: text).components(separatedBy: .newlines)
        for line in lines {
            if line.characters.count > maxAllowedCharactersPerLine {
                return false
            }
        }
        return true
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        lbl_MessagePlaceholder.isHidden = true
        self.viewPicker.isHidden = true
        self.animateTextView(textView: textView, up: true, movementDistance: 250, scrollView:self.scrollView)
        
        
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        let str = textView.text.trimmingCharacters(in: .whitespaces)
        
        if str == ""
        {
            self.txtViewDescription.text = ""
            lbl_MessagePlaceholder.isHidden = false
            
        }
        else{
            txtViewDescription.text = textView.text
        }
        
        DispatchQueue.main.async {
            
            self.animateTextView(textView: textView, up: false, movementDistance: 250, scrollView:self.scrollView)
        }
        
    }
    
}
extension AddEventVC:FSCalendarDelegate,FSCalendarDataSource{
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if date < calendar.today!
        {
            calenderDate.deselect(date)
            self.showAlert(Message: "Please select future date.")
            return
        }
            
        else{
            if date == calendar.today!
            {
                // lblTime.text = "00:00"
                //str_time =  ""
                self.pickerTime.minimumDate = nil
            }
            str_date_selected = (self.formatter.string(from: date))
            print(str_date_selected)
        }
    }
    
    
    //Called when available date is selected
    //    func calendar(_ calendar: FSCalendar, didSelect date: Date) {
    //
    //
    //        if date < calendar.today!
    //        {
    //            calenderDate.deselect(date)
    //            self.showAlert(Message: "Please select future date.")
    //            return
    //        }
    //
    //        else{
    //            if date == calendar.today!
    //            {
    //            lblTime.text = "00:00"
    //            //str_time =  ""
    //            self.pickerTime.minimumDate = nil
    //            }
    //            str_date_selected = (self.formatter.string(from: date))
    //            print(str_date_selected)
    //        }
    //
    //    }
    
    //calendarCurrentPageDidChange
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        
        
    }
    
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        
        if date == calenderDate.today
        {
            return "Today"
        }
        else{
            return nil
        }
    }
    
}

extension AddEventVC : EventScheduleDelegate {
    func SubjectEventSuccess() {
        
    }
    
    func AddEventScheduleSucceed() {
        
        if editMode == true {
            self.showAlert(alert: "Event updated successfully.")
            
        }
        else {
            self.showAlert(alert: "Event added successfully.")
            
        }
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func EventScheduleSucceed(array: [EventScheduleListResultData]) {
        
    }
    
    func EventScheduleFailour(msg: String) {
        
    }
    
    
}

extension AddEventVC : ViewDelegate {
    
    func showAlert(alert: String) {
        print("your error : \(alert)")
        self.showAlert(Message: alert)
    }
    
    func showLoader() {
        ShowLoader()
    }
    
    func hideLoader() {
        HideLoader()
    }
    
}
@IBDesignable class UITextViewFixed: UITextView {
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    func setup() {
        translatesAutoresizingMaskIntoConstraints = true
        textContainerInset = UIEdgeInsets.zero
        textContainer.lineFragmentPadding = 0
        translatesAutoresizingMaskIntoConstraints = false
    }
}
